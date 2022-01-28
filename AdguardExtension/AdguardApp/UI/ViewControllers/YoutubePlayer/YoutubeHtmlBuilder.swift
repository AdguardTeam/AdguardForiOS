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


/// A simple builder to create an html page with configured YouTube player.
/// See: [API doc](https://developers.google.com/youtube/iframe_api_reference)
/// See: [Player params](https://developers.google.com/youtube/player_parameters)
class YoutubeHtmlBuilder {

    // MARK: - Properties

    private let videoId: String
    private var params = [String: String]()

    // MARK: - Private constants

    private static let doctype = "<!DOCTYPE html>"
    private static let htmlOpenTag = "<html>"
    private static let htmlCloseTag = "</html>"
    private static let bodyOpenTag = "<body>"
    private static let bodyCloseTag = "</body>"
    private static let scriptOpenTag = "<script>"
    private static let scriptCloseTag = "</script>"
    private static let divDefinition = "<div id=\"player\"></div>"
    private static let scriptGenerator: (String, [String: String]) -> String = { (videoId: String, params: [String: String]) in
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
                    'autoplay': \(params["autoplay"] ?? "1"),
                    'controls': \(params["controls"] ?? "1"),
                    'fs': \(params["fs"] ?? "1"),
                    'enablejsapi': \(params["enablejsapi"] ?? "1"),
                    'rel': \(params["rel"] ?? "0"),
                    'loop': \(params["loop"] ?? "0"),
                    'disablekb': 1,
                    'modestbranding': 1,
                    'autohide': 0,
                    'wmode': 'transparent',
                    'showinfo': 0,
                    'playsinline': 1,
                    'iv_load_policy': 3
                },
                events: {
                   'onReady': onPlayerReady,
                }
            });
        }

        function onPlayerReady(event) {
            player.playVideo();
        }
        """
    }

    // MARK: - Initializers

    init(videoId: String) {
        self.videoId = videoId
    }

    // MARK: - Public functions

    func setAutoPlay(enabled: Bool) -> YoutubeHtmlBuilder {
        params["autoplay"] = enabled ? "1" : "0"
        return self
    }

    func setControls(enabled: Bool) -> YoutubeHtmlBuilder {
        params["controls"] = enabled ? "1" : "0"
        return self
    }

    func setFullScreen(enabled: Bool) -> YoutubeHtmlBuilder {
        params["fs"] = enabled ? "1" : "0"
        return self
    }

    func setJsApi(enabled: Bool) -> YoutubeHtmlBuilder {
        params["enablejsapi"] = enabled ? "1" : "0"
        return self
    }

    func setRelatedVideos(enabled: Bool) -> YoutubeHtmlBuilder {
        params["rel"] = enabled ? "1" : "0"
        return self
    }

    func setLoop(enabled: Bool) -> YoutubeHtmlBuilder {
        params["loop"] = enabled ? "1" : "0"
        return self
    }

    func build() -> String {
        """
        \(YoutubeHtmlBuilder.doctype)
        \(YoutubeHtmlBuilder.htmlOpenTag)
        \(YoutubeHtmlBuilder.bodyOpenTag)
        \(YoutubeHtmlBuilder.divDefinition)
        \(YoutubeHtmlBuilder.scriptOpenTag)
        \(YoutubeHtmlBuilder.scriptGenerator(videoId, params))
        \(YoutubeHtmlBuilder.scriptCloseTag)
        \(YoutubeHtmlBuilder.bodyCloseTag)
        \(YoutubeHtmlBuilder.htmlCloseTag)
        """
    }
}