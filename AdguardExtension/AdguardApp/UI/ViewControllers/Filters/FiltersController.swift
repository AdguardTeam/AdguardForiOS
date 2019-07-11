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
import UIKit

// MARK: custom views

class LangView: UIButton {
    var name: String?
}

class TagView: RoundRectButton {
    var name: String?
}

class TagCell: UICollectionViewCell {
    
    
    @IBOutlet weak var button: TagView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        var size = button.sizeThatFits(CGSize(width: 1000, height: button.frame.height))
        size.width = size.width + 6
        size.height = 22
        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
    
}

class LangCell: UICollectionViewCell {
 
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: LangView!
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        
        let size = CGSize(width: 25, height: 22)
        var newFrame = layoutAttributes.frame
        newFrame.size = size
        layoutAttributes.frame = newFrame
        
        return layoutAttributes
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        
        return attributes
    }
    
    
}

// MARK: - FiltersController -
class FiltersController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UIViewControllerTransitioningDelegate, CustomFilterInfoInfoDelegate, NewCustomFilterDetailsDelegate {
    
    var viewModel: FiltersViewModelProtocol?
    
    // MARK:  private properties
    
    var theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private let newFilterCellId = "newCustomFilterReuseID"
    private let filterCellId = "filterCellID"
    private let groupCellId = "GroupCellReuseID"
    private let tagCellId = "tagCellId"
    private let langCellId = "langCellId"
    
    private var selectedIndex: Int?
    
    private let groupSection = 0
    private let addFilterSection = 1
    private let filtersSection = 2
    
