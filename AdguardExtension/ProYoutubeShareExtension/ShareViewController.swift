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

import UIKit
import Social
import MobileCoreServices

/** UIViewController that handles https scheme, retrieves Youtube video ID and passes it to the main app */
class ShareViewController: UIViewController {

    private let typeText = String(kUTTypeText)
    private let typeURL = String(kUTTypeURL)

    private let appURL = "adguard-pro://watch_youtube_video?video_id="
    private let youtubeUrl = "https://youtube.com"
    private let youtubeCompressedUrl = "https://youtu.be"
    private let youtubeUrlWithWww = "https://www.youtube.com"
    private let youtubeEmbed = "/embed/"

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            finish(withError: .noUrl, logMessage: "Failed to get item provider")
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(typeText) {
            processText(from: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            processUrl(from: itemProvider)
        } else {
            finish(withError: .noUrl, logMessage: "No url or text found")
            return
        }
    }

    /** Processes itemProvider as it contains a text */
    private func processText(from itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeText, options: nil) { (item, error) in
            if let error = error {
                self.finish(withError: .itemProviderError, logMessage: error.localizedDescription)
                return
            }

            if let text = item as? String {
                do {
                    let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                    let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

                    if let firstMatch = matches.first, let range = Range(firstMatch.range, in: text) {
                        self.openMainApp(String(text[range]))
                    } else {
                        self.finish(withError: .itemProviderError, logMessage: "No matches found")
                    }
                } catch let error {
                    self.finish(withError: .itemProviderError, logMessage: error.localizedDescription)
                }
            }
        }
    }

    /** Processes itemProvider as it contains an url */
    private func processUrl(from itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeURL, options: nil) { (item, error) in
            if let error = error {
                self.finish(withError: .itemProviderError, logMessage: error.localizedDescription)
                return
            }

            if let url = item as? NSURL, let urlString = url.absoluteString {
                self.openMainApp(urlString)
            } else {
                self.finish(withError: .itemProviderError, logMessage: "Failed to handle incoming URL")
            }
        }
    }

    private func getVideoId(from url: String) -> String? {
        if url.starts(with: youtubeCompressedUrl) {
            guard let idx = url.lastIndex(of: "/") else {
                return nil
            }

            return String(youtubeCompressedUrl[idx...])
        }

        if url.starts(with: youtubeUrl) || url.starts(with: youtubeUrlWithWww) {

        }

        return nil
    }

    /** Validates urlString, converts it to adguard scheme and opens main app */
    private func openMainApp(_ urlString: String) {
        guard let urlValidationResult = validateUrl(url: urlString) else {
            finish(withError: .badUrl, logMessage: "Shared URL is not from YouTube")
            return
        }

        guard let videoId = UrlValidationResult.extractVideoId(forResult: urlValidationResult, from: urlString) else {
            finish(withError: .badUrl, logMessage: "Failed to get video ID from \(urlString)")
            return
        }

        extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: "\(self.appURL)\(videoId)") else { return }
            _ = self.openURL(url)
        })
    }

    /** Returns UrlValidationResult or nil if given url is not valid */
    private func validateUrl(url: String) -> UrlValidationResult? {
        if url.starts(with: youtubeCompressedUrl) {
            return .compressed
        }

        if url.starts(with: youtubeUrl) || url.starts(with: youtubeUrlWithWww) {
            if url.contains(youtubeEmbed) {
                return .embed
            }
            return .regular
        }

        return nil
    }

    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }

        return false
    }

    private func finish(withError error: Error, logMessage: String) {
        DDLogError("(ShareViewController) -> \(logMessage)")
        let (title, message) = Error.getAlertTitleAndMessage(for: error)
        presentSimpleAlert(title: String.localizedString(title), message: String.localizedString(message)) {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }



    /** Possible errors that may occur during sharing a link*/
    private enum Error {
        case noUrl
        case badUrl
        case itemProviderError

        static func getAlertTitleAndMessage(for error: Error) -> (String, String) {
            switch error {

            case .noUrl:
                return ("youtube_share_extension_no_url_title", "youtube_share_extension_no_url_summary")
            case .badUrl:
                return ("youtube_share_extension_bad_url_title", "youtube_share_extension_bad_url_summary")
            case .itemProviderError:
                return ("youtube_share_extension_item_provider_error_title", "youtube_share_extension_item_provider_error_summary")
            }
        }
    }

    /** Possible valid YouTube URL formats */
    private enum UrlValidationResult {
        // https://youtu.be/<video_id><?params>
        case compressed
        // https://youtube.com/embed/<video_id><?params>
        case embed
        // https://youtube.com/embed/watch?v=<video_id><?params>
        case regular

        /** Extracts video ID from given youtube URL according to given validation result */
        static func extractVideoId(forResult: UrlValidationResult, from: String) -> String? {
            switch forResult {

            case .compressed:
                fallthrough
            case .embed:
                guard let firstIdx = from.lastIndex(of: "/") else {
                    return nil
                }

                if let lastIdx = from.firstIndex(of: "?") {
                    return String(from[firstIdx...lastIdx])
                } else {
                    return String(from[firstIdx...])
                }
            case .regular:
                return URL.init(string: from)?.parseUrl().params?["v"]
            }
        }
    }
}