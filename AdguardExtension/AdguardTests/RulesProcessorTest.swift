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

class RulesProcessorTest: XCTestCase {
    
    var processor: RulesProcessorProtocol!

    override func setUp() {
        processor = RulesProcessor()
    }

    func testAddWhitelistDomainToEmptyJson() {
        
        let jsonString =    """
                            """
        
        let domain = "google.com"
        let result =  """
                    [
                        {
                            "trigger": {
                                "url-filter": "^[htpsw]+:\\\\/\\\\/",
                                "if-domain": [
                                    "*google.com"
                                ]
                            },
                            "action": {
                                "type": "ignore-previous-rules"
                            }
                        }
                    ]
                    """
        testAddDomain(json: jsonString, domain: domain, expectedResult: result)
    }
    
    func testAddWhitelistDomainToEmptyArray() {

        let jsonString =    """
                            []
                            """

        let domain = "google.com"
        let result =  """
                    [
                        {
                            "trigger": {
                                "url-filter": "^[htpsw]+:\\\\/\\\\/",
                                "if-domain": [
                                    "*google.com"
                                ]
                            },
                            "action": {
                                "type": "ignore-previous-rules"
                            }
                        }
                    ]
                    """

        testAddDomain(json: jsonString, domain: domain, expectedResult: result)
    }
    
    func testAddWhitelistToFilled() {
        let jsonString =    """
                            [
                                {
                                    "trigger": {
                                        "url-filter": "^[htpsw]+:\\\\/\\\\/",
                                        "if-domain": [
                                            "*google.com"
                                        ]
                                    },
                                    "action": {
                                        "type": "ignore-previous-rules"
                                    }
                                }
                            ]
                            """
        
        let domain = "apple.com"
        let result =  """
                    [
                        {
                            "trigger": {
                                "url-filter": "^[htpsw]+:\\\\/\\\\/",
                                "if-domain": [
                                    "*google.com"
                                ]
                            },
                            "action": {
                                "type": "ignore-previous-rules"
                            }
                        },
                        {
                            "trigger": {
                                "url-filter": "^[htpsw]+:\\\\/\\\\/",
                                "if-domain": [
                                    "*apple.com"
                                ]
                            },
                            "action": {
                                "type": "ignore-previous-rules"
                            }
                        }
                    ]
                    """
        
        testAddDomain(json: jsonString, domain: domain, expectedResult: result)
    }
    
    func testAddToOverlimit() {
        let jsonString =    """
                            [
                                {
                                "trigger" : {
                                  "url-filter" : "^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?watchcartoononline\\\\.io\\\\/inc\\\\/sharing\\\\/",
                                  "resource-type" : [
                                    "image"
                                  ]
                                },
                                "action" : {
                                  "type" : "block"
                                }
                              }
                            ]
                            """
        
        let domain = "google.com"
        let result =  """
                    [
                        {
                            "trigger": {
                                "url-filter": "^[htpsw]+:\\\\/\\\\/",
                                "if-domain": [
                                    "*google.com"
                                ]
                            },
                            "action": {
                                "type": "ignore-previous-rules"
                            }
                        }
                    ]
                    """
        
        testAddDomain(json: jsonString, domain: domain, expectedResult: result, overlimit: true)
    }
    
    func testAddToOverlimit2() {
        let jsonString =    """
                            [
                                {
                                "trigger" : {
                                  "url-filter" : "^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?watchcartoononline\\\\.io\\\\/inc\\\\/sharing\\\\/",
                                  "resource-type" : [
                                    "image"
                                  ]
                                },
                                "action" : {
                                  "type" : "block"
                                }
                              },
                              {
                                "trigger" : {
                                  "url-filter" : "^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?watchcartoononline\\\\.io\\\\/inc\\\\/sharing\\\\/",
                                  "resource-type" : [
                                    "image"
                                  ]
                                },
                                "action" : {
                                  "type" : "block"
                                }
                              }
                            ]
                            """
        
        let domain = "google.com"
        let result =  """
                    [
                        {
                            "trigger" : {
                              "url-filter" : "^[htpsw]+:\\\\/\\\\/([a-z0-9-]+\\\\.)?watchcartoononline\\\\.io\\\\/inc\\\\/sharing\\\\/",
                              "resource-type" : [
                                "image"
                              ]
                            },
                            "action" : {
                              "type" : "block"
                            }
                        },
                        {
                            "trigger": {
                                "url-filter": "^[htpsw]+:\\\\/\\\\/",
                                "if-domain": [
                                    "*google.com"
                                ]
                            },
                            "action": {
                                "type": "ignore-previous-rules"
                            }
                        }
                    ]
                    """
        
        testAddDomain(json: jsonString, domain: domain, expectedResult: result, overlimit: true)
    }

    func testRemoveWhitelistDomain() {

        let jsonString =
            """
            [
                {
                    "trigger": {
                        "url-filter": "^[htpsw]+:\\\\/\\\\/",
                        "if-domain": [
                            "*google.com"
                        ]
                    },
                    "action": {
                        "type": "ignore-previous-rules"
                    }
                }
            ]
            """

        let domain = "google.com"
        let expectedResult =
            """
            []
            """
        
        testRemoveDomain(json: jsonString, domain: domain, expectedResult: expectedResult)
    }
    
    func testAddInvertedToEmpty() {
        
        let source = "[]"
        let domain = "google.com"
        
        let result =
        """
        [
            {
                "trigger": {
                    "url-filter": "^[htpsw]+:\\\\/\\\\/",
                    "unless-domain": [
                        "*google.com"
                    ]
                },
                "action": {
                    "type": "ignore-previous-rules"
                }
            }
        ]
        """
        
        testAddInvertedDomain(json: source, domain: domain, expectedResult: result)
    }
    
