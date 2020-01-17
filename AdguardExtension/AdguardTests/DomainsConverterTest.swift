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

import XCTest

class DomainsConverterTest: XCTestCase {
    let converter: DomainsConverterProtocol = DomainsConverter()
    
    // MARK: - Test whitelistDomainFromRule function
    
    func testWhitelistDomainFromRuleWithRule(){
        let domain = "www.google.com"
        let whitelistRule = "@@||www.google.com^|"
        let domainToCheck = converter.whitelistDomainFromRule(whitelistRule)
        
        XCTAssertEqual(domain, domainToCheck)
    }
    
    func testWhitelistDomainFromRuleWithDomain(){
        let domain = "www.google.com"
        let domainToCheck = converter.whitelistDomainFromRule(domain)
        
        XCTAssertEqual(domain, domainToCheck)
    }
    
    // MARK: - Test blacklistRuleFromDomain function
    
    func testBlacklistRuleFromDomainWithRule(){
        let domain = "www.google.com"
        let blacklistRule = "||www.google.com^"
        let ruleToCheck = converter.blacklistRuleFromDomain(domain)
        
        XCTAssertEqual(blacklistRule, ruleToCheck)
    }
    
    func testBlacklistRuleFromDomainWithDomain(){
        let blacklistRule = "||www.google.com^"
        let ruleToCheck = converter.blacklistRuleFromDomain(blacklistRule)
        
        XCTAssertEqual(blacklistRule, ruleToCheck)
    }
    
    func testBlacklistRuleFromDomainWithRuleWithDotInTheEnd(){
        let domain = "www.google.com."
        let blacklistRule = "||www.google.com^"
        let ruleToCheck = converter.blacklistRuleFromDomain(domain)
        
        XCTAssertEqual(blacklistRule, ruleToCheck)
    }
    
    // MARK: - Test whitelistRuleFromDomain function
    
    func testWhitelistRuleFromDomainWithRule(){
        let domain = "www.google.com"
        let whitelistRule = "@@||www.google.com^|"
        let ruleToCheck = converter.whitelistRuleFromDomain(domain)
        
        XCTAssertEqual(whitelistRule, ruleToCheck)
    }
    
    func testWhitelistRuleFromDomainWithDomain(){
        let whitelistRule = "@@||www.google.com^|"
        let ruleToCheck = converter.whitelistRuleFromDomain(whitelistRule)
        
        XCTAssertEqual(whitelistRule, ruleToCheck)
    }
}
