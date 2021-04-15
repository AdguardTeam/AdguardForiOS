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

protocol StatisticsModelObserver: AnyObject {
    func statisticsChanged()
    func mainPageDateTypeChanged()
    func activityPageDateTypeChanged()
}

protocol StatisticsModelProtocol: AnyObject {
    var observers: [StatisticsModelObserver] { get set }
    
    var mainPageDateType: ChartDateType { get set }
    var activityPageDateType: ChartDateType { get set }
    
    /* Updates statistics records for provided type */
    func updateStatistics(for type: ChartDateType, _ completion: @escaping () -> Void)
    func statistics(for type: ChartDateType) -> StatisticsModel.Statistics
    func chartViewConfig(for type: ChartDateType) -> StatisticsChartModel.ChartViewConfig
}

final class StatisticsModel: NSObject, StatisticsModelProtocol {
    // MARK: - Public properties
    
    // TODO: - We need to transfer WeakArray from AdGuard VPN
    var observers: [StatisticsModelObserver] = []
    
    var mainPageDateType: ChartDateType {
        get {
            return resources.chartDateType
        }
        set {
            if newValue != mainPageDateType {
                resources.chartDateType = newValue
                mainPageDateTypeChanged()
            }
        }
    }
    
    var activityPageDateType: ChartDateType {
        get {
            return resources.activityStatisticsType
        }
        set {
            if newValue != activityPageDateType {
                resources.activityStatisticsType = newValue
                activityPageDateTypeChanged()
            }
        }
    }
    
    
    // MARK: - Private properties
    
    private var recordsByType: [ChartDateType: [DnsStatisticsRecord]] = [.alltime: [],
                                                                         .month: [],
                                                                         .week: [],
                                                                         .day: [],
                                                                         .today: []]
    private var statisticsByType: [ChartDateType: Statistics] = [.alltime: Statistics(),
                                                                 .month: Statistics(),
                                                                 .week: Statistics(),
                                                                 .day: Statistics(),
                                                                 .today: Statistics()]
    
    private let statisticsQueue = DispatchQueue(label: "model.statistics.queue", qos: .userInitiated)
    
    // We use timer to periodically update statistics, update interval depends on current ChartDateType
    private var timer: Timer?
    
    /* Observers */
    private var resetSettingsToken: NotificationToken?
    private var resetStatisticsToken: NotificationToken?
    
    /* Services */
    private let dnsStatistics: DnsStatisticsServiceProtocol
    private let resources: AESharedResourcesProtocol
    
    // MARK: - Object life cycle
    
    init(dnsStatistics: DnsStatisticsServiceProtocol, resources: AESharedResourcesProtocol) {
        self.dnsStatistics = dnsStatistics
        self.resources = resources
        super.init()
        
        addObservers()
        
        /* Initialize statistics */
        let group = DispatchGroup()
        group.enter()
        updateStatisticsInternal { group.leave() }
        group.wait()
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - Public methods
    
    func statistics(for type: ChartDateType) -> Statistics {
        let oldStatistics = statisticsByType[type]!
        let newStatistics = Statistics(allRequests: oldStatistics.allRequests + resources.tempRequestsCount,
                                       encryptedRequests: oldStatistics.encryptedRequests + resources.tempEncryptedRequestsCount,
                                       summElapsedTimeMs: oldStatistics.summElapsedTimeMs)
        return newStatistics
    }
    
    func updateStatistics(for type: ChartDateType, _ completion: @escaping () -> Void) {
        updateStatisticsInternal(for: type, completion)
    }
    
    func chartViewConfig(for type: ChartDateType) -> StatisticsChartModel.ChartViewConfig {
        let records = recordsByType[type]!
        let config = StatisticsChartModel.points(for: records, type)
        return config
    }
    
    // MARK: - Observing Values from User Defaults
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == LastStatisticsSaveTime {
            updateStatisticsInternal()
            return
        }
        statisticsChanged()
    }
    
    // MARK: - Private methods
    
