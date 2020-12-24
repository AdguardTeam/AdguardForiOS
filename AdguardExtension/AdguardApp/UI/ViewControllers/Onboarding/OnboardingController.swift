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

import Foundation

class OnboardingCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var separator: UIView!
}

protocol OnboardingControllerDelegate {
    func onboardingDidFinish()
}

class OnboardingController: UIViewController {
    
    var delegate: OnboardingControllerDelegate?
    var needsShowingPremium: Bool?
    
    // MARK: - services
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let configuration: ConfigurationService = ServiceLocator.shared.getService()!
    
    private var themeToken: NotificationToken?
    private var contenBlockerObservation: NSKeyValueObservation?
    
    private let showLicenseSegue = "ShowLicenseSegue"
    private let onboardingCellId = "OnboardingCellId"
    
    private let contentBlockers = ["AdGuard — Custom", "AdGuard — General", "AdGuard — Other", "AdGuard — Privacy"]
    private let cellsAlpha: [CGFloat] = [1.0, 0.7, 0.4, 0.1]
    
    // MARK: - outlets
    @IBOutlet weak var settingsLabel: ThemableLabel!
    @IBOutlet weak var safariLabel: ThemableLabel!
    @IBOutlet weak var switchLabel: ThemableLabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var watchManualButtonIpad: UIButton!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    // MARK: - view controller live cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
            self?.setupLabels()
        }
        
        contenBlockerObservation = configuration.observe(\.contentBlockerEnabled) {[weak self] (_, _) in
            self?.observeContentBlockersState()
        }
        
        setupLabels()
        updateTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let getProController = segue.destination as? GetProController {
            navigationController?.setNavigationBarHidden(false, animated: true)
            getProController.needsShowingExitButton = true
            if let getProControllerDelegate = delegate as? GetProControllerDelegate {
                getProController.getProControllerDelegate = getProControllerDelegate
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return theme.statusbarStyle()
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(_ sender: Any) {
        // We mustn't show License screen for japannese in onboarding
        let isJapanesse = Locale.current.languageCode == "ja"
        
        if needsShowingPremium == true && !configuration.proStatus && !isJapanesse{
            performSegue(withIdentifier: self.showLicenseSegue, sender: self)
        } else {
            dismiss(animated: true) { [weak self] in
                self?.delegate?.onboardingDidFinish()
            }
        }
    }
    
    @IBAction func videoAction(_ sender: UIButton) {
        showVideoTutorial()
    }
    
    
    // MARK: - Private methods
    
    private func setupLabels() {
        settingsLabel.attributedText = NSMutableAttributedString.fromHtml(String.localizedString("onboarding_first_step_text"), fontSize: settingsLabel.font!.pointSize, color: theme.grayTextColor, attachmentImage: nil)
        
        safariLabel.attributedText = NSMutableAttributedString.fromHtml(String.localizedString("onboarding_second_step_text"), fontSize: safariLabel.font!.pointSize, color: theme.grayTextColor, attachmentImage: nil)
        
        switchLabel.attributedText = NSMutableAttributedString.fromHtml(String.localizedString("onboarding_third_step_text"), fontSize: switchLabel.font!.pointSize, color: theme.grayTextColor, attachmentImage: nil)
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
        theme.setupTable(tableView)
        watchManualButtonIpad.applyStandardOpaqueStyle()
        tableView.reloadData()
    }
    
    private func observeContentBlockersState(){
        // We mustn't show License screen for japannese in onboarding
        let isJapanesse = Locale.current.languageCode == "ja"
        
        if needsShowingPremium == true && configuration.someContentBlockersEnabled && !configuration.proStatus {
            DispatchQueue.main.async {[weak self] in
                guard let self = self else { return }
                if isJapanesse {
                    self.dismiss(animated: true) {
                        self.delegate?.onboardingDidFinish()
                    }
                } else {
                    self.performSegue(withIdentifier: self.showLicenseSegue, sender: self)
                }
            }
        }
    }
}

extension OnboardingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentBlockers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: onboardingCellId) as? OnboardingCell {
            cell.titleLabel.text = contentBlockers[indexPath.row]
            cell.separator.isHidden = indexPath.row == contentBlockers.count - 1
            
            theme.setupTableCell(cell)
            theme.setupSeparator(cell.separator)
            cell.titleLabel.textColor = configuration.darkTheme ? .white : .black
            cell.contentView.alpha = cellsAlpha[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
