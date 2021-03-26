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

final class StoriesProgressView: UIView {
    
    weak var delegate: StoriesProgressComponentViewDelegate? {
        didSet {
            components.forEach { $0.delegate = delegate }
        }
    }
    
    private let stackView = UIStackView()
    private var components: [StoriesProgressComponentView] { stackView.arrangedSubviews.map { $0 as! StoriesProgressComponentView } }
    
    private let numberOfStories: Int
    private let storyDuration: Double
    private var currentComponentIndex = 0
    
    init(numberOfStories: Int, storyDuration: Double) {
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
    
    // MARK: - Public methods
    
    func next() {
        if currentComponentIndex < numberOfStories - 1 {
            let currentComponent = components[currentComponentIndex]
            let nextComponent = components[currentComponentIndex + 1]
             
            currentComponent.setFullProgress()
            nextComponent.startFromBeginning()
            
            currentComponentIndex += 1
        }
    }
    
    func previous() {
        if currentComponentIndex > 0 {
            let currentComponent = components[currentComponentIndex]
            let previousComponent = components[currentComponentIndex - 1]
             
            currentComponent.setZeroProgress()
            previousComponent.startFromBeginning()
            
            currentComponentIndex -= 1
        }
    }
    
    func start() {
        let currentComponent = components[currentComponentIndex]
        currentComponent.startFromBeginning()
    }
    
    func pause() {
        let currentComponent = components[currentComponentIndex]
        currentComponent.pause()
    }
    
    func resume() {
        let currentComponent = components[currentComponentIndex]
        currentComponent.resume()
    }
    
    func stop() {
        let currentComponent = components[currentComponentIndex]
        currentComponent.setZeroProgress()
    }
}

// MARK: - StoriesProgressView + Setup UI

extension StoriesProgressView {
    fileprivate func setupUI() {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = isIpadTrait ? 6.0 : 3.0
        
        for _ in 1...numberOfStories {
            let componentView = StoriesProgressComponentView(animationDuration: storyDuration)
            componentView.delegate = delegate
            stackView.addArrangedSubview(componentView)
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
