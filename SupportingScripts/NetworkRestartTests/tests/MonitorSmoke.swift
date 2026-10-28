// GPL-3.0-or-later. This smoke check does not toggle the host's networking.
import Foundation
@main struct MonitorSmoke {
    static func main() {
        weak var released: NetworkUtils?
        do {
            let utils = NetworkUtils()
            released = utils
            let deadline = Date().addingTimeInterval(3)
            while utils.getCurrentNetworkStateSync().physicalNetwork == nil && Date() < deadline {
                Thread.sleep(forTimeInterval: 0.02)
            }
            let state = utils.getCurrentNetworkStateSync()
            precondition(state.physicalNetwork != nil, "physical monitor did not deliver its initial snapshot")
            print("PASS: real NWPathMonitor delivered physical snapshot; no host network changes made")
        }
        let deadline = Date().addingTimeInterval(3)
        while released != nil && Date() < deadline { Thread.sleep(forTimeInterval: 0.02) }
        precondition(released == nil, "monitor callback retains NetworkUtils")
        print("PASS: NetworkUtils and monitors released after use")
    }
}
