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

protocol StatisticsDatePickerModelDelegate: AnyObject {
    func shouldShowDateTypePickerChanged()
}

protocol StatisticsDatePickerModelProtocol: AnyObject {
    var shouldShowDateTypePicker: Bool { get }
}

final class StatisticsDatePickerModel: StatisticsDatePickerModelProtocol {
    
    // MARK: - Public properties
    
    weak var delegate: StatisticsDatePickerModelDelegate?
    
    private(set) var shouldShowDateTypePicker: Bool = false {
        didSet {
            if oldValue != shouldShowDateTypePicker {
                delegate?.shouldShowDateTypePickerChanged()
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
        processShouldShowDateTypePicker()
    }
    
    // MARK: - Private methods
    
    private func addObservers() {
        dnsImplementationObserver = NotificationCenter.default.observe(name: .dnsImplementationChanged, object: nil, queue: .main) { [weak self] _ in
            DDLogDebug("(MainPageModel) - Received DNS implementation change notification")
            self?.processShouldShowDateTypePicker()
        }
        
        proStatusObserver = configuration.observe(\.proStatus) { (_, _) in
            DDLogDebug("(MainPageModel) - Received Pro status change notification")
            DispatchQueue.main.async { [weak self] in
                self?.processShouldShowDateTypePicker()
            }
        }
    }
    
    private func processShouldShowDateTypePicker() {
        shouldShowDateTypePicker = resources.dnsImplementation == .adGuard && configuration.proStatus
    }
}
