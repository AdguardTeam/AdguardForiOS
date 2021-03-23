import XCTest

class StoriesProviderTest: XCTestCase {
    
    func testStoriesAreDecodedCorrectly() {
        let stories = StoriesProvider.stories
        XCTAssertEqual(stories.count, 6)
    }
}
