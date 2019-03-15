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

/** FilterGroupViewModel
    Model for GroupsController
 */
protocol FilterGroupViewModelProtocol {
    
    var groups: [Group]? { get }
    
    /**
     loads filters list
    */
    func load(_ completion: @escaping ()->Void)
    
    /**
     enable/disable group
    */
    func set(group: Group, enabled: Bool, completion: @escaping (_ success: Bool)->Void)
    
    /**
     sets groups change observer
    */
    func bind(groupChanged: @escaping (_ index: Int)->Void)
}

class FilterGroupViewModel: NSObject, FilterGroupViewModelProtocol {
    
    var groups: [Group]? {
        get {
            return filtersService.groups
        }
    }
    
    // MARK: - private properties
    private var groupsObserver: ((_ index: Int)->Void)?
    private var filtersService: FiltersServiceProtocol
    
    // MARK: - initializers
    
    init(filtersService: FiltersServiceProtocol) {
        self.filtersService = filtersService
        super.init()
        
        NotificationCenter.default.addObserver(forName: self.filtersService.updateNotification, object: nil, queue: nil) {
            [weak self] (notification) in
            self?.groupsObserver?(0)
        }
    }
    
    // MARK: - public methods
    
    func bind(groupChanged: @escaping (Int) -> Void) {
        groupsObserver = groupChanged
    }
    
    func load(_ completion: @escaping () -> Void){
        filtersService.load(refresh: false, completion)
    }
    
    func set(group: Group, enabled: Bool, completion: @escaping (_ success: Bool)->Void) {
        
        filtersService.setGroup(group, enabled: enabled)
    }
    
    // MARK: - private methods
}
