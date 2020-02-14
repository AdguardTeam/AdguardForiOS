//
//  RateAppController.swift
//  Adguard
//
//  Created by Илья Ковальчук on 14.02.2020.
//  Copyright © 2020 Performiks. All rights reserved.
//

import UIKit

class RateAppController: UIViewController {

    @IBOutlet weak var rateAppView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var verticalSeparatorView: UIView!
    @IBOutlet weak var titleLabel: ThemableLabel!
    @IBOutlet weak var messageLabel: ThemableLabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet var stars: [UIButton]!
    
    private let theme: ThemeServiceProtocol = ServiceLocator.shared.getService()!
    private var themeToken: NotificationToken?
    
    private let rateAppService: RateAppServiceProtocol = ServiceLocator.shared.getService()!
    
    private var selectedStar: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTheme()
        setupRateApp()
        
        themeToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {[weak self] in
            self?.changeBackgroungOnShow()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.backgroundColor = .clear
    }

    @IBAction func starTapped(_ sender: UIButton) {
        let tag = sender.tag
        selectedStar = tag + 1
        
        for star in stars {
            star.isSelected = star.tag <= tag
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        if let selectedStar = selectedStar {
            rateAppService.rateApp(selectedStar)
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func updateTheme() {
        rateAppView.backgroundColor = theme.popupBackgroundColor
        separatorView.backgroundColor = theme.separatorColor
        verticalSeparatorView.backgroundColor = theme.separatorColor
        cancelButton.backgroundColor = theme.popupBackgroundColor
        submitButton.backgroundColor = theme.popupBackgroundColor
        theme.setupLabel(titleLabel)
        theme.setupLabel(messageLabel)
    }
    
    private func setupRateApp(){
        rateAppView.layer.cornerRadius = 15.0
        rateAppView.clipsToBounds = true
    }
    
    private func changeBackgroungOnShow(){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {[weak self] in
                guard let self = self else { return }
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            }
        }
    }
}
