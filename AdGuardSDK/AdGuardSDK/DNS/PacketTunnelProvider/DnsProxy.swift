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

import AGDnsProxy
import SharedAdGuardSDK

protocol DnsProxyProtocol: AnyObject {
    func start(_ systemDnsUpstreams: [DnsUpstream]) -> Error?
    func stop()
    func resolve(dnsRequest: Data, onRequestResolved: @escaping (Data?) -> Void)
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(DnsProxy.self)

/// This object is a wrapper arround `AGDnsProxy`
/// It is used to control proxy lifecycle
/// and to resolve requests that we obtain from `PacketTunnelProvider`
final class DnsProxy: DnsProxyProtocol {

    // MARK: - Private variables

    // Queue to resolve requests with DNS-lib
    private let resolveQueue = DispatchQueue(label: "DnsAdGuardSDK.DnsProxyBuilder.resolveQueue", attributes: .concurrent)

    // DNS proxy
    private var proxy: AGDnsProxy?

    /* Services */
    private let proxySettingsProvider: DnsProxyConfigurationProviderProtocol
    private let statisticsDbContainerUrl: URL

    // MARK: - Initialization

    init(proxySettingsProvider: DnsProxyConfigurationProviderProtocol, statisticsDbContainerUrl: URL) {
        self.proxySettingsProvider = proxySettingsProvider
        self.statisticsDbContainerUrl = statisticsDbContainerUrl
    }

    // MARK: - Public methods

    func start(_ systemDnsUpstreams: [DnsUpstream]) -> Error? {
        return resolveQueue.sync(flags: .barrier) { [weak self] in
            return self?.internalStart(systemDnsUpstreams)
        }
    }

    func stop() {
        resolveQueue.sync(flags: .barrier) { [weak self] in
            LOG.info("(DnsProxy) - stop")
            self?.proxy?.stop()
            self?.proxy = nil
            self?.proxySettingsProvider.reset()
            LOG.info("(DnsProxy) - stopped")
        }
    }

    func resolve(dnsRequest: Data, onRequestResolved: @escaping (Data?) -> Void) {
        resolveQueue.async { [weak self] in
            let reply = self?.proxy?.handlePacket(dnsRequest)
            onRequestResolved(reply)
        }
    }

    // MARK: - Private methods

    private func internalStart(_ systemDnsUpstreams: [DnsUpstream]) -> Error? {
        LOG.info("(DnsProxy) - start")

        // Configuration
        if proxy != nil {
            proxy?.stop()
            proxy = nil
        }
        proxySettingsProvider.reset()
        let configuration = proxySettingsProvider.getProxyConfig(systemDnsUpstreams)
        let agConfig = AGDnsProxyConfig(from: configuration)

        // Processing events config
        let handler: DnsRequestProcessedEventHandlerProtocol
        do {
            handler = DnsRequestProcessedEventHandler(
                proxyConfigurationProvider: proxySettingsProvider,
                activityStatistics: try ActivityStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl),
                chartStatistics: try ChartStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl),
                dnsLogStatistics: try DnsLogStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
            )
        }
        catch {
            LOG.error("(DnsProxy) - internalStart; Error initializing statistics: \(error)")
            return error
        }

        let agEvents = AGDnsProxyEvents()
        agEvents.onRequestProcessed = { [handler] event in
            if let event = event {
                handler.handle(event: AGDnsRequestProcessedEventWrapper(event: event))
            }
        }

        // Error reference
        var error: NSError?

        LOG.info("(DnsProxy) start with config: \n\(agConfig.extendedDescription)")

        // Proxy init
        proxy = AGDnsProxy(config: agConfig, handler: agEvents, error: &error)

        if let error = error {
            LOG.error("(DnsProxy) - started with error: \(error)")
            return error
        } else if proxy != nil {
            LOG.info("(DnsProxy) - started successfully")
            return nil
        } else {
            LOG.error("(DnsProxy) - started with unknown error")
            assertionFailure("Error and AGDnsProxy can't be both nil at the same time")
            return CommonError.missingData
        }
    }
}
