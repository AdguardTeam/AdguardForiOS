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
import SafariAdGuardSDK

protocol FilterDetailsViewControllerDelegate: AnyObject {
    func deleteFilter(with groupId: Int, filterId: Int, onFilterDeleted: @escaping () -> Void)
    func editFilter(with groupId: Int, filterId: Int, onFilterEdited: @escaping (_ newFilterMeta: SafariFilterProtocol) -> Void)
    func setFilter(with groupId: Int, filterId: Int, enabled: Bool, onFilterSet: @escaping  (_ newFilterMeta: SafariFilterProtocol) -> Void)
}

final class FilterDetailsViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    // MARK: - Public properties
    
    weak var delegate: FilterDetailsViewControllerDelegate?
    var filterMeta: SafariFilterProtocol!
    
    // MARK: - Private properties
    
    private var model: FilterDetailsViewModel!
    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeObserver: NotificationToken?
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        processBottomButtons()
        setupBackButton()
        updateTheme()
        setupTableView()
        tableView.tableHeaderView = ExtendedTitleTableHeaderView(title: filterMeta.name ?? "", normalDescription: filterMeta.description ?? "")
        
        themeObserver = NotificationCenter.default.observe(name: .themeChanged, object: nil, queue: .main) { [weak self] _ in
            self?.updateTheme()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        model = FilterDetailsViewModel(filterMeta: filterMeta, themeService: themeService)
        model.delegate = self
        
        tableView.delegate = model
        tableView.dataSource = model
        tableView.separatorStyle = .none
        
        SwitchTableViewCell.registerCell(forTableView: tableView)
        FilterDetailsCell.registerCell(forTableView: tableView)
        FilterDetailsTagsCell.registerCell(forTableView: tableView)
    }
    
    private func processBottomButtons() {
        if filterMeta.editable {
            let title = String.localizedString("common_edit").uppercased()
            let button = button(withTitle: title)
            button.applyStandardOpaqueStyle()
            button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpOutside)
            
            buttonsStackView.addArrangedSubview(button)
            stackViewHeightConstraint.constant = 40.0
        }
        
        if filterMeta.removable {
            let title = String.localizedString("common_delete").uppercased()
            let button = button(withTitle: title)
            button.applyStandardOpaqueStyle(color: UIColor.AdGuardColor.red)
            button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
            button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpOutside)
            
            buttonsStackView.addArrangedSubview(button)
            if buttonsStackView.arrangedSubviews.isEmpty {
                stackViewHeightConstraint.constant = 40.0
            } else {
                stackViewHeightConstraint.constant = 88.0
            }
        }
    }
    
    private func button(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return button
    }
    
    @objc private final func editButtonTapped() {
        delegate?.editFilter(with: filterMeta.group.groupId, filterId: filterMeta.filterId) { newFilterMeta in
            DispatchQueue.asyncSafeMain { [weak self] in
                self?.filterMeta = newFilterMeta
                self?.setupTableView()
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc private final func deleteButtonTapped() {
        delegate?.deleteFilter(with: filterMeta.group.groupId, filterId: filterMeta.filterId) {
            DispatchQueue.asyncSafeMain { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}


// MARK: - FilterDetailsTableController + SwitchTableViewCellDelegate

extension FilterDetailsViewController: SwitchTableViewCellDelegate {
    func switchStateChanged(to enabled: Bool) {
        delegate?.setFilter(with: filterMeta.group.groupId, filterId: filterMeta.filterId, enabled: enabled) { newFilterMeta in
            DispatchQueue.asyncSafeMain { [weak self] in
                self?.filterMeta = newFilterMeta
                self?.setupTableView()
                self?.tableView.reloadData()
                if let header = self?.tableView.tableHeaderView as? ExtendedTitleTableHeaderView {
                    header.title = newFilterMeta.name ?? ""
                    header.setNormalTitle(newFilterMeta.description ?? "")
                    self?.tableView.layoutTableHeaderView()
                }
            }
        }
    }
}

// MARK: - FilterDetailsTableController + ThemableProtocol

extension FilterDetailsViewController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = themeService.backgroundColor
        themeService.setupTable(tableView)
    }
}
