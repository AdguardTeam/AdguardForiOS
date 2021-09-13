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

import DnsAdGuardSDK

protocol ChartViewModelDelegate: AnyObject {
    func numberOfRequestsChanged(with records: [ChartRecords],
                          countersStatisticsRecord: CountersStatisticsRecord?,
                          firstFormattedDate: String,
                          lastFormattedDate: String)
}

protocol ChartViewModelProtocol {
    var statisticsInfo: CountersStatisticsRecord? { get }
    var statisticsPeriod: StatisticsPeriod { get set }
    var chartType: ChartType { get set }
    var delegate: ChartViewModelDelegate? { get set }
    func startChartStatisticsAutoUpdate(seconds: TimeInterval)
}

final class ChartViewModel: ChartViewModelProtocol {
    //MARK: - Properties
    weak var delegate: ChartViewModelDelegate?
    
    var statisticsInfo: CountersStatisticsRecord? {
        return try? activityStatistics.getCounters(for: statisticsPeriod)
    }
    
    var statisticsPeriod: StatisticsPeriod {
        didSet {
            guard isStarted else { return }
            startChartStatisticsAutoUpdate(seconds: repeatTime)
        }
    }
    
    var chartType: ChartType = .requests {
        didSet {
            guard isStarted else { return }
            startChartStatisticsAutoUpdate(seconds: repeatTime)
        }
    }
    
    //MARK: - Private properties
    private let chartStatistics: ChartStatisticsProtocol
    private let activityStatistics: ActivityStatisticsProtocol
    private var isStarted: Bool = false
    private var timer: Timer?
    private var repeatTime: TimeInterval = 5.0
    
    private var firstFormattedDate: String = ""
    private var lastFormattedDate: String = ""
    
    //MARK: - Init
    init(statisticsPeriod: StatisticsPeriod, statisticsDbContainerUrl: URL) throws {
        self.statisticsPeriod = statisticsPeriod
        self.chartStatistics = try ChartStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
        self.activityStatistics = try ActivityStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
    }
    
    func startChartStatisticsAutoUpdate(seconds: TimeInterval) {
        isStarted = true
        timer?.invalidate()
        timer = nil
        repeatTime = seconds
        chartStatisticUpdate()
        timer = Timer.scheduledTimer(withTimeInterval: repeatTime, repeats: true, block: { [weak self] _ in
            self?.chartStatisticUpdate()
        })
    }
    
    //MARK: - Private methods
    private func chartStatisticUpdate() {
        guard let info = self.statisticsInfo else { return }
        let records = self.getChartRecords(for: self.statisticsPeriod)
        self.delegate?.numberOfRequestsChanged(with: records, countersStatisticsRecord: info, firstFormattedDate: firstFormattedDate, lastFormattedDate: lastFormattedDate)
    }
    
    private func getChartRecords(for period: StatisticsPeriod) -> [ChartRecords] {
        var result: [ChartRecords] = []
        if let requests = try? chartStatistics.getPoints(for: .requests, for: period) {
            let preparedRequests = prepareRecords(records: requests)
            result.append(preparedRequests)
        }
        if let encrypted = try? chartStatistics.getPoints(for: .encrypted, for: period) {
            let preparedEncrypted = prepareRecords(records: encrypted)
            result.append(preparedEncrypted)
        }
        
        let oldestDate = chartStatistics.getOldestRecordDate()
        prepareDateIntervals(oldestRecordDate: oldestDate)
        return result
    }
    
    private func prepareRecords(records: ChartRecords) -> ChartRecords {
        let first = records.points.first?.x ?? 0
        var points: [Point] = []
        
        for point in records.points {
            let xPosition = point.x - first
            points.append(Point(x: xPosition, y: point.y))
        }
        
        return ChartRecords(chartType: records.chartType, points: points)
    }
    
    private func prepareDateIntervals(oldestRecordDate: Date?) {
        let intervalBounds = statisticsPeriod.getIntervalBoundsStrings(oldestRecordDate)
        firstFormattedDate = intervalBounds.start
        lastFormattedDate = intervalBounds.end
    }
}

fileprivate extension StatisticsPeriod {
    func getInterval(_ oldestRecordDate: Date?) -> DateInterval {
        switch self {
        case .today, .day, .week, .month:
            return self.interval
        case .all:
            let now = Date()
            let oldest: Date = oldestRecordDate ?? now
            return DateInterval(start: oldest, end: now)
        }
    }

    func getIntervalBoundsStrings(_ oldestRecordDate: Date?) -> (start: String, end: String) {
        let interval = getInterval(oldestRecordDate)
        let start = self.getFormatterString(from: interval.start)
        let end = self.getFormatterString(from: interval.end)
        return (start, end)
    }
}