    /*
     Updates statistics records for provided type
     If type is nil updates all types
     */
    private func updateStatisticsInternal(for type: ChartDateType? = nil, _ completion: (() -> Void)? = nil) {
        // Remove current timer
        DispatchQueue.main.async {
            self.timer?.invalidate()
            self.timer = nil
        }
        
        statisticsQueue.async { [weak self] in
            defer { completion?() }
            guard let self = self else { return }
            
            /*
             Update from UI is only available from ActivityViewController now
             To speed up loading data from database we load only current type
             */
            if let type = type {
                let records = self.dnsStatistics.getRecords(by: type)
                self.recordsByType[type] = records
            }
            /*
             When updating data not from UI, we load data for all types to
             be able quikly change chart when user wants
            */
            else {
                for type in ChartDateType.allCases {
                    let records = self.dnsStatistics.getRecords(by: type)
                    self.recordsByType[type] = records
                }
            }
            
            self.setActualStatistics(for: type)
            self.statisticsChanged()
            
            // Set timer to update statics records
            DispatchQueue.main.async { [weak self] in
                self?.timer = Timer.scheduledTimer(withTimeInterval: self?.dnsStatistics.minimumStatisticSaveTime ?? 0.0, repeats: true, block: { [weak self] _ in
                    self?.updateStatisticsInternal()
                })
            }
        }
    }
    
    /*
     Updates statistics objects for provided type
     If type is nil updates all types
     */
    private func setActualStatistics(for type: ChartDateType? = nil) {
        for tp in ChartDateType.allCases {
            // If type is nil update all types
            if type != nil, type != tp {
                continue
            }
            let records = recordsByType[tp]!
            var newStatistics = Statistics()
            for record in records {
                newStatistics += Statistics(allRequests: record.requests, encryptedRequests: record.encrypted, summElapsedTimeMs: record.elapsedSumm)
            }
            statisticsByType[tp]! = newStatistics
        }
    }
    
    // MARK: - Observers methods
    
    private func statisticsChanged() {
        observers.forEach { observer in
            DispatchQueue.main.async {
                observer.statisticsChanged()
            }
        }
    }
    
    private func mainPageDateTypeChanged() {
        observers.forEach { observer in
            DispatchQueue.main.async {
                observer.mainPageDateTypeChanged()
            }
        }
    }
    
    private func activityPageDateTypeChanged() {
        observers.forEach { observer in
            DispatchQueue.main.async {
                observer.activityPageDateTypeChanged()
            }
        }
    }
    
    private func addObservers() {
        resetSettingsToken = NotificationCenter.default.observe(name: NSNotification.resetSettings, object: nil, queue: .main) { [weak self] _ in
            self?.updateStatisticsInternal()
        }
        
        resetStatisticsToken = NotificationCenter.default.observe(name: NSNotification.resetStatistics, object: nil, queue: .main) { [weak self] _ in
            self?.updateStatisticsInternal()
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

// MARK: - StatisticsModel + Statistics

extension StatisticsModel {
    struct Statistics {
        let allRequests: Int
        let encryptedRequests: Int
        let summElapsedTimeMs: Int
        let averageElapsedTimeMs: Double
        
        init(allRequests: Int = 0, encryptedRequests: Int = 0, summElapsedTimeMs: Int = 0) {
            self.allRequests = allRequests
            self.encryptedRequests = encryptedRequests
            self.summElapsedTimeMs = summElapsedTimeMs
            
            if allRequests == 0 {
                self.averageElapsedTimeMs = 0
            } else {
                self.averageElapsedTimeMs = Double(summElapsedTimeMs) / Double(allRequests)
            }
        }
        
        static func +(left: Statistics, right: Statistics) -> Statistics {
            return Statistics(
                allRequests: left.allRequests + right.allRequests,
                encryptedRequests: left.encryptedRequests + right.encryptedRequests,
                summElapsedTimeMs: left.summElapsedTimeMs + right.summElapsedTimeMs
            )
        }
        
        static func +=(left: inout Statistics, right: Statistics) {
            left = left + right
        }
    }
}
