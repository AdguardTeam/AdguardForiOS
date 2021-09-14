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
import struct CoreGraphics.CGPoint

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
    func startChartStatisticsAutoUpdate(seconds: TimeInterval)
    func chartViewSizeChanged(frame: CGRect)
}

final class ChartViewModel: ChartViewModelProtocol {
    typealias ChartPoints = (requestsPoints: [CGPoint], encryptedPoints: [CGPoint])
    
    //MARK: - Properties
    weak var delegate: ChartViewModelDelegate?
    
    var statisticsInfo: CountersStatisticsRecord {
        do {
            let record = try activityStatistics?.getCounters(for: statisticsPeriod)
            return record ?? CountersStatisticsRecord(requests: 0, encrypted: 0, blocked: 0, elapsedSumm: 0)
        } catch {
            DDLogError("(ChartViewModel) statisticsInfo; getCounters return error: \(error)")
            return CountersStatisticsRecord(requests: 0, encrypted: 0, blocked: 0, elapsedSumm: 0)
        }
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
    private let chartStatistics: ChartStatisticsProtocol?
    private let activityStatistics: ActivityStatisticsProtocol?
    private var isStarted: Bool = false
    private var timer: Timer?
    private var repeatTime: TimeInterval = 5.0
    
    private var firstFormattedDate: String = ""
    private var lastFormattedDate: String = ""
    
    private var maxXelement: CGFloat = 0
    private var maxYelement: CGFloat = 0
    private var frame: CGRect = .zero
    
    //MARK: - Init
    init(statisticsPeriod: StatisticsPeriod, statisticsDbContainerUrl: URL) {
        self.statisticsPeriod = statisticsPeriod
        self.chartStatistics = try? ChartStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
        self.activityStatistics = try? ActivityStatistics(statisticsDbContainerUrl: statisticsDbContainerUrl)
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
    
    func chartViewSizeChanged(frame: CGRect) {
        self.frame = frame
        startChartStatisticsAutoUpdate(seconds: repeatTime)
    }
    
    //MARK: - Private methods
    private func chartStatisticUpdate() {
        let info = self.statisticsInfo
        let records = self.getChartRecords(for: self.statisticsPeriod)
        
        let points = findMaxElements(requestsPoints: records.requests.points, encryptedPoints: records.encrypted.points)
        
        self.delegate?.numberOfRequestsChanged(with: (points.requestsPoints, points.encryptedPoints), countersStatisticsRecord: info, firstFormattedDate: firstFormattedDate, lastFormattedDate: lastFormattedDate, maxRequests: Int(maxYelement))
    }
    
    private func getChartRecords(for period: StatisticsPeriod) -> (requests: ChartRecords, encrypted: ChartRecords) {
        var resultRequests: ChartRecords!
        var resultEncrypted: ChartRecords!
        
        if let requests = try? chartStatistics?.getPoints(for: .requests, for: period) {
            resultRequests = requests
        } else {
            resultRequests = ChartRecords(chartType: .requests, points: [])
        }
        
        if let encrypted = try? chartStatistics?.getPoints(for: .encrypted, for: period) {
            resultEncrypted = encrypted
        } else {
            resultRequests = ChartRecords(chartType: .encrypted, points: [])
        }
        
        let oldestDate = chartStatistics?.oldestRecordDate
        prepareDateIntervals(oldestRecordDate: oldestDate)
        return (resultRequests, resultEncrypted)
    }
    
    private func prepareDateIntervals(oldestRecordDate: Date?) {
        let intervalBounds = statisticsPeriod.getIntervalBoundsStrings(oldestRecordDate)
        firstFormattedDate = intervalBounds.start
        lastFormattedDate = intervalBounds.end
    }
    
    private func findMaxElements(requestsPoints: [Point], encryptedPoints: [Point]) -> ChartPoints {
        guard requestsPoints.count == encryptedPoints.count,
              !requestsPoints.isEmpty
        else {
            DDLogWarn("(ChartViewModel) findMaxElements; Number of requests points not equal to number of encrypted points or points number is zero")
            return ([], [])
        }
        
        let requestsPoints = requestsPoints
        let encryptedPoints = encryptedPoints
        var requestsResult: [CGPoint] = []
        var encryptedResult: [CGPoint] = []
        
        var maxXRequestsElement: CGFloat = 0.0
        var maxYRequestsElement: CGFloat = 0.0
        var maxXEncryptedElement: CGFloat = 0.0
        var maxYEncryptedElement: CGFloat = 0.0
        
        for i in 0..<requestsPoints.count {

            var requestsPointX = requestsPoints[i].x
            let requestsPointY = requestsPoints[i].y
            
            var encryptedPointX = encryptedPoints[i].x
            let encryptedPointY = encryptedPoints[i].y
            
            //Correct point x
            requestsPointX -= requestsPoints[0].x
            encryptedPointX -= encryptedPoints[0].x
            
            let requestsPoint = CGPoint(x: requestsPointX, y: requestsPointY)
            let encryptedPoint = CGPoint(x: encryptedPointX, y: encryptedPointY)
            
            requestsResult.append(requestsPoint)
            encryptedResult.append(encryptedPoint)
            
            //Find max element
            if requestsResult[i].x > maxXRequestsElement {
                maxXRequestsElement = CGFloat(requestsPointX)
            }
            
            if requestsResult[i].y > maxYRequestsElement {
                maxYRequestsElement = CGFloat(requestsPointY)
            }
            
            if encryptedResult[i].x > maxXEncryptedElement {
                maxXEncryptedElement = CGFloat(encryptedPointX)
            }
            
            if encryptedResult[i].y > maxYEncryptedElement {
                maxYEncryptedElement = CGFloat(encryptedPointY)
            }
        }
            
        self.maxXelement = max(maxXRequestsElement, maxXEncryptedElement)
        self.maxYelement = max(maxYRequestsElement, maxYEncryptedElement)
        
        return modifyCGPoints(points: (requestsResult, encryptedResult))
    }
    
    private func modifyCGPoints(points: ChartPoints) -> ChartPoints {
        guard points.requestsPoints.count == points.encryptedPoints.count, !points.requestsPoints.isEmpty else {
            DDLogWarn("(ChartViewModel) modifyCGPoints;  Number of requests points not equal to number of encrypted points or points number is zero")
            return ([], [])
        }
        
        var requestsResult: [CGPoint] = []
        var encryptedResult: [CGPoint] = []
        
        for i in 0..<points.requestsPoints.count {
            
            let requestsPoint = points.requestsPoints[i]
            let encryptedPoint = points.encryptedPoints[i]
            
            requestsResult.append(getModifiedPoint(point: requestsPoint))
            encryptedResult.append(getModifiedPoint(point: encryptedPoint))
        }
        return (requestsResult, encryptedResult)
    }
    
    
    private func getModifiedPoint(point: CGPoint) -> CGPoint {
        let ratioY: CGFloat = maxYelement == 0 ? 0.0 : point.y / CGFloat(maxYelement) * 0.7
        let newY = (frame.height - frame.height * ratioY) - frame.height * 0.15
        
        let ratioX: CGFloat = maxXelement == 0 ? 0.0 : point.x / CGFloat(maxXelement)
        let newX = frame.width * ratioX
        
        return CGPoint(x: newX, y: newY)
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
