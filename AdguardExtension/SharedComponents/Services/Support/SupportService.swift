///
/// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
/// Copyright © Adguard Software Limited. All rights reserved.
///
/// Adguard for iOS is free software: you can redistribute it and/or modify
/// it under the terms of the GNU General Public License as published by
/// the Free Software Foundation, either version 3 of the License, or
/// (at your option) any later version.
///
/// Adguard for iOS is distributed in the hope that it will be useful,
/// but WITHOUT ANY WARRANTY; without even the implied warranty of
/// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
/// GNU General Public License for more details.
///
/// You should have received a copy of the GNU General Public License
/// along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
///

import Zip
import SafariAdGuardSDK
import DnsAdGuardSDK
import AGDnsProxy

protocol SupportServiceProtocol {
    /// Preparing logs archive to sharing. Return archive file URL in temporary directory
    func exportLogs() throws -> URL?

    /// Delete log archive and other log files from temporary directory. Call it after sharing archive of logs
    func deleteLogsFiles()

    /// Sending feedback data to our backend
    func sendFeedback(_ email: String, description: String, reportType: ReportType, sendLogs: Bool, _ completion: @escaping (_ logsSentSuccessfully: Bool) -> Void)
}

/// Support service assemble app state info
final class SupportService: SupportServiceProtocol {
    fileprivate typealias DnsServerInfo = (serverName: String, serverId: Int, upstreams: String)

    // MARK: - Services

    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationServiceProtocol
    private let complexProtection: ComplexProtectionServiceProtocol
    private let networkSettings: NetworkSettingsServiceProtocol
    private let productInfo: ADProductInfoProtocol
    private let keyChainService: KeychainServiceProtocol
    private let safariProtection: SafariProtectionProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let dnsProtection: DnsProtectionProtocol

    // MARK: - Helper variable

    private let reportUrl = "https://reports.adguard.com/new_issue.html"

    private var appLogsUrls: [URL] {
        let logsUrl = resources.sharedLogsURL()
        let fm = FileManager.default
        let logsUrls = try? fm.contentsOfDirectory(at: logsUrl, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [])
        return logsUrls ?? []
    }

    // Directories urls to delete theme after logs export
    private var logsDirectory: URL?
    private var logsZipDirectory: URL?

    //MARK: - Init

    init(resources: AESharedResourcesProtocol, configuration: ConfigurationServiceProtocol, complexProtection: ComplexProtectionServiceProtocol, productInfo: ADProductInfoProtocol, keyChainService: KeychainServiceProtocol, safariProtection: SafariProtectionProtocol, networkSettings: NetworkSettingsServiceProtocol, dnsProvidersManager: DnsProvidersManagerProtocol, dnsProtection: DnsProtectionProtocol) {
        self.resources = resources
        self.configuration = configuration
        self.complexProtection = complexProtection
        self.productInfo = productInfo
        self.keyChainService = keyChainService
        self.safariProtection = safariProtection
        self.networkSettings = networkSettings
        self.dnsProvidersManager = dnsProvidersManager
        self.dnsProtection = dnsProtection
    }

    // MARK: - Public methods

    func exportLogs() throws -> URL? {
        let archiveName = "AdGuard_logs.zip"
        let fileManager = FileManager.default

        let tmp = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let baseUrl = tmp.appendingPathComponent("logs", isDirectory: true)
        let cbUrl = baseUrl.appendingPathComponent("CB jsons", isDirectory: true)
        let targetsUrl = baseUrl.appendingPathComponent("Targets", isDirectory: true)
        let logsZipUrl = tmp.appendingPathComponent(archiveName)
        self.logsDirectory = fileManager.fileExists(atPath: baseUrl.path) ? baseUrl : nil
        self.logsZipDirectory = fileManager.fileExists(atPath: logsZipUrl.path) ? logsZipUrl : nil

        ///Remove old logs if it exists
        deleteLogsFiles()

        /// Create directories in base directory
        try fileManager.createDirectory(at: baseUrl, withIntermediateDirectories: true, attributes: nil)
        try fileManager.createDirectory(at: cbUrl, withIntermediateDirectories: true, attributes: nil)
        try fileManager.createDirectory(at: targetsUrl, withIntermediateDirectories: true, attributes: nil)

        /// Get jsons for content blockers and append them to base directory
        try appendCBJsonsIntoTemporaryDirectory(cbUrl: cbUrl)

        /// Get application state info and save it as state.txt to base directory
        let appStateData = createApplicationStateInfo().data(using: .utf8)
        let appStateUrl = baseUrl.appendingPathComponent("state.txt")
        try appStateData?.write(to: appStateUrl)

        /// Flush Logs before appending them
        ACLLogger.singleton()?.flush()

        /// Append log file for each process to base directory
        try appLogsUrls.forEach { appLogUrl in
            let logFileData = applicationLogData(fromUrl: appLogUrl)
            let fileName = appLogUrl.lastPathComponent
            let fileUrl = targetsUrl.appendingPathComponent(fileName)
            try logFileData.write(to: fileUrl)
        }

        do {
            try Zip.zipFiles(paths: [baseUrl], zipFilePath: logsZipUrl, password: nil, compression: .BestSpeed, progress: nil)
            return logsZipUrl
        }
        catch {
            DDLogError("(SupportService) - exportLogs; Failed to export logs: \(error)")
        }
        return nil
    }

