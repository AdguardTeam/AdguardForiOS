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
    
    var requestsCount: Int { get set }
    var blockedCount: Int { get set }
    
    var chartDateType: ChartDateType { get set }
    var chartRequestType: ChartRequestType { get set }
    
    var chartPointsChangedDelegate: ChartPointsChangedDelegate? { get set }
    
    func obtainStatistics()
}

protocol ChartPointsChangedDelegate: class {
    func chartPointsChanged(requests: [Point], blocked: [Point])
    func numberOfRequestsChanged(requests: Int, blocked: Int)
}

enum ChartDateType {
    case today, day, week, month, alltime
    
    func getTimeInterval(requestsDates: [Date]) -> (begin: Date, end: Date){
        let firstDate: Date = requestsDates.first ?? now()
        let lastDate: Date = requestsDates.last ?? now()
        
        var interval: Double = 0.0
        
        let hour = 60.0 * 60.0 // 1 hour
        let day = 24.0 * hour // 24 hours
        let week = 7.0 * day
        let month = 30.0 * day
        
        switch self {
        case .today:
            let calendar = Calendar.current
            let hours = Double(calendar.component(.hour, from: lastDate))
            let minutes = Double(calendar.component(.minute, from: lastDate))
            
            interval = hours * hour + minutes * 60.0

        case .day:
            interval = day
        case .week:
            interval = week
        case .month:
            interval = month
        case .alltime:
            return (firstDate, lastDate)
        }
        
        var endDate = lastDate - interval
        if endDate < firstDate {
            endDate = firstDate
        }
        
        return (endDate, lastDate)
    }
    
    private func now() -> Date {
        return Date()
    }
}

enum ChartRequestType {
    case requests, blocked
}

class ChartViewModel: ChartViewModelProtocol {
    
    var requestsCount: Int = 0
    var blockedCount: Int = 0
    
    weak var chartPointsChangedDelegate: ChartPointsChangedDelegate?
    
    var requests: [RequestsStatisticsBlock] = []
    var blockedRequests: [RequestsStatisticsBlock] = []
    
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
    
    private let dateFormatter = DateFormatter()
    
    private let dnsStatisticsService: DnsStatisticsServiceProtocol
    
    // MARK: - init
    init(_ dnsStatisticsService: DnsStatisticsServiceProtocol) {
        self.dnsStatisticsService = dnsStatisticsService
    }
    
    func obtainStatistics() {
        let statistics = dnsStatisticsService.readStatistics()
        
        requests = statistics[.all] ?? []
        blockedRequests = statistics[.blocked] ?? []
        
        changeChart()
    }
    
    // MARK: - private methods
    
    private func changeChart(){
    
        let requestsData = getPoints(from: requests)
        let blockedData = getPoints(from: blockedRequests)
        
        requestsCount = requestsData.number
        blockedCount = blockedData.number
                
        chartPointsChangedDelegate?.chartPointsChanged(requests: requestsData.points, blocked: blockedData.points)
        chartPointsChangedDelegate?.numberOfRequestsChanged(requests: requestsData.number, blocked: blockedData.number)
    }
    
    private func getPoints(from requests: [RequestsStatisticsBlock]) -> (points: [Point], number: Int){
        let maximumPointsNumber = 50
        var pointsArray: [Point] = []
        var number = 0
                
        var requestsDates: [Date] = requests.map({ $0.date })
        requestsDates.sort(by: { $0 < $1 })
        
        if requestsDates.count < 2 {
            return ([], 0)
        }
        
        let intervalTime = chartDateType.getTimeInterval(requestsDates: requestsDates)
        
        let firstDate = intervalTime.begin.timeIntervalSinceReferenceDate
        let lastDate = intervalTime.end.timeIntervalSinceReferenceDate
        
        var xPosition: CGFloat = 0.0
        for request in requests {
            let date = request.date.timeIntervalSinceReferenceDate
            if (date > firstDate && date < lastDate) || chartDateType == .alltime {
                let point = Point(x: xPosition, y: CGFloat(integerLiteral: request.numberOfRequests))
                number += request.numberOfRequests
                pointsArray.append(point)
                xPosition += 1.0
            }
        }
        
        if pointsArray.count > maximumPointsNumber {
            let points = rearrangePoints(from: pointsArray, max: maximumPointsNumber)
            return (points, number)
        } else {
            return (pointsArray, number)
        }
    }
    
    private func rearrangePoints(from points: [Point], max: Int) -> [Point] {
        var ratio: Float = Float(points.count) / Float(max)
        ratio = ceil(ratio)
        
        var copyPoints = points.map({$0.y})
        
        let intRatio = Int(ratio)
        var newPoints = [Point]()
        var xPosition: CGFloat = 0.0
        
        while !copyPoints.isEmpty {
            let points = copyPoints.prefix(intRatio)
            let sum = points.reduce(0, +)
            let point = Point(x: xPosition, y: sum)
            newPoints.append(point)
            
            xPosition += 1.0
            
            if copyPoints.count < intRatio {
                copyPoints.removeAll()
            } else {
                copyPoints.removeFirst(intRatio)
            }
        }
        
        return newPoints
    }
    
}
