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

protocol LogCellModelProtocol {
    var isUserCell: Bool { get }
    var isDataCell: Bool { get }
    
    var copiedString: String? { get }
    var title: String? { get }
    
    var info: String? { get }
    var infoFont: UIFont? { get }
    var infoColor: UIColor? { get }
    var infoAttributedString: NSMutableAttributedString? { get }
    
    // These fields are for DataRequestDetailsCell
    var bytesSent: String? { get }
    var bytesReceived: String? { get }
    
    // Services
    var theme: ThemeServiceProtocol? { get }
    var configuration: ConfigurationServiceProtocol? { get }
}

class LogCellModel: LogCellModelProtocol {
    var isUserCell: Bool
    var isDataCell: Bool
    
    var copiedString: String?
    var title: String?
    
    var info: String?
    var infoFont: UIFont?
    var infoColor: UIColor?
    var infoAttributedString: NSMutableAttributedString?
    
    var bytesSent: String?
    var bytesReceived: String?
    
    var theme: ThemeServiceProtocol?
    var configuration: ConfigurationServiceProtocol?
    
    init(isUserCell: Bool = true, isDataCell: Bool = false, copiedString: String? = nil, title: String? = nil, info: String? = nil, infoFont: UIFont? = nil, infoColor: UIColor? = nil, infoAttributedString: NSMutableAttributedString? = nil, bytesSent: String? = nil, bytesReceived: String? = nil, theme: ThemeServiceProtocol? = nil, configuration: ConfigurationServiceProtocol? = nil) {
        self.isUserCell = isUserCell
        self.isDataCell = isDataCell
        self.copiedString = copiedString
        self.title = title
        self.info = info
        self.infoFont = infoFont
        self.infoColor = infoColor
        self.infoAttributedString = infoAttributedString
        self.bytesSent = bytesSent
        self.bytesReceived = bytesReceived
        self.theme = theme
        self.configuration = configuration
    }
}

protocol CopiableCellInfo {
    var stringToCopy: String? { get }
    
    func showCopyLabel()
    func hideCopyLabel()
}

class RequestDetailsCell: UITableViewCell, CopiableCellInfo {
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var infoLabel: ThemableLabel!
    @IBOutlet weak var copiedLabel: UIButton!
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var separatorHeight: NSLayoutConstraint!
    // For data
    @IBOutlet weak var bytesSentLabel: ThemableLabel!
    @IBOutlet weak var bytesReceivedLabel: ThemableLabel!
    
    @IBOutlet var dataViews: [UIView]!
    
    
    var model: LogCellModelProtocol? {
        didSet{
            updateModel(model)
        }
    }
    
    // MARK: - Public methods
    
    func hideSeparator(){
        separator.isHidden = true
        separatorHeight.constant = 0.0
    }
    
    func showSeparator(){
        separator.isHidden = false
        separatorHeight.constant = 1.0
    }
    
    func openWebsite() {
        guard let website = model?.info else { return }
        if let url = URL(string: website){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - CopiableCellInfo protocol
    
    var stringToCopy: String?
    
    func showCopyLabel() {
        copiedLabel.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.titleLabel.alpha = 0.0
            self?.copiedLabel.alpha = 1.0
        }) {[weak self] (success) in
            if success {
                self?.titleLabel.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.hideCopyLabel()
                }
            }
        }
    }
    
    func hideCopyLabel() {
        titleLabel.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {[weak self] in
            self?.titleLabel.alpha = 1.0
            self?.copiedLabel.alpha = 0.0
        }) {[weak self] (success) in
            if success {
                self?.copiedLabel.isHidden = true
            }
        }
    }
    
    // MARK: -  private methods
    
    private func updateModel(_ model: LogCellModelProtocol?) {
        guard let model = model else {
            hideSeparator()
            isHidden = true
            return
        }
        
        let developerMode = model.configuration?.developerMode ?? false
        if !developerMode && !model.isUserCell {
            hideSeparator()
            isHidden = true
            return
        }
        
        showSeparator()
        updateTheme(model.theme)
        titleLabel.text = model.title
        stringToCopy = model.copiedString
    
        if model.isDataCell {
            dataViews.forEach({ $0.isHidden = false })
            infoLabel.isHidden = true
            bytesSentLabel.text = model.bytesSent
            bytesReceivedLabel.text = model.bytesReceived
            return
        } else {
            dataViews.forEach({ $0.isHidden = true })
            infoLabel.isHidden = false
        }
        
        infoLabel.text = nil
        infoLabel.attributedText = model.infoAttributedString

        infoLabel.text = model.info
        let font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        infoLabel.font = model.infoFont == nil ? font : model.infoFont
        infoLabel.textColor = model.infoColor == nil ? infoLabel.textColor : model.infoColor
    }
    
    private func updateTheme(_ theme: ThemeServiceProtocol?){
        theme?.setupLabel(titleLabel)
        separator.backgroundColor = theme?.separatorColor
        
        if model?.isDataCell ?? false {
            theme?.setupLabel(bytesSentLabel)
            theme?.setupLabel(bytesReceivedLabel)
        } else {
            theme?.setupLabel(infoLabel)
        }
    }
}
