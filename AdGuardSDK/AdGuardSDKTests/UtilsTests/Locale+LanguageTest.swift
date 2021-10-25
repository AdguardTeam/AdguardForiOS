import XCTest

class Locale_LanguageTest: XCTestCase {

    func testIdentifierLanguageCode() {
        let locale = Locale(identifier: "pt")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertNil(locale.scriptCode)
        XCTAssertNil(locale.variantCode)
        XCTAssertNil(locale.regionCode)

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first!, "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first!, "pt")
    }

    func testIdentifierLanguageCode_RegionCode() {
        let locale = Locale(identifier: "pt_RU")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertNil(locale.scriptCode)
        XCTAssertNil(locale.variantCode)
        XCTAssertEqual(locale.regionCode, "RU")

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_RU")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-RU")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierLanguageCode_VariantCode_VarianCode() {
        let locale = Locale(identifier: "pt-RU_RU")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertNil(locale.scriptCode)
        XCTAssertNil(locale.variantCode)
        XCTAssertEqual(locale.regionCode, "RU")

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_RU")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-RU")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierLanguageCode_VariantCode_RegionCode() {
        let locale = Locale(identifier: "pt-BR_RU")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertNil(locale.scriptCode)
        XCTAssertEqual(locale.variantCode, "RU")
        XCTAssertEqual(locale.regionCode, "BR")

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_BR")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-BR")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierLanguageCode_ScriptCode_SimplifiedChenese() {
        let locale = Locale(identifier: "pt-Hans")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertEqual(locale.scriptCode, "Hans")
        XCTAssertNil(locale.variantCode)
        XCTAssertNil(locale.regionCode)

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_CN")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-CN")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierLanguageCode_ScriptCode_TraditionalChenese() {
        let locale = Locale(identifier: "pt-Hant")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertEqual(locale.scriptCode, "Hant")
        XCTAssertNil(locale.variantCode)
        XCTAssertNil(locale.regionCode)

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_TW")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-TW")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierLanguageCode_WrongScriptCode() {
        let locale = Locale(identifier: "pt-Some")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertEqual(locale.scriptCode, "Some")
        XCTAssertNil(locale.variantCode)
        XCTAssertNil(locale.regionCode)

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], "pt")
    }

    func testIdentifierLanguageCode_WrongDigitScriptCode() {
        let locale = Locale(identifier: "pt-1234")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertNil(locale.scriptCode)
        XCTAssertEqual(locale.variantCode, "1234")
        XCTAssertNil(locale.regionCode)

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_US")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-US")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierLanguageCode_ScriptCode_RegionCode() {
        let locale = Locale(identifier: "pt-Hans_RU")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertEqual(locale.scriptCode, "Hans")
        XCTAssertNil(locale.variantCode)
        XCTAssertEqual(locale.regionCode, "RU")

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_CN")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-CN")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierLanguageCode_ScriptCode_AlternativeRegionCode() {
        let locale = Locale(identifier: "pt-Hans-RU")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertEqual(locale.scriptCode, "Hans")
        XCTAssertNil(locale.variantCode)
        XCTAssertEqual(locale.regionCode, "RU")

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_CN")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-CN")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierLanguageCode_ScriptCode_VariantCode_RegionCode() {
        let locale = Locale(identifier: "pt-Hans-HK_RU")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertEqual(locale.scriptCode, "Hans")
        XCTAssertEqual(locale.variantCode, "RU")
        XCTAssertEqual(locale.regionCode, "HK")

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], "pt_CN")
        XCTAssertEqual(result[1], "pt_HK")
        XCTAssertEqual(result[2], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], "pt-CN")
        XCTAssertEqual(result[1], "pt-HK")
        XCTAssertEqual(result[2], "pt")
    }

    func testIdentifierLanguageCode_ScriptCode_VariantCode_VariantCode() {
        let locale = Locale(identifier: "pt-Hans-HK_HK")

        XCTAssertEqual(locale.languageCode, "pt")
        XCTAssertEqual(locale.scriptCode, "Hans")
        XCTAssertNil(locale.variantCode)
        XCTAssertEqual(locale.regionCode, "HK")

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt_CN")
        XCTAssertEqual(result[1], "pt")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], "pt-CN")
        XCTAssertEqual(result[1], "pt")
    }

    func testIdentifierEmpty() {
        let locale = Locale(identifier: "")

        XCTAssertNil(locale.languageCode)
        XCTAssertNil(locale.scriptCode)
        XCTAssertNil(locale.variantCode)
        XCTAssertNil(locale.regionCode)

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], "en")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], "en")
    }

    func testIdentifierWrongID() {
        let locale = Locale(identifier: "123foo")

        XCTAssertEqual(locale.languageCode, "123foo")
        XCTAssertNil(locale.scriptCode)
        XCTAssertNil(locale.variantCode)
        XCTAssertNil(locale.regionCode)

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], "123foo")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], "123foo")
    }

    func testIdentifierSpaceID() {
        let locale = Locale(identifier: "    ")

        XCTAssertEqual(locale.languageCode, "    ")
        XCTAssertNil(locale.scriptCode)
        XCTAssertNil(locale.variantCode)
        XCTAssertNil(locale.regionCode)

        var result = locale.getSuitableLanguages(delimiter: .underScore)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], "    ")

        result = locale.getSuitableLanguages(delimiter: .dash)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], "    ")
    }
}
