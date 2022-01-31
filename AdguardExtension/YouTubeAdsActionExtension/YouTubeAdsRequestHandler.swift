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
import MobileCoreServices

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



struct YouTubeAdsJsResult {

    enum Status: String {
        case success
        case wrongDomain
        case alreadyExecuted
        case error

        var title: String {
            switch self {
            case .success: return String.localizedString("youtube_script_success_title")
            case .wrongDomain: return String.localizedString("youtube_script_wrong_domain_title")
            case .alreadyExecuted: return String.localizedString("youtube_script_already_executed_title")
            case .error: return String.localizedString("youtube_script_error_title")
            }
        }
    }

    let successfullyExecuted: Bool
    let status: Status

    init?(jsDict: [String: Any]) {
        guard let successfullyExecuted = jsDict["success"] as? Bool,
              let statusString = jsDict["status"] as? String,
              let status = Status(rawValue: statusString)
        else {
            return nil
        }

        self.successfullyExecuted = successfullyExecuted
        self.status = status
    }
}



/// Handler that can processes 2 cases:
/// - The YouTube link has been shared from the browser
/// In this case we should run userscript on the given page
/// - The YouTube link has been shared from another place (e.g. YouTube app)
/// In this case we should start in-app youtube player
class YouTubeAdsRequestHandler : UIViewController {

    // App url is different for AdGuard and AdGuardPro targets
    private let appURL: String = "\(Bundle.main.inAppScheme)://watch_youtube_video?video_id="

    private lazy var notifications: UserNotificationServiceProtocol = { UserNotificationService() }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let resources = AESharedResources()

