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

import DnsAdGuardSDK
import UIKit

protocol ChartViewModelDelegate: AnyObject {
    func numberOfRequestsChanged(with points: (requests: [CGPoint], encrypted: [CGPoint]),
                                 countersStatisticsRecord: CountersStatisticsRecord?,
                                 firstFormattedDate: String,
                                 lastFormattedDate: String,
                                 maxRequests: Int)
}

protocol ChartViewModelProtocol {
    var statisticsInfo: CountersStatisticsRecord { get }
    var statisticsPeriod: StatisticsPeriod { get set }
    var chartType: ChartType { get set }
    var delegate: ChartViewModelDelegate? { get set }
    func chartViewSizeChanged(frame: CGRect)
}

final class ChartViewModel: ChartViewModelProtocol {
    private struct ChartPoints {
        let requestsPoints: [CGPoint]
        let encryptedPoints: [CGPoint]
        let maxXelement: CGFloat
        let maxYelement: CGFloat
    }

    // MARK: - Properties

    weak var delegate: ChartViewModelDelegate?

    var statisticsInfo: CountersStatisticsRecord {
        do {
            let record = try activityStatistics.getCounters(for: statisticsPeriod)
            return record
        } catch {
            DDLogError("(ChartViewModel) statisticsInfo; getCounters return error: \(error)")
            return CountersStatisticsRecord.emptyRecord()
        }
    }

    var statisticsPeriod: StatisticsPeriod {
        didSet {
            guard isStarted else { return }
            startChartStatisticsAutoUpdate()
        }
    }

    var chartType: ChartType = .requests {
        didSet {
            guard isStarted else { return }
            startChartStatisticsAutoUpdate()
        }
    }

    // MARK: - Private properties

    private let chartPointsCount = 25

    private let chartStatistics: ChartStatisticsProtocol
    private let activityStatistics: ActivityStatisticsProtocol
    private var isStarted: Bool = false
    private var timer: Timer?

    private var firstFormattedDate: String = ""
    private var lastFormattedDate: String = ""
    private var frame: CGRect = .zero

    // MARK: - Init

    init(statisticsPeriod: StatisticsPeriod, activityStatistics: ActivityStatisticsProtocol, chartStatistics: ChartStatisticsProtocol) {
        self.statisticsPeriod = statisticsPeriod
        self.chartStatistics = chartStatistics
        self.activityStatistics = activityStatistics
    }

    func startChartStatisticsAutoUpdate() {
        isStarted = true
        timer?.invalidate()
        timer = nil
        let repeatTime = statisticsPeriod.getChartViewUpdateInterval(statisticsInfo.requests)
        chartStatisticUpdate()
        timer = Timer.scheduledTimer(withTimeInterval: repeatTime, repeats: true, block: { [weak self] _ in
            self?.chartStatisticUpdate()
        })
    }

    func chartViewSizeChanged(frame: CGRect) {
        self.frame = frame
        startChartStatisticsAutoUpdate()
    }

    // MARK: - Private methods

    // Update chart points
    private func chartStatisticUpdate() {
        let info = self.statisticsInfo
        let records = self.getChartRecords(for: self.statisticsPeriod)

        let points = getPreparedPoints(requestsPoints: records.requests.points, encryptedPoints: records.encrypted.points)

        self.delegate?.numberOfRequestsChanged(with: (points.requestsPoints, points.encryptedPoints), countersStatisticsRecord: info, firstFormattedDate: firstFormattedDate, lastFormattedDate: lastFormattedDate, maxRequests: Int(points.maxYelement))
    }

    // Return statistics date from SDK
    private func getChartRecords(for period: StatisticsPeriod) -> (requests: ChartRecords, encrypted: ChartRecords) {
        var resultRequests: ChartRecords!
        var resultEncrypted: ChartRecords!

        if let requests = try? chartStatistics.getPoints(for: .requests, for: period, pointsCount: chartPointsCount) {
            resultRequests = requests
        } else {
            resultRequests = ChartRecords(chartType: .requests, points: [])
        }

        if let encrypted = try? chartStatistics.getPoints(for: .encrypted, for: period, pointsCount: chartPointsCount) {
            resultEncrypted = encrypted
        } else {
            resultRequests = ChartRecords(chartType: .encrypted, points: [])
        }

        let oldestDate = chartStatistics.oldestRecordDate
        prepareDateIntervals(oldestRecordDate: oldestDate)
        return (resultRequests, resultEncrypted)
    }

    // Get period borders date
    private func prepareDateIntervals(oldestRecordDate: Date?) {
        let intervalBounds = statisticsPeriod.getIntervalBoundsStrings(oldestRecordDate)
        firstFormattedDate = intervalBounds.start
        lastFormattedDate = intervalBounds.end
    }

