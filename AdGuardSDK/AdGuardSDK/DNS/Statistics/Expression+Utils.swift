/**
       This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
       Copyright © Adguard Software Limited. All rights reserved.
 
       Adguard for iOS is free software: you can redistribute it and/or modify
       it under the terms of the GNU General Public License as published by
       the Free Software Foundation, either version 3 of the License, or
       (at your option) any later version.
 
       Adguard for iOS is distributed in the hope that it will be useful,
       but WITHOUT ANY WARRANTY; without even the implied warranty of
       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
       GNU General Public License for more details.
 
       You should have received a copy of the GNU General Public License
       along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
 */

import Foundation
import SQLite

// MARK: - Expression + DB functions

extension Expression where Datatype == Date {
    /// Arithmetic mean for Date objects
    var avgDate: Expression<Date> {
        Expression(literal: "datetime(avg(strftime('%s', \(self.asSQL()))), 'unixepoch') as \(self.template)")
    }
}

extension Expression where Datatype == Int {
    /// SUM function with variable
    var varSum: Expression<Int> {
        Expression(literal: "SUM(\(self.asSQL())) as \(self.template)")
    }
}

extension Expression where Datatype == Double {
    /// SUM function with variable
    var varSum: Expression<Double> {
        Expression(literal: "SUM(\(self.asSQL())) as \(self.template)")
    }
}
