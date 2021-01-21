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

class ImportSettingsController: BottomAlertController, UITextViewDelegate, UITableViewDataSource, ImportSettingsCellDelegate {
    
    var settings: Settings?
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var importButton: RoundRectButton!
    @IBOutlet weak var okButton: RoundRectButton!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private let antibanner: AESAntibannerProtocol = ServiceLocator.shared.getService()!
    private let importService: ImportSettingsServiceProtocol = ServiceLocator.shared.getService()!
    private let dnsProvidersService: DnsProvidersServiceProtocol = ServiceLocator.shared.getService()!
    private var model: ImportSettingsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if settings != nil {
            model = ImportSettingsViewModel(settings: settings!, importSettingsService: importService, antibanner: antibanner, dnsProvidersService: dnsProvidersService)
        }
        
        okButton.isHidden = true
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let contentHeight = tableView.contentSize.height
        let maxHeight = view.frame.size.height - 250
        tableViewHeightConstraint.constant = min(contentHeight, maxHeight)
    }
    
    @IBAction func importAction(_ sender: Any) {
        importButton.startIndicator()
        importButton.isEnabled = false
        tableView.isUserInteractionEnabled = false
        tableView.alpha = 0.5
        model?.applySettings() {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                if self?.model?.rows.count ?? 0 > 0 {
                    self?.importButton.stopIndicator()
                    self?.importButton.isHidden = true
                    self?.okButton.isHidden = false
                    self?.tableView.alpha = 1.0
                    self?.tableView.isUserInteractionEnabled = true
                } else {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func okAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.rows.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImportSettingsCell") as? ImportSettingsCell else {
            DDLogError("can not instantiate ImportSettingsCell")
            return UITableViewCell()
        }
        
        guard let row = model?.rows[indexPath.row] else {
            DDLogError("can not find row at index: \(indexPath.row)")
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.tag = indexPath.row
        
        cell.setup(model: row, lastRow: indexPath.row == (model?.rows.count ?? 0) - 1, theme: theme)
        
        return cell
    }
    
    // MARK: - cell delegate
    
    func stateChanged(tag: Int, state: Bool) {
        model?.setState(state, forRow: tag)
    }
    
    // MARK: - privateMethods
    
    private func updateTheme() {
        self.contentView.backgroundColor = theme.backgroundColor
        tableView.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
    }
    
}
