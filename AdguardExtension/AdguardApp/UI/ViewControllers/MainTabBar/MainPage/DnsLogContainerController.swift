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
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    private let complexProtection: ComplexProtectionServiceProtocol = ServiceLocator.shared.getService()!
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    private let model = DnsRequestLogViewModel(dnsLogService: ServiceLocator.shared.getService()!, dnsTrackerService: ServiceLocator.shared.getService()!, dnsFiltersService: ServiceLocator.shared.getService()!)
    
    private var themeNotificationToken: NotificationToken?
    private var proObservation: NSKeyValueObservation?
    
    private let showDnsLogSegueId = "showDnsLogSegue"
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        
        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
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
    
    private func updateTheme(){
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
    }
    
    
    
    private func setCurrentContainerView(){
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            let proStatus = self.configuration.proStatus
            
            if proStatus {
                let systemProtectionEnabled = self.complexProtection.systemProtectionEnabled
                let recordsAreEmpty = self.model.records.isEmpty
                if recordsAreEmpty && !systemProtectionEnabled {
                    self.navigationItem.rightBarButtonItems = []
                    self.getProContainerView.isHidden = true
                    self.systemProtectionEnablerContainerView.isHidden = false
                    self.dnsLogContainerView.isHidden = true
                    self.hideTitle()
                } else {
                    self.getProContainerView.isHidden = true
                    self.systemProtectionEnablerContainerView.isHidden = true
                    self.dnsLogContainerView.isHidden = false
                }
            } else {
                self.navigationItem.rightBarButtonItems = []
                self.getProContainerView.isHidden = false
                self.systemProtectionEnablerContainerView.isHidden = true
                self.dnsLogContainerView.isHidden = true
                self.hideTitle()
            }
        }
    }
}

extension DnsLogContainerController: ActivityViewControllerDelegate {
    func hideTitle() {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.3
        fadeTextAnimation.type = .fade

        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        navigationItem.title = ""
    }
    
    func showTitle() {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.3
        fadeTextAnimation.type = .fade

        navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
        navigationItem.title = String.localizedString("activity_title")
    }
}
