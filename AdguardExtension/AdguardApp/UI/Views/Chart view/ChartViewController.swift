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

class ChartViewController: UIViewController, UIViewControllerTransitioningDelegate, DateTypeChangedProtocol, ChartPointsChangedDelegate {

    @IBOutlet weak var chartView: ChartView!
    @IBOutlet var changeChartTypeButtons: [UIButton]!
    
    @IBOutlet weak var leftDateLabel: ThemableLabel!
    @IBOutlet weak var rightDateLabel: ThemableLabel!
    @IBOutlet weak var changeDateTypeButton: UIButton!

    private var model: ChartViewModelProtocol = ChartViewModel(ServiceLocator.shared.getService()!)
    private let resources: AESharedResourcesProtocol = ServiceLocator.shared.getService()!
    
    private let requestsTag = 0
    private let blockedTag = 1
    private let countersTag = 2
    
    private var requestsObserver: Any?
    private var blockedRequestsObserver: Any?
    private var countersRequestsObserver: Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeChartTypeButtons[0].isSelected = true
        changeChartTypeButtons[0].titleLabel?.font = UIFont.systemFont(ofSize: 21.0, weight: .bold)
        
        model.chartPointsChangedDelegate = self
        model.obtainRecords {[weak self] in
            self?.changeAllButtonsText()
        }
        
        requestsObserver = resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsRequests, options: .new, context: nil)
        
        blockedRequestsObserver = resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsBlockedRequests, options: .new, context: nil)
        
        countersRequestsObserver = resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsCountersRequests, options: .new, context: nil)
    }

    // MARK: - Actions
    
    @IBAction func chartTypeAction(_ sender: UIButton) {
        for btn in changeChartTypeButtons {
            if btn.tag == sender.tag {
                btn.isSelected = true
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 21.0, weight: .bold)
                continue
            }
            btn.isSelected = false
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 21.0, weight: .regular)
        }
        
        switch sender.tag {
        case requestsTag:
            model.chartRequestType = .requests
        case blockedTag:
            model.chartRequestType = .blocked
        case countersTag:
            model.chartRequestType = .counters
        default:
            break
        }
    }
    
    @IBAction func changeDateTypeAction(_ sender: Any) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "ChartDateTypeController") as? ChartDateTypeController else { return }
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = self
        controller.delegate = self
        
        present(controller, animated: true, completion: nil)
    }
    
    // MARK: - DateTypeChangedProtocol method
    
    func dateTypeChanged(dateType: ChartDateType) {
        changeDateTypeButton(dateType: dateType)
        model.chartDateType = dateType
    }
    
    // MARK: - ChartPointsChangedDelegate method
    
    func chartPointsChanged(points: [Point]) {
        chartView.chartPoints = points
    }

    // MARK: - Observing Values from User Defaults
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        switch keyPath {
        case AEDefaultsRequests:
            changeButtonsText(with: requestsTag)
        case AEDefaultsBlockedRequests:
            changeButtonsText(with: blockedTag)
        case AEDefaultsCountersRequests:
            changeButtonsText(with: countersTag)
        default:
            break
        }
    }
    
    // MARK: - Private methods
    
    private func changeAllButtonsText(){
        changeChartTypeButtons.forEach { (button) in
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            switch button.tag{
            case requestsTag:
                let number = resources.sharedDefaults().integer(forKey: AEDefaultsRequests)
                button.setTitle(String(format: ACLocalizedString("chart_requests", nil), number), for: .normal)
            case blockedTag:
                let number = resources.sharedDefaults().integer(forKey: AEDefaultsBlockedRequests)
                button.setTitle(String(format: ACLocalizedString("chart_blockers", nil), number), for: .normal)
            case countersTag:
                let number = resources.sharedDefaults().integer(forKey: AEDefaultsCountersRequests)
                button.setTitle(String(format: ACLocalizedString("chart_counters", nil), number), for: .normal)
            default:
                break
            }
        }
    }
    
    private func changeButtonsText(with tag: Int){
        let button = changeChartTypeButtons.filter({ $0.tag == tag })
        switch tag{
        case requestsTag:
            let number = resources.sharedDefaults().integer(forKey: AEDefaultsRequests)
            button[0].setTitle(String(format: ACLocalizedString("chart_requests", nil), number), for: .normal)
        case blockedTag:
            let number = resources.sharedDefaults().integer(forKey: AEDefaultsBlockedRequests)
            button[0].setTitle(String(format: ACLocalizedString("chart_blockers", nil), number), for: .normal)
        case countersTag:
            let number = resources.sharedDefaults().integer(forKey: AEDefaultsCountersRequests)
            button[0].setTitle(String(format: ACLocalizedString("chart_counters", nil), number), for: .normal)
        default:
            break
        }
    }
    
    private func changeDateTypeButton(dateType: ChartDateType){
        switch dateType {
        case .day:
            changeDateTypeButton.setTitle(ACLocalizedString("chart_24hours", nil), for: .normal)
        case .today:
            changeDateTypeButton.setTitle(ACLocalizedString("chart_date_today", nil), for: .normal)
        case .week:
            changeDateTypeButton.setTitle(ACLocalizedString("chart_7days", nil), for: .normal)
        case .month:
            changeDateTypeButton.setTitle(ACLocalizedString("chart_30days", nil), for: .normal)
        case .alltime:
            changeDateTypeButton.setTitle(ACLocalizedString("chart_alltime", nil), for: .normal)
        }
    }
}
