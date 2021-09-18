import NetworkExtension

final class PacketTunnelSettingsProviderMock: PacketTunnelSettingsProviderProtocol {

    var invokedCreateSettingsCount = 0
    var invokedCreateSettingsParameters: (full: Bool, withoutVpnIcon: Bool)?
    var invokedCreateSettingsParametersList = [(full: Bool, withoutVpnIcon: Bool)]()
    var stubbedCreateSettingsResult: NEPacketTunnelNetworkSettings!
    func createSettings(full: Bool, withoutVpnIcon: Bool) -> NEPacketTunnelNetworkSettings {
        invokedCreateSettingsCount += 1
        invokedCreateSettingsParameters = (full, withoutVpnIcon)
        invokedCreateSettingsParametersList.append((full, withoutVpnIcon))
        return stubbedCreateSettingsResult
    }
}
