// GPL-3.0-or-later. Compiled against the actual patched production policy and proxy.
import Foundation
import Network

var checks = 0
func check(_ condition: @autoclosure () -> Bool, _ message: String) {
    precondition(condition(), message)
    checks += 1
}
let wifi = PhysicalNetworkState(available: true, interfaces: ["en0:6"], gateways: ["router-A"], addresses: ["en0:192.0.2.2"])
let cellular = PhysicalNetworkState(available: true, interfaces: ["pdp_ip0:8"], gateways: ["cell-router"], addresses: ["pdp_ip0:192.0.2.9"])
let down = PhysicalNetworkState(available: false, interfaces: [], gateways: [], addresses: [])
func tracker(_ physical: PhysicalNetworkState? = wifi) -> NetworkChangeTracker {
    NetworkChangeTracker(available: true, interfaceName: "en0", physicalNetwork: physical)
}
var policy = tracker()
check(policy.update(available: true, interfaceName: "en0", physicalNetwork: wifi) == .none, "identical event")
check(policy.update(available: true, interfaceName: "ipsec8", physicalNetwork: wifi) == .refreshProxy, "VPN on")
check(policy.update(available: false, interfaceName: nil, physicalNetwork: wifi) == .none, "VPN transient outage")
check(policy.update(available: true, interfaceName: "en0", physicalNetwork: wifi) == .refreshProxy, "VPN off after transient outage")
check(policy.update(available: true, interfaceName: "ipsec9", physicalNetwork: wifi) == .refreshProxy, "VPN new interface index")
check(policy.update(available: true, interfaceName: "ipsec9", physicalNetwork: cellular) == .restartTunnel, "Wi-Fi to cellular with same VPN")
check(policy.update(available: true, interfaceName: "ipsec9", physicalNetwork: wifi) == .restartTunnel, "cellular to Wi-Fi")
check(policy.update(available: true, interfaceName: "ipsec9", physicalNetwork: wifi) == .none, "physical callback duplicate")
for replacement in [
    PhysicalNetworkState(available: true, interfaces: wifi.interfaces, gateways: ["router-B"], addresses: wifi.addresses),
    PhysicalNetworkState(available: true, interfaces: wifi.interfaces, gateways: wifi.gateways, addresses: ["en0:192.0.2.3"]),
    PhysicalNetworkState(available: true, interfaces: ["en0:10"], gateways: wifi.gateways, addresses: wifi.addresses)
] {
    var change = tracker()
    check(change.update(available: true, interfaceName: "en0", physicalNetwork: replacement) == .restartTunnel, "same interface name with network identity change")
}
policy = tracker()
check(policy.update(available: false, interfaceName: nil, physicalNetwork: down) == .none, "airplane mode")
check(policy.update(available: false, interfaceName: nil, physicalNetwork: wifi) == .none, "physical recovery before default route")
check(policy.update(available: true, interfaceName: "en0", physicalNetwork: wifi) == .restartTunnel, "remember recovery with identical addresses")
policy = tracker()
check(policy.update(available: true, interfaceName: "en0", physicalNetwork: down) == .none, "stale available default while physical down")
check(policy.update(available: true, interfaceName: "en0", physicalNetwork: wifi) == .restartTunnel, "recover without default change")
policy = tracker(nil)
check(policy.update(available: true, interfaceName: "ipsec8", physicalNetwork: nil) == .refreshProxy, "underlay monitor not initialized")
check(policy.update(available: true, interfaceName: "ipsec8", physicalNetwork: wifi) == .none, "first underlay sample establishes baseline")
check(policy.update(available: true, interfaceName: "ipsec8", physicalNetwork: wifi, routeChanged: true) == .refreshProxy, "route/DNS callback with same physical fingerprint")
policy = tracker(nil)
check(policy.update(available: true, interfaceName: "ipsec8", physicalNetwork: nil, physicalMonitoringSupported: false) == .restartTunnel, "iOS 13 compatibility")

