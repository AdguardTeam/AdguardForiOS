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
import WebKit

/// UIViewController with WKWebView to watch Youtube videos without ads 🎥
/// See: [Jira task](https://jira.adguard.com/browse/AG-11561)
class YoutubePlayerController : UIViewController {

    private var webView: WKWebView!
    private var videoId: String

    init(videoId: String) {
        self.videoId = videoId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        // FIXME discuss if this should be here or anywhere else
        assertionFailure("Don`t use this init")
        return nil
    }

    func reload(videoId: String) {
        self.videoId = videoId
        webView.loadHTMLString(createHtml(videoId: videoId), baseURL: nil)
    }

    override func loadView() {
        createWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTheme()
        setUpCloseButton()

        startPlayer(videoId: videoId)
    }



    private func setUpCloseButton() {
        let image = UIImage(named: "cross")
        let buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        navigationItem.setRightBarButton(buttonItem, animated: true)
    }

    /// Starts Youtube player with given playerUrl and configures content blocking list and userscript
    private func startPlayer(videoId: String) {
        guard let userscriptSource = readFileToString(resIdentifier: "userscript", type: "js") else {
            showAlert(withError: .userscriptError, logMessage: "Failed to read userscript")
            return
        }

        let userscript = WKUserScript(source: userscriptSource, injectionTime: .atDocumentStart, forMainFrameOnly: true)
        if (userscript == nil) {
            showAlert(withError: .userscriptError, logMessage: "Userscript is not valid")
            return
        }

        guard let blockRules = readFileToString(resIdentifier: "filter", type: "json") else {
            showAlert(withError: .contentBlockingListError, logMessage: "Failed to read content blocking rules")
            return
        }

        WKContentRuleListStore.default().compileContentRuleList(
                forIdentifier: "ContentBlockingRules",
                encodedContentRuleList: blockRules) { list, error in

            if let error = error {
                self.showAlert(withError: .contentBlockingListError, logMessage: error.localizedDescription)
                return
            }

            if list == nil {
                self.showAlert(withError: .contentBlockingListError, logMessage: "Failed to convert filtering rules")
                return
            }

            self.webView.configuration.userContentController.addUserScript(userscript)
            self.webView.configuration.userContentController.add(list!)

            self.webView.loadHTMLString(self.createHtml(videoId: videoId), baseURL: nil)
        }
    }

    // Sets up WKWebView with given configuration and loads given playerUrl
    private func createWebView() {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = false
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        self.webView = webView
        view = webView
    }

    // Creates embed YouTube URL
    private func createEmbedUrl(videoId: String) -> URL? {
        let url = "https://www.youtube.com/embed/\(videoId)"
        return URL(string: url)
    }

    // Shows alert for given error and prints logMessage to the log
    private func showAlert(withError error: YouTubePlayerError, logMessage: String, fromFunction: String = #function) {
        DDLogError("(YoutubePlayerController) -> \(fromFunction); \(logMessage)")
        presentSimpleAlert(title: error.alertTitle, message: error.alertMessage) {
            self.dismiss(animated: true)
        }
    }

    // Reads file with given resIdentifier and type to the String
    private func readFileToString(resIdentifier: String, type: String) -> String? {
        if let filePath = Bundle.main.path(forResource: resIdentifier, ofType: type) {
            return try? String(contentsOfFile: filePath)
        }
        return nil
    }

    private func createHtml(videoId: String) -> String {
        YoutubeHtmlBuilder(videoId: videoId)
                .setAutoPlay(enabled: true)
                .setFullScreen(enabled: true)
                .setJsApi(enabled: true)
                .setRelatedVideos(enabled: true)
                .build()
    }

    @objc final private func close() {
        dismiss(animated: true)
    }



    /// Errors that may occur during user's flow
    private enum YouTubePlayerError : Error {
        case badUrl
        case contentBlockingListError
        case userscriptError

        var alertTitle: String {
            switch self {
            case .badUrl:                   return String.localizedString("youtube_player_controller_bad_url_title")
            case .contentBlockingListError: return String.localizedString("youtube_player_controller_content_blocking_list_error_title")
            case .userscriptError:          return String.localizedString("youtube_player_controller_userscript_error_title")
            }
        }

        var alertMessage: String {
            switch self {
            case .badUrl:                   return String.localizedString("youtube_player_controller_bad_url_message")
            case .contentBlockingListError: return String.localizedString("youtube_player_controller_content_blocking_list_error_message")
            case .userscriptError:          return String.localizedString("youtube_player_controller_userscript_error_message")
            }
        }
    }
}



extension YoutubePlayerController : ThemableProtocol {
    func updateTheme() {
        let service: ThemeServiceProtocol = ServiceLocator.shared.getService()!
        service.setupNavigationBar(navigationController?.navigationBar)
    }
}