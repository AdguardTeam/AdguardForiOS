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
import UIKit
import WebKit

/** UIAlertController inheritor with the same logic to be used to find out if it is top view controller */
class YoutubeAlertController : UIAlertController { }

/**
 * UIViewController with WKWebView to watch Youtube videos without ads 🎥
 *
 * - See: https://jira.adguard.com/browse/AG-11561
 *
 * FIXME Explore the mechanism that prohibits playing videos outside of the YouTube
 * FIXME: Investigate which way to load URL is the best
 */
class YoutubePlayerController : UIViewController {

    private var webView: WKWebView?
    private var videoId: String?

    private let doctype = "<!DOCTYPE html>"
    private let htmlOpenTag = "<html>"
    private let htmlCloseTag = "</html>"
    private let bodyOpenTag = "<body>"
    private let bodyCloseTag = "</body>"
    private let scriptOpenTag = "<script>"
    private let scriptCloseTag = "</script>"
    private let divDefinition = "<div id=\"player\"></div>"
    private let scriptGenerator: (String) -> String = { videoId in
        """
        var tag = document.createElement('script');
        tag.src = "https://www.youtube.com/iframe_api";
        var firstScriptTag = document.getElementsByTagName('script')[0];
        firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

        var player;
        function onYouTubeIframeAPIReady() {
            player = new YT.Player('player', {
                height: window.innerHeight,
                width: window.innerWidth,
                videoId: '\(videoId)',
                playerVars: {
                    'playsinline': 0,
                    'autoplay': 1,
                    'mute': 1,
                    'controls': 1,
                    'disablekb': 0,
                    'fs': 1,
                    'modestbranding': 1,
                    'enablejsapi': 1,
                    'rel': 0,
                    'autohide': 0,
                    'wmode': 'transparent',
                    'showinfo': 0,
                    'loop': 1,
                    'iv_load_policy': 3
                },
                events: {
                   'onReady': onPlayerReady,
                }
            });
        }

        function onPlayerReady(event) {
            event.target.playVideo()
        }
        """
    }

    convenience init(videoId: String, nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(nibName: nil, bundle: nil)
        self.videoId = videoId
    }

    func reload(videoId: String) {
        if webView == nil {
            DDLogError("WebView is not initialized")
            dismiss(animated: true)
            return
        }

        guard let url = createEmbedUrl(videoId: videoId) else {
            showAlert(withError: .badUrl, logMessage: "Failed to create URL on reloading")
            return
        }

        webView?.load(URLRequest(url: url))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTheme()
        setUpCloseButton()

        guard let youtubeVideoId = videoId else {
            showAlert(withError: .badUrl, logMessage: "URL is nil")
            return
        }

        startPlayer(videoId: youtubeVideoId)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    private func setUpCloseButton() {
        let image = UIImage(named: "cross")
        let buttonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        navigationItem.setRightBarButton(buttonItem, animated: true)
    }

    /** Starts Youtube player with given playerUrl and configures content blocking list and userscript */
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

            let configuration = self.createWebViewConfiguration(userscript: userscript, contentRulesList: list!)

            configuration.allowsInlineMediaPlayback = false
            configuration.mediaTypesRequiringUserActionForPlayback = []

            self.setUpWebView(configuration: configuration, videoId: videoId)
        }
    }

    /** Creates WKWebViewConfiguration with tuned WKUserContentController */
    private func createWebViewConfiguration(userscript: WKUserScript, contentRulesList: WKContentRuleList) -> WKWebViewConfiguration {
        let contentController = WKUserContentController()
        contentController.addUserScript(userscript)
        contentController.add(contentRulesList)

        let config = WKWebViewConfiguration()
        config.userContentController = contentController

        return config
    }

    /** Sets up WKWebView with given configuration and loads given playerUrl */
    private func setUpWebView(configuration: WKWebViewConfiguration, videoId: String) {
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // webView.loadHTMLString(createWebPage(videoId: videoId), baseURL: nil)
        guard let url = createEmbedUrl(videoId: videoId) else {
            showAlert(withError: .badUrl, logMessage: "Failed to create URL")
            return
        }
        webView.load(URLRequest(url: url))
        self.webView = webView
    }

    /** Creates embed YouTube URL */
    private func createEmbedUrl(videoId: String) -> URL? {
        let url = "https://www.youtube.com/embed/\(videoId)"
        return URL(string: url)
    }

    /** Shows alert for given error and prints logMessage to the log */
    private func showAlert(withError error: Error, logMessage: String) {
        DDLogError("(YoutubePlayerController) -> \(logMessage)")
        DispatchQueue.asyncSafeMain {
            let (title, message) = Error.getAlertTitleAndMessageIds(forError: error)
            let alert = YoutubeAlertController(title: String.localizedString(title), message: String.localizedString(message), preferredStyle: .alert)
            let okAction = UIAlertAction(title: String.localizedString("common_action_ok"), style: .default) { _ in
                alert.dismiss(animated: true)
                self.dismiss(animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    /** Reads file with given resIdentifier and type to the String */
    private func readFileToString(resIdentifier: String, type: String) -> String? {
        if let filePath = Bundle.main.path(forResource: resIdentifier, ofType: type) {
            return try? String(contentsOfFile: filePath)
        }
        return nil
    }

    @objc private func close() {
        dismiss(animated: true)
    }

    private func createWebPage(videoId: String) -> String {
        """
        \(doctype)
        \(htmlOpenTag)
        \(bodyOpenTag)
        \(divDefinition)
        \(scriptOpenTag)
        \(scriptGenerator(videoId))
        \(scriptCloseTag)
        \(bodyCloseTag)
        \(htmlCloseTag)
        """
    }



    /** Errors that may occur during user's flow */
    private enum Error {
        case badUrl
        case contentBlockingListError
        case userscriptError

        static func getAlertTitleAndMessageIds(forError error: Error) -> (String, String) {
            switch error {
            case .badUrl:
                return ("youtube_player_controller_bad_url_title", "youtube_player_controller_bad_url_message")
            case .contentBlockingListError:
                return ("youtube_player_controller_content_blocking_list_error_title", "youtube_player_controller_content_blocking_list_error_message")
            case .userscriptError:
                return ("youtube_player_controller_userscript_error_title", "youtube_player_controller_userscript_error_message")
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