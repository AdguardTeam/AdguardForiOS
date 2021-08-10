import XCTest

class ExtendedFiltersMetaLocalizationsTest: XCTestCase {
    func testExtendedFiltersMetaIsDecodedProperly() {
        let jsonUrl = Bundle(for: type(of: self)).url(forResource: "filters_i18n_test", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonUrl)
        
        do {
            let decoder = JSONDecoder()
            let extendedFiltersMetaLocalizations = try decoder.decode(ExtendedFiltersMetaLocalizations.self, from: jsonData)
            
            // Tags number differs from filters_test.json because localizations for some tags are missing
            XCTAssertEqual(extendedFiltersMetaLocalizations.tags.count, 60)
            XCTAssertEqual(extendedFiltersMetaLocalizations.groups.count, 7)
            /*
             filters_test.json contains 81 filter, however there are 82 localizations for filters in filters_i18n_test.json
             filters_i18n_test.json contains localization for filter with id=17, but there is no filter with id=17 in filters_test.json
             */
            XCTAssertEqual(extendedFiltersMetaLocalizations.filters.count, 82)
        }
        catch {
            XCTFail(error.localizedDescription)
        }
    }
}