    func testAddInvertedToFilled() {
        
        let source =
        """
        [
            {
                "trigger": {
                    "url-filter": "^[htpsw]+:\\\\/\\\\/",
                    "unless-domain": [
                        "*google.com"
                    ]
                },
                "action": {
                    "type": "ignore-previous-rules"
                }
            }
        ]
        """
        
        let domain = "apple.com"
        
        let result =
        """
        [
            {
                "trigger": {
                    "url-filter": "^[htpsw]+:\\\\/\\\\/",
                    "unless-domain": [
                        "*google.com",
                        "*apple.com"
                    ]
                },
                "action": {
                    "type": "ignore-previous-rules"
                }
            }
        ]
        """
        
        testAddInvertedDomain(json: source, domain: domain, expectedResult: result)
    }
    
    func testAddInvertedToExistedEmptyRule() {
        let source =
        """
        [
            {
                "trigger": {
                    "url-filter": "^[htpsw]+:\\\\/\\\\/",
                },
                "action": {
                    "type": "ignore-previous-rules"
                }
            }
        ]
        """
        
        let domain = "apple.com"
        
        let result =
        """
        [
            {
                "trigger": {
                    "url-filter": "^[htpsw]+:\\\\/\\\\/",
                    "unless-domain": [
                        "*apple.com"
                    ]
                },
                "action": {
                    "type": "ignore-previous-rules"
                }
            }
        ]
        """
        
        testAddInvertedDomain(json: source, domain: domain, expectedResult: result)
    }
    
    func testRemoveInverted() {
        
        let source =
        """
        [
            {
                "trigger": {
                    "url-filter": "^[htpsw]+:\\\\/\\\\/",
                    "unless-domain": [
                        "*google.com"
                    ]
                },
                "action": {
                    "type": "ignore-previous-rules"
                }
            }
        ]
        """
        
        let domain = "google.com"
        
        let result =
        """
        [
            {
                "trigger": {
                    "url-filter": "^[htpsw]+:\\\\/\\\\/"
                },
                "action": {
                    "type": "ignore-previous-rules"
                }
            }
        ]
        """
        
        testRemoveInvertedDomain(json: source, domain: domain, expectedResult: result)
    }
    
    func testRemoveInvertedDomain(json: String, domain: String, expectedResult: String) {
        let jsonData = json.data(using: .utf8)
        
        let (resultData, error) = processor.removeInvertedWhitelistDomain(domain: domain, jsonData: jsonData!)
        
        XCTAssertNil(error)
        
        let obj = try? JSONSerialization.jsonObject(with: resultData!, options: [])
        let expectedObj = try? JSONSerialization.jsonObject(with: expectedResult.data(using: .utf8)!, options: [])
        
        let data = try? NotEcapingJsonSerialization.data(withJSONObject: obj!, options: [])
        let expectedData = try? NotEcapingJsonSerialization.data(withJSONObject: expectedObj!, options: [])
        
        
        XCTAssertEqual(data, expectedData)
    }
    
    
    func testAddInvertedDomain(json: String, domain: String, expectedResult: String, overlimit: Bool = false) {
        let jsonData = json.data(using: .utf8)
        
        let (resultData, error) = processor.addDomainToInvertedWhitelist(domain: domain, jsonData: jsonData!, overlimit: overlimit)
        
        XCTAssertNil(error)
        
        let obj = try? JSONSerialization.jsonObject(with: resultData!, options: [])
        let expectedObj = try? JSONSerialization.jsonObject(with: expectedResult.data(using: .utf8)!, options: [])
        
        let data = try? NotEcapingJsonSerialization.data(withJSONObject: obj!, options: [])
        let expectedData = try? NotEcapingJsonSerialization.data(withJSONObject: expectedObj!, options: [])
        
        
        XCTAssertEqual(data, expectedData)
    }
    
    func testAddDomain(json: String, domain: String, expectedResult: String, overlimit: Bool = false) {
        
        let jsonData = json.data(using: .utf8)
        
        let (resultData, error) = processor.addDomainToWhitelist(domain: domain, enabled: true, jsonData: jsonData!, overlimit: overlimit)
        
        XCTAssertNil(error)
        
        let obj = try? JSONSerialization.jsonObject(with: resultData!, options: [])
        let expectedObj = try? JSONSerialization.jsonObject(with: expectedResult.data(using: .utf8)!, options: [])
        
        let data = try? NotEcapingJsonSerialization.data(withJSONObject: obj!, options: [])
        let expectedData = try? NotEcapingJsonSerialization.data(withJSONObject: expectedObj!, options: [])
        
        
        XCTAssertEqual(data, expectedData)
    }
    
    func testRemoveDomain(json: String, domain: String, expectedResult: String) {
        
        let jsonData = json.data(using: .utf8)
        
        let (resultData, error) = processor.removeWhitelistDomain(domain: domain, jsonData: jsonData!)
        
        XCTAssertNil(error)
        
        let obj = try? JSONSerialization.jsonObject(with: resultData!, options: [])
        let expectedObj = try? JSONSerialization.jsonObject(with: expectedResult.data(using: .utf8)!, options: [])
        
        let data = try? NotEcapingJsonSerialization.data(withJSONObject: obj!, options: [])
        let expectedData = try? NotEcapingJsonSerialization.data(withJSONObject: expectedObj!, options: [])
        
        
        XCTAssertEqual(data, expectedData)
    }
}
