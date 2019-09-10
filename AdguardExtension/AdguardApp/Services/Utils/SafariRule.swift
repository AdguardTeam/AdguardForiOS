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

enum Action {
    case block, whitelist, invertedWhitelist
}

/**
 SafariRule this class is used for working with safari rules.
 It can parse json and detect blocklist^ whitelist or inverted whitelist rules
 Also it can create new whitelist or inverted whitelist rules.
 It can not create blacklist rules. You can use Converter.js to make it.
 */
class SafariRule: Equatable {
    
    var action: Action
    
    // this property contains array of domains for whitelist or invertedwhitelist rules. nil for blacklist rules
    var domains: [String]?
    
    private static let stringByAction:[Action: String] = [.block: "block",
                                                          .whitelist:"ignore-previous-rules",
                                                          .invertedWhitelist: "ignore-previous-rules"]
    
    private static let urlFilterAll = "^[htpsw]+:\\/\\/"
    
    // create new rule
    init(domains: [String], action:Action) {
        self.action = action
        self.domains = domains.map { "*\($0)" }
    }
    
    // parse rule from Dictionary
    init?(object: Any) {
        
        guard let json = object as? [String: Any] else { return nil }
        
        guard let trigger = json["trigger"] as? [String:Any],
            let action = json["action"] as? [String: String] else { return nil }
        
        guard let type = action["type"] else { return nil }
        
        let ifDomains = trigger["if-domain"] as? [String]
        let unlessDomains = trigger["unless-domain"] as? [String]
        
        let urlFilter = trigger["url-filter"] as? String
        
        if type == "block" {
            self.action = .block
        }
        else if type == "ignore-previous-rules" && ifDomains != nil {
            self.action = .whitelist
            self.domains = ifDomains
        }
        else if type == "ignore-previous-rules" && urlFilter == SafariRule.urlFilterAll {
            self.action = .invertedWhitelist
            self.domains = unlessDomains
        }
        else {
            return nil
        }
    }
    
    // compare two rules
    static func == (lhs: SafariRule, rhs: SafariRule) -> Bool {
        return lhs.action == rhs.action && lhs.domains == rhs.domains
    }
    
    // returns correct object only for whitelist or inverted whitelist rules
    func json()->[String:Any] {
        
        var json = [String:Any]()
        
        var trigger = [String:Any]()
        trigger["url-filter"] = SafariRule.urlFilterAll
        if (domains?.count ?? 0) > 0 {
            if action == .invertedWhitelist {
                trigger["unless-domain"] = domains
            }
            else {
                trigger["if-domain"] = domains
            }
        }
        
        var action = [String:String]()
        action["type"] = SafariRule.stringByAction[self.action]
        
        json["trigger"] = trigger
        json["action"] = action
        
        return json
    }
    
    func appendDomain(_ domain: String) {
        if domains == nil {
            domains = [String]()
        }
        domains?.append("*\(domain)")
    }
    
    func removeDomain(_ domain: String)->Bool{
        
        if domains == nil { return false }
        var indexToRemove: Int?
        let searchDomain = "*\(domain)"
        for (index, currentDomain) in domains!.enumerated() {
            if searchDomain == currentDomain {
                indexToRemove = index
                break
            }
        }
        
        if indexToRemove != nil {
            domains?.remove(at: indexToRemove!)
            return true
        }
        
        return false
    }
}