    // Return fully prepared points
    private func getPreparedPoints(requestsPoints: [Point], encryptedPoints: [Point]) -> ChartPoints {
        guard requestsPoints.count == encryptedPoints.count,
              !requestsPoints.isEmpty
        else {
            DDLogWarn("(ChartViewModel) findMaxElements; Number of requests points not equal to number of encrypted points or points number is zero")
            return ChartPoints(requestsPoints: [], encryptedPoints: [], maxXelement: 0, maxYelement: 0)
        }

        var requestsResult: [CGPoint] = []
        requestsResult.reserveCapacity(requestsPoints.count)
        var encryptedResult: [CGPoint] = []
        encryptedResult.reserveCapacity(encryptedPoints.count)

        var maxXRequestsElement: CGFloat = 0.0
        var maxYRequestsElement: CGFloat = 0.0
        var maxXEncryptedElement: CGFloat = 0.0
        var maxYEncryptedElement: CGFloat = 0.0

        for i in 0..<requestsPoints.count {

            var requestsPointX = requestsPoints[i].x
            let requestsPointY = requestsPoints[i].y

            var encryptedPointX = encryptedPoints[i].x
            let encryptedPointY = encryptedPoints[i].y

            //Correcting x coordinates of all points to find chart start position
            requestsPointX -= requestsPoints[0].x
            encryptedPointX -= encryptedPoints[0].x

            let requestsPoint = CGPoint(x: requestsPointX, y: requestsPointY)
            let encryptedPoint = CGPoint(x: encryptedPointX, y: encryptedPointY)

            requestsResult.append(requestsPoint)
            encryptedResult.append(encryptedPoint)

            //Find max x element for requests
            if requestsResult[i].x > maxXRequestsElement {
                maxXRequestsElement = CGFloat(requestsPointX)
            }
            //Find max y element for requests
            if requestsResult[i].y > maxYRequestsElement {
                maxYRequestsElement = CGFloat(requestsPointY)
            }

            //Find max x element for encrypted requests
            if encryptedResult[i].x > maxXEncryptedElement {
                maxXEncryptedElement = CGFloat(encryptedPointX)
            }

            //Find max y element for encrypted requests
            if encryptedResult[i].y > maxYEncryptedElement {
                maxYEncryptedElement = CGFloat(encryptedPointY)
            }
        }

        let maxXelement = max(maxXRequestsElement, maxXEncryptedElement)
        let maxYelement = max(maxYRequestsElement, maxYEncryptedElement)
        let chartPoints = ChartPoints(requestsPoints: requestsResult, encryptedPoints: encryptedResult, maxXelement: maxXelement, maxYelement: maxYelement)

        return modifyPoints(points: chartPoints)
    }

    // Return modified points
    private func modifyPoints(points: ChartPoints) -> ChartPoints {
        guard points.requestsPoints.count == points.encryptedPoints.count, !points.requestsPoints.isEmpty else {
            DDLogWarn("(ChartViewModel) modifyCGPoints;  Number of requests points not equal to number of encrypted points or points number is zero")
            return ChartPoints(requestsPoints: [], encryptedPoints: [], maxXelement: 0, maxYelement: 0)
        }

        var requestsResult: [CGPoint] = []
        requestsResult.reserveCapacity(points.requestsPoints.count)
        var encryptedResult: [CGPoint] = []
        encryptedResult.reserveCapacity(points.encryptedPoints.count)

        for i in 0..<points.requestsPoints.count {

            let requestsPoint = points.requestsPoints[i]
            let encryptedPoint = points.encryptedPoints[i]

            requestsResult.append(getModifiedPoint(point: requestsPoint, maxXelement: points.maxXelement, maxYelement: points.maxYelement))
            encryptedResult.append(getModifiedPoint(point: encryptedPoint, maxXelement: points.maxXelement, maxYelement: points.maxYelement))
        }
        return ChartPoints(requestsPoints: requestsResult, encryptedPoints: encryptedResult, maxXelement: points.maxXelement, maxYelement: points.maxYelement)
    }

    // Return modified point relative to the frame
    private func getModifiedPoint(point: CGPoint, maxXelement: CGFloat, maxYelement: CGFloat) -> CGPoint {
        // ratio to frame for y coordinate with height constraint
        let ratioY: CGFloat = maxYelement == 0.0 ? 0.0 : point.y / CGFloat(maxYelement) * 0.7
        // inverted position y for frame with space from top of chart view
        let newY = (frame.height - frame.height * ratioY) - frame.height * 0.15

        //ratio to frame for x coordinate
        let ratioX: CGFloat = maxXelement == 0.0 ? 0.0 : point.x / CGFloat(maxXelement)
        // position x for frame
        let newX = frame.width * ratioX

        return CGPoint(x: newX, y: newY)
    }
}

fileprivate extension StatisticsPeriod {

    /// Returns counters update interval depending on requests number
    /// The less requests number the less significant changes are
    func getChartViewUpdateInterval(_ requestsCount: Int) -> TimeInterval {
        switch requestsCount {
        case 0..<1000: return 10.0
        case 1000..<10000: return 30.0
        default: return 60.0
        }
    }

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
