# Network restart regression checks

Run from the repository root on macOS with Xcode and its iPhoneOS SDK selected:

```sh
./SupportingScripts/NetworkRestartTests/build.sh
```

The script compiles the checked-out production network policy, proxy, and monitor
adapter. Collaborators in `tests/` are isolated test doubles; they are never linked
into the app. No private package registry, signing identity, device, or network
configuration change is required. Build products are temporary and removed on exit.

The checks cover VPN interface changes, transient default-path outages, physical
network recovery, changed addresses/gateways/interface indices, callback ordering,
iOS 13 fallback, proxy errors, late events after stopping, and repeated VPN changes
without creating additional packet readers or reapplying tunnel settings. A real
NWPathMonitor smoke check verifies initial delivery and object release without
switching the host network. iOS SDK checks cover the state model on iOS 13/15 and
the monitor/proxy on iOS 13; the provider receives a syntax check only.

These checks supplement the application tests; they do not replace a complete
build with real DNS dependencies or physical-device validation. In particular,
they do not validate DNS leaks, IPv6/NAT64, power use, or network transitions on a
phone. The monitor smoke check expects macOS 11 or later.

## Physical-device regression matrix

Use Split-Tunnel with DNS protection and Restart protection when network changes
enabled. Keep the system Personal VPN configuration constant between comparisons.

- Repeatedly connect/disconnect IKEv2 and verify fresh HTTPS requests and DNS queries.
  VPN-only changes should refresh DNS egress without cancelling the provider or
  reinstalling tunnel settings.
- Switch Wi-Fi/cellular and back, switch between Wi-Fi networks (including networks
  sharing an address range), and recover from Airplane Mode. Physical changes should
  retain full restart behavior with the setting on and internal recovery with it off.
- Check lock/wake recovery, IPv4/IPv6/NAT64, DNS allow/block responses and actual
  egress, Safari filtering, and sustained connectivity/power use.
- Verify iOS 13 separately: this version retains the previous restart policy because
  the monitor that excludes virtual interfaces is unavailable.

The physical snapshot is not an SSID identity: two networks with identical
interfaces, addresses and gateways, with no observed outage, cannot be distinguished
by this policy. Default-path changes still refresh DNS egress in that case.
