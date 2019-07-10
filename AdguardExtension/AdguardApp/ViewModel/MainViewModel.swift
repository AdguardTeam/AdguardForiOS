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

/** view model for MainViewController
 */
class MainViewModel {
    
    // MARK: - private members
    
    private let antibanner: AESAntibannerProtocol
    private var start : (()->Void)?
    private var finish: ((String)->Void)?
    private var error: ((String)->Void)?
    private var observers = [NSObjectProtocol]()
    
    // MARK: - init
    init(antibanner: AESAntibannerProtocol) {
        self.antibanner = antibanner
        
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
     @start - this callback calls when updating process is started
     @finish - this callback calls when updating process is finished
     @error - this callback calls if error occurs
     */
    func updateFilters(start:@escaping ()->Void, finish:@escaping (_ message: String)->Void, error:@escaping (_ message: String)->Void) {
        self.start = start
        self.finish = finish
        self.error = error
        
        antibanner.beginTransaction()
        let result = antibanner.startUpdatingForced(true, interactive: true)
        
        if (!result) {
            antibanner.rollbackTransaction()
        }
    }
    
    // MARK: - private functions
    
    private func observeAntibanerState(){
        let observer1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.ASAntibannerStartedUpdate, object: nil, queue: nil) { [weak self] (note) in
            self?.start?()
        }
        observers.append(observer1)
        let observer2 = NotificationCenter.default.addObserver(forName: NSNotification.Name.ASAntibannerFinishedUpdate, object: nil, queue: nil) { [weak self] (note) in
            
            let updatedMetas: Array<Any>? = (note.userInfo?[ASAntibannerUpdatedFiltersKey]) as! Array<Any>?
            
            var message: String?
            if updatedMetas != nil && updatedMetas!.count > 0 {
                
                let format = ACLocalizedString("filters_updated_format", nil);
                message = String(format: format, updatedMetas!.count)
            } else {
                message = ACLocalizedString("filters_noUpdates", nil);
            }
            
            self?.finish?(message!)
        }
        observers.append(observer2)
        let observer3 = NotificationCenter.default.addObserver(forName: NSNotification.Name.ASAntibannerFailuredUpdate, object: nil, queue: nil) { [weak self] (note) in
            
            if self?.antibanner.inTransaction() ?? false {
                self?.antibanner.rollbackTransaction()
            }
            
            self?.error?(ACLocalizedString("filter_updates_error", nil))
        }
        observers.append(observer3)
    }
}
