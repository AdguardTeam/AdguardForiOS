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

// MARK: - BlockRequestCellModel

class BlockRequestCellModel: CustomDebugStringConvertible {
    let domain: String
    var isSelected: Bool
    let theme: ThemeServiceProtocol
    
    var debugDescription: String {
        return "domain: \(domain)\nisSelected: \(isSelected)"
    }
    
    init(domain: String, isSelected: Bool, theme: ThemeServiceProtocol) {
        self.domain = domain
        self.isSelected = isSelected
        self.theme = theme
    }
}


// MARK: - BlockRequestCell

class BlockRequestCell: UITableViewCell {
    
    var model: BlockRequestCellModel? {
        didSet {
            checkBox.isSelected = model?.isSelected ?? false
            domainLabel.text = "..." + (model?.domain ?? "")
            
            model?.theme.setupLabel(domainLabel)
        }
    }
    
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var domainLabel: ThemableLabel!
}


// MARK: - BlockRequestController

class BlockRequestController: BottomAlertController {
        
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    var fullDomain: String = "" {
        didSet{
            generateSubDomains(from: fullDomain)
        }
    }
    var type: DnsLogButtonType = .addDomainToWhitelist
    var delegate: AddDomainToListDelegate?
    
    private var subDomains: [BlockRequestCellModel] = []
    
    private let blockRequestCellId = "BlockRequestCellId"
    private let rowHeight: CGFloat = 50.0
    
    private let editDomainSegueId = "EditDomainSegueId"
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeNotificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = type == .addDomainToWhitelist ? String.localizedString("whitelist_request") : String.localizedString("block_request")
        
        updateTheme()
        
        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        tableViewHeight.constant = rowHeight * CGFloat(subDomains.count)
        tableView.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EditBlockRequestController {
            vc.type = type
            vc.domain = subDomains.first(where: { $0.isSelected })?.domain ?? ""
            vc.delegate = delegate
        }
    }
    
    // MARK: - Actions
    
    @IBAction func addTapped(_ sender: UIButton) {
        let domain = subDomains.first(where: { $0.isSelected })?.domain ?? ""
        delegate?.add(domain: domain, needsCorrecting: true, by: type)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editTapped(_ sender: UIButton) {
        performSegue(withIdentifier: editDomainSegueId, sender: self)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func checkBoxTapped(_ sender: UIButton) {
        let tag = sender.tag
        
        subDomains.forEach({ $0.isSelected = false })
        subDomains[tag].isSelected = true
        tableView.reloadData()
    }
    
    // MARK: - Private methods
    
    private func updateTheme(){
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupLabels(themableLabels)
        tableView.reloadData()
    }
    
    private func generateSubDomains(from domain: String) {
        var subdomains = domain.split(separator: ".")
        
        // First rule is selected
        var isSelected = true
        
        while subdomains.count >= 2{
            let newSubDomain = subdomains.joined(separator: ".")
            let model = BlockRequestCellModel(domain: newSubDomain, isSelected: isSelected, theme: theme)
            isSelected = false
            self.subDomains.append(model)
            subdomains = Array(subdomains.dropFirst())
        }
    }
}


// MARK: - Table view delegate and data source

extension BlockRequestController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subDomains.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: blockRequestCellId) as? BlockRequestCell else { return UITableViewCell() }
        theme.setupTableCell(cell)
        cell.model = subDomains[indexPath.row]
        cell.checkBox.tag = indexPath.row
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        subDomains.forEach({ $0.isSelected = false })
        subDomains[indexPath.row].isSelected = true
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}
