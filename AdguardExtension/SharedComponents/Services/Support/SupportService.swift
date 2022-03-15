//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import Zip
import SafariAdGuardSDK
import DnsAdGuardSDK
import AGDnsProxy
import SharedAdGuardSDK

protocol SupportServiceProtocol {
    /// Preparing logs archive to sharing. Return archive file URL in temporary directory
    func exportLogs() throws -> URL?

    /// Delete log archive and other log files from temporary directory. Call it after sharing archive of logs
    func deleteLogsFiles()

    /// Sending feedback data to our backend
    func sendFeedback(_ email: String, description: String, sendLogs: Bool, _ completion: @escaping (_ logsSentSuccessfully: Bool) -> Void)
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(SupportService.self)

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
    private let fileManager = FileManager.default

    private var appLogsUrls: [URL] {
        let logsUrl = resources.sharedLogsURL()
        let logsUrls = try? fileManager.contentsOfDirectory(at: logsUrl, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: [])
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

        /// Move logs to tmp directory
        try moveFiles(appLogsUrls, targetsUrl)

        do {
            try Zip.zipFiles(paths: [baseUrl], zipFilePath: logsZipUrl, password: nil, compression: .BestSpeed, progress: nil)
            return logsZipUrl
        }
        catch {
            LOG.error("Failed to export logs: \(error)")
        }
        return nil
    }

    func deleteLogsFiles() {

        do {
            if let logsDirectory = self.logsDirectory {
                try fileManager.removeItem(at: logsDirectory)
            }
            if let logsZipDirectory = self.logsZipDirectory {
                try fileManager.removeItem(at: logsZipDirectory)
            }

            self.logsDirectory = nil
            self.logsZipDirectory = nil
        }
        catch {
            LOG.error("Error removing logs files: \(error)")
        }
    }

    func sendFeedback(_ email: String, description: String, sendLogs: Bool, _ completion: @escaping (_ logsSentSuccessfully: Bool) -> Void) {
        let appId = keyChainService.appId
        let version = productInfo.buildVersion()
        let email = email
        let language = ADLocales.lang()
        let subject = "\(Bundle.main.applicationName) app bug report"
        let description = description
        let applicationState = createApplicationStateInfo()
        let debugInfo = sendLogs ? createDebugInfo() : ""
        let feedback = FeedBack(applicationId: appId, version: version, email: email, language: language, subject: subject, description: description, applicationState: applicationState, debugInfo: debugInfo)

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

        General CB rules count: \(safariProtection.allConverterResults.first(where: { $0.type == .general })?.totalConverted ?? 0)
        Privacy CB rules count: \(safariProtection.allConverterResults.first(where: { $0.type == .privacy })?.totalConverted ?? 0)
        Social CB rules count: \(safariProtection.allConverterResults.first(where: { $0.type == .socialWidgetsAndAnnoyances })?.totalConverted ?? 0)
        Other CB rules count: \(safariProtection.allConverterResults.first(where: { $0.type == .other })?.totalConverted ?? 0)
        Custom CB rules count: \(safariProtection.allConverterResults.first(where: { $0.type == .custom })?.totalConverted ?? 0)
        Security CB rules count: \(safariProtection.allConverterResults.first(where: { $0.type == .security })?.totalConverted ?? 0)
        Advanced rules count: \(safariProtection.advancedRulesCount)

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

        /// Append log file for each process to base
        
        do {
            let data = try getLogDataForReport(appLogsUrls)
            if let stringData = String(data: data, encoding: .utf8), !stringData.isEmpty {
                LOG.info("Successfully create report logs data")
                return stringData
            }
            LOG.warn("Report logs data is missing")
        } catch {
            LOG.error("On creating report logs error occurred: \(error)")
        }
        
        return ""
        
    }

    /* Returns delimeter for filename */
    private func getDelimeter(for fileName: String) -> String {
        var delimeter = "\r\n-------------------------------------------------------------\r\n"
        delimeter += "LOG FILE: \(fileName)"
        delimeter += "\r\n-------------------------------------------------------------\r\n"
        return delimeter
    }

    private func appendCBJsonsIntoTemporaryDirectory(cbUrl: URL) throws {
        let advancedRulesFileUrl = safariProtection.advancedRulesFileUrl
        if fileManager.fileExists(atPath: advancedRulesFileUrl.path) {
            try fileManager.copyItem(at: advancedRulesFileUrl, to: cbUrl.appendingPathComponent(advancedRulesFileUrl.lastPathComponent))
        }
        
        try safariProtection.allContentBlockerJsonUrls.forEach { fileUrl in
            if fileManager.fileExists(atPath: fileUrl.path) {
                try fileManager.copyItem(at: fileUrl, to: cbUrl.appendingPathComponent(fileUrl.lastPathComponent))
            }
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
    
    private func moveFiles(_ logFileURLs: [URL], _ targetDirectory: URL) throws {
        try logFileURLs.forEach {
            var targetDirectory = targetDirectory
            let fileName = $0.lastPathComponent
            targetDirectory.appendPathComponent(fileName)
            
            try fileManager.moveItem(at: $0, to: targetDirectory)
        }
    }
    
    private func getLogDataForReport(_ logFilePathes: [URL]) throws -> Data {
        var data = Data()
        for processLogDir in logFilePathes {
            let processData = try readLogFiles(processLogDir)
            data.append(processData)
        }
        
        return data
    }
    
    private func readLogFiles(_ processLogsDirPath: URL) throws -> Data {
        let singleProcessLogsContent = try getDirectoryContentUrls(processLogsDirPath)
        var data: Data = Data()
        
        for logPath in singleProcessLogsContent {
            let partOfLogs = try readLogFile(logPath, processName: processLogsDirPath.lastPathComponent)
            data.append(partOfLogs)
        }
        
        return data
    }
    
    private func readLogFile(_ filePath: URL, processName: String) throws -> Data {
        var data: Data = Data()
        
        let fileName = "\(processName).\(filePath.lastPathComponent)" // <PROCESS NAME>.<LOG FILE NAME>
        let singleLogFileData = try Data(contentsOf: filePath)
        let delimeter = getDelimeter(for: fileName)
        
        if let delimeterData = delimeter.data(using: .utf8) {
            data.append(delimeterData)
        }
        
        data.append(singleLogFileData)
        
        return data
    }
    
    
    private func getDirectoryContentUrls(_ target: URL) throws -> [URL] {
        if try target.resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true {
            let logsUrls = try fileManager
                .contentsOfDirectory(at: target, includingPropertiesForKeys: [.contentModificationDateKey], options: [.skipsHiddenFiles])
                .sorted(by: {
                    let date0 = try $0.promisedItemResourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate!
                    let date1 = try $1.promisedItemResourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate!
                    return date0.compare(date1) == .orderedAscending
                })
            return logsUrls
        }
        return []
    }
}
