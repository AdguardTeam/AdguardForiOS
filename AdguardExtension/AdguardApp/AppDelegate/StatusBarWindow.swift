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

protocol IStatusBarWindow: AnyObject {
    var statusBarWindowIsHidden: Bool { get set }
    func createStatusBarWindow()
    func showStatusViewIfNeeded(text: String)
    func hideStatusViewIfNeeded()
    func changeOrientation()
    func changeTextForStatusView(text: String)
}

final class StatusBarWindow: IStatusBarWindow {
    //MARK: - Properties
    
    var statusBarWindowIsHidden: Bool {
        get {
            statusBarWindow?.isHidden ?? true
        }
        
        set {
            statusBarWindow?.isHidden = newValue
        }
    }
    
    private var statusBarIsShown = false
    private var statusViewCounter = 0
    
    private let statusView = StatusView()
    private var statusBarWindow: UIWindow?
    private let configuration: ConfigurationServiceProtocol
    
    init(configuration: ConfigurationServiceProtocol) {
        self.configuration = configuration
    }
    
    //MARK: - IStatusBarWindow methods
    
    func createStatusBarWindow() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        let bottomSafeAreaInset = keyWindow.safeAreaInsets.bottom / 2.0
        
        let frame = CGRect(x: 0.0, y: keyWindow.frame.maxY, width: keyWindow.frame.width, height: 16.0 + bottomSafeAreaInset)
        
        let bannerWindow = UIWindow(frame: frame)
        bannerWindow.backgroundColor = UIColor.AdGuardColor.lightGray
        bannerWindow.windowLevel = UIWindow.Level.statusBar
        bannerWindow.addSubview(statusView)
        bannerWindow.isHidden = false
        
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.topAnchor.constraint(equalTo: bannerWindow.topAnchor).isActive = true
        statusView.leftAnchor.constraint(equalTo: bannerWindow.leftAnchor).isActive = true
        statusView.rightAnchor.constraint(equalTo: bannerWindow.rightAnchor).isActive = true
        statusView.bottomAnchor.constraint(equalTo: bannerWindow.bottomAnchor).isActive = true
        
        self.statusBarWindow = bannerWindow
    }
    
    func showStatusViewIfNeeded(text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.statusViewCounter += 1
            
            if !self.configuration.showStatusBar {
                return
            }
            
            if !self.statusBarIsShown {
                self.statusBarIsShown = true
                self.showStatusView(with: text)
                
            } else {
                self.changeTextForStatusView(text: text)
            }
        }
    }
    
    func hideStatusViewIfNeeded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.statusViewCounter > 0{
                self.statusViewCounter -= 1
            }
            
            if self.statusViewCounter == 0 {
                self.hideStatusView()
            }
        }
    }
    
    func changeOrientation() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5) { [weak self] in
                guard let self = self else { return }
                guard let keyWindow = UIApplication.shared.keyWindow else { return }
                let height = self.statusBarWindow?.frame.height ?? 0.0
                
                if self.statusBarIsShown {
                    let frame = CGRect(x: 0.0, y: keyWindow.frame.maxY - height, width: keyWindow.frame.width, height: height)
                    self.statusBarWindow?.frame = frame
                } else {
                    let frame = CGRect(x: 0.0, y: keyWindow.frame.maxY, width: keyWindow.frame.width, height: height)
                    self.statusBarWindow?.frame = frame
                }
            }
        }
    }
    
    func changeTextForStatusView(text: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statusView.text = text
        }
    }
    //MARK: - Private methods
    
    private func showStatusView(with text: String?) {
        statusBarWindow?.isHidden = false
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let self = self else { return }
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            
            self.statusView.text = text
            let height = self.statusBarWindow?.frame.height ?? 0.0
            self.statusBarWindow?.frame.origin.y = keyWindow.frame.maxY - height
        }
    }
    
    private func hideStatusView() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let self = self else { return }
            guard let keyWindow = UIApplication.shared.keyWindow else { return }
            
            self.statusBarWindow?.frame.origin.y = keyWindow.frame.maxY
        }) { [weak self] (success) in
            guard let self = self else { return }
            self.statusBarIsShown = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                self.statusBarWindow?.isHidden = true
            }
        }
    }
}
