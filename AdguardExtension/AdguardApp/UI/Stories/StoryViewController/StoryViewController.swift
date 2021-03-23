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

final class StoryViewController: UIViewController {
    
    private var storyGroup: StoryGroup?
    
    // UI elements
    private let stackView = UIStackView()
    
    init(storyGroup: StoryGroup) {
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        setupUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - StoryViewController + Setup UI

extension StoryViewController {
    fileprivate func setupUI() {
        setupStackView()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
    }
    
    private func setupProgressView() {
        
    }
}
