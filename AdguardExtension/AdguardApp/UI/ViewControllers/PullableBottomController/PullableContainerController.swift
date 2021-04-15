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

class PullableContainerController: UIViewController {
    
    @IBOutlet weak var pullableView: UIView!
    @IBOutlet weak var pullableViewHeightConstraint: NSLayoutConstraint! {
        didSet {
            pullableViewCompactHeight = pullableViewHeightConstraint.constant
        }
    }
    
    /*
     This constraint is used to make pullable view static when screen size changes
     For example: iPad orientation change, app entering background, etc.
     */
    private lazy var topConstraint: NSLayoutConstraint = {
        return pullableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: maxSpaceToTop)
    }()
    
    // MARK: - Public properties
    
    var contentController: PullableContentController!
    var maxSpaceToTop: CGFloat = 72.0
    
    /*
     True if pullable view is in the lowest positiion
     False if pullable view is in the highest position
     Nil if pullable view is in the process of transition between states
     */
    private(set) var isCompact: Bool? = true
    
    // MARK: - Private properties
    
    /* We need this layer to quickly remove it when the device is rotated and setup new one */
    private var pullableViewLayer: CALayer?
    
    /* Used to reveal current pullable view height */
    private var heightBeforePull: CGFloat = 0.0
    
    /* Initial pullable view height. It will be taken from height constraint when it is set */
    private var pullableViewCompactHeight: CGFloat = 0.0
    
    /* Tap gesture is used to show full size view on tap */
    private var pullableViewTapGesture: UITapGestureRecognizer!
    
    /* View is used to blur background when ContentController is shown */
    private let screenCoverView = UIView()
    
    /* Tap gesture is used to hide pullable view on tap */
    private var screenCoverViewTapGesture: UITapGestureRecognizer!
    
    /* Screen cover view color when view is in the highest position */
    private let coverColor = UIColor.black.withAlphaComponent(0.5)
    
    // MARK: - UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPullableView()
        setupScreenCoverView()
        addTapGestureRecognizerToPullableView()
        addPanGestureRecognizerToPullableView()
        addTapGestureRecognizerToScreenCoverView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupPullableViewLayer()
    }
}

// MARK: - PullableContainerController + Setup pullable view

extension PullableContainerController {
    
    /* Pullable view initial setup */
    private func setupPullableView() {
        addChild(contentController)
        
        let viewForPullableView = contentController.view!
        viewForPullableView.translatesAutoresizingMaskIntoConstraints = false
        pullableView.addSubview(viewForPullableView)
        view.bringSubviewToFront(pullableView)
        
        viewForPullableView.leadingAnchor.constraint(equalTo: pullableView.leadingAnchor).isActive = true
        viewForPullableView.trailingAnchor.constraint(equalTo: pullableView.trailingAnchor).isActive = true
        viewForPullableView.topAnchor.constraint(equalTo: pullableView.topAnchor).isActive = true
        viewForPullableView.bottomAnchor.constraint(equalTo: pullableView.bottomAnchor).isActive = true
        
        let corners: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        let radius: CGFloat = 24.0
        viewForPullableView.layer.cornerRadius = radius
        viewForPullableView.layer.maskedCorners = corners
    }
    
    /* Applying layer on pullable view (rounding corners, shadows) */
    private func setupPullableViewLayer() {
        pullableViewLayer?.removeFromSuperlayer()
        let shadowColor = UIColor.black.cgColor
        
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: pullableView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 24.0, height: 24.0)).cgPath
        shadowLayer.shadowColor = shadowColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: -5.0)
        shadowLayer.shadowRadius = 4
        shadowLayer.shadowOpacity = 0.1
        
        pullableView.layer.insertSublayer(shadowLayer, at: 0)
        pullableViewLayer = shadowLayer
    }

    /* Calculates maximum height of pullable view */
    private func calculateMaxPullableViewHeight() -> CGFloat {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        return height - maxSpaceToTop
    }
}

// MARK: - PullableContainerController + Setup gesture recognizers

extension PullableContainerController {
    
