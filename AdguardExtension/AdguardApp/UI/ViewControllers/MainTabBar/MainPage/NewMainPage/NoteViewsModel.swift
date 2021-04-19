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

protocol NoteViewsModelDelegate: AnyObject {
    func contentBlockersStateChanged()
    func proStatusChanged()
}

protocol NoteViewsModelProtocol: AnyObject {
    var shouldShowContentBlockersView: Bool { get }
    var shouldShowGetProView: Bool { get }
}

final class NoteViewsModel: NoteViewsModelProtocol {
    
    weak var delegate: NoteViewsModelDelegate?
    
    private(set) var shouldShowContentBlockersView: Bool {
        didSet {
            if oldValue != shouldShowContentBlockersView {
                delegate?.contentBlockersStateChanged()
            }
        }
    }
    
    private(set) var shouldShowGetProView: Bool {
        didSet {
            if oldValue != shouldShowGetProView {
                delegate?.proStatusChanged()
            }
        }
    }
    
    private var contentBlockersStateObserver: NSKeyValueObservation?
    private var proStatusObserver: NSKeyValueObservation?
    private let configuration: ConfigurationService
    
    init(configuration: ConfigurationService) {
        self.configuration = configuration
        self.shouldShowContentBlockersView = !configuration.allContentBlockersEnabled
        self.shouldShowGetProView = !configuration.proStatus
        
        configuration.checkContentBlockerEnabled()
        
        contentBlockersStateObserver = configuration.observe(\.contentBlockerEnabled) { (_, _) in
            DispatchQueue.main.async { [weak self] in
                self?.shouldShowContentBlockersView = !configuration.allContentBlockersEnabled
            }
        }
        
        proStatusObserver =  configuration.observe(\.proStatus) { (_, _) in
            DispatchQueue.main.async { [weak self] in
                self?.shouldShowGetProView = !configuration.proStatus
            }
        }
    }
    
    deinit {
        if let contentBlockersStateObserver = contentBlockersStateObserver,
           let proStatusObserver = proStatusObserver {
            NotificationCenter.default.removeObserver(contentBlockersStateObserver)
            NotificationCenter.default.removeObserver(proStatusObserver)
        }
    }
}
