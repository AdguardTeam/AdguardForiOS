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

protocol AddNewFilterDelegate {
    func addCustomFilter(filter: AASCustomFilterParserResult)
}

protocol EditFilterDelegate {
    func renameFilter(newName: String)
}

enum ControllerModeType {
    case addingFilter, editingFilter
}

protocol NewCustomFilterDetailsControllerInterface {
    var name: String? { get }
    var rulesCount: Int? { get }
    var homepage: String? { get }
}

struct NewCustomFilterDetailsControllerModel: NewCustomFilterDetailsControllerInterface {
    var name: String?
    var rulesCount: Int?
    var homepage: String?
}

class NewCustomFilterDetailsController : BottomAlertController {
    
    var filterType: NewFilterType = .safariCustom
    var controllerModeType: ControllerModeType = .addingFilter
    
    var model: NewCustomFilterDetailsControllerInterface? = nil
    var filter : AASCustomFilterParserResult?
    
    var addDelegate : AddNewFilterDelegate?
    var editDelegate: EditFilterDelegate?
    
    private let contentBlockerService: ContentBlockerService = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private var homepageLink: String?
    
    // MARK: - IB Outlets
    @IBOutlet weak var rulesCount: UILabel!
    @IBOutlet weak var homepage: UILabel!
    @IBOutlet weak var name: UITextField!
    @IBOutlet var themableLabels: [ThemableLabel]!
    @IBOutlet weak var newFilterTitle: ThemableLabel!
    @IBOutlet weak var textViewUnderline: TextFieldIndicatorView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var homepageTopConstraint: NSLayoutConstraint!
    
    private let textFieldCharectersLimit = 50
    
    // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if controllerModeType == .addingFilter {
            setupAddingNewFilter()
        } else {
            setupEditingFilter()
        }
        
        updateTheme()
        addButton.makeTitleTextUppercased()
        addButton.applyStandardGreenStyle()
        cancelButton.applyStandardOpaqueStyle(color: UIColor.AdGuardColor.lightGray4)
        cancelButton.makeTitleTextUppercased()
    }
    
    // MARK: - Actions
    @IBAction func AddAction(_ sender: Any) {
        if controllerModeType == .addingFilter {
            filter?.meta.name = ((name.text == nil || name.text == "") ? filter?.meta.name : name.text) ?? ""
            addDelegate?.addCustomFilter(filter: filter!)
        } else if controllerModeType == .editingFilter {
            if let newName = (name.text == nil || name.text == "") ? model?.name : name.text {
                editDelegate?.renameFilter(newName: newName)
            }
        }
        dismiss(animated: true)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func redirectToSafariAction(_ sender: UIButton) {
        guard let link = homepageLink else { return }
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if  updatedText.count >= textFieldCharectersLimit {
            textField.text = String(updatedText.prefix(textFieldCharectersLimit))
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textViewUnderline.state = .enabled
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textViewUnderline.state = .disabled
    }
    
    // MARK: - private methods
    
    private func setupAddingNewFilter() {
        newFilterTitle.text = filterType.getTitleText()
        
        name.text = String(filter?.meta.name.prefix(textFieldCharectersLimit) ?? "")
        let count: Int = filter?.rules.count ?? 0
        rulesCount.text = String(count)
        
        if let homepageUrl = filter?.meta.homepage, homepageUrl.count > 0 {
            homepageLink = homepageUrl
            homepage.attributedText = makeAttributedLink(with: homepageUrl)
            homepageTopConstraint.constant = 52.0
        }
        else {
            homepage.isHidden = true
            homepageTopConstraint.constant = 23.0
        }
        
        addButton.setTitle(String.localizedString("common_add").uppercased(), for: .normal)
    }
    
    private func setupEditingFilter() {
        newFilterTitle.text = String.localizedString("edit_custom_filter_title")
        name.text = String(model?.name?.prefix(textFieldCharectersLimit) ?? "")
        rulesCount.text = String(model?.rulesCount ?? 0)
        
        if let homepageUrl = model?.homepage, homepageUrl.count > 0 {
            homepageLink = homepageUrl
            homepage.attributedText = makeAttributedLink(with: homepageUrl)
            homepageTopConstraint.constant = 52.0
        }
        else {
            homepage.isHidden = true
            homepageTopConstraint.constant = 23.0
        }

        addButton.setTitle(String.localizedString("common_save").uppercased(), for: .normal)
    }
    
    private func makeAttributedLink(with url: String) -> NSAttributedString {
        let homepageString = ACLocalizedString("homepage_title", nil) + "  "
        
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
}

extension NewCustomFilterDetailsController: ThemableProtocol {
    func updateTheme() {
        newFilterTitle.textColor = theme.popupTitleTextColor
        contentView.backgroundColor = theme.popupBackgroundColor
        theme.setupTextField(name)
        theme.setupPopupLabels(themableLabels)
    }
}
