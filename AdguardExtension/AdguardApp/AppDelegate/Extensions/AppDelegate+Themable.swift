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
        recursiveThemeUpdate(vc: vc?.presentedViewController)
        recursiveChieldThemeUpdate(chields: vc?.children)
        (vc as? ThemableProtocol)?.themeNeedUpdate()
    }
    
    private func recursiveChieldThemeUpdate(chields: [UIViewController]?) {
        if let chields = chields, chields.isEmpty { return }
        chields?.forEach {
            recursiveChieldThemeUpdate(chields: $0.children)
            ($0 as? ThemableProtocol)?.themeNeedUpdate()
        }
    }
}