// Real proxy branches; collaborators are stubs, not the restart implementation.
do {
    let fixture = ProxyFixture()
    fixture.proxy.networkChanged(physicalNetworkChanged: false)
    fixture.drainAndStop()
    check(fixture.dns.starts == 1, "VPN change refreshes DNS with switch ON")
    check(fixture.dns.upstreams == ["system://ipsec8"], "preserve VPN DNS egress and filter own DNS")
    check(fixture.delegate.cancels == 0, "VPN change must not cancel tunnel")
    check(fixture.delegate.settings == 0, "VPN change must not reapply tunnel routes")
    check(fixture.delegate.reads == 0, "VPN refresh must not create another packet reader")
}
do {
    let fixture = ProxyFixture()
    fixture.proxy.networkChanged(physicalNetworkChanged: true)
    fixture.proxy.networkChanged(physicalNetworkChanged: true)
    fixture.drainAndStop()
    check(fixture.delegate.cancels == 1, "physical change with switch ON cancels once")
    check(fixture.dns.starts == 0, "queued event cannot restart cancelled provider")
}
do {
    let fixture = ProxyFixture()
    fixture.configuration.lowLevelConfiguration.restartByReachability = false
    fixture.proxy.networkChanged(physicalNetworkChanged: true)
    fixture.drainAndStop()
    check(fixture.dns.starts == 1 && fixture.delegate.settings == 1, "switch OFF physical recovery refreshes settings and DNS")
    check(fixture.delegate.cancels == 0, "switch OFF preserves extension")
}
do {
    let fixture = ProxyFixture()
    fixture.dns.error = NSError(domain: "test-DNS", code: 1)
    fixture.proxy.networkChanged(physicalNetworkChanged: false)
    fixture.drainAndStop()
    check(fixture.delegate.cancels == 1 && fixture.delegate.cancelError != nil, "DNS refresh failure retains error recovery")
}
do {
    let fixture = ProxyFixture()
    fixture.configuration.lowLevelConfiguration.restartByReachability = false
    fixture.delegate.settingsError = NSError(domain: "test-settings", code: 2)
    fixture.proxy.networkChanged(physicalNetworkChanged: true)
    fixture.drainAndStop()
    check(fixture.delegate.cancels == 1 && fixture.delegate.cancelError != nil, "physical settings failure retains error recovery")
}
do {
    let fixture = ProxyFixture()
    fixture.drainAndStop()
    fixture.proxy.networkChanged(physicalNetworkChanged: false)
    fixture.drainAndStop()
    check(fixture.dns.starts == 0 && fixture.delegate.cancels == 0, "late event after stop is ignored")
}
do {
    let fixture = ProxyFixture()
    let started = DispatchSemaphore(value: 0)
    fixture.proxy.startTunnel(options: nil) { error in
        precondition(error == nil)
        started.signal()
    }
    check(started.wait(timeout: .now() + 3) == .success, "initial proxy start")
    check(fixture.delegate.readStarted.wait(timeout: .now() + 3) == .success, "initial packet reader")
    var churn = tracker()
    for index in 0..<20 {
        let name = index.isMultiple(of: 2) ? "ipsec8" : "en0"
        let action = churn.update(available: true, interfaceName: name, physicalNetwork: wifi)
        check(action == .refreshProxy, "repeated VPN changes remain proxy-only")
        fixture.proxy.networkChanged(physicalNetworkChanged: action == .restartTunnel)
    }
    fixture.drainAndStop()
    check(fixture.dns.starts == 21, "DNS refresh runs for each changed egress")
    check(fixture.delegate.cancels == 0 && fixture.delegate.settings == 1,
          "VPN churn retains the original tunnel settings")
    check(fixture.delegate.reads == 1, "VPN churn preserves one pending packet reader")
}
print("PASS: \(checks) checks against patched NetworkStateInfo.swift and PacketTunnelProviderProxy.swift")
