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

class StringUtilsTest: XCTestCase {
    
    let correctDnsServers: [String] = ["8.8.8.8", "https://dns.google/dns-query", "tls://dns.google", "https://www.cloudflare.com/dns/", "https://dns.cloudflare.com/dns-query", "tls://1.1.1.1", "208.67.222.222", "sdns://AQAAAAAAAAAADjIwOC42Ny4yMjAuMjIwILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ", "sdns://AQAAAAAAAAAADjIwOC42Ny4yMjAuMTIzILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvbQ", "149.112.112.112", "sdns://AQMAAAAAAAAADDkuOS45Ljk6ODQ0MyBnyEe4yHWM0SAkVUO-dWdG3zTfHYTAC4xHA2jfgh2GPhkyLmRuc2NyeXB0LWNlcnQucXVhZDkubmV0"]
    
    let incorrectDnsServers: [String] = ["уоатылрволаы", "tls://аолаоав.fje", "fыдджg", "sdns://AQAAAAAAAAAADjIwOC42Ny4yMjAuMjIwILc1EUAgbyJdPivYItf9aR6hwzzI1maNDL4Ev6vKQ_t5GzIuZG5zY3J5cHQtY2VydC5vcGVuZG5zLmNvаораоровооароровоаf", ""]
    
    func testCheckIfValidDnsServerForCorrectExamples() {
        for server in correctDnsServers {
            XCTAssertTrue(server.isValidUpstream())
        }
    }
    
    func testCheckIfValidDnsServerForIncorrectExamples() {
        for server in incorrectDnsServers {
            XCTAssertFalse(server.isValidUpstream())
        }
    }
    
    // MARK: - generateSubDomains tests
    
    func testGenerateSubDomainsWithNormalDomain(){
        let domain = "e6858.dscce9.akamaiedge.net"
        let subdomains = ["e6858.dscce9.akamaiedge.net",
                          "dscce9.akamaiedge.net",
                          "akamaiedge.net"]
        let subDomainsToCheck = String.generateSubDomains(from: domain)
        XCTAssertEqual(subdomains, subDomainsToCheck)
    }
    
    func testGenerateSubDomainsWithDotInTheEnd(){
        let domain = "e6858.dscce9.akamaiedge.net."
        let subdomains = ["e6858.dscce9.akamaiedge.net",
                          "dscce9.akamaiedge.net",
                          "akamaiedge.net"]
        let subDomainsToCheck = String.generateSubDomains(from: domain)
        XCTAssertEqual(subdomains, subDomainsToCheck)
    }
    
    func testGenerateSubDomainsWithEmptyDomain(){
        let domain = ""
        let subdomains: [String] = []
        let subDomainsToCheck = String.generateSubDomains(from: domain)
        XCTAssertEqual(subdomains, subDomainsToCheck)
    }
}
