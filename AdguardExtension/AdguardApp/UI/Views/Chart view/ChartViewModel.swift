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
    var requests: [ChartRerord] { get }
    var blockedRequests: [ChartRerord] { get }
    var countersRequests: [ChartRerord] { get }
    
    var chartDateType: ChartDateType { get set }
    var chartRequestType: ChartRequestType { get set }
    
    var chartPointsChangedDelegate: ChartPointsChangedDelegate? { get set }
    var requestsObserver: (([ChartRerord])->Void)? { get }
    
    func obtainRecords(completion: @escaping ()->())
}

protocol ChartPointsChangedDelegate: class {
    func chartPointsChanged(points: [Point])
}

enum ChartDateType {
    case today, day, week, month, alltime
}

enum ChartRequestType {
    case requests, blocked, counters
}

class ChartRerord {
    let date: Date
    let type: BlockedRecordType
    
    init(date: Date, type: BlockedRecordType) {
        self.date = date
        self.type = type
    }
}

class ChartViewModel: ChartViewModelProtocol {
    
    var requestsObserver: (([ChartRerord]) -> Void)?
    
    weak var chartPointsChangedDelegate: ChartPointsChangedDelegate?
    
    var requests: [ChartRerord] = []
    
    var blockedRequests: [ChartRerord] = []
    
    var countersRequests: [ChartRerord] = []
    
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
    
    private let vpnManager: APVPNManager
    
    // MARK: - init
    init(_ vpnManager: APVPNManager) {
        self.vpnManager = vpnManager
    }
    
    // MARK: - private methods
    /**
     obtains records array from vpnManager
    */
    func obtainRecords(completion: @escaping ()->()) {
        vpnManager.obtainDnsLogRecords { [weak self] (chartRecordsOpt)  in
            guard let sSelf = self else { return }
            sSelf.requests = []
            guard let chartRecords = chartRecordsOpt else { return }
            for chartRecord in chartRecords.reversed() {

                let record = ChartRerord(date: chartRecord.date, type: chartRecord.blockRecordType)
                
                if chartRecord.blockRecordType == .blocked {
                    sSelf.blockedRequests.append(record)
                }
                
                if chartRecord.blockRecordType == .tracked {
                    sSelf.countersRequests.append(record)
                }
                
                sSelf.requests.append(record)
            }
            completion()
            sSelf.changeChart()
        }
    }
    
    private func changeChart(){
        var requests: [ChartRerord] = []
        let sectorsNumber = 50
        var pointsArray: [Point] = []
        
        switch chartRequestType {
        case .requests:
            requests = self.requests
        case .blocked:
            requests = blockedRequests
        case .counters:
            requests = countersRequests
        }
        
        var requestsDates: [Double] = requests.map({ $0.date.timeIntervalSinceReferenceDate })
        requestsDates.sort(by: { $0 > $1 })
        
        if requestsDates.count < 2 {
            chartPointsChangedDelegate?.chartPointsChanged(points: [])
            return
        }
        
        let firstDate = requestsDates[0]
        let lastDate = requestsDates.last ?? firstDate
        
        let diff = (lastDate - firstDate) / Double(sectorsNumber)
        if diff == 0 {
            chartPointsChangedDelegate?.chartPointsChanged(points: [Point(x: 5.0, y: CGFloat(integerLiteral: requestsDates.count))])
            return
        }
        
        var sectorPoints: [Double] = []
        
        for i in 0...sectorsNumber {
            sectorPoints.append(firstDate + Double(i)*diff)
        }
        
        requestsDates.append(contentsOf: sectorPoints)
        requestsDates.sort(by: {$0 > $1})
        
        var previousIndex = 0
        for (i, sector) in sectorPoints.enumerated() {
            if let index = requestsDates.firstIndex(of: sector){
                let y = index - previousIndex
                previousIndex = index
                let point = Point(x: CGFloat(integerLiteral: i), y: CGFloat(integerLiteral: y))
                pointsArray.append(point)
            }
        }
        
        chartPointsChangedDelegate?.chartPointsChanged(points: pointsArray)
    }
    
}
