//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import SharedAdGuardSDK

class CustomFiltersMetaParserMock: CustomFilterMetaParserProtocol {
    var invokedParse = false
    var invokedParseCount = 0
    var invokedParseParameters: (filterFileContentString: String, parserType: CustomFilterMetaParserType, filterDownloadPage: String?)?
    var invokedParseParametersList = [(filterFileContentString: String, parserType: CustomFilterMetaParserType, filterDownloadPage: String?)]()
    var stubbedParseError: Error?
    var stubbedParseResult: ExtendedCustomFilterMetaProtocol!

    func parse(_ filterFileContentString: String, for parserType: CustomFilterMetaParserType, filterDownloadPage: String?) throws -> ExtendedCustomFilterMetaProtocol {
        invokedParse = true
        invokedParseCount += 1
        invokedParseParameters = (filterFileContentString, parserType, filterDownloadPage)
        invokedParseParametersList.append((filterFileContentString, parserType, filterDownloadPage))
        if let error = stubbedParseError {
            throw error
        }
        return stubbedParseResult
    }
}

extension CustomFilterMetaParserProtocol {
    func getMetaFrom(url: URL, for parserType: CustomFilterMetaParserType) throws -> ExtendedCustomFilterMetaProtocol {
        return try parse("filterContent", for: parserType, filterDownloadPage: url.absoluteString)
    }
}
