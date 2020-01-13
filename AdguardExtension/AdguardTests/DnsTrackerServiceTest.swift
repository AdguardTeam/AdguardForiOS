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

class DnsTrackerServiceTest: XCTestCase {

    var trackersService: DnsTrackerService!
    
    override func setUp() {
        trackersService = DnsTrackerService()
    }
    
    let simpleJson = """
                    {
                        "timeUpdated": "2019-11-11T16:19:45.362Z",
                        "categories": {
                            "0": "audio_video_player",
                            "1": "comments",
                            "2": "customer_interaction",
                            "3": "pornvertising",
                            "4": "advertising",
                            "5": "essential",
                            "6": "site_analytics",
                            "7": "social_media",
                            "8": "misc",
                            "9": "cdn",
                            "10": "hosting",
                            "11": "unknown",
                            "12": "extensions"
                        },
                        "trackers": {
                            "google": {
                                "name": "Google",
                                "categoryId": 4,
                                "url": "https://www.google.com/",
                                "company": "Google"
                            },
                            "google_translate": {
                                "name": "Google Translate",
                                "categoryId": 2,
                                "url": "https://translate.google.com/manager",
                                "company": "Google"
                            }
                        },
                        "trackerDomains": {
                            "google.com": "google",
                            "translate.google.com": "google_translate"
                        }
                    }
                """
    
    func testSimpleTracker() {
        setupTrackersJson(json: simpleJson)
        let info = trackersService.getTrackerInfo(by: "google.com")
        XCTAssertNotNil(info)
        XCTAssertEqual(info?.categoryKey, "advertising")
    }
    
    func testSubdomain() {
        setupTrackersJson(json: simpleJson)
        let info = trackersService.getTrackerInfo(by: "www.google.com")
        XCTAssertNotNil(info)
    }
    
    func testNotFound() {
        setupTrackersJson(json: simpleJson)
        let info = trackersService.getTrackerInfo(by: "apple.com")
        XCTAssertNil(info)
    }
    
    func testSubdomainCategory() {
        setupTrackersJson(json: simpleJson)
        let info = trackersService.getTrackerInfo(by: "translate.google.com")
        XCTAssertNotNil(info)
        XCTAssertEqual(info?.categoryKey, "customer_interaction")
    }
    
    func testSubdomainCategory2() {
        setupTrackersJson(json: simpleJson)
        let info = trackersService.getTrackerInfo(by: "subdomain.translate.google.com")
        XCTAssertNotNil(info)
        XCTAssertEqual(info?.categoryKey, "customer_interaction")
    }
    
    func setupTrackersJson(json: String) {
        guard let data = json.data(using: .utf8) else {
            XCTFail()
            return
        }
        do {
            try trackersService.decodeTrackers(data: data)
        }
        catch {
            XCTFail()
        }
    }
}
