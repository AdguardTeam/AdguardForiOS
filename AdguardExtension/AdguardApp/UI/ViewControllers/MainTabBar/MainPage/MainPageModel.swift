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

protocol MainPageModelDelegate: class {
    func updateStarted()
    func updateFinished(message: String?)
    func updateFailed(error: String)
}

protocol MainPageModelProtocol: class {
    func updateFilters()
    var delegate: MainPageModelDelegate? { get set }
}

class MainPageModel: MainPageModelProtocol {
    
    weak var delegate: MainPageModelDelegate?
    
    // MARK: - private members
    
    private let filtersService: FiltersServiceProtocol
    private var observers = [NSObjectProtocol]()
    
    // MARK: - init
    
    init(filtersService: FiltersServiceProtocol) {
        self.filtersService = filtersService
        self.observeAntibanerState()
    }
    
    deinit {
        observers.forEach { (observer) in
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    
    // MARK: - public methods
    
    /**
     updates filters. calls callback during updating process
     */
    func updateFilters() {
        filtersService.load(refresh: true) {}
    }
    
    // MARK: - private methods
    
    private func observeAntibanerState(){
        let observer1 = NotificationCenter.default.observe(name: .appDelegateStartedUpdateNotification, object: nil, queue: .main) { [weak self] (note) in
            self?.delegate?.updateStarted()
        }
        observers.append(observer1)
        
        let observer2 = NotificationCenter.default.observe(name: .appDelegateFinishedUpdateNotification, object: nil, queue: .main) { [weak self] (note) in
            
            let updatedMetas: Int = (note.userInfo?[Notification.Name.appDelegateUpdatedFiltersKey] as? Int) ?? 0
            
            let message: String?
            if updatedMetas > 0 {
                let format = ACLocalizedString("filters_updated_format", nil);
                message = String(format: format, updatedMetas)
            } else {
                message = ACLocalizedString("filters_noUpdates", nil);
            }
            
            self?.delegate?.updateFinished(message: message)
        }
        observers.append(observer2)
        
        let observer3 = NotificationCenter.default.observe(name: .appDelegateFailuredUpdateNotification, object: nil, queue: .main) { [weak self] (note) in
            guard let self = self else { return }
            
            self.delegate?.updateFailed(error: ACLocalizedString("filter_updates_error", nil))
        }
        observers.append(observer3)
        
        let observer4 = NotificationCenter.default.observe(name: .appDelegateUpdateDidNotStartedNotification, object: nil, queue: .main) { [weak self] (note) in
            guard let self = self else { return }
            DDLogInfo("(MainPageModel) update did not start")
            self.delegate?.updateFinished(message: String.localizedString("filters_noUpdates"))
        }
        observers.append(observer4)
    }
}
