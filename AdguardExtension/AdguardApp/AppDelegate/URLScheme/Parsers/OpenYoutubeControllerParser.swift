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

/// IURLSchemeParametersParser that retrieves video_id from the given url and starts YoutubePlayerController
struct OpenYoutubeControllerParser : IURLSchemeParametersParser {

    private let executor: IURLSchemeExecutor
    private let videoIdParamName = "video_id"

    init(executor: IURLSchemeExecutor) {
        self.executor = executor
    }

    func parse(_ url: URL) -> Bool {
        guard let videoId = url.parseUrl().params?[videoIdParamName], !videoId.isEmpty else {
            DDLogWarn("(OpenYoutubeControllerParser) - parse; Youtube URL is empty")
            return false
        }
        DDLogInfo("(OpenYoutubeControllerParser) - parse; Opening video with ID \(videoId)")
        return executor.openYoutubePlayerController(videoId: videoId)
    }
}