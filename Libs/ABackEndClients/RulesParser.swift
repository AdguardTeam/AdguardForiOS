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

/**
 RulesParser - parses array of plain strings to array of ASDFilterRule
 */

@objc
@objcMembers
class RulesParser: NSObject {
    
    private let adblockFirstLine = "Adblock Plus"
    private let affinityPrefix = "!#safari_cb_affinity("
    private let affinitySuffix = "!#safari_cb_affinity"
    
    /**
     convert array of plain strings to array of ASDFilterRule
     fill ruleText, ruleId,filterId and affinity properties
     set enabled to true
    
     */
    func parseStrings(_ strings: [String], filterId: NSNumber)->[ASDFilterRule] {
        var rules = [ASDFilterRule]()
        
        var firstLine = true
        var count = 0
        
        var affinityMask: Affinity?
        
        for line in strings {
            if (firstLine) {
                firstLine = false
                if line.lowercased().contains(adblockFirstLine.lowercased()) {
                    continue;
                }
            }
            if (line.count == 0) {
                continue
            }
            
            let rule = ASDFilterRule(text: line, enabled: true)
            
            count += 1
            rule.ruleId = count as NSNumber

            if line.hasPrefix(affinityPrefix) {
                affinityMask = parseContentBlockerTypes(line)
            } else if line.hasSuffix(affinitySuffix) {
                affinityMask = nil
            } else {
                rule.ruleText = line;
                rule.isEnabled = true;
                rule.filterId = filterId;
                rule.affinity =  affinityMask?.rawValue as NSNumber?
                
                rules.append(rule)
            }
        }
        
        return rules
    }
    
    // MARK: - private methods
    private static let stringToAffinity:[String: Affinity] = [  "general" : .general,
                                                        "privacy" : .privacy,
                                                        "social"  : .socialWidgetsAndAnnoyances,
                                                        "other" : .other,
                                                        "custom" : .custom,
                                                        "security" : .security,
                                                        "all" : Affinity(rawValue: 0)]
    
    private func parseContentBlockerTypes(_ ruleText: String)->Affinity?{
        var result: Affinity?
        
        let startIndex = ruleText.index(ruleText.startIndex, offsetBy: affinityPrefix.count)
        let endIndex = ruleText.index(ruleText.startIndex, offsetBy: ruleText.count - 1)
        let range = startIndex..<endIndex
        let stripped = ruleText[range]
        let list = stripped.components(separatedBy: ",")
        
        for item in list {
            
            let trimmed = item.trimmingCharacters(in: .whitespacesAndNewlines)
            let affinity = RulesParser.stringToAffinity[trimmed]
            if affinity != nil {
                if result == nil {
                    result = affinity
                }
                else {
                    result?.insert(affinity!)
                }
            }
        }
        
        return result;
    }
}