    func deleteLogsFiles() {
        let fm = FileManager.default

        guard let logsDirectory = self.logsDirectory, let logsZipDirectory = self.logsZipDirectory else {
            DDLogWarn("(SupportService) - deleteLogsFiles; File is missing")
            return
        }

        do {
            try fm.removeItem(at: logsDirectory)
            try fm.removeItem(at: logsZipDirectory)

            self.logsDirectory = nil
            self.logsZipDirectory = nil
        }
        catch {
            DDLogError("(SupportService) - deleteLogsFiles; Error removing logs files: \(error)")
        }
    }

    func sendFeedback(_ email: String, description: String, reportType: ReportType, sendLogs: Bool, _ completion: @escaping (_ logsSentSuccessfully: Bool) -> Void) {
        let appId = keyChainService.appId
        let version = productInfo.buildVersion()
        let email = email
        let language = ADLocales.lang()
        let subject = reportType.subject
        let description = description
        let applicationState = createApplicationStateInfo()
        let debugInfo = sendLogs ? createDebugInfo() : ""
        let feedback: FeedBackProtocol = FeedBack(applicationId: appId, version: version, email: email, language: language, subject: subject, description: description, applicationState: applicationState, debugInfo: debugInfo)

        let httpRequestService = HttpRequestService()
        httpRequestService.sendFeedback(feedback) { success in
            completion(success)
        }
    }

    private func createApplicationStateInfo() -> String {
        let serverInfo = collectDnsServerInfo()

        let device = UIDevice.current

        let enabledGroups = safariProtection.groups.filter { $0.isEnabled }
        let groupsString = enabledGroups.reduce("", { $0 + "Group id=\($1.groupId) name=\($1.groupName)\n" })

        let filtersString = enabledGroups
            .flatMap { $0.filters }
            .filter { $0.isEnabled }
            .reduce("") { filtersString, filter in
                let metaString = "ID=\(filter.filterId) GroupId=\(filter.group.groupId) Name=\"\(filter.name ?? "-")\" Version=\(filter.version ?? "-")\n"
                return filtersString + metaString
            }

        let tunnelMode = resources.tunnelMode.debugDescription

        let customBootstraps = resources.customBootstrapServers?.joined(separator: ", ") ?? ""
        let customFallbacks = resources.customFallbackServers?.joined(separator: ", ") ?? ""

        var resultString = """
        Application version: \(productInfo.buildVersion() ?? "Unknown")

        Device: \(device.model)
        Platform: \(device.systemName)
        OS: \(device.systemVersion)
        ID: \(device.identifierForVendor?.uuidString ?? "Unknown")
        APP ID: \(keyChainService.appId ?? "nil")

        Locale: \(ADLocales.lang() ?? "Unknown")
        Region: \(ADLocales.region() ?? "Unknown")

        GeneralContentBlockerRulesCount: \(resources.generalContentBlockerRulesCount)
        PrivacyContentBlockerRulesCount: \(resources.privacyContentBlockerRulesCount)
        SocialContentBlockerRulesCount: \(resources.socialContentBlockerRulesCount)
        OtherContentBlockerRulesCount: \(resources.otherContentBlockerRulesCount)
        CustomContentBlockerRulesCount: \(resources.customContentBlockerRulesCount)
        SecurityContentBlockerRulesCount: \(resources.securityContentBlockerRulesCount)

        Safari Filters information:
        Enabled Groups:
        \(groupsString)

        Enabled Filters:
        \(filtersString)

        PRO:
        Pro feature \(configuration.proStatus ? "ENABLED" : "DISABLED").

        Complex protection enabled: \(complexProtection.complexProtectionEnabled)
        Safari protection enabled: \(complexProtection.safariProtectionEnabled)
        System protection enabled: \(complexProtection.systemProtectionEnabled)
        Tunnel mode \(tunnelMode)
        DNS server: \(serverInfo.serverName)
        Restart when network changes: \(resources.restartByReachability)
        Filter mobile data: \(networkSettings.filterMobileDataEnabled)
        Filter wi-fi data: \(networkSettings.filterWifiDataEnabled)

        Dns server id: \(serverInfo.serverId)
        Dns custom bootstrap servers: \(customBootstraps)"
        Dns custom fallback servers: \(customFallbacks)"

        VPN application info:

        AdGuard VPN is installed on device: \(UIApplication.adGuardVpnIsInstalled)
        AdGuard VPN tunnel is running: \(UIApplication.adGuardVpnIsActive)
        AdGuard DNS library version:\(AGDnsProxy.libraryVersion() ?? "Unknown")
        """

        resultString.append("\r\nDns upstream: \(serverInfo.upstreams)")

        if networkSettings.exceptions.count > 0 {
            resultString.append("\r\n\r\nWi-Fi exceptions:")
            for exception in networkSettings.exceptions {
                resultString.append("\r\nWi-Fi name=\"\(exception.rule)\" Enabled=\(exception.enabled)")
            }
        }

        let dnsFiltersString = collectDnsFilters()
        guard !dnsFiltersString.isEmpty else { return resultString }
        resultString.append("\r\nDns filters: \r\n");
        resultString.append(dnsFiltersString)

        return resultString
    }

