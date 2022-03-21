import Foundation

extension UIApplication {
    static var isOldAdGuardInstalled: Bool {
        let adGuard = URL(string: "")!
        let adGuardPro = URL(string: "")!
        return shared.canOpenURL(adGuardPro) || shared.canOpenURL(adGuardPro)
    }
}
