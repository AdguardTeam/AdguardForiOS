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

/// The result of processing shared YouTube link
struct YouTubeShareLinkResult {

    let sharingLinkError: SharingLinkError?
    let validationResult: UrlValidationResult?
    let videoId: String?
    let messageForLog: String

    init(videoId: String, validationResult: UrlValidationResult, messageForLog: String) {
        self.sharingLinkError = nil
        self.validationResult = validationResult
        self.videoId = videoId
        self.messageForLog = messageForLog
    }

    init(sharingLinkError: SharingLinkError, messageForLog: String) {
        self.sharingLinkError = sharingLinkError
        self.messageForLog = messageForLog
        self.videoId = nil
        self.validationResult = nil
    }

    // Possible errors that may occur during sharing a link
    enum SharingLinkError : Error {
        case noUrl
        case badUrl
        case itemProviderError

        var alertTitle: String {
            switch self {
            case .noUrl:                return String.localizedString("youtube_share_extension_no_url_title")
            case .badUrl:               return String.localizedString("youtube_share_extension_bad_url_title")
            case .itemProviderError:    return String.localizedString("youtube_share_extension_item_provider_error_title")
            }
        }

        var alertMessage: String {
            switch self {
            case .noUrl:                return String.localizedString("youtube_share_extension_no_url_summary")
            case .badUrl:               return String.localizedString("youtube_share_extension_bad_url_summary")
            case .itemProviderError:    return String.localizedString("youtube_share_extension_item_provider_error_summary")
            }
        }
    }

    // Possible valid YouTube URL formats
    enum UrlValidationResult {
        // https://youtu.be/<video_id><?params>
        case compressed
        // https://youtube.com/embed/<video_id><?params>
        case embed
        // https://youtube.com/embed/watch?v=<video_id><?params>
        case regular

        // Extracts video ID from given youtube URL according to given validation result
        func extractVideoId(from: String) -> String? {
            switch self {

            case .compressed, .embed:
                guard let firstIdx = from.lastIndex(of: "/") else { return nil }

                if let lastIdx = from.firstIndex(of: "?") {
                    return String(from[firstIdx...lastIdx])
                } else {
                    return String(from[firstIdx...])
                }
            case .regular:
                return URL(string: from)?.parseUrl().params?["v"]
            }
        }
    }
}