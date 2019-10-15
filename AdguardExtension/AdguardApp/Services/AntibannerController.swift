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

/** AntibannerController this class is responsible for Antibanner life cycle */
@objc
protocol AntibannerControllerProtocol {
    
    // start antibanner
    func start()
    
    // Execute block of code, when antibanner is ready to work
    // We must block the gui until the anti-banner is initialized.
    // Otherwise, we display incorrect information on some screens.
    func onReady(_ block: @escaping  (_ antibanner: AESAntibannerProtocol)->Void)
}

struct ReadyFlag: OptionSet {
    
    let rawValue: UInt8
    
    static let notReady = ReadyFlag(rawValue: 0)
    static let installed = ReadyFlag(rawValue: 1)
    static let databaseReady = ReadyFlag(rawValue: 2)
    
    static let ready = installed.union(databaseReady)
}

class AntibannerController: AntibannerControllerProtocol {
    
    private let startQueue = DispatchQueue(label: "antibanner controller start")
    private let readyQueue = DispatchQueue(label: "antibanner controller ready")
    private let workQueue = DispatchQueue(label: "antibanner controller work")
    private let antibanner: AESAntibannerProtocol
    
    private var started = false
    private var readyFlag = ReadyFlag.notReady
    private var onReadyBlocks:[(AESAntibannerProtocol)->Void] = []
    
    init(antibanner: AESAntibannerProtocol) {
        self.antibanner = antibanner
        
        // Subscribing to Antibanner notifications
        NotificationCenter.default.addObserver(forName: Notification.Name.ASAntibannerReady, object: self, queue: nil) { [weak self] (notification) in
            self?.checkForServiceReady(readyFlag: .databaseReady)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.ASAntibannerInstalled, object: self, queue: nil) { [weak self] (notification) in
            self?.checkForServiceReady(readyFlag: .installed)
        }
    }
    
    func start() {
        startQueue.async { [weak self] in
            guard let sSelf = self else { return }
            if sSelf.started { return }
            
            sSelf.antibanner.start()
            sSelf.started = true
        }
    }
    
    func onReady(_ block: @escaping (_ antibanner: AESAntibannerProtocol) -> Void) {
        
        readyQueue.async { [weak self] in
            guard let sSelf = self else { return }
            
            sSelf.onReadyBlocks.append(block)
            
            if sSelf.readyFlag == .ready {
                sSelf.pushReadyBlocksToWorkingQueue()
            }
        }
    }
    
    // MARK: - private methods
    
    private func pushReadyBlocksToWorkingQueue() {

        for block in onReadyBlocks {
            workQueue.async { [weak self] in
                guard let sSelf = self else { return }
                block(sSelf.antibanner)
            }
        }
        onReadyBlocks.removeAll()
    }
    
    func checkForServiceReady(readyFlag: ReadyFlag){

        readyQueue.async { [weak self] in
            guard let sSelf = self else { return }
            sSelf.readyFlag.insert(readyFlag)
            
            if sSelf.readyFlag == .ready {
                sSelf.pushReadyBlocksToWorkingQueue()
            }
        }
    }
}
