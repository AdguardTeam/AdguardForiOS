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

import Foundation

protocol ChartViewModelProtocol {
    var chartView: ChartView? { get set }
    
    var requestsCount: Int { get set }
    var encryptedCount: Int { get set }
    var averageElapsed: Double { get set }
    
    var chartDateType: ChartDateType { get set }
    var chartRequestType: ChartRequestType { get set }
    
    var chartPointsChangedDelegate: NumberOfRequestsChangedDelegate? { get set }
    
    func obtainStatistics()
}

protocol NumberOfRequestsChangedDelegate: class {
    func numberOfRequestsChanged()
}

enum ChartRequestType {
    case requests, encrypted
}

class ChartViewModel: ChartViewModelProtocol {
    
    var chartView: ChartView?
    var chartPointsChangedDelegate: NumberOfRequestsChangedDelegate?
    
    var requestsCount: Int = 0
    var encryptedCount: Int = 0
    var averageElapsed: Double = 0.0

    var chartDateType: ChartDateType = .alltime {
        didSet {
            changeChart()
        }
    }
    
    var chartRequestType: ChartRequestType = .requests {
        didSet {
            changeChart()
        }
    }
    
    private var recordsByType: [ChartDateType: [DnsStatisticsRecord]] = [:]
    
    private let dateFormatter = DateFormatter()
    
    private var timer: Timer?
    
    private let dnsStatisticsService: DnsStatisticsServiceProtocol
    
    // MARK: - init
    init(_ dnsStatisticsService: DnsStatisticsServiceProtocol) {
        self.dnsStatisticsService = dnsStatisticsService
    }
    
    func obtainStatistics() {
        DispatchQueue(label: "obtainStatistics queue").async { [weak self] in
            guard let self = self else { return }
            
            self.timer?.invalidate()
            self.timer = nil
            
            for type in ChartDateType.allCases {
                self.recordsByType[type] = self.dnsStatisticsService.getRecords(by: type)
            }
            
            self.changeChart()
            
            self.timer = Timer.scheduledTimer(withTimeInterval: self.dnsStatisticsService.minimumStatisticSaveTime, repeats: true, block: {[weak self] (timer) in
                self?.obtainStatistics()
            })
        }
    }
    
    // MARK: - private methods
    
    private func changeChart(){
        DispatchQueue(label: "chart processing queue").async { [weak self] in
            guard let self = self, let records = self.recordsByType[self.chartDateType] else { return }
            let requestsInfo = self.getInfo(from: records)
                
            self.requestsCount = requestsInfo.requestsNumber
            self.encryptedCount = requestsInfo.encryptedNumber
                
            self.averageElapsed = requestsInfo.averageElapsedTime
            
            self.chartView?.chartPoints = (requestsInfo.requestsPoints, requestsInfo.encryptedPoints)
            self.chartPointsChangedDelegate?.numberOfRequestsChanged()
        }
    }
    
    private func getInfo(from records: [DnsStatisticsRecord]) -> (requestsPoints: [Point], requestsNumber: Int, encryptedPoints: [Point], encryptedNumber: Int, averageElapsedTime: Double){
        let maximumPointsNumber = 35
        
        var requestsPoints: [Point] = []
        var requestsNumber: Int = 0
        
        var encryptedPoints: [Point] = []
        var encryptedNumber = 0
        
        var elapsedSumm: Int = 0
                    
        let firstDate = records.first?.date ?? Date()
        let lastDate = records.last?.date ?? Date()
        
        DispatchQueue.main.async { [weak self] in
            self?.chartView?.leftDateLabelText = self?.chartDateType.getFormatterString(from: firstDate)
            self?.chartView?.rightDateLabelText = self?.chartDateType.getFormatterString(from: lastDate)
        }
        
        if records.count < 2 {
            return ([], 0, [], 0, 0.0)
        }
        
        let firstDateSecondsFromReferenceDate: CGFloat = CGFloat(firstDate.timeIntervalSinceReferenceDate)
        for record in records {
            let xPosition: CGFloat = CGFloat(record.date.timeIntervalSinceReferenceDate) - firstDateSecondsFromReferenceDate
            
            let requestPoint = Point(x: xPosition, y: CGFloat(integerLiteral: record.requests))
            requestsPoints.append(requestPoint)
            requestsNumber += record.requests
            
            let encryptedPoint = Point(x: xPosition, y: CGFloat(integerLiteral: record.encrypted))
            encryptedPoints.append(encryptedPoint)
            encryptedNumber += record.encrypted
            
            elapsedSumm += record.elapsedSumm
        }
        
        let averageElapsedTime = Double(elapsedSumm) / Double(requestsNumber)
        
        if records.count > maximumPointsNumber {
            let rearrangedRequestsPoints = rearrangePoints(from: requestsPoints, max: maximumPointsNumber)
            let rearrangedEncryptedPoints = rearrangePoints(from: encryptedPoints, max: maximumPointsNumber)
            
            return (rearrangedRequestsPoints, requestsNumber, rearrangedEncryptedPoints, encryptedNumber, averageElapsedTime)
        } else {
            return (requestsPoints, requestsNumber, encryptedPoints, encryptedNumber, averageElapsedTime)
        }
    }
    
    private func rearrangePoints(from points: [Point], max: Int) -> [Point] {
        var ratio: Float = Float(points.count) / Float(max)
        ratio = ceil(ratio)
        
        var copyPoints = points
    
        let intRatio = Int(ratio)
        var newPoints = [Point]()
        
        /* X must be 0.0 for first records */
        var isFirstRecord = true
        
        while !copyPoints.isEmpty {
            let mergedPoints = copyPoints.prefix(intRatio)
            
            let xPoints = mergedPoints.map({ $0.x })
            let yPoints = mergedPoints.map({ $0.y })
            
            let ySumm = yPoints.reduce(0, +)
            let xSumm = xPoints.reduce(0, +)
            
            let xPosition: CGFloat = isFirstRecord ? 0.0 : xSumm / CGFloat(xPoints.count)
            
            let point = Point(x: xPosition, y: ySumm)
            newPoints.append(point)
            
            if copyPoints.count < intRatio {
                copyPoints.forEach({ newPoints.append($0) })
            } else {
                copyPoints.removeFirst(intRatio)
            }
            
            isFirstRecord = false
        }
        
        return newPoints
    }
    
}
