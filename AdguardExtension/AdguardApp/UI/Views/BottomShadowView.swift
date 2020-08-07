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

class BottomShadowButton: UIButton {
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    // If color is nil, than it will be dispalayed as theme.grayTextColor
    var titleColor: UIColor? = .clear {
        didSet{
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    var action: (() -> Void)?
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        commonInit()
    }
    
    private func commonInit() {
        self.addTarget(self, action: #selector(BottomShadowButton.clicked), for: .touchUpInside)
    }
    
    @objc func clicked() {
        action?()
    }
}

class BottomShadowView: UIView {
    
    @IBOutlet weak var buttonsViewHeight: NSLayoutConstraint!
    
    var buttons: [BottomShadowButton] = [] {
        didSet {
            resizeView()
            updateTheme()
        }
    }

    private var buttonsHeight: CGFloat {
        get {
            let isBigScreen = traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular
            return isBigScreen ? 80.0 : 60.0
        }
    }
    private let separatorHeight: CGFloat = 1.0
    
    private var shadowColor: UIColor = .clear
    private var shadowAlpha: CGFloat = 0.0
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupShadow()
    }
    
    // MARK: - Public methods
    
    func updateTheme(){
        for view in subviews {
            if let btn = view as? BottomShadowButton {
                btn.backgroundColor = theme.backgroundColor
                if btn.titleColor == nil {
                    btn.setTitleColor(theme.grayTextColor, for: .normal)
                }
            } else {
                view.backgroundColor = theme.separatorColor
            }
        }
        shadowColor = theme.invertedBackgroundColor
        self.layer.shadowColor = shadowColor.cgColor.copy(alpha: shadowAlpha)
    }

    func animateHidingOfShadow(){
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let sSelf = self else { return }
            DispatchQueue.main.async {
                sSelf.shadowAlpha = 0.0
                let color = sSelf.shadowColor.cgColor
                sSelf.layer.shadowColor = color.copy(alpha: sSelf.shadowAlpha)
            }
        }
    }
    
    func animateAppearingOfShadow(){
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let sSelf = self else { return }
            DispatchQueue.main.async {
                sSelf.shadowAlpha = 0.5
                let color = sSelf.shadowColor.cgColor
                sSelf.layer.shadowColor = color.copy(alpha: sSelf.shadowAlpha)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func setupShadow(){
        shadowColor = theme.invertedBackgroundColor
        self.layer.shadowColor = shadowColor.withAlphaComponent(shadowAlpha).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
    }
    
    private func resizeView(){
        buttonsViewHeight.constant = 0.0
                
        var previousElement: UIView = self
        for (index, button) in buttons.enumerated() {
            positionButton(button: button, previousElement: previousElement, index: index)
            
            buttonsViewHeight.constant += buttonsHeight
            previousElement = button
            
            if index != buttons.endIndex - 1 {
                previousElement = createSeparator(previousElement: previousElement)
                buttonsViewHeight.constant += separatorHeight
            }
        }
    }
    
    private func positionButton(button: BottomShadowButton, previousElement: UIView, index: Int){
        button.translatesAutoresizingMaskIntoConstraints = false
        addSubview(button)

        let isBigScreen = traitCollection.verticalSizeClass == .regular && traitCollection.horizontalSizeClass == .regular
        button.titleLabel?.font = UIFont.systemFont(ofSize: isBigScreen ? 24.0 : 16.0, weight: .medium)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: isBigScreen ? 24.0 : 16.0, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left
        
        button.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: buttonsHeight).isActive = true
        button.topAnchor.constraint(equalTo: index == 0 ? previousElement.topAnchor : previousElement.bottomAnchor ).isActive = true
    }
    
    private func createSeparator(previousElement: UIView) -> UIView{
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    
        view.backgroundColor = theme.separatorColor
        
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: separatorHeight).isActive = true
        view.topAnchor.constraint(equalTo: previousElement.bottomAnchor).isActive = true
        
        return view
    }
}
