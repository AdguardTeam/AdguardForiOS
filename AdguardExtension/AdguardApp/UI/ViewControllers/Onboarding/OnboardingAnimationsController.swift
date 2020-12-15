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
import Lottie

class OnboardingAnimationsController: UIViewController {

    @IBOutlet weak var animationsScrollView: UIScrollView!
    @IBOutlet weak var textsScrollView: UIScrollView!
    
    @IBOutlet weak var firstAnimationView: AnimationView!
    @IBOutlet weak var secondAnimationView: AnimationView!
    @IBOutlet weak var thirdAnimationView: AnimationView!
    @IBOutlet weak var pageContol: UIPageControl!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    var delegate: OnboardingControllerDelegate?
    
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeToken: NotificationToken?
    private var orientationChangeNotification: NotificationToken?
    
    private var currentStep = 1
    
    private let showOnboardingControllerSegue = "ShowOnboardingController"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        setupAnimationViews()
        addGestureRecognizers()
        firstAnimationView.play()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        orientationChangeNotification = NotificationCenter.default.observe(name: UIDevice.orientationDidChangeNotification, object: nil, queue: nil, using: {[weak self] (notification) in
            DispatchQueue.main.async {
                self?.setupScrollViews()
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
        nextButton.layer.borderColor  = UIColor.AdGuardColor.green.cgColor
        nextButton.layer.borderWidth = 1.0
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return theme.statusbarStyle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? OnboardingController {
            controller.delegate = delegate
            controller.needsShowingPremium = true
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if currentStep == 3 {
            performSegue(withIdentifier: showOnboardingControllerSegue, sender: self)
            return
        }
        
        pageContol.currentPage += 1
        currentStep += 1
        
        setupScrollViews()
        
        if currentStep == 2 {
            firstAnimationView.stop()
            secondAnimationView.play()
            return
        }
        
        if currentStep == 3 {
            secondAnimationView.stop()
            thirdAnimationView.play()
            return
        }
    }
    
    private func setupAnimationViews() {
        if let firstAnimation = Animation.onboardingFirstStep {
            firstAnimationView.animation = firstAnimation
            firstAnimationView.loopMode = .loop
            firstAnimationView.backgroundBehavior = .pauseAndRestore
        }
        if let secondAnimation = Animation.onboardingSecondStep {
            secondAnimationView.animation = secondAnimation
            secondAnimationView.loopMode = .loop
            secondAnimationView.backgroundBehavior = .pauseAndRestore
        }
        if let thirdAnimation = Animation.onboardingThirdStep {
            thirdAnimationView.animation = thirdAnimation
            thirdAnimationView.loopMode = .loop
            thirdAnimationView.backgroundBehavior = .pauseAndRestore
        }
    }
    
    private func updateTheme() {
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
    }
    
    private func setupScrollViews() {
        var offset: CGFloat = 0.0
        
        if currentStep == 1 {
            offset = 0.0
        }
        else if currentStep == 2 {
            offset = secondAnimationView.frame.minX
        }
        else if currentStep == 3 {
            offset = thirdAnimationView.frame.minX
        }
        
        animationsScrollView.setContentOffset(CGPoint(x: offset, y: 0.0), animated: true)
        textsScrollView.setContentOffset(CGPoint(x: offset, y: 0.0), animated: true)
    }
    
    private func addGestureRecognizers() {
        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onRightSwipe(_:)))
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onLeftSwipe(_:)))
        
        rightSwipeRecognizer.direction = .right
        leftSwipeRecognizer.direction = .left
        
        view.addGestureRecognizer(rightSwipeRecognizer)
        view.addGestureRecognizer(leftSwipeRecognizer)
    }
    
    @objc private func onRightSwipe(_ sender: UISwipeGestureRecognizer) {
        if currentStep == 1 {
            return
        }
        
        pageContol.currentPage -= 1
        currentStep -= 1
        
        setupScrollViews()
        
        if currentStep == 2 {
            thirdAnimationView.stop()
            secondAnimationView.play()
            return
        }
        
        if currentStep == 1 {
            secondAnimationView.stop()
            firstAnimationView.play()
            return
        }
    }
    
    @objc private func onLeftSwipe(_ sender: UISwipeGestureRecognizer) {
        if currentStep == 3 {
            return
        }
        
        pageContol.currentPage += 1
        currentStep += 1
        
        setupScrollViews()
        
        if currentStep == 2 {
            firstAnimationView.stop()
            secondAnimationView.play()
            return
        }
        
        if currentStep == 3 {
            secondAnimationView.stop()
            thirdAnimationView.play()
            return
        }
    }
}
