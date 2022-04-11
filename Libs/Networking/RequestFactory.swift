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

import Foundation

public struct RequestFactory {
    static func sendFeedbackConfig(_ feedback: FeedBackProtocol) -> RequestConfig<SuccessFailureParser> {
        return RequestConfig<SuccessFailureParser>(request: SendFeedbackRequest(feedback), parser: SuccessFailureParser())
    }

    /// Returns attribution records request config
    static func attributionRecordsConfig(_ attributionToken: String) -> RequestConfig<AdServicesAttributionRecordsParser> {

        return RequestConfig<AdServicesAttributionRecordsParser>(
            request: AdServicesAttributionRecordsRequest(attributionToken),
            parser: AdServicesAttributionRecordsParser()
        )
    }

    /// Returns remote migration request config
    static func remoteMigrationConfig(_ appId: String) -> RequestConfig<RemoteMigrationRequestParser> {
        return RequestConfig<RemoteMigrationRequestParser>(
            request: RemoteMigrationRequest(appId),
            parser: RemoteMigrationRequestParser()
        )
    }

    /// Returns in-app purchase receipt hash request config
    static func inAppPurchaseReceiptHashConfig(_ appId: String, inAppPurchaseBase64Receipt: String) -> RequestConfig<InAppPurchaseReceiptHashParser> {
        return RequestConfig<InAppPurchaseReceiptHashParser>(
            request: InAppPurchaseReceiptHashRequest(appId: appId, inAppPurchaseBase64Receipt: inAppPurchaseBase64Receipt),
            parser: InAppPurchaseReceiptHashParser())
    }
}
