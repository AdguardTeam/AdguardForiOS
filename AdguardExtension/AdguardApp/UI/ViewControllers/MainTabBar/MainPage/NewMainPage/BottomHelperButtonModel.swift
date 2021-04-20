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

protocol BottomHelperButtonModelDelegate: AnyObject {
    func bottomButtonTypeChanged()
    func bottomButtonVisibilityChanged()
}

protocol BottomHelperButtonModelProtocol: AnyObject {
    var buttonType: BottomHelperButtonModel.ButtonType { get }
    var shouldShowBottomButton: Bool { get }
}

final class BottomHelperButtonModel: BottomHelperButtonModelProtocol {
    
    enum ButtonType {
        case datePicker
        case proStatusPromotion
    }
    
    // MARK: - Public properties
    
    weak var delegate: BottomHelperButtonModelDelegate?
    
    private(set) var buttonType: ButtonType = .proStatusPromotion {
        didSet {
            if oldValue != buttonType {
                delegate?.bottomButtonTypeChanged()
            }
        }
    }
    
    private(set) var shouldShowBottomButton: Bool = false {
        didSet {
            if oldValue != shouldShowBottomButton {
                delegate?.bottomButtonVisibilityChanged()
            }
        }
    }
    
    // MARK: - Private properties
    
    /* Services */
    private let resources: AESharedResourcesProtocol
    private let configuration: ConfigurationService
    
    /* Observers */
    private var dnsImplementationObserver: NotificationToken?
    private var proStatusObserver: NSKeyValueObservation?
    
    init(resources: AESharedResourcesProtocol, configuration: ConfigurationService) {
        self.resources = resources
        self.configuration = configuration
        
        addObservers()
        processBottomButton()
    }
    
    deinit {
        if let proStatusObserver = proStatusObserver {
            NotificationCenter.default.removeObserver(proStatusObserver)
        }
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: .main) { [weak self] _ in
            DDLogDebug("(MainPageModel) - Received DNS implementation change notification")
            self?.processBottomButton()
        }
        
        proStatusObserver = configuration.observe(\.proStatus) { (_, _) in
            DDLogDebug("(MainPageModel) - Received Pro status change notification")
            DispatchQueue.main.async { [weak self] in
                self?.processBottomButton()
            }
        }
    }
    
    private func processBottomButton() {
        let buttonType: ButtonType = configuration.proStatus ? .datePicker : .proStatusPromotion
        self.buttonType = buttonType
        
        if buttonType == .datePicker {
            let shouldShowDateTypePicker = resources.dnsImplementation == .adGuard && configuration.proStatus
            self.shouldShowBottomButton = shouldShowDateTypePicker
        } else {
            let shouldShowDnsStatistics = !configuration.proStatus
            self.shouldShowBottomButton = shouldShowDnsStatistics
        }
    }
}
