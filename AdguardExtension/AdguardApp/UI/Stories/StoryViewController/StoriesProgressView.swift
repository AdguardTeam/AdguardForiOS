/**
    This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
    Copyright © Adguard Software Limited. All rights reserved.

    Adguard for iOS is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Adguard for iOS is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit

class StoriesProgressView: UIView {
    
    private let numberOfStories: Int
    private let storyDuration: Float
    private var currentSegment = 0
    
    
    init(numberOfStories: Int, storyDuration: Float) {
        self.numberOfStories = numberOfStories
        self.storyDuration = storyDuration
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        self.numberOfStories = 0
        self.storyDuration = 0.0
        super.init(coder: coder)
        setupUI()
    }
    
    func next() {
        
    }
    
    func previous() {
        
    }
    
    func start() {
        
    }
    
    func stop() {
        
    }
}

// MARK: - StoriesProgressView + Setup UI

extension StoriesProgressView {
    fileprivate func setupUI() {
        backgroundColor = .red
    }
}
