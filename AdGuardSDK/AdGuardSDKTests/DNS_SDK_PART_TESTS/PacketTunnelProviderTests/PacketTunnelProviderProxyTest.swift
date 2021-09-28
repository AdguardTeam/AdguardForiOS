import XCTest
import NetworkExtension

class PacketTunnelProviderProxyTest: XCTestCase {
    let addresses = PacketTunnelProvider.Addresses(
        tunnelRemoteAddress: "127.0.0.1",
        interfaceIpv4: "172.16.209.3",
        interfaceIpv6: "fd12:1:1:1::3",
        localDnsIpv4: "198.18.0.1",
        localDnsIpv6: "2001:ad00:ad00::ad00",
        defaultSystemDnsServers: ["94.140.14.140", "94.140.14.141", "2a10:50c0::1:ff", "2a10:50c0::2:ff"]
    )
    var dnsProxy: DnsProxyMock!
    var dnsConfiguration: DnsConfigurationMock!
    var packetTunnelSetting: PacketTunnelSettingsProviderMock!
    var providersManager: DnsProvidersManagerMock!
    var delegateMock: PacketTunnelProviderProxyDelegateMock!
    var packetTunnelProviderProxy: PacketTunnelProviderProxyProtocol!

    override func setUp() {
        dnsProxy = DnsProxyMock()
        dnsConfiguration = DnsConfigurationMock()
        packetTunnelSetting = PacketTunnelSettingsProviderMock()
        providersManager = DnsProvidersManagerMock()
        delegateMock = PacketTunnelProviderProxyDelegateMock()
        packetTunnelProviderProxy = PacketTunnelProviderProxy(
            isDebugLogs: true,
            tunnelAddresses: addresses,
            dnsProxy: dnsProxy,
            dnsConfiguration: dnsConfiguration,
            tunnelSettings: packetTunnelSetting,
            providersManager: providersManager
        )
        packetTunnelProviderProxy.delegate = delegateMock
    }

    func test() {
        packetTunnelSetting.stubbedCreateSettingsResult = NEPacketTunnelNetworkSettings()
        delegateMock.stubbedReadPacketsCompletionHandlerResult = ([], [])

        let expectation = XCTestExpectation()
        packetTunnelProviderProxy.startTunnel(options: nil) { error in

            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.5)
    }

    // TODO: - Need more tests
}

// MARK: - PacketTunnelProviderProxyDelegateMock

final class PacketTunnelProviderProxyDelegateMock: PacketTunnelProviderProxyDelegate {

    var invokedSetTunnelSettingsCount = 0
    var invokedSetTunnelSettingsParameter: NETunnelNetworkSettings?
    var invokedSetTunnelSettingsParametersList: [NETunnelNetworkSettings?] = []
    var stubbedSetTunnelSettingsResult: Error?
    func setTunnelSettings(_ settings: NETunnelNetworkSettings?, _ completionHandler: ((Error?) -> Void)?) {
        invokedSetTunnelSettingsCount += 1
        invokedSetTunnelSettingsParameter = settings
        invokedSetTunnelSettingsParametersList.append(settings)
        completionHandler?(stubbedSetTunnelSettingsResult)
    }

    var invokedReadPacketsCount = 0
    var stubbedReadPacketsCompletionHandlerResult: ([Data], [NSNumber])!
    func readPackets(completionHandler: @escaping ([Data], [NSNumber]) -> Void) {
        invokedReadPacketsCount += 1
        DispatchQueue.global(qos: .background).async { [unowned self] in
            completionHandler(stubbedReadPacketsCompletionHandlerResult.0, stubbedReadPacketsCompletionHandlerResult.1)
        }
    }

    var invokedWritePacketsCount = 0
    var invokedWritePacketsParameters: (packets: [Data], protocols: [NSNumber])?
    var invokedWritePacketsParametersList: [(packets: [Data], protocols: [NSNumber])] = []
    func writePackets(_ packets: [Data], _ protocols: [NSNumber]) {
        invokedWritePacketsCount += 1
        invokedWritePacketsParameters = (packets, protocols)
        invokedWritePacketsParametersList.append((packets, protocols))
    }

    var invokedCancelTunnelCount = 0
    var invokedCancelTunnelParameters: Error?
    var invokedCancelTunnelParametersList = [Error?]()
    func cancelTunnel(with error: Error?) {
        invokedCancelTunnelCount += 1
        invokedCancelTunnelParameters = error
        invokedCancelTunnelParametersList.append(error)
    }
}