        // Init Logger
        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())
        let isDebugLogs = resources.isDebugLogs
        DDLogInfo("(YouTubeAdsRequestHandler) Start with log level: \(isDebugLogs ? "DEBUG" : "Normal")")
        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
    }

    // It's important to perform payload in this callback:
    // - It guarantees that 'beginRequest' has been executed earlier and extensionContext has been set;
    // - It guarantees that UIResponder is not nil.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        extensionContext?.handleInputItem({ [weak self] jsResult in
            if let result = jsResult {
                self?.notifications.postNotificationWithoutBadge(title: nil, body: result.status.title, onNotificationSent: {
                    DDLogInfo("(YouTubeAdsRequestHandler) js finished with result: \(result)")
                    self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                })
            } else {
                DDLogInfo("(YouTubeAdsRequestHandler) js finished, result is nil")
                self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }) { [weak self] youTubeShareLinkResult in
            DDLogInfo("(YouTubeAdsRequestHandler) result of youtube app share link handling: \(youTubeShareLinkResult.messageForLog)")
            guard let videoId = youTubeShareLinkResult.videoId else {
                self?.finish(withError: youTubeShareLinkResult.sharingLinkError)
                return
            }

            self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
                guard let url = URL(string: "\(self?.appURL ?? "")\(videoId)") else { return }
                self?.openURL(url)
            })
        } ?? DDLogInfo("(YouTubeAdsRequestHandler) Failed to access extensionContext")
    }

    @objc private func openURL(_ url: URL) {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.perform(#selector(openURL(_:)), with: url)
            }
            responder = responder?.next
        }
    }

    private func finish(withError error: YouTubeShareLinkResult.SharingLinkError?) {
        presentSimpleAlert(
            title: error?.alertTitle ?? String.localizedString("youtube_share_extension_item_provider_unknown_error_title"),
            message: error?.alertMessage ?? String.localizedString("youtube_share_extension_item_provider_unknown_error_summary")) {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
}



fileprivate enum RequestType {
    case safari
    case application
}



fileprivate extension NSExtensionContext {
    /// Handles input item in self NSExtensionContext
    ///
    /// - Parameters:
    ///   - onJsExecuted: lambda that handles YouTubeAdsJsResult if URL has been shared from the browser
    ///   - onYouTubeShareLinkResult: lambda that handles YouTubeShareLinkResult if URL has been shared from the application
    func handleInputItem(
        _ onJsExecuted: @escaping (_ jsResult: YouTubeAdsJsResult?) -> Void,
        _ onYouTubeShareLinkResult: @escaping (_ youTubeShareLinkResult: YouTubeShareLinkResult) -> Void
    ) {
        guard let inputItem = inputItems.first as? NSExtensionItem,
              let itemProvider = inputItem.attachments?.first,
              itemProvider.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList))
              else {
            // It means that link was shared not from the browser
            handleYoutubeShareLink(onResult: onYouTubeShareLinkResult)
            return
        }

        itemProvider.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil) { results, error in

            if let error = error {
                DDLogError("(YouTubeAdsRequestHandler) Error: \(error)")
                onJsExecuted(nil)
                return
            }

            guard let jsResultDict = results as? [String: Any] else {
                DDLogError("(YouTubeAdsRequestHandler) Error - result dict incorrect. Results: \(results.debugDescription )")
                onJsExecuted(nil)
                return
            }

            guard let youTubeAdsJsResultDict = jsResultDict[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any] else {
                DDLogError("(YouTubeAdsRequestHandler) Error - can not get NSExtensionJavaScriptPreprocessingResultsKey. Results: \(results.debugDescription )")
                onJsExecuted(nil)
                return
            }

            let youTubeAdsJsResult = YouTubeAdsJsResult(jsDict: youTubeAdsJsResultDict)
            onJsExecuted(youTubeAdsJsResult)
        }
    }

    /// Handles shared link and validates it
    ///
    /// - Parameter onResult: lambda to be invoked on YouTubeShareLinkResult after handling and validation
    private func handleYoutubeShareLink(onResult: @escaping (_ youTubeShareLinkResult: YouTubeShareLinkResult) -> Void) {
        let typeText = String(kUTTypeText)
        let typeURL = String(kUTTypeURL)

        guard let extensionItem = inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            let result = YouTubeShareLinkResult(sharingLinkError: .noUrl, messageForLog: "Failed to get item provider")
            onResult(result)
            return
        }

        if itemProvider.hasItemConformingToTypeIdentifier(typeText) {
            processText(from: itemProvider, onResult: onResult)
        } else if itemProvider.hasItemConformingToTypeIdentifier(typeURL) {
            processUrl(from: itemProvider, onResult: onResult)
        } else {
            let result = YouTubeShareLinkResult(sharingLinkError: .noUrl, messageForLog: "No url or text found")
            onResult(result)
        }
    }

    // Processes itemProvider as it contains a text
    private func processText(from itemProvider: NSItemProvider, onResult: @escaping (_ youTubeShareLinkResult: YouTubeShareLinkResult) -> Void) {
        itemProvider.loadItem(forTypeIdentifier: String(kUTTypeText), options: nil) { (item, error) in
            if let error = error {
                let result = YouTubeShareLinkResult(sharingLinkError: .itemProviderError, messageForLog: error.localizedDescription)
                onResult(result)
            }

            guard let text = item as? String else { return }

            do {
                let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))

                if let firstMatch = matches.first, let range = Range(firstMatch.range, in: text) {
                    let result = self.processUrlString(String(text[range]))
                    onResult(result)
                } else {
                    let result = YouTubeShareLinkResult(sharingLinkError: .itemProviderError, messageForLog: "No matches found")
                    onResult(result)
                }
            } catch {
                let result = YouTubeShareLinkResult(sharingLinkError: .itemProviderError, messageForLog: error.localizedDescription)
                onResult(result)
            }
        }
    }

    // Processes itemProvider as it contains an url
    private func processUrl(from itemProvider: NSItemProvider, onResult: @escaping (_ youTubeShareLinkResult: YouTubeShareLinkResult) -> Void) {
        itemProvider.loadItem(forTypeIdentifier: String(kUTTypeURL), options: nil) { (item, error) in
            if let error = error {
                let result = YouTubeShareLinkResult(sharingLinkError: .itemProviderError, messageForLog: error.localizedDescription)
                onResult(result)
                return
            }

            if let url = item as? NSURL, let urlString = url.absoluteString {
                let result = self.processUrlString(urlString)
                onResult(result)
            } else {
                let result = YouTubeShareLinkResult(sharingLinkError: .itemProviderError, messageForLog: "Failed to handle incoming URL")
                onResult(result)
            }
        }
    }

    private func processUrlString(_ urlString: String) -> YouTubeShareLinkResult {
        guard let urlValidationResult = validateUrl(url: urlString) else {
            return YouTubeShareLinkResult(sharingLinkError: .badUrl, messageForLog: "Shared URL is not from YouTube")
        }

        guard let videoId = urlValidationResult.extractVideoId(from: urlString) else {
            return YouTubeShareLinkResult(sharingLinkError: .badUrl, messageForLog: "Failed to get video ID from \(urlString)")
        }

        return YouTubeShareLinkResult(videoId: videoId, validationResult: urlValidationResult, messageForLog: "Video ID has been extracted successfully")
    }

    // Returns UrlValidationResult or nil if given url is not valid
    private func validateUrl(url: String) -> YouTubeShareLinkResult.UrlValidationResult? {
        let youtubeUrl = "youtube.com"
        let youtubeCompressedUrl = "youtu.be"
        let youtubeKids = "youtubekids.com"
        let youtubeMusic = "music.youtube.com"
        let youtubeMobile = "m.youtube.com"
        let youtubeNoCookie = "youtube-nocookie.com"
        let youtubeEmbed = "/embed/"

        guard let domain: String = URL(string: url)?.domain else { return nil }

        if equalsAny(domain, [youtubeCompressedUrl]) {
            return .compressed
        }

        if equalsAny(domain, [youtubeUrl, youtubeKids, youtubeMusic, youtubeMobile, youtubeNoCookie]) {
            return url.contains(youtubeEmbed) ? .embed : .regular
        }

        return nil
    }

    private func equalsAny(_ a: String, _ b: [String]) -> Bool {
        for s in b {
            if a.compare(s, options: .caseInsensitive) == .orderedSame {
                return true
            }
        }

        return false
    }
}
