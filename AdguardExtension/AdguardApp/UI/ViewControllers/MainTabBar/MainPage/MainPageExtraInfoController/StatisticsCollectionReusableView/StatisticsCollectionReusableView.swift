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

protocol StatisticsCollectionReusableViewDelegate: AnyObject {
    func newDateTypeSelected(_ newDateType: ChartDateType)
}

final class StatisticsCollectionReusableView: UICollectionViewCell, Reusable, NibInitializable {
    
    // MARK: - UI Elements
    
    @IBOutlet weak var statisticsTitleLabel: ThemableLabel!
    @IBOutlet weak var timePeriodLabel: ThemableLabel!
    
    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var statisticsInfoView: StatisticsInfoView!
    
    // MARK: - Public variables
    
    weak var delegate: StatisticsCollectionReusableViewDelegate?
        
    var chartDateType = ChartDateType.alltime {
        didSet {
            timePeriodLabel.text = chartDateType.getDateTypeString()
        }
    }
    
    var chartViewConfig = StatisticsChartModel.ChartViewConfig(points: StatisticsChartModel.Points(requestsPoints: [], encryptedPoints: []), leftBorderText: "", rightBorderText: "") {
        didSet {
            chartView.chartPoints = chartViewConfig.points
            chartView.leftDateLabelText = chartViewConfig.leftBorderText
            chartView.rightDateLabelText = chartViewConfig.rightBorderText
            chartView.activeChart = statisticsInfoView.currentType
        }
    }
    
    var chartViewIsEnabled: Bool = false {
        didSet {
            chartView.isEnabled = chartViewIsEnabled
        }
    }
    
    var statisticsModel: StatisticsModel.Statistics = StatisticsModel.Statistics() {
        didSet {
            statisticsInfoView.statisticsModel = statisticsModel
        }
    }
    
    // MARK: - Private variables
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statisticsTitleLabel.text = String.localizedString("statistics_title")
        timePeriodLabel.text = chartDateType.getDateTypeString()
        statisticsInfoView.delegate = self
        chartView.activeChart = statisticsInfoView.currentType
        
        /*
         There is a bug 🐞 in iOS 12 and earlier
         All subviews appeared under content view
         Maybe it's xib bug, because it doesn'g show content view 🤷‍♂️
         */
        contentView.isUserInteractionEnabled = false
    }
    
    // MARK: - Public methods
    
    func updateTheme(_ theme: ThemeServiceProtocol) {
        backgroundColor = theme.popupBackgroundColor
        theme.setupLabels([statisticsTitleLabel, timePeriodLabel])
        statisticsInfoView.updateTheme(theme)
        chartView.updateTheme()
    }
    
    // MARK: - Actions
    
    @IBAction func previousTimePeriod(_ sender: UIButton) {
        let currentIndex = ChartDateType.allCases.firstIndex(of: chartDateType)!
        let newDateType: ChartDateType
        
        if currentIndex == ChartDateType.allCases.count - 1 {
            newDateType = ChartDateType.allCases.first!
        } else {
            newDateType = ChartDateType.allCases[currentIndex + 1]
        }
        chartDateType = newDateType
        delegate?.newDateTypeSelected(newDateType)
    }
    
    @IBAction func nextTimePeriod(_ sender: UIButton) {
        let currentIndex = ChartDateType.allCases.firstIndex(of: chartDateType)!
        let newDateType: ChartDateType
        
        if currentIndex == 0 {
            newDateType = ChartDateType.allCases.last!
        } else {
            newDateType = ChartDateType.allCases[currentIndex - 1]
        }
        delegate?.newDateTypeSelected(newDateType)
    }
}

// MARK: - StatisticsCollectionReusableView + StatisticsInfoViewDelegate

extension StatisticsCollectionReusableView: StatisticsInfoViewDelegate {
    func activeTypeChanged() {
        chartView.activeChart = statisticsInfoView.currentType
    }
}
