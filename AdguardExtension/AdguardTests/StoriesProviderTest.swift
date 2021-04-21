import XCTest

class StoriesProviderTest: XCTestCase {
    
    func testStoriesAreDecodedCorrectly() {
        let stories = StoriesProvider.stories
        XCTAssertEqual(stories.count, 6)
        
        XCTAssertEqual(stories[0].category.type, .whatsNew)
        XCTAssertEqual(stories[0].storyTokens.count, 2)
        XCTAssertNotNil(stories[0].storyTokens[1].buttonConfig)
        
        XCTAssertEqual(stories[1].category.type, .dnsProtection)
        XCTAssertEqual(stories[1].storyTokens.count, 6)
        XCTAssertNotNil(stories[1].storyTokens[5].buttonConfig)
        
        XCTAssertEqual(stories[2].category.type, .vpnProtection)
        XCTAssertEqual(stories[2].storyTokens.count, 5)
        XCTAssertNotNil(stories[2].storyTokens[0].buttonConfig)
        XCTAssertNotNil(stories[2].storyTokens[4].buttonConfig)
        
        XCTAssertEqual(stories[3].category.type, .safariProtection)
        XCTAssertEqual(stories[3].storyTokens.count, 3)
        XCTAssertNotNil(stories[3].storyTokens[2].buttonConfig)
        
        XCTAssertEqual(stories[4].category.type, .youtubeAds)
        XCTAssertEqual(stories[4].storyTokens.count, 3)
        XCTAssertNotNil(stories[4].storyTokens[2].buttonConfig)
        
        XCTAssertEqual(stories[5].category.type, .dnsServers)
        XCTAssertEqual(stories[5].storyTokens.count, 8)
        XCTAssertNotNil(stories[5].storyTokens[4].buttonConfig)
        XCTAssertNotNil(stories[5].storyTokens[5].buttonConfig)
        XCTAssertNotNil(stories[5].storyTokens[6].buttonConfig)
        XCTAssertNotNil(stories[5].storyTokens[7].buttonConfig)
    }
    
    func testStoryCategoriesAreNotMissing() {
        let pathString = Bundle.main.path(forResource: "stories", ofType: "json")!
        let pathUrl = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: pathUrl)
        let json = try! JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
        
        let jsonCategories = json["categories"] as! [[String: Any]]
        XCTAssertEqual(jsonCategories.count, StoryCategory.CategoryType.allCases.count)
        XCTAssertEqual(jsonCategories.count, StoriesProvider.allCategories.count)
    }
    
    func testStoryActionsAreNotMissing() {
        let pathString = Bundle.main.path(forResource: "stories", ofType: "json")!
        let pathUrl = URL(fileURLWithPath: pathString)
        let jsonData = try! Data(contentsOf: pathUrl)
        let json = try! JSONSerialization.jsonObject(with: jsonData) as! [String: Any]
        
        let jsonActions = json["actions"] as! [String]
        XCTAssertEqual(jsonActions.count, StoryActionType.allCases.count)
        XCTAssertEqual(jsonActions.count, StoriesProvider.allActions.count)
    }
}
