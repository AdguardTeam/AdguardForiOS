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
import AdGuardSDK

class FilterTagsView: UIView, FilterTagsViewModel {
    
    var highlightIsOn = true
    
    weak var delegate: TagButtonTappedDelegate?
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    private var viewHeight: NSLayoutConstraint?
    
    var filter: SafariFilterProtocol?{
        didSet{
            setupUI()
            layoutIfNeeded()
        }
    }
    
    private var leftInset: CGFloat = 0.0
    private var currentYposition: CGFloat = 0.0
    
    
    // MARK: - Variables to distinguish iPad and iPhone
    
    private var isBigScreen: Bool {
        get {
            return traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular
        }
    }
    
    private var tagCornerRadius: CGFloat {
        get {
            return isBigScreen ? 5.0 : 3.0
        }
    }
    
    private var buttonHeight: CGFloat {
        get {
            return isBigScreen ? 32.0 : 22.0
        }
    }
    
    private var langButtonWidth: CGFloat {
        get {
            return isBigScreen ? 40.0 : 30.0
        }
    }
    
    private var inset: CGFloat {
        get {
            return isBigScreen ? 16.0 : 8.0
        }
    }
    
    private var tagFont: UIFont {
        get {
            return isBigScreen ? UIFont.systemFont(ofSize: 18.0, weight: .regular) : UIFont.systemFont(ofSize: 12.0, weight: .regular)
        }
    }
    
    private var buttonTextInset: CGFloat {
        get {
            return isBigScreen ? 12.0 : 6.0
        }
    }
    
    
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    init() {
        super.init(frame: .zero)
        customInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    override func layoutSubviews() {
        
        leftInset = 0.0
        currentYposition = 0.0
        height = 0.0
        
        guard let filter = self.filter else { return }
        
        if (filter.languages.count > 0 || filter.tags.count > 0) {
            height += buttonHeight + inset
            currentYposition += inset
        }
        
        for view in subviews{
            if let button = view as? UIButton {
                replaceButton(button)
            }
        }
        viewHeight?.constant = height
    }
    
    private func customInit(){
        translatesAutoresizingMaskIntoConstraints = false
        viewHeight = heightAnchor.constraint(equalToConstant: height)
        viewHeight?.isActive = true
    }
    
    private func setupUI(){
        subviews.forEach({ $0.removeFromSuperview() })
        
        width = frame.width
        
        backgroundColor = theme.backgroundColor
        
        guard let filter = self.filter else { return }
        
        for lang in filter.languages {
            setupLangButton(lang: (lang, false))
        }
        for tag in filter.tags {
            setupTagButton(tag: (tag.tagName, false))
        }
        
        setNeedsLayout()
    }
    
    private func setupLangButton(lang: (name: String, highlighted: Bool)){
        let langButton = TagButton()
        langButton.delegate = self.delegate
        
        langButton.name = lang.name
        langButton.setImage(UIImage(named: lang.name), for: .normal)
        langButton.imageView?.contentMode = .scaleAspectFill
        if highlightIsOn{
            langButton.alpha = lang.highlighted ? 0.3 : 1.0
        }
        langButton.layer.cornerRadius = tagCornerRadius
        langButton.layer.masksToBounds = true
        
        langButton.frame.size.height = buttonHeight
        langButton.frame.size.width = langButtonWidth
        
        addSubview(langButton)
    }
    
    private func setupTagButton(tag: (name: String, highlighted: Bool)){
        let tagButton = TagButton()
        tagButton.delegate = self.delegate
        
        tagButton.customBackgroundColor = .black
        tagButton.customDisabledBackgroundColor = UIColor(hexString: "#757575")
        tagButton.customDisabledBackgroundColor = UIColor(hexString: "#CCCCCC")
        
        tagButton.setTitle(tag.name, for: .normal)
        tagButton.titleLabel?.font = tagFont
        tagButton.layer.cornerRadius = tagCornerRadius
        if highlightIsOn{
            tagButton.alpha = tag.highlighted ? 0.3 : 1.0
        }
        tagButton.name = tag.name
        theme.setupTagButton(tagButton)
        
        tagButton.frame.size.height = buttonHeight
        var size = tagButton.sizeThatFits(CGSize(width: 1000, height: tagButton.frame.height))
        size.width = size.width + buttonTextInset
        size.height = tagButton.frame.size.height
        tagButton.frame.size = size
        
        addSubview(tagButton)
    }
    
    private func replaceButton(_ sender: UIButton) {
        if (leftInset + sender.frame.size.width) > width {
            height += sender.frame.size.height + inset
            currentYposition += sender.frame.size.height + inset
            leftInset = 0.0
        }
        
        sender.frame.origin = CGPoint(x: leftInset, y: currentYposition)
                
        leftInset += sender.frame.size.width + inset
    }
}