    // MARK:  IB Outlets
    
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var headerLabel: ThemableLabel!
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    
    // MARK: - ViewController life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.filtersChangedCallback = { [weak self] in
            guard let sSelf = self else { return }
            sSelf.tableView.reloadData()
            sSelf.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            sSelf.tableView.setContentOffset(.zero, animated: false)
        }
        viewModel?.searchChangedCallback = { [weak self] in self?.updateBarButtons() }
        tableView.rowHeight = UITableView.automaticDimension
        updateBarButtons()
        navigationItem.title = viewModel?.group.name
        if viewModel?.customGroup ?? false {
            tableView.tableHeaderView = headerView
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCustomFilterSegue" {
            
        }
    }
    
    // MARK: - TableView delegate methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case groupSection, addFilterSection:
            return 1
        case filtersSection:
            return viewModel?.filters.count ?? 0
        default:
            return 0
        }
    }
    
    static var updated = false
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case groupSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: groupCellId) as! GroupCell
            cell.nameLabel.text = viewModel?.group.name
            cell.descriptionLabel.text = viewModel?.group.subtitle
            cell.icon.image = UIImage(named: viewModel?.group.iconName ?? "")
            
            let enabled = viewModel?.group.enabled ?? false
            if cell.enabledSwitch.isOn != enabled {
                cell.enabledSwitch.setOn(enabled, animated: true)
            }
            cell.enabledSwitch.removeTarget(self, action: nil, for: .valueChanged)
            cell.enabledSwitch.addTarget(self, action: #selector(toogleGroupEnable(_:)), for: .valueChanged)
            
            theme.setupLabels(cell.themableLabels)
            theme.setupTableCell(cell)
            theme.setupSwitch(cell.enabledSwitch)
            cell.separator.backgroundColor = theme.separatorColor
            
            return cell
            
        case addFilterSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: newFilterCellId)
            return cell!
            
        case filtersSection:
            let filter = viewModel?.filters[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: filterCellId) as! FilterCell
            cell.name.text = filter?.name ?? ""
            cell.filterDescription.text = filter?.desc ?? ""
            
            if let version = filter?.version {
                cell.version.text = String(format: ACLocalizedString("filter_version_format", nil), version)
            }

            cell.enableSwitch.tag  = indexPath.row
            cell.enableSwitch.isOn = filter?.enabled ?? false
            cell.homepageButton.tag = indexPath.row
            
            cell.collectionView.delegate = nil
            cell.collectionView.tag = indexPath.row
            cell.collectionView.delegate = self
            cell.collectionView.dataSource = self
            
            cell.collectionTopConstraint.constant = (cell.filterDescription.text?.count ?? 0) > 0 ? 10 : 0
            cell.collectionHeightConstraint.constant = filter?.tags?.count == 0 && filter?.langs?.count == 0 ? 0 : 22
            cell.collectionTopConstraint.constant = filter?.tags?.count == 0 && filter?.langs?.count == 0 ? 0 : 10
            
            UIView.animate(withDuration: 0.0) {
                cell.collectionView.performBatchUpdates({
                    cell.collectionView.reloadSections(IndexSet(integer: 0))
                }, completion: { (_) in
                    cell.collectionView.layoutSubviews()
                })
            }
            
            let groupEnabled = viewModel?.group.enabled ?? false
            cell.enableSwitch.isEnabled = groupEnabled
            cell.enableSwitch.isUserInteractionEnabled = groupEnabled
            cell.contentView.alpha = groupEnabled ? 1.0 : 0.5
            
            theme.setupLabels(cell.themableLabels)
            theme.setupTableCell(cell)
            theme.setupSwitch(cell.enableSwitch)
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case groupSection:
            break
        case addFilterSection:
            showAddFilterDialog()
        case filtersSection:
            if viewModel?.customGroup ?? false {
                selectedIndex = indexPath.row
                showCustomFilterInfoDialog()
            }
            else {
                let cell = tableView.cellForRow(at: indexPath) as! FilterCell
                if cell.enableSwitch.isEnabled {
                    cell.enableSwitch.setOn(!cell.enableSwitch.isOn, animated: true)
                    toggleEnableSwitch(cell.enableSwitch)
                }
            }
            
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case groupSection:
            return 72
        case addFilterSection:
            return (viewModel?.customGroup ?? false) ? 60 : 0
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    // MARK: - CollectionView data source
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let filterIndex = collectionView.tag
        let filter = viewModel?.filters[filterIndex]
        
        let tagsCount = filter?.tags?.count ?? 0
        let langsCount = filter?.langs?.count ?? 0
        return langsCount + tagsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let filterIndex = collectionView.tag
        if let filter = viewModel?.filters[filterIndex]{
            
            let langsCount = filter.langs?.count ?? 0
            
            if indexPath.row < langsCount {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: langCellId, for: indexPath) as! LangCell
                let lang = filter.langs![indexPath.row]
                cell.image.image = UIImage(named: lang.name)
                cell.image.alpha = lang.heighlighted ? 0.3 : 1.0
                cell.button.name = lang.name
                cell.button.removeTarget(self, action: #selector(langAction(_:)), for: .touchUpInside)
                cell.button.addTarget(self, action: #selector(langAction(_:)), for: .touchUpInside)
                
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: tagCellId, for: indexPath) as! TagCell
                let tag = filter.tags![indexPath.row - langsCount]
                cell.button.setTitle(tag.name, for: .normal)
                cell.button.alpha = tag.heighlighted ? 0.3 : 1.0
                cell.button.name = tag.name
                theme.setupTagButton(cell.button)
                return cell
            }
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - Actions
    
    @IBAction func toggleEnableSwitch(_ sender: UISwitch) {
        let row = sender.tag
        guard let filter = viewModel?.filters[row] else { return }
        viewModel?.set(filter: filter, enabled: sender.isOn)
        
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: 0, section: groupSection)], with: .automatic)
        tableView.endUpdates()
    }
    
    @IBAction func showSiteAction(_ sender: UIButton) {
        let row = sender.tag
        let filter = viewModel?.filters[row]
        guard   let homepage = filter?.homepage,
                let url = URL(string: homepage) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        viewModel?.searchFilter(query: "")
        self.updateBarButtons()
        searchBar.becomeFirstResponder()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        tableView.tableHeaderView = nil
        viewModel?.cancelSearch()
        self.updateBarButtons()
    }
    
    @IBAction func tagAction(_ sender: TagView) {
        viewModel?.switchTag(name: sender.name ?? "")
    }
    
    @objc func langAction(_ sender: LangView) {
        viewModel?.switchTag(name: sender.name ?? "")
    }
    
    @objc func toogleGroupEnable(_ sender: UISwitch) {
        viewModel?.setGroup(enabled: sender.isOn)
    }
    
    // MARK: - searchbar methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.searchFilter(query: searchBar.text ?? "")
    }
    
    // MARK: - Presentation delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    // MARK: - FilterInfo delegate methods
    
    func deleteFilter(filter: Filter) {
        viewModel?.deleteCustomFilter(filter: filter, completion: { (succes) in
            self.tableView.reloadData()
        })
    }
    
    // MARK: - NewCustomFilter delegate
    func addCustomFilter(filter: AASCustomFilterParserResult, overwriteExisted: Bool) {
        viewModel?.addCustomFilter(filter: filter, overwriteExisted: overwriteExisted, completion: { (success) in
            self.tableView.reloadData()
        })
    }
    
    // MARK: - private methods
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupNavigationBar(navigationController?.navigationBar)
        theme.setupTable(tableView)
        theme.setupSearchBar(searchBar)
        theme.setubBarButtonItem(searchButton)
        theme.setupLabels(themableLabels)
    }
    
    private func updateBarButtons() {
        if viewModel!.isSearchActive {
            navigationItem.rightBarButtonItems = [cancelButton]
            tableView.tableHeaderView = searchView
            searchBar.text = viewModel?.searchString
        }
        else {
            navigationItem.rightBarButtonItems = [searchButton]
            tableView.tableHeaderView = nil
            searchBar.text = viewModel?.searchString
        }
    }
    
    private func showAddFilterDialog() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "NewCustomFilterInfoController") as? UINavigationController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        
        (controller.viewControllers.first as? AddCustomFilterController)?.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    private func showCustomFilterInfoDialog() {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "CustomFilterInfoController") as? CustomFilterInfoInfoController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.filter = viewModel?.filters[selectedIndex!]
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
}
