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
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var importButton: RoundRectButton!
    @IBOutlet weak var okButton: RoundRectButton!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    var model: ImportSettingsViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        okButton.isHidden = true
        tableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        let contentHeight = tableView.contentSize.height
        let maxHeight = view.frame.size.height - 150
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
                self?.importButton.stopIndicator()
                self?.importButton.isHidden = true
                self?.okButton.isHidden = false
                self?.tableView.alpha = 1.0
                self?.tableView.isUserInteractionEnabled = true
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
        
        cell.title.text = row.title
        cell.tag = indexPath.row
        cell.delegate = self
        
        if row.imported {
            let image: UIImage?
            switch (row.enabled, row.successful) {
            case (_, true):
                image = UIImage(named: "logocheck")
            case (true, false):
                image = UIImage(named: "errorAttention")
            case (false, _):
                image = UIImage(named: "cross")
            }
            
            cell.check.image = image
        } else {
            cell.check.isHighlighted = row.enabled
        }
        
        cell.subtitle.text = row.subtitle
        
        cell.subtitleTopConstraint.constant = row.subtitle.count > 0 ? 7 : 0
        
        if indexPath.row == (model?.rows.count ?? 0) - 1 {
            cell.separator.isHidden = true
        }
        else {
            cell.separator.isHidden = false
        }
        
        theme.setupTableCell(cell)
        theme.setupLabel(cell.title)
        theme.setupSeparator(cell.separator)
        
        return cell
    }
    
    // MARK: - cell delegate
    
    func stateChanged(tag: Int, state: Bool) {
        model?.setState(state, forRow: tag)
    }
    
    // MARK: - privateMethods
    
    func updateTheme() {
        
        tableView.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
    }
    
}
