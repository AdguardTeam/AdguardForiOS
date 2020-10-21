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
    var chartDateType: ChartDateType { get set }
    var chartDateTypeActivity: ChartDateType { get set }
    var chartRequestType: ChartRequestType { get set }
    
    var chartPointsChangedDelegates: [NumberOfRequestsChangedDelegate] { get set }
    
    func obtainStatistics(_ fromUI: Bool, _ completion: @escaping ()->())
}

protocol NumberOfRequestsChangedDelegate: class {
    func numberOfRequestsChanged(requestsCount: Int, encryptedCount: Int, averageElapsed: Double)
}

enum ChartRequestType {
    case requests, encrypted
}

class ChartViewModel: NSObject, ChartViewModelProtocol {
    
    var chartView: ChartView? {
        didSet {
            changeChart {}
        }
    }
    var chartPointsChangedDelegates: [NumberOfRequestsChangedDelegate] = []

    var chartDateType: ChartDateType = .alltime {
        didSet {
            changeChart {}
        }
    }
    
    var chartDateTypeActivity: ChartDateType = .alltime {
        didSet {
            countInfoNumbers()
        }
    }
    
    var chartRequestType: ChartRequestType = .requests {
        didSet {
            changeChart{}
        }
    }
    
    /**
     Saved statistics numbers for dynamic numbers change, otherwise it must be counted
     */
    private var requestsMain = 0
    private var encryptedMain = 0
    private var averageElapsedMain: Double = 0.0
    
    private var requestsActivity = 0
    private var encryptedActivity = 0
    private var averageElapsedActivity: Double = 0.0
    
    private var recordsByType: [ChartDateType: [DnsStatisticsRecord]] = [:]
    
    private let dateFormatter = DateFormatter()
    
    private var timer: Timer?
    
    private let dnsStatisticsService: DnsStatisticsServiceProtocol
    private let resources: AESharedResourcesProtocol
    
    /* Observers */
    private var resetSettingsToken: NotificationToken?
    
    private let chartProcessingQueue = DispatchQueue(label: "chart processing queue", qos: .userInitiated)
    private let activityStatisticsCountQueue = DispatchQueue(label: "activity statistics count queue", qos: .userInitiated)
    private let obtainStatisticsQueue = DispatchQueue(label: "obtainStatistics queue", qos: .userInitiated)
    
    // MARK: - init
    init(_ dnsStatisticsService: DnsStatisticsServiceProtocol, resources: AESharedResourcesProtocol) {
        self.dnsStatisticsService = dnsStatisticsService
        self.resources = resources
        super.init()
        
        addObservers()
        
        /* Waiting when statistics is obtained, to show ready statistics on main page, without redrawing it */
        let group = DispatchGroup()
        group.enter()
        obtainStatistics(false) { group.leave() }
        group.wait()
    }
    
    func obtainStatistics(_ fromUI: Bool, _ completion: @escaping ()->()) {
        obtainStatisticsQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.timer?.invalidate()
            self.timer = nil
            
            if fromUI {
                /*
                 Update from UI is only available from ActivityViewController
                 To speed up loading data from database we load only current type
                 */
                let records = self.dnsStatisticsService.getRecords(by: self.chartDateTypeActivity)
                self.recordsByType[self.chartDateTypeActivity] = records
                
            } else {
                /*
                 When updating data not from UI, we load data for all types to
                 be able quikly change chart when user wants
                */
                for type in ChartDateType.allCases {
                    let records = self.dnsStatisticsService.getRecords(by: type)
                    self.recordsByType[type] = records
                }
            }
            
            self.changeChart {
                completion()
            }
            
            self.timer = Timer.scheduledTimer(withTimeInterval: self.dnsStatisticsService.minimumStatisticSaveTime, repeats: true, block: {[weak self] (timer) in
                self?.obtainStatistics(false) {}
            })
        }
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - Observing Values from User Defaults
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == LastStatisticsSaveTime {
            obtainStatistics(false) {[weak self] in
                self?.countInfoNumbers()
            }
            return
        }
        
        for delegate in chartPointsChangedDelegates {
            if delegate is MainPageController {
                delegate.numberOfRequestsChanged(requestsCount: requestsMain, encryptedCount: encryptedMain, averageElapsed: averageElapsedMain)
            }
            else if delegate is ActivityViewController {
                delegate.numberOfRequestsChanged(requestsCount: requestsActivity, encryptedCount: encryptedActivity, averageElapsed: averageElapsedActivity)
            }
        }
    }
    
    // MARK: - private methods
    
    private func countInfoNumbers() {
        activityStatisticsCountQueue.async { [weak self] in
            guard let self = self, let records = self.recordsByType[self.chartDateTypeActivity] else { return }
            
            var requestsNumber: Int = 0
            var encryptedNumber = 0
            var elapsedSumm: Int = 0
            
            for record in records {
                requestsNumber += record.requests
                encryptedNumber += record.encrypted
                elapsedSumm += record.elapsedSumm
            }
            
            let averageElapsedTime = requestsNumber == 0 ? 0.0 : Double(elapsedSumm) / Double(requestsNumber)
            
            self.requestsActivity = requestsNumber
            self.encryptedActivity = encryptedNumber
            self.averageElapsedActivity = averageElapsedTime
            
            let delegate = self.chartPointsChangedDelegates.first(where: { $0 is ActivityViewController })
            delegate?.numberOfRequestsChanged(requestsCount: requestsNumber, encryptedCount: encryptedNumber, averageElapsed: averageElapsedTime)
        }
    }
    
    private func changeChart(_ completion: @escaping ()->()){
        chartProcessingQueue.async { [weak self] in
            guard let self = self, let records = self.recordsByType[self.chartDateType] else { return }
            let requestsInfo = self.getInfo(from: records)

            self.chartView?.chartPoints = (requestsInfo.requestsPoints, requestsInfo.encryptedPoints)
            
            self.requestsMain = requestsInfo.requestsNumber
            self.encryptedMain = requestsInfo.encryptedNumber
            self.averageElapsedMain = requestsInfo.averageElapsedTime
            
            let delegate = self.chartPointsChangedDelegates.first(where: { $0 is MainPageController })
            delegate?.numberOfRequestsChanged(requestsCount: requestsInfo.requestsNumber, encryptedCount: requestsInfo.encryptedNumber, averageElapsed: requestsInfo.averageElapsedTime)
            
            completion()
        }
    }
    
    private func getInfo(from records: [DnsStatisticsRecord]) -> (requestsPoints: [Point], requestsNumber: Int, encryptedPoints: [Point], encryptedNumber: Int, averageElapsedTime: Double){
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

        return (requestsPoints, requestsNumber, encryptedPoints, encryptedNumber, averageElapsedTime)
    }
    
    private func addObservers() {
        resetSettingsToken = NotificationCenter.default.observe(name: NSNotification.resetSettings, object: nil, queue: .main) { [weak self] (notification) in
            self?.obtainStatistics(false) {}
        }
        
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsRequests, options: .new, context: nil)
        
        resources.sharedDefaults().addObserver(self, forKeyPath: AEDefaultsEncryptedRequests, options: .new, context: nil)
        
        resources.sharedDefaults().addObserver(self, forKeyPath: LastStatisticsSaveTime, options: .new, context: nil)
    }
    
    private func removeObservers() {
        resources.sharedDefaults().removeObserver(self, forKeyPath: AEDefaultsRequests)
        resources.sharedDefaults().removeObserver(self, forKeyPath: AEDefaultsEncryptedRequests)
        resources.sharedDefaults().removeObserver(self, forKeyPath: LastStatisticsSaveTime)
    }
}
