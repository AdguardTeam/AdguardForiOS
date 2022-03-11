//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SharedAdGuardSDK
import SafariAdGuardSDK
import UIKit

protocol NewCustomFilterDetailsControllerDelegate: AnyObject {
    func addCustomFilter(_ meta: ExtendedCustomFilterMetaProtocol, _ onFilterAdded: @escaping (Error?) -> Void)
    func renameFilter(withId filterId: Int, to newName: String) throws -> FilterDetailsProtocol
}

enum ControllerModeType {
    case addingFilter, editingFilter
}

struct NewCustomFilterModel {
    let filterName: String
    let filterType: NewFilterType
    let meta: ExtendedCustomFilterMetaProtocol
}

struct EditCustomFilterModel {
    let filterName: String
    let filterId: Int
    let rulesCount: Int
    let homePage: String?
}

private let LOG = ComLog_LoggerFactory.getLoggerWrapper(NewCustomFilterDetailsController.self)

final class NewCustomFilterDetailsController: BottomAlertController {

    var newFilterModel: NewCustomFilterModel?
    var editFilterModel: EditCustomFilterModel?

    weak var delegate: NewCustomFilterDetailsControllerDelegate?

    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    private var homepageLink: String?

    // MARK: - IB Outlets
    @IBOutlet weak var rulesCount: UILabel!
    @IBOutlet weak var homepage: UILabel!
    @IBOutlet weak var name: AGTextField!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var newFilterTitle: ThemableLabel!

    @IBOutlet weak var addButton: RoundRectButton!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var homepageTopConstraint: NSLayoutConstraint!

    private let textFieldCharectersLimit = 50

    private var enteredName: String { name.text ?? "" }

    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        name.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)

        if let newFilterModel = newFilterModel {
            setupAddingNewFilter(newFilterModel)
        } else if let editFilterModel = editFilterModel {
            setupEditingFilter(editFilterModel)
        } else {
            return
        }

        updateTheme()
        addButton.makeTitleTextCapitalized()
        addButton.applyStandardGreenStyle()
        addButton.setBackgroundColor()
        cancelButton.makeTitleTextCapitalized()
        cancelButton.applyStandardOpaqueStyle()
        updateAddButton()
    }

    // MARK: - Actions
    @IBAction func addAction(_ sender: Any) {
        guard !enteredName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        addButton.isEnabled = false
        if let newFilterModel = newFilterModel {
            addCustomFilter(newFilterModel)
        } else if let editFilterModel = editFilterModel {
            editFilter(editFilterModel)
        } else {
            return
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func redirectToSafariAction(_ sender: UIButton) {
        guard
            let link = homepageLink,
            let url = URL(string: link)
        else {
            return
        }
        UIApplication.shared.open(url)
    }

    // MARK: - UITextFieldDelegate

    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        name.borderState = .disabled
        name.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        if updatedText.count >= textFieldCharectersLimit {
            textField.text = String(updatedText.prefix(textFieldCharectersLimit))
            return false
        }

        return true
    }

    // MARK: - private methods

    private func addCustomFilter(_ model: NewCustomFilterModel) {
        let filterName = enteredName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !filterName.isEmpty else {
            return
        }

        let meta = CustomFilterMeta(
            name: filterName,
            description: model.meta.description,
            version: model.meta.version,
            lastUpdateDate: model.meta.lastUpdateDate,
            homePage: model.meta.homePage,
            licensePage: model.meta.licensePage,
            issuesReportPage: model.meta.issuesReportPage,
            communityPage: model.meta.communityPage,
            filterDownloadPage: model.meta.filterDownloadPage,
            rulesCount: model.meta.rulesCount
        )
        delegate?.addCustomFilter(meta) { [weak self] error in
            if let error = error {
                LOG.error("Error adding custom filter to DB; Error: \(error)")
                self?.showUnknownErrorAlert()
                self?.addButton.isEnabled = true
                return
            }
            DispatchQueue.asyncSafeMain { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }

    private func editFilter(_ model: EditCustomFilterModel) {
        let filterName = enteredName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !filterName.isEmpty else {
            return
        }

        do {
            let _ = try delegate?.renameFilter(withId: model.filterId, to: filterName)
            addButton.isEnabled = true
            dismiss(animated: true)
        } catch {
            LOG.error("Error renaming filter; Error: \(error)")
            showUnknownErrorAlert()
        }
    }

    private func setupAddingNewFilter(_ model: NewCustomFilterModel) {
        newFilterTitle.text = model.filterType.title

        name.text = model.filterName
        rulesCount.text = String(model.meta.rulesCount)

        if let homepageUrl = model.meta.homePage, homepageUrl.count > 0 {
            homepageLink = homepageUrl
            homepageTopConstraint.constant = 52.0

            let attributedText = makeAttributedLink(with: homepageUrl)
            DispatchQueue.asyncSafeMain { self.homepage.attributedText = attributedText }
        }
        else {
            homepage.isHidden = true
            homepageTopConstraint.constant = 23.0
        }

        addButton.setTitle(String.localizedString("common_add").capitalized, for: .normal)
    }

    private func setupEditingFilter(_ model: EditCustomFilterModel) {
        newFilterTitle.text = String.localizedString("edit_custom_filter_title")
        name.text = model.filterName
        rulesCount.text = String(model.rulesCount)

        if let homepageUrl = model.homePage, homepageUrl.count > 0 {
            homepageLink = homepageUrl
            homepageTopConstraint.constant = 52.0

            let attributedText = makeAttributedLink(with: homepageUrl)
            DispatchQueue.asyncSafeMain { self.homepage.attributedText = attributedText }
        }
        else {
            homepage.isHidden = true
            homepageTopConstraint.constant = 23.0
        }

        addButton.setTitle(String.localizedString("common_save").capitalized, for: .normal)
    }

    private func makeAttributedLink(with url: String) -> NSMutableAttributedString {
            let homepageString = String.localizedString("homepage_title")

            let homepageAttributedString = NSAttributedString(string: homepageString)
            let urlAttributedString = NSMutableAttributedString(string: url)

            let urlStringRange = NSRange(location: 0, length: url.count)

            let highlightColor = UIColor.AdGuardColor.lightGreen1

            urlAttributedString.addAttribute(.underlineStyle, value: 1, range: urlStringRange)
            urlAttributedString.addAttribute(.underlineColor, value: highlightColor, range: urlStringRange)
            urlAttributedString.addAttribute(.foregroundColor, value: highlightColor, range: urlStringRange)

            let returnString = NSMutableAttributedString()
            returnString.append(homepageAttributedString)
            returnString.append(urlAttributedString)

            return returnString
    }

    @objc private final func textFieldEditingChanged(_ sender: UITextField) {
        updateAddButton()
        name.rightView?.isHidden = enteredName.isEmpty
    }

    private func updateAddButton() {
        let text = enteredName.trimmingCharacters(in: .whitespacesAndNewlines)
        addButton.isEnabled = !text.isEmpty
    }
}

// MARK: - NewCustomFilterDetailsController + ThemableProtocol

extension NewCustomFilterDetailsController: ThemableProtocol {
    func updateTheme() {
        newFilterTitle.textColor = theme.popupTitleTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupTextField(name)
        theme.setupPopupLabels(themableLabels)
        name.updateTheme()
    }
}

fileprivate extension NewFilterType {
    var title: String {
        switch self {
        case .safariCustom:
            return String.localizedString("new_filter_title")
        case .dnsCustom:
            return String.localizedString("new_dns_filter_title")
        }
    }
}
