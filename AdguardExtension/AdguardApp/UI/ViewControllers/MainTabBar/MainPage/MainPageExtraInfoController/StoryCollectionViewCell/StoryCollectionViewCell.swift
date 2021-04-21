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

struct StoryCollectionViewModel {
    let title: String
    let storyIsWatched: Bool
    let category: StoryCategory.CategoryType
    let backGroundImage: UIImage?
    
    enum FigureType: CaseIterable {
        case circle
        case rectangle
    }
}
// TODO: - Don't forget about twosky.json
final class StoryCollectionViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var storyTitleLabel: UILabel!
    @IBOutlet weak var storyShownImageView: UIImageView!
    
    var model: StoryCollectionViewModel! {
        didSet {
            storyTitleLabel.text = model.title
            storyShownImageView.isHidden = model.storyIsWatched
            backgroundImageView.image = model.backGroundImage
            backgroundImageView.alpha = model.storyIsWatched ? 0.5 : 1.0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        storyTitleLabel.text = nil
        storyShownImageView.isHidden = false
        backgroundImageView.image = nil
        backgroundImageView.alpha = 1.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
}
