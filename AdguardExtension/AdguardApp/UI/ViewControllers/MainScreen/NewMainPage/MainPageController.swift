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

class MainPageController: UIViewController, UIViewControllerTransitioningDelegate, DateTypeChangedProtocol, ChartPointsChangedDelegate {

    // MARK: - Nav bar elements
    
    @IBOutlet weak var adguardTitleLabel: ThemableLabel!
    @IBOutlet weak var refreshButton: UIButton!
    
    
    
    // MARK: - Protection status elements
    
    @IBOutlet weak var safariProtectionButton: UIButton!
    @IBOutlet weak var systemProtectionButton: UIButton!
    
    @IBOutlet weak var protectionStateLabel: ThemableLabel!
    @IBOutlet weak var protectionStatusLabel: ThemableLabel!
    
    
    // MARK: - Complex protection switch
    
    @IBOutlet weak var complexProtectionSwitch: ComplexProtectionSwitch!
    
    
    // MARK: - Statistics elements
    
    @IBOutlet weak var changeStatisticsDatesButton: UIButton!
    @IBOutlet weak var chartView: ChartView!
    
    
    @IBOutlet weak var statisticsStackView: UIStackView!
    
    @IBOutlet weak var requestsButton: UIButton!
    @IBOutlet weak var blockedButton: UIButton!
    
    @IBOutlet weak var requestsNumberLabel: ThemableLabel!
    @IBOutlet weak var blockedNumberLabel: ThemableLabel!
    
    @IBOutlet weak var requestsTextLabel: ThemableLabel!
    @IBOutlet weak var blockedTextLabel: ThemableLabel!
    
    
    // MARK: Get Pro elements
    
    @IBOutlet weak var getProView: UIView!
    @IBOutlet weak var adguardManImageView: UIImageView!
    @IBOutlet weak var manDialogView: UIView!
    @IBOutlet weak var manDialogText: ThemableLabel!
    @IBOutlet weak var getProButton: UIButton!
    
    
    // MARK: - Themable labels
    
    @IBOutlet var themableLabels: [ThemableLabel]!
    
    
    // MARK: - Variables
    
    // MARK: - Services
    
    private lazy var configuration: ConfigurationService = { ServiceLocator.shared.getService()! }()
    private lazy var antibanner: AESAntibannerProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()
    private lazy var resources: AESharedResourcesProtocol = { ServiceLocator.shared.getService()! }()
    
    
    // MARK: - View models
    
    private var chartModel: ChartViewModelProtocol = ChartViewModel(ServiceLocator.shared.getService()!)
    private var mainPageModel: MainPageModelProtocol?
    
    
    // MARK: - Observers
    
    private var themeNotificationToken: NotificationToken?
    private var observations: [NSKeyValueObservation] = []
    
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainPageModel = MainPageModel(antibanner: antibanner)
        
        addObservers()
    
        chooseRequest()
        
        chartModel.chartPointsChangedDelegate = self
        
        changeProtectionStatusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateTheme()
        chartModel.obtainStatistics()
        updateTextForButtons()
    }
    
    deinit {
        removeObservers()
    }
    
    
    // MARK: - Actions

    
    // MARK: - Nav Bar Actions
    
    @IBAction func updateFiltersAction(_ sender: UIButton) {
        mainPageModel?.updateFilters(start: {
            DispatchQueue.main.async { [weak self] in
                self?.updateStarted()
                self?.protectionStatusLabel.text = ACLocalizedString("update_filter_start_message", nil)
            }
        }, finish: { [weak self] (message) in
            DispatchQueue.main.async {
                self?.protectionStatusLabel.text = message
                self?.updateEnded()
            }
        }, error: { [weak self] (message) in
            DispatchQueue.main.async {
                self?.protectionStatusLabel.text = message
                self?.updateEnded()
            }
        })
    }
    
    
    // MARK: - Protection Status Actions
    
    @IBAction func changeSafariProtectionState(_ sender: UIButton) {
    }
    
    @IBAction func changeSystemProtectionState(_ sender: UIButton) {
    }
    
    
    // MARK: - Complex protection switch action
    
    @IBAction func complexProtectionState(_ sender: ComplexProtectionSwitch) {
        
    }
    
    
    // MARK: - Statistics Actions
    
    @IBAction func changeStatisticDates(_ sender: UIButton) {
        showChartDateTypeController()
    }
    
    @IBAction func requestsTapped(_ sender: UIButton) {
        chooseRequest()
    }
    
    @IBAction func blockedTapped(_ sender: UIButton) {
        chooseBlocked()
    }
    
    
    // MARK: - Get pro action
    
    @IBAction func getProAction(_ sender: UIButton) {
        
    }
    
    
    // MARK: - Observing Values from User Defaults
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        changeTextForButton(with: keyPath)
    }
    
    // MARK: - ChartPointsChangedDelegate method
    
    func chartPointsChanged(points: [Point]) {
        chartView.chartPoints = points
    }
    
    
    // MARK: - DateTypeChangedProtocol method
    
    func dateTypeChanged(dateType: ChartDateType) {
        changeDateTypeButton(dateType: dateType)
        chartModel.chartDateType = dateType
    }
    
    
    // MARK: - Presentation delegate method
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomAnimatedTransitioning()
    }
    
    
    // MARK: - Private methods
    
    /**
     Updates theme when notification is observed
     */
    private func updateTheme(){
        chartView.backgroundColor = theme.backgroundColor
        view.backgroundColor = theme.backgroundColor
        theme.setupLabels(themableLabels)
    }
    
    /**
     Presents ChartDateTypeController
     */
    private func showChartDateTypeController(){
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ChartDateTypeController") as? ChartDateTypeController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    /**
     Set title for changeStatisticsDatesButton when it is changed
     */
    private func changeDateTypeButton(dateType: ChartDateType){
        switch dateType {
        case .day:
            changeStatisticsDatesButton.setTitle(ACLocalizedString("chart_24hours", nil), for: .normal)
        case .today:
            changeStatisticsDatesButton.setTitle(ACLocalizedString("chart_date_today", nil), for: .normal)
        case .week:
            changeStatisticsDatesButton.setTitle(ACLocalizedString("chart_7days", nil), for: .normal)
        case .month:
            changeStatisticsDatesButton.setTitle(ACLocalizedString("chart_30days", nil), for: .normal)
        case .alltime:
            changeStatisticsDatesButton.setTitle(ACLocalizedString("chart_alltime", nil), for: .normal)
        }
    }
    
    /**
     Changes number of requests for specific button
     */
    private func changeTextForButton(with keyPath: String?){
        if keyPath == AEDefaultsRequests {
            let number = resources.sharedDefaults().integer(forKey: AEDefaultsRequests)
            requestsNumberLabel.text = "\(number)"
        } else if keyPath == AEDefaultsBlockedRequests {
            let number = resources.sharedDefaults().integer(forKey: AEDefaultsBlockedRequests)
            blockedNumberLabel.text = "\(number)"
        }
    }
    
    /**
    Changes number of requests for all buttons
    */
    private func updateTextForButtons(){
        let requestsNumber = resources.sharedDefaults().integer(forKey: AEDefaultsRequests)
        requestsNumberLabel.text = "\(requestsNumber)"
        
        let blockedNumber = resources.sharedDefaults().integer(forKey: AEDefaultsBlockedRequests)
        blockedNumberLabel.text = "\(blockedNumber)"
    }
    
    private func changeProtectionStatusLabel(){
        protectionStatusLabel.text = "Something is written here"
    }
    
    /**
     Called when "requests" button tapped
     */
    private func chooseRequest(){
        chartModel.chartRequestType = .requests
        
        requestsNumberLabel.alpha = 1.0
        blockedNumberLabel.alpha = 0.5
        
        requestsTextLabel.alpha = 1.0
        blockedTextLabel.alpha = 0.5
    }
    
    /**
    Called when "blocked" button tapped
    */
    private func chooseBlocked(){
        chartModel.chartRequestType = .blocked
        
        requestsNumberLabel.alpha = 0.5
        blockedNumberLabel.alpha = 1.0
        
        requestsTextLabel.alpha = 0.5
        blockedTextLabel.alpha = 1.0
    }
    
    /**
     Adds observers to controller
     */
    private func addObservers(){

        themeNotificationToken = NotificationCenter.default.observe(name: NSNotification.Name( ConfigurationService.themeChangeNotification), object: nil, queue: OperationQueue.main) {[weak self] (notification) in
            self?.updateTheme()
        }
        
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsRequests, options: .new, context: nil)
        
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsBlockedRequests, options: .new, context: nil)
        
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsCountersRequests, options: .new, context: nil)
        
        let proObservation = configuration.observe(\.proStatus) {[weak self] (_, _) in
            // Add pro observation
        }
        
        let contenBlockerObservation = configuration.observe(\.contentBlockerEnabled) {[weak self] (_, _) in
            // Add content blocker observation
        }

        observations.append(proObservation)
        observations.append(contenBlockerObservation)
        
        configuration.checkContentBlockerEnabled()
    }
    
    /**
     Removes observers from controller
     */
    private func removeObservers(){
        resources.sharedDefaults().removeObserver(self, forKeyPath: AEDefaultsRequests, context: nil)
        
        resources.sharedDefaults().removeObserver(self, forKeyPath: AEDefaultsBlockedRequests, context: nil)
        
        resources.sharedDefaults().removeObserver(self, forKeyPath: AEDefaultsCountersRequests, context: nil)
    }
    
    /**
     Starts to rotate refresh button
     */
    private func updateStarted(){
        refreshButton.isUserInteractionEnabled = false
        refreshButton.rotateImage(isNedeed: true)
    }
    
    /**
     Stops to rotate refresh button
     */
    private func updateEnded(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {[weak self] in
            self?.refreshButton.isUserInteractionEnabled = true
            self?.refreshButton.rotateImage(isNedeed: false)
            self?.changeProtectionStatusLabel()
        })
    }
}
