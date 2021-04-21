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

extension UILabel {
    /*
     Should be used to set attributed text
     When app goes to background, setting attributedText will crash the app
     It looks like Swift bug https://developer.apple.com/forums/thread/115405
     */
    func setAttributedTitle(_ html: String, fontSize: CGFloat, color: UIColor, attachmentImage: UIImage?, textAlignment: NSTextAlignment = .left) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let text = NSMutableAttributedString.fromHtml(html, fontSize: fontSize, color: color, attachmentImage: attachmentImage, textAlignment: textAlignment)
            self.attributedText = text
        }
    }
}
