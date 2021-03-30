protocol ThemableProtocol {
    func themeNeedUpdate()
}

extension AppDelegate {
    
    func themeChange() {
        guard let root =  window?.rootViewController else { return }
        recursiveThemeUpdate(vc: root)
    }
    
    private func recursiveThemeUpdate(vc: UIViewController?) {
        if vc == nil { return }
        print("TEST - ", vc)
        recursiveThemeUpdate(vc: vc?.presentedViewController)
        recursiveChieldThemeUpdate(chields: vc?.children)
        (vc as? ThemableProtocol)?.themeNeedUpdate()
    }
    
    private func recursiveChieldThemeUpdate(chields: [UIViewController]?) {
        if let chields = chields, chields.isEmpty { return }
        print("TEST - chields", chields)
        chields?.forEach {
            print("TEST - chield", $0)
            recursiveChieldThemeUpdate(chields: $0.children)
            ($0 as? ThemableProtocol)?.themeNeedUpdate()
        }
    }
}
