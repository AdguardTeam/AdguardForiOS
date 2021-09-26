/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import Zip
import SafariAdGuardSDK
import DnsAdGuardSDK

protocol SupportServiceProtocol {
    /// Preparing logs archive to sharing. Return archive file URL in temporary directory
    func exportLogs() -> URL?
    /// Delete log archive and other log files from temporary directory. Call it after sharing archive of logs
    func deleteLogsFiles()
    /// Sending feedback data to our backend
    func sendFeedback(_ email: String, description: String, reportType: ReportType, sendLogs: Bool, _ completion: @escaping (_ logsSentSuccessfully: Bool) -> Void)
}

/// Support service assemble app state info
final class SupportService: SupportServiceProtocol {
    
    fileprivate struct DnsServerInfo {
        let serverName: String
        let serverId: Int
        let upstreams: String
    }
    
    // Services
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationServiceProtocol
    private let complexProtection: ComplexProtectionServiceProtocol
    private let networkSettings: NetworkSettingsServiceProtocol
    private let productInfo: ADProductInfoProtocol
    private let keyChainService: KeychainServiceProtocol
    private let safariProtection: SafariProtectionProtocol
    private let dnsProvidersManager: DnsProvidersManagerProtocol
    private let dnsProtection: DnsProtectionProtocol

    // Helper variable
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
    
    func exportLogs() -> URL? {
        let archiveName = "AdGuard_logs.zip"
        
        let tmp = NSTemporaryDirectory()
        let baseUrlString = tmp + "logs/"
        let cbUrlString = baseUrlString + "CB jsons/"
        let targetsUrlString = baseUrlString + "Targets/"
        let fileManager = FileManager.default
        
        /// Create directories in base directory
        try? fileManager.createDirectory(atPath: baseUrlString, withIntermediateDirectories: true, attributes: nil)
        try? fileManager.createDirectory(atPath: cbUrlString, withIntermediateDirectories: true, attributes: nil)
        try? fileManager.createDirectory(atPath: targetsUrlString, withIntermediateDirectories: true, attributes: nil)
        
        /// Get jsons for content blockers and append them to base directory
        appendCBJsonsIntoTemporaryDirectory(cbUrlString: cbUrlString)
        
        /// Get application state info and save it as state.txt to base directory
        let appStateData = createApplicationStateInfo().data(using: .utf8)
        let appStateUrl = URL(fileURLWithPath: baseUrlString + "state.txt")
        try? appStateData?.write(to: appStateUrl)
        
        /// Flush Logs before appending them
        ACLLogger.singleton()?.flush()
        
        /// Append log file for each process to base directory
        appLogsUrls.forEach { appLogUrl in
            let logFileData = applicationLogData(fromUrl: appLogUrl)
            let fileName = appLogUrl.lastPathComponent
            let fileUrl = URL(fileURLWithPath: targetsUrlString + fileName)
            try? logFileData.write(to: fileUrl)
        }
        
        let baseUrl = URL(fileURLWithPath: baseUrlString, isDirectory: true)
        let logsZipUrl = URL(fileURLWithPath: tmp + archiveName)
        
        self.logsDirectory = baseUrl
        self.logsZipDirectory = logsZipUrl
        
        do {
            try Zip.zipFiles(paths: [baseUrl], zipFilePath: logsZipUrl, password: nil, compression: .BestSpeed, progress: nil)
            return logsZipUrl
        }
        catch {
            DDLogError("Failed to export logs: \(error)")
        }
        return nil
    }
    
    func deleteLogsFiles() {
        let fm = FileManager.default
        
        guard let logsDirectory = self.logsDirectory, let logsZipDirectory = self.logsZipDirectory else {
            DDLogError("File is missing")
            return
        }
        
        do {
            try fm.removeItem(at: logsDirectory)
            try fm.removeItem(at: logsZipDirectory)
            
            self.logsDirectory = nil
            self.logsZipDirectory = nil
        }
        catch {
            DDLogError("Error removing logs files: \(error)")
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
        
        let filters = safariProtection.groups
            .filter { $0.isEnabled }
            .flatMap { $0.filters }
            .reduce("") { filtersString, filter in
                let metaString = "ID=\(filter.filterId) Name=\"\(filter.name ?? "-")\" Version=\(filter.version ?? "-") Enabled=\(filter.isEnabled)\n"
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

        Locale: \(ADLocales.lang() ?? "Unknown")
        Region: \(ADLocales.region() ?? "Unknown")

        GeneralContentBlockerRulesCount: \(resources.generalContentBlockerRulesCount)
        PrivacyContentBlockerRulesCount: \(resources.privacyContentBlockerRulesCount)
        SocialContentBlockerRulesCount: \(resources.socialContentBlockerRulesCount)
        OtherContentBlockerRulesCount: \(resources.otherContentBlockerRulesCount)
        CustomContentBlockerRulesCount: \(resources.customContentBlockerRulesCount)
        SecurityContentBlockerRulesCount: \(resources.securityContentBlockerRulesCount)

        Filters subscriptions:
        \(filters)

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
        """
        
        resultString.append("\r\nDns upstream: \(serverInfo.upstreams)")
        
        if networkSettings.exceptions.count > 0 {
            resultString.append("\r\n\r\nWi-Fi exceptions:")
            for exception in networkSettings.exceptions {
                resultString.append("\r\nWi-Fi name=\"\(exception.rule)\" Enabled=\(exception.enabled)")
            }
        }
        
        let filtersString = collectDnsFilters()
        guard !filtersString.isEmpty else { return resultString }
        resultString.append("\r\nDns filters: \r\n");
        resultString.append(filtersString)
        
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
    
    private func appendCBJsonsIntoTemporaryDirectory(cbUrlString: String) {
        safariProtection.allConverterResults.forEach { converterResult in
            let fileUrl = converterResult.jsonUrl
            let fileManager = FileManager.default
            try? fileManager.copyItem(atPath: fileUrl.path, toPath: cbUrlString + fileUrl.lastPathComponent)
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
        return DnsServerInfo(serverName: serverName,
                             serverId: serverId,
                             upstreams: upstreams)
    }
    
    private func collectDnsFilters() -> String {
        return dnsProtection.filters.reduce("") { partialResult, filter in
            guard filter.isEnabled else { return partialResult }
            let filterString = "ID=\(filter.filterId) Name=\"\(filter.name ?? "UNDEFINED")\" Url=\(filter.filterDownloadPage ?? "UNDEFINED") Enabled=\(filter.isEnabled)\r\n"
            return partialResult + filterString
        }
    }
}
