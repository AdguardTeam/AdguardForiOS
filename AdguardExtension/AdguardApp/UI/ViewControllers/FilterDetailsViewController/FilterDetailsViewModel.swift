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

import SafariAdGuardSDK

final class FilterDetailsViewModel: NSObject {
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    fileprivate enum Section {
        case state
        case meta
        case tags
    }
    
    private let sections: [Section]
    private let metaRows: [FilterDetailsCellModel]
    private let tagModels: [SafariTagButtonModel]
    
    private let filterMeta: FilterDetailsProtocol
    private let themeService: ThemeServiceProtocol
    
    init(filterMeta: FilterDetailsProtocol, themeService: ThemeServiceProtocol) {
        self.filterMeta = filterMeta
        self.themeService = themeService
        
        var sections: [Section] = []
        var metaRows: [FilterDetailsCellModel] = []
        self.tagModels = filterMeta.tags.map { SafariTagButtonModel(tag: $0, isSelected: true) }
        sections.append(.state)
        
        if let version = filterMeta.version {
            let model = FilterDetailsCellModel(
                title: String.localizedString("detailed_filter_info_version_subtitle"),
                description: version,
                isLink: false
            )
            metaRows.append(model)
        }
        
        if let updated = filterMeta.lastUpdateDate?.formatedString() {
            let model = FilterDetailsCellModel(
                title: String.localizedString("detailed_filter_info_updated_subtitle"),
                description: updated,
                isLink: false
            )
            metaRows.append(model)
        }
        
        let model = FilterDetailsCellModel(
            title: String.localizedString("detailed_filter_info_rules_count_subtitle"),
            description: String(filterMeta.rulesCount),
            isLink: false
        )
        metaRows.append(model)
        
        if let website = filterMeta.homepage {
            let model = FilterDetailsCellModel(
                title: String.localizedString("detailed_filter_info_website_subtitle"),
                description: website,
                isLink: true
            )
            metaRows.append(model)
        }
        
        if let subscriptionUrl = filterMeta.filterDownloadPage {
            let model = FilterDetailsCellModel(
                title: String.localizedString("detailed_filter_info_subscription_subtitle"),
                description: subscriptionUrl,
                isLink: true
            )
            metaRows.append(model)
        }
        
        if !metaRows.isEmpty {
            sections.append(.meta)
        }
        
        if !tagModels.isEmpty {
            sections.append(.tags)
        }
        
        self.sections = sections
        self.metaRows = metaRows
    }
}

// MARK: - FilterDetailsViewModel + UITableViewDelegate

extension FilterDetailsViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sct = sections[indexPath.section]
        switch sct {
        case .state:
            break
        case .meta:
            let model = metaRows[indexPath.row]
            if model.isLink, let url = URL(string: model.description) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .tags:
            break
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - FilterDetailsViewModel + UITableViewDataSource

extension FilterDetailsViewModel: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sct = sections[section]
        switch sct {
        case .state: return 1
        case .meta: return metaRows.count
        case .tags: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sct = sections[indexPath.section]
        switch sct {
        case .state:
            let cell = SwitchTableViewCell.getCell(forTableView: tableView)
            cell.selectionStyle = .none
            cell.switchIsOn = filterMeta.isEnabled
            cell.updateTheme(themeService)
            cell.delegate = delegate
            return cell
        case .meta:
            let model = metaRows[indexPath.row]
            let cell = FilterDetailsCell.getCell(forTableView: tableView)
            cell.model = model
            cell.selectionStyle = model.isLink ? .default : .none
            cell.updateTheme(themeService)
            return cell
        case .tags:
            let cell = FilterDetailsTagsCell.getCell(forTableView: tableView)
            cell.tagModels = tagModels
            cell.updateTheme()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
