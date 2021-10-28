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

final class UserRulesEditorController: UIViewController {

    // MARK: - UI elements

    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var descriptionLabel: ThemableLabel!
    @IBOutlet weak var rulesTextView: UITextView!
    @IBOutlet var saveButton: UIBarButtonItem!

    // MARK: - Internal variables

    var model: UserRulesEditorProtocol!

    // MARK: - Private variables

    private var textChanged = false
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - UIViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        rulesTextView.delegate = self
        updateTheme()
        setupBackButton()
        navigationItem.rightBarButtonItem = saveButton
        setTexts()
    }

    // MARK: - Actions

    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        // Do something only if text was changed
        if textChanged {
            model.saveUserRules(from: rulesTextView.text)
        }
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Private methods

    private func setTexts() {
        titleLabel.text = model.editorTitle
        descriptionLabel.text = model.editorDescription
        rulesTextView.text = model.userRulesString
    }
}

// MARK: - UserRulesEditorController + UITextViewDelegate

extension UserRulesEditorController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textChanged = true
    }
}

// MARK: - UserRulesEditorController + ThemableProtocol

extension UserRulesEditorController: ThemableProtocol {
    func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabel(titleLabel)
        theme.setupLabel(descriptionLabel)
        theme.setupTextView(rulesTextView)
    }
}
