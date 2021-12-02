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

/// This view is responsible for displaying multiple premium features
final class PremiumFeaturesPagingView: UIView {

    // MARK: - Public properties

    var models: [PremiumFeatureViewModel] = [] {
        didSet {
            processModels()
        }
    }

    // MARK: - Private properties

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var pageControl: AGPageControl = {
        let pageControl = AGPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.clipsToBounds = true
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        return pageControl
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()

    private var sharedConstraints: [NSLayoutConstraint] = []
    private var iPhoneConstraints: [NSLayoutConstraint] = []
    private var iPadConstraints: [NSLayoutConstraint] = []

    private let themeService: ThemeServiceProtocol = ServiceLocator.shared.getService()!

    // MARK: - Public methods

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard
            previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass ||
            previousTraitCollection?.horizontalSizeClass != traitCollection.horizontalSizeClass
        else {
            return
        }

        layout(for: traitCollection)
        setBackgroundColor()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        scrollToSelectedPage(withAnimation: false)
    }

    func updateTheme() {
        setBackgroundColor()
        horizontalStackView.arrangedSubviews.forEach {
            if let view = $0 as? PremiumFeatureView {
                view.updateTheme(themeService)
            }
        }
        pageControl.updateTheme(themeService)
    }

    // MARK: - Private methods

    private func initialize() {
        addSubview(scrollView)
        scrollView.addSubview(horizontalStackView)
        addSubview(pageControl)
        bringSubviewToFront(pageControl)

        initializeConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layout(for: traitCollection)
    }

    private func initializeConstraints() {
        sharedConstraints = [
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            horizontalStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),

            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]

        iPhoneConstraints = [
            pageControl.heightAnchor.constraint(equalToConstant: 10.0),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20.0)
        ]

        iPadConstraints = [
            pageControl.heightAnchor.constraint(equalToConstant: 16.0),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24.0)
        ]
    }

    private func layout(for traitCollection: UITraitCollection) {
        if traitCollection.isIpadTraitCollection {
            NSLayoutConstraint.deactivate(iPhoneConstraints)
            NSLayoutConstraint.activate(iPadConstraints)
        } else {
            NSLayoutConstraint.deactivate(iPadConstraints)
            NSLayoutConstraint.activate(iPhoneConstraints)
        }
    }

    private func processModels() {
        horizontalStackView.arrangedSubviews.forEach { horizontalStackView.removeArrangedSubview($0) }
        models.forEach {
            let view = PremiumFeatureView()
            view.model = $0
            horizontalStackView.addArrangedSubview(view)
        }
        pageControl.numberOfPages = models.count
        horizontalStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: CGFloat(horizontalStackView.arrangedSubviews.count)).isActive = true
    }

    private func scrollToSelectedPage(withAnimation: Bool = true) {
        let page = CGFloat(pageControl.currentPage)

        if withAnimation {
            UIView.animate(withDuration: 0.15) {
                self.scrollView.contentOffset.x = self.scrollView.frame.width * page
            }
        } else {
            self.scrollView.contentOffset.x = self.scrollView.frame.width * page
        }
    }

    @objc final private func pageControlValueChanged() {
        scrollToSelectedPage()
    }

    private func setBackgroundColor() {
        if traitCollection.isIpadTraitCollection {
            backgroundColor = themeService.backgroundColor
        } else {
            backgroundColor = themeService.getLicensePageTraitSpecificColor(traitCollection.isIpadTraitCollection)
        }
    }
}

extension PremiumFeaturesPagingView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        let width = scrollView.bounds.width
        let page = Int(contentOffset / width)
        pageControl.currentPage = page
    }
}
