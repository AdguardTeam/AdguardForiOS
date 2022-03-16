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
import SharedAdGuardSDK

private let LOG = LoggerFactory.getLoggerWrapper(YouTubeAdsRequestHandler.self)

/// Handler that can process 2 cases:
/// - The YouTube link has been shared from the browser
/// In this case we should run userscript on the given page
/// - The YouTube link has been shared from another place (e.g. YouTube app)
/// In this case we should start in-app youtube player
class YouTubeAdsRequestHandler : UINavigationController {

    private lazy var notifications: UserNotificationServiceProtocol = { UserNotificationService() }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar to avoid UI flickering
        setNavigationBarHidden(true, animated: false)

        let resources = AESharedResources()

        // Init Logger
//        ACLLogger.singleton()?.initLogger(resources.sharedAppLogsURL())

        let logManager = LoggerManagerImpl(url: resources.sharedLogsURL())
        let isDebugLogs = resources.isDebugLogs
        let logLevel: LogLevel = isDebugLogs ? .debug : .info
        logManager.configure(logLevel)
        LOG.info("Start with log level: \(isDebugLogs ? "DEBUG" : "Normal")")

//        ACLLogger.singleton()?.logLevel = isDebugLogs ? ACLLDebugLevel : ACLLDefaultLevel
    }

    override func beginRequest(with context: NSExtensionContext) {
        super.beginRequest(with: context)

        extensionContext?.handleInputItem({ [weak self] jsResult in
            if let result = jsResult {
                self?.notifications.postNotificationWithoutBadge(title: nil, body: result.status.title, onNotificationSent: {
                    LOG.info("js finished with result: \(result)")
                    self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                })
            } else {
                LOG.info("js finished, result is nil")
                self?.extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
            }
        }) { [weak self] youTubeShareLinkResult in
            LOG.info("Result of youtube app share link handling: \(youTubeShareLinkResult.messageForLog)")
            guard let videoId = youTubeShareLinkResult.videoId else {
                self?.finish(withError: youTubeShareLinkResult.sharingLinkError)
                return
            }

            DispatchQueue.main.async {
                let playerController = YoutubePlayerController(videoId: videoId)
                self?.viewControllers.append(playerController)
            }
        } ?? LOG.info("Failed to access extensionContext")
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
                LOG.error("Error: \(error)")
                onJsExecuted(nil)
                return
            }

            guard let jsResultDict = results as? [String: Any] else {
                LOG.error("Error - result dict incorrect. Results: \(results.debugDescription )")
                onJsExecuted(nil)
                return
            }

            guard let youTubeAdsJsResultDict = jsResultDict[NSExtensionJavaScriptPreprocessingResultsKey] as? [String: Any] else {
                LOG.error("Error - can not get NSExtensionJavaScriptPreprocessingResultsKey. Results: \(results.debugDescription )")
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