    /* Adds pan gesture recognizer to pullable view */
    private func addPanGestureRecognizerToPullableView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(processPanGesture(_:)))
        panGesture.delegate = self
        pullableView.addGestureRecognizer(panGesture)
    }
    
    /* Adds tap gesture recognizer to pullable view */
    private func addTapGestureRecognizerToPullableView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(processPullableViewTapGesture))
        pullableViewTapGesture = tapGesture
        pullableView.addGestureRecognizer(tapGesture)
    }
    
    /* Adds tap gesture recognizer to screen cover view */
    private func addTapGestureRecognizerToScreenCoverView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(processScreenCoverViewTapGesture))
        screenCoverViewTapGesture = tapGesture
        screenCoverView.addGestureRecognizer(tapGesture)
    }
    
    /* When user taps on the pullable view when it is in compact state this method is called */
    @objc private func processPullableViewTapGesture() {
        showFullView()
    }
    
    /* When user taps on the screen cover view when it is in full state this method is called */
    @objc private func processScreenCoverViewTapGesture() {
        hideFullView()
    }
    
    /* When user pulls up/down the pullable view this method is called */
    @objc private func processPanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let velocity = recognizer.velocity(in: view)
        
        // Return if view is already im compact state and user swipes down
        if isCompact == true && velocity.y > 0 {
            return
        }
        
        // Return if view is already im full state and user swipes up
        if isCompact == false && velocity.y <= 0 {
            return
        }
        
        topConstraint.isActive = false
        
        // User began to pull
        if recognizer.state == .began {
            // we do not know the exact state of pullable view so it is nil
            isCompact = nil
            // saving the height before being pulled up to modify it later
            heightBeforePull = pullableViewHeightConstraint.constant
        }
        
        // Current heigth of view while user is pulling up the view
        let resultHeight = heightBeforePull - translation.y
        // Maximum height of pullable view
        let fullViewHeight = calculateMaxPullableViewHeight()
        
        // If current view height is between lowest and highest border than we can modify it
        if resultHeight >= pullableViewCompactHeight && resultHeight <= fullViewHeight {
            pullableViewHeightConstraint.constant = resultHeight
            
            if velocity.y < 0 {
                pullableView.layoutIfNeeded()
            }
            
            let ratio = resultHeight / fullViewHeight
        
            // Percent of pullable view being pulled
            let percent = ratio * 100.0
            
            // dimming cover screen
            screenCoverView.backgroundColor = coverColor.withAlphaComponent(0.5 * ratio)
            
            // Notify content view controller about percent change
            contentController.parentViewIsTransitioning(percent: percent <= 15 ? 0.0 : percent)
        }
        
        /*
         When user removes his finger from the screen we get his finger direction
         and decide to make view compact or show it in full height
         */
        if recognizer.state == .ended {
            if velocity.y > 0 {
                hideFullView()
            } else {
                showFullView()
            }
        }
    }
    
    /* Animates view transition to full height */
    private func showFullView() {
        if isCompact == false { return }
        let height = calculateMaxPullableViewHeight()
        pullableViewHeightConstraint.constant = height
        contentController.parentViewWillTransitionToFullSize()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState, .preferredFramesPerSecond60], animations: {[weak self] in
            self?.view.layoutIfNeeded()
            self?.screenCoverView.backgroundColor = self?.coverColor
        }) {[weak self] _ in
            self?.isCompact = false
            self?.pullableViewTapGesture.isEnabled = false
            self?.screenCoverViewTapGesture.isEnabled = true
            self?.screenCoverView.isUserInteractionEnabled = true
            self?.topConstraint.isActive = true
            self?.contentController.parentViewDidTransitionToFullSize()
        }
    }
    
    /* Animates view transition to compact height */
    private func hideFullView() {
        if isCompact == true { return }
        contentController.parentViewWillTransitionToCompactSize()
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.allowUserInteraction, .beginFromCurrentState, .preferredFramesPerSecond60], animations: {[weak self] in
            self?.pullableViewHeightConstraint.constant = self?.pullableViewCompactHeight ?? 100.0
            self?.topConstraint.isActive = false
            self?.view.layoutIfNeeded()
            self?.screenCoverView.backgroundColor = .clear
        }) {[weak self] _ in
            self?.isCompact = true
            self?.pullableViewTapGesture.isEnabled = true
            self?.screenCoverViewTapGesture.isEnabled = false
            self?.screenCoverView.isUserInteractionEnabled = false
            self?.contentController.parentViewDidTransitionToCompactSize()
        }
    }
}

// MARK: - PullableContainerController + Dimming cover view

extension PullableContainerController {
    
    /* Screen cover view initial setup */
    private func setupScreenCoverView() {
        screenCoverView.backgroundColor = .clear
        screenCoverView.translatesAutoresizingMaskIntoConstraints = false
        screenCoverView.isUserInteractionEnabled = false
        view.insertSubview(screenCoverView, belowSubview: pullableView)
        
        screenCoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        screenCoverView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        screenCoverView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        screenCoverView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - PullableContainerController + UIGestureRecognizerDelegate

extension PullableContainerController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