    private func createDebugInfo() -> String {

        /// Flush Logs before appending them
        ACLLogger.singleton()?.flush()

        /// Append log file for each process to base directory
        return appLogsUrls.reduce("") { resultString, appLogUrl -> String in
            let logFileData = applicationLogData(fromUrl: appLogUrl)
            let fileName = appLogUrl.lastPathComponent
            if let logString = String(data: logFileData, encoding: .utf8), !logString.isEmpty {
                let delimeter = getDelimeter(for: fileName)
                return delimeter + logString + "\r\n\r\n"
            }
            return ""
        }
    }

    /*
     Returns Data for certain log file
     We have multiple log files, one for each process
     */
    private func applicationLogData(fromUrl url: URL) -> Data {
        let manager = ACLLogFileManagerDefault(logsDirectory: url.path)
        let logFileInfos = manager?.sortedLogFileInfos ?? []

        var logData = Data()
        for info in logFileInfos.reversed() {
            let delimeter = getDelimeter(for: info.fileName)
            if let delimeterData = delimeter.data(using: .utf8) {
                logData.append(delimeterData)
            }

            let fileUrl = URL(fileURLWithPath: info.filePath)
            if let fileData = try? Data(contentsOf: fileUrl) {
                logData.append(fileData)
            }
        }
        return logData
    }

    /* Returns delimeter for filename */
    private func getDelimeter(for fileName: String) -> String {
        var delimeter = "\r\n-------------------------------------------------------------\r\n"
        delimeter += "LOG FILE: \(fileName)"
        delimeter += "\r\n-------------------------------------------------------------\r\n"
        return delimeter
    }

    private func appendCBJsonsIntoTemporaryDirectory(cbUrl: URL) throws {
        try safariProtection.allConverterResults.forEach { converterResult in
            let fileUrl = converterResult.jsonUrl
            try FileManager.default.copyItem(at: fileUrl, to: cbUrl.appendingPathComponent( fileUrl.lastPathComponent))
        }
    }

    private func collectDnsServerInfo() -> DnsServerInfo {
        let provider = dnsProvidersManager.activeDnsProvider
        let server = dnsProvidersManager.activeDnsServer
        let serverName = server.isPredefined ? server.predefined.name : provider.name
        let serverId = server.id
        let upstreams = server.upstreams.reduce("") { partialResult, upstream in
            partialResult + "\(upstream.upstream)\n"
        }
        return (serverName, serverId, upstreams)
    }

    private func collectDnsFilters() -> String {
        return dnsProtection.filters.reduce("") { partialResult, filter in
            guard filter.isEnabled else { return partialResult }

            let filterString = "ID=\(filter.filterId) Name=\"\(filter.name ?? "UNDEFINED")\" Url=\(filter.filterDownloadPage ?? "UNDEFINED") Enabled=\(filter.isEnabled)\r\n"
            return partialResult + filterString
        }
    }
}
