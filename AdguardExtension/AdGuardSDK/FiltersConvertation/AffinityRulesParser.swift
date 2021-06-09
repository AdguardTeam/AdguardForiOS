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

// MARK: - FilterRule

struct FilterRule {
    let rule: String
    let affinity: Affinity?
}

// MARK: - AffinityRulesParserProtocol

protocol AffinityRulesParserProtocol {
    /* Converts array of rules strings to array of FilterRule-s with affinities */
    static func parse(strings: [String]) -> [FilterRule]
    
    /**
     Converts rules string without affinity to the string with specified affinity
     - Parameter rule: String represantation of rule
     - Parameter affinity: Affinity mask to apply for rule
     - Returns: String represantation of rule with affinity
     
     For example:
     If we pass **@@||imasdk.googleapis.com** and affinity **general** and **privacy**
     The function will return:
     !#safari_cb_affinity(general,privacy)
     @@||imasdk.googleapis.com
     !#safari_cb_affinity
     */
    static func rule(_ rule: String, withAffinity affinity: Affinity?) -> String
}

/**
 This object parses array of plain strings to array of FilterRule

 Every filter group has content blocker where it's converted rules are stored,
 but sometimes rules need to be stored in another CB to be able to work properly.
 Such rules have **Affinity**.
 If rules are bordered with **affinityPrefix** and **affinitySuffix** than they should be added to the specified CB.
 Rules with affinity look like this:
 ~~~
 !#safari_cb_affinity(general,privacy)
 @@||imasdk.googleapis.com/js/sdkloader/ima3.js$domain=ondemandkorea.com
 @@||google-analytics.com/collect|$domain=ondemandkorea.com
 !#safari_cb_affinity
 ~~~
 
 That means that this 2 rules should be added to **general** and **privacy** content blockers,
 although all other rules from filter example will be added to **ads** CB.
 */
struct AffinityRulesParser: AffinityRulesParserProtocol {
    
    // MARK: - Private properties
    
    private static let adblockFirstLine = "Adblock Plus"
    private static let affinityPrefix = "!#safari_cb_affinity("
    private static let affinitySuffix = "!#safari_cb_affinity"
    
    private static let stringToAffinity:[String: Affinity] = ["general" : .general,
                                                              "privacy" : .privacy,
                                                              "social"  : .socialWidgetsAndAnnoyances,
                                                              "other" : .other,
                                                              "custom" : .custom,
                                                              "security" : .security,
                                                              "all" : Affinity(rawValue: 0)]
    
    // MARK: - Public methods
    
    static func parse(strings: [String]) -> [FilterRule] {
        var rules: [FilterRule] = []
        var affinityMask: Affinity?
        
        // Iterating over file's content line by line
        for (lineIndex, line) in strings.enumerated() {
            
            // If first line contains Adblock Plus than it's not a rule or affinity
            if lineIndex == 0, line.lowercased().contains(adblockFirstLine.lowercased()) {
                continue
            }
            
            // If line is empty just go on
            if line.count == 0 {
                continue
            }
            
            // Affinity mask found
            if line.hasPrefix(affinityPrefix) {
                affinityMask = parseContentBlockerTypes(from: line)
                continue
            }
            // End of affinity mask found
            else if line.hasSuffix(affinitySuffix) {
                affinityMask = nil
                continue
            }
            // Comment found
            else if line.first == "!"{
                continue
            }
            
            let rule = FilterRule(rule: line, affinity: affinityMask)
            rules.append(rule)
        }
        
        return rules
    }
    
    static func rule(_ rule: String, withAffinity affinity: Affinity?) -> String {
        guard let affinity = affinity else {
            return rule
        }

        var affinityValues: [String] = []

        if affinity.contains(.general) { affinityValues.append("general") }
        if affinity.contains(.custom) { affinityValues.append("custom") }
        if affinity.contains(.other) { affinityValues.append("other") }
        if affinity.contains(.privacy) { affinityValues.append("privacy") }
        if affinity.contains(.security) { affinityValues.append("security") }
        if affinity.contains(.socialWidgetsAndAnnoyances) { affinityValues.append("social") }
        if affinity.rawValue == 0 { affinityValues.append("all") }
        
        return "!#safari_cb_affinity(\(affinityValues.joined(separator: ",")))\n\(rule)\n!#safari_cb_affinity"
    }
    
    // MARK: - private methods
    
    // Gets all affinity masks from rule
    private static func parseContentBlockerTypes(from ruleText: String) -> Affinity? {
        var result: Affinity?
        
        let startIndex = ruleText.index(ruleText.startIndex, offsetBy: affinityPrefix.count)
        let endIndex = ruleText.index(ruleText.startIndex, offsetBy: ruleText.count - 1)
        guard startIndex < endIndex else {
            return nil
        }
        
        let range = startIndex..<endIndex
        let stripped = ruleText[range]
        let list = stripped.components(separatedBy: ",")
        
        for item in list {
            let trimmed = item.trimmingCharacters(in: .whitespacesAndNewlines)
            let affinity = AffinityRulesParser.stringToAffinity[trimmed]
            if let affinity = affinity {
                if result == nil {
                    result = affinity
                }
                else {
                    result?.insert(affinity)
                }
            }
        }
        return result
    }
}
