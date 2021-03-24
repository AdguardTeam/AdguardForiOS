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

class RoundRectButton: UIButton {
    
    // If indicator needs to be displayed this variable must be true, otherwise content insets won't be set in init and indicator will be displayed in a weird way
    @IBInspectable var needsToDisplayIndicator: Bool = false
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            self.layer.borderColor = borderColor?.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var customBackgroundColor: UIColor? {
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable var isNeedHighlight: Bool  = true {
        didSet {
            updateBackground()
        }
    }
    
    @IBInspectable var customHighlightedBackgroundColor: UIColor? {
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable var customDisabledBackgroundColor: UIColor? {
        didSet{
            updateBackground()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var onTintColor: UIColor = .clear {
        didSet {
            updateTints()
        }
    }
    
    @IBInspectable var offTintColor: UIColor = .clear {
        didSet {
            updateTints()
        }
    }
    
    
    var onAccessibilityTitle: String? = nil
    var offAccessibilityTitle: String? = nil
    
    var buttonIsOn: Bool = true {
        didSet{
            updateTints()
            
            if onAccessibilityTitle == nil || offAccessibilityTitle == nil { return }
            accessibilityLabel = buttonIsOn ? onAccessibilityTitle : offAccessibilityTitle
        }
    }
    
    override var isHighlighted: Bool {
        didSet{
            updateBackground()
        }
    }
    
    //MARK: - Initialization
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        if needsToDisplayIndicator{
            self.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: indicatorSize + 2 * indicatorInset, bottom: 5.0, right: indicatorSize + 2 * indicatorInset)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // increase touch area
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let newArea = CGRect(x: self.bounds.origin.x - 10, y: self.bounds.origin.y - 10, width: self.bounds.size.width + 20, height: self.bounds.size.height + 20)
        return newArea.contains(point)
    }
    
    //MARK: - Load indicator property
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let indicatorSize: CGFloat = 40.0
    private let indicatorInset: CGFloat = 5.0
    
    var indicatorColor: UIColor = .white {
        didSet{
            self.activityIndicator.color = indicatorColor
        }
    }
    
    var indicatorStyle: UIActivityIndicatorView.Style = .white {
        didSet{
            self.activityIndicator.style = indicatorStyle
        }
    }
    
    override var isSelected: Bool {
        didSet{
            updateBackground()
        }
    }
    
    override var isEnabled: Bool {
        didSet{
            updateBackground()
        }
    }
    
    //MARK: - Public methods
    
    func startIndicator(){
        setupIndicator()
        activityIndicator.startAnimating()
    }
    
    func stopIndicator(){
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
    //MARK: - Private methods

    private func updateBackground() {
        if !isEnabled,
            let disabledColor = customDisabledBackgroundColor {
            self.backgroundColor = disabledColor
        }
        else if isHighlighted, isNeedHighlight,
            let highlightedColor = customHighlightedBackgroundColor {
            self.backgroundColor = highlightedColor
        }
        else if let backgroundColor = customBackgroundColor {
            self.backgroundColor = backgroundColor
        }
        else {
            return
        }
    }
    
    private func updateTints(){
        tintColor = buttonIsOn ? onTintColor : offTintColor
    }
    
    private func setupIndicator(){
        activityIndicator.frame.size = CGSize(width: indicatorSize, height: indicatorSize)
        
        let point = CGPoint(x: (self.titleLabel?.frame.maxX ?? 0.0) + (indicatorSize / 2) + indicatorInset, y: self.bounds.midY)
        activityIndicator.center = point
        self.addSubview(activityIndicator)
    }
}
