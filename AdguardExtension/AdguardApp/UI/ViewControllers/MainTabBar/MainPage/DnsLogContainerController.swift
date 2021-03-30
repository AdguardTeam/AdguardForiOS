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

import UIKit

class DnsLogContainerController: UIViewController {

    // MARK: - Variables
    @IBOutlet weak var systemProtectionEnablerContainerView: UIView!
    @IBOutlet weak var getProContainerView: UIView!
    @IBOutlet weak var dnsLogContainerView: UIView!
    @IBOutlet weak var nativeDnsContainerView: UIView!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    private let model = DnsRequestLogViewModel(dnsLogService: ServiceLocator.shared.getService()!, dnsTrackerService: ServiceLocator.shared.getService()!, dnsFiltersService: ServiceLocator.shared.getService()!)
    
    private var resetSettingsToken: NotificationToken?
    private var proObservation: NSKeyValueObservation?
    
    private let showDnsLogSegueId = "showDnsLogSegue"
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        resetSettingsToken = NotificationCenter.default.observe(name: NSNotification.resetSettings, object: nil, queue: .main) { [weak self] (notification) in
            self?.setCurrentContainerView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCurrentContainerView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showDnsLogSegueId {
            if let vc = segue.destination as? ActivityViewController {
                vc.requestsModel = model
                vc.delegate = self
            }
        }
    }
    
    
    // MARK: - Private methods
    
    private func setCurrentContainerView() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            let proStatus = self.configuration.proStatus
            let nativeDnsImplementation = self.resources.dnsImplementation == .native
            
            self.getProContainerView.isHidden = true
            self.systemProtectionEnablerContainerView.isHidden = true
            self.dnsLogContainerView.isHidden = true
            self.nativeDnsContainerView.isHidden = true
            self.hideTitle()
            
            if proStatus {
                
                if nativeDnsImplementation {
                    self.nativeDnsContainerView.isHidden = false
                    return
                }
                
                let systemProtectionEnabled = self.complexProtection.systemProtectionEnabled
                let recordsAreEmpty = self.model.records.isEmpty
                
                if recordsAreEmpty && !systemProtectionEnabled {
                    self.systemProtectionEnablerContainerView.isHidden = false
                } else {
                    self.dnsLogContainerView.isHidden = false
                }
            } else {
                self.getProContainerView.isHidden = false
            }
        }
    }
}

extension DnsLogContainerController: ActivityViewControllerDelegate {
    func hideTitle() {
        animateHidingTitleInNavBar()
    }
    
    func showTitle() {
        animateShowingTitleInNavBar(String.localizedString("activity_title"))
    }
}

extension DnsLogContainerController: ThemableProtocol {
    func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
    }
}
