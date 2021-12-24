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

import UIKit

extension UIViewController {
    /// Presents Alert with provided title and message
    func presentSimpleAlert(title: String?, message: String?, onOkButtonTapped: (() -> Void)? = nil) {
        DispatchQueue.asyncSafeMain { [weak self] in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

            let okAction = UIAlertAction(title: String.localizedString("common_action_ok"), style: .default) { _ in
                onOkButtonTapped?()
            }
            alert.addAction(okAction)

            self?.present(alert, animated: true, completion: nil)
        }
    }

    /// Presents native alert for unknown error. Title and message are already set.
    func showUnknownErrorAlert() {
        let title = String.localizedString("something_went_wrong_title")
        let message = String.localizedString("unknown_error_description")
        presentSimpleAlert(title: title, message: message, onOkButtonTapped: nil)
    }
}
