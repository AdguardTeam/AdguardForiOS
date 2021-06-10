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
import SQLite

/* FilterRulesTable; filter_rules table */
private struct FilterRulesTable {
    // Properties from table
    let filterId: Int
    let ruleId: Int
    let ruleText: String
    let isEnabled: Bool
    let affinity: Int?
    
    // Table name
    static let table = Table("filter_rules")
    
    // Columns names
    static let filterId = Expression<Int>("filter_id")
    static let ruleId = Expression<Int>("rule_id")
    static let ruleText = Expression<String>("rule_text")
    static let isEnabled = Expression<Bool>("is_enabled")
    static let affinity = Expression<Int>("affinity")
    
    // Initializer from DB result
    init(dbFilterRule: Row) {
        self.filterId = dbFilterRule[Self.filterId]
        self.ruleId = dbFilterRule[Self.ruleId]
        self.ruleText = dbFilterRule[Self.ruleText]
        self.isEnabled = dbFilterRule[Self.isEnabled]
        self.affinity = dbFilterRule[Self.affinity]
    }
}

// MARK: - MetaStorage + Filter rules

extension MetaStorage {
    
}
