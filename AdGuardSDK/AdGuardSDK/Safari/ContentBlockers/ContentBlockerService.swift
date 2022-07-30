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

import SharedAdGuardSDK

public protocol ContentBlockerServiceProtocol {
    /* Returns every content blocker reloading state */
    var reloadingContentBlockers: [ContentBlockerType: Bool] { get }

    /* Returns every content blocker state */
    var allContentBlockersStates: [ContentBlockerType: Bool] { get }

    /*
     Updates all content blockers
     Returns error if it occured during update
     Returns nil if everything is fine
     */
    func updateContentBlockers(onContentBlockersUpdated: @escaping (_ error: Error?) -> Void)

    /* Returns state of the specified content blocker */
    func getState(for cbType: ContentBlockerType) -> Bool
}

/* This class is responsible for updating Safari content blockers */
final public class ContentBlockerService: ContentBlockerServiceProtocol {

    // MARK: - Public  properties

    public private(set) var reloadingContentBlockers: [ContentBlockerType: Bool]

    public var allContentBlockersStates: [ContentBlockerType: Bool] {
        var result: [ContentBlockerType : Bool] = [:]
        ContentBlockerType.allCases.forEach { result[$0] = getState(for: $0) }
        return result
    }

    // MARK: - Private properties

    // Queue for updating content blockers
    private let updateQueue = DispatchQueue(label: "AdGuardSDK.ContentBlockerService.updateQueue", qos: .background)

    /* Services */
    private let appBundleId: String
    private let contentBlockersManager: ContentBlockersManagerProtocol

    // MARK: - Initialization

    public init(appBundleId: String) {
        self.appBundleId = appBundleId
        self.contentBlockersManager = ContentBlockersManager()
        self.reloadingContentBlockers = Self.emptyReloadingStates()
    }

    init(
        appBundleId: String,
        contentBlockersManager: ContentBlockersManagerProtocol = ContentBlockersManager()
    ) {
        self.appBundleId = appBundleId
        self.contentBlockersManager = contentBlockersManager
        self.reloadingContentBlockers = Self.emptyReloadingStates()
    }

    // MARK: - Internal methods

    public func updateContentBlockers(onContentBlockersUpdated: @escaping (_ error: Error?) -> Void) {
        updateQueue.async { [weak self] in
            Logger.logInfo("(ContentBlockerService) - updateContentBlockers; CBs update started")

            NotificationCenter.default.contentBlockersUpdateStarted()
            let updateError = self?.updateContentBlockersSync()
            NotificationCenter.default.contentBlockersUpdateFinished()

            Logger.logInfo("(ContentBlockerService) - updateContentBlockers; CBs update finished")
            onContentBlockersUpdated(updateError)
        }
    }

    public func getState(for cbType: ContentBlockerType) -> Bool {
        let group = DispatchGroup()
        let cbBundleId = cbType.contentBlockerBundleId(appBundleId)
        var isEnabled = false
        group.enter()
        contentBlockersManager.getStateOfContentBlocker(withId: cbBundleId) { result in
            switch result {
            case .success(let enabled):
                isEnabled = enabled
            case .error(let error):
                Logger.logError("(ContentBlockerService) - getState; Failed to reveal CB state, suppose it is disabled; Error: \(error)")
            }
            group.leave()
        }
        group.wait()
        return isEnabled
    }

    // MARK: - Private methods

    /// Helper function to avoid duplicate code in init
    private static func emptyReloadingStates() -> [ContentBlockerType: Bool] {
        var reloadingStates: [ContentBlockerType: Bool] = [:]
        ContentBlockerType.allCases.forEach {
            reloadingStates[$0] = false
        }
        return reloadingStates
    }

    /*
     Updates all content blockers syncroniously.
     Returns error if some content blockers were failed to be updated.
     Returns nil if update successeded.
     */
    private func updateContentBlockersSync() -> Error? {
        var resultError: Error?
        let group = DispatchGroup()

        for cb in ContentBlockerType.allCases {
            group.enter()
            reloadContentBlocker(for: cb) { error in
                if let error = error {
                    resultError = error
                }
                group.leave()
            }
        }
        group.wait()

        return resultError
    }

    // Reloads safari content blocker. If fails for the first reload than tries to reload it once more
    private func reloadContentBlocker(for cbType: ContentBlockerType, firstTry: Bool = true, _ onContentBlockerReloaded: @escaping (_ error: Error?) -> Void) {
        // Notify CB started to reload
        if firstTry {
            NotificationCenter.default.standaloneContentBlockerUpdateStarted(cbType)
        }

        let cbBundleId = cbType.contentBlockerBundleId(appBundleId)

        // Try to reload content blocker
        contentBlockersManager.reloadContentBlocker(withId: cbBundleId) { [weak self] error in
            guard let self = self else {
                Logger.logError("(ContentBlockerService) - reloadContentBlocker; сontentBlockersManager.reloadContentBlocker self is missing!")
                onContentBlockerReloaded(CommonError.missingSelf)
                NotificationCenter.default.standaloneContentBlockerUpdateFinished(cbType)
                return
            }

            if let userInfo = (error as NSError?)?.userInfo {
                Logger.logError("(ContentBlockerService) - reloadContentBlocker; Error reloading content blocker; Error: \(userInfo)")
                // Sometimes Safari fails to register a content blocker because of inner race conditions, so we try to reload it second time
                if firstTry {
                    // Do not notify when CB finished to reload if it was first try and there will be second reload
                    self.reloadContentBlocker(for: cbType, firstTry: false, onContentBlockerReloaded)
                } else {
                    NotificationCenter.default.standaloneContentBlockerUpdateFinished(cbType)
                    onContentBlockerReloaded(error)
                }
            }
            else {
                NotificationCenter.default.standaloneContentBlockerUpdateFinished(cbType)
                onContentBlockerReloaded(nil)
            }
        }
    }
}

// MARK: - ContentBlockerType + contentBlockerBundleId

extension ContentBlockerType {
    func contentBlockerBundleId(_ mainAppBundleId: String) -> String {
        switch self {
        case .general: return "\(mainAppBundleId).extension"
        case .privacy: return "\(mainAppBundleId).extensionPrivacy"
        case .socialWidgetsAndAnnoyances: return "\(mainAppBundleId).extensionAnnoyances"
        case .other: return "\(mainAppBundleId).extensionOther"
        case .custom: return "\(mainAppBundleId).extensionCustom"
        case .security: return "\(mainAppBundleId).extensionSecurity"
        }
    }
}

// MARK: - NotificationCenter + Content blockers reload events

fileprivate extension ContentBlockerType {
    // String constant for user info
    static let contentBlockerType = "contentBlockerType"
}

fileprivate extension NSNotification.Name {
    static var contentBlockersUpdateStarted: NSNotification.Name { .init(rawValue: "AdGuardSDK.contentBlockersUpdateStarted") }
    static var contentBlockersUpdateFinished: NSNotification.Name { .init(rawValue: "AdGuardSDK.contentBlockersUpdateFinished") }

    // Notifications for every Content Blocker
    static var standaloneContentBlockerUpdateStarted: NSNotification.Name { .init(rawValue: "AdGuardSDK.standaloneContentBlockerUpdateStarted") }
    static var standaloneContentBlockerUpdateFinished: NSNotification.Name { .init(rawValue: "AdGuardSDK.standaloneContentBlockerUpdateFinished") }
}

fileprivate extension NotificationCenter {
    func contentBlockersUpdateStarted() {
        self.post(name: .contentBlockersUpdateStarted, object: self, userInfo: nil)
    }

    func contentBlockersUpdateFinished() {
        self.post(name: .contentBlockersUpdateFinished, object: self, userInfo: nil)
    }

    func standaloneContentBlockerUpdateStarted(_ cbType: ContentBlockerType) {
        let userInfo = [ContentBlockerType.contentBlockerType: cbType]
        self.post(name: .standaloneContentBlockerUpdateStarted, object: nil, userInfo: userInfo)
    }

    func standaloneContentBlockerUpdateFinished(_ cbType: ContentBlockerType) {
        let userInfo = [ContentBlockerType.contentBlockerType: cbType]
        self.post(name: .standaloneContentBlockerUpdateFinished, object: nil, userInfo: userInfo)
    }
}

public extension NotificationCenter {
    func contentBlockersUpdateStart(queue: OperationQueue? = .main, handler: @escaping () -> Void) -> NotificationToken {
        return self.observe(name: .contentBlockersUpdateStarted, object: nil, queue: queue) { _ in
            handler()
        }
    }

    func contentBlockersUpdateFinished(queue: OperationQueue? = .main, handler: @escaping () -> Void) -> NotificationToken {
        return self.observe(name: .contentBlockersUpdateFinished, object: nil, queue: queue) { _ in
            handler()
        }
    }

    func standaloneContentBlockerUpdateStarted(queue: OperationQueue? = .main, handler: @escaping (_ cbType: ContentBlockerType) -> Void) -> NotificationToken {
        return self.observe(name: .standaloneContentBlockerUpdateStarted, object: nil, queue: queue) { note in
            let userInfo = note.userInfo!
            let cbType = userInfo[ContentBlockerType.contentBlockerType] as! ContentBlockerType
            handler(cbType)
        }
    }

    func standaloneContentBlockerUpdateFinished(queue: OperationQueue? = .main, handler: @escaping (_ cbType: ContentBlockerType) -> Void) -> NotificationToken {
        return self.observe(name: .standaloneContentBlockerUpdateStarted, object: nil, queue: queue) { note in
            let userInfo = note.userInfo!
            let cbType = userInfo[ContentBlockerType.contentBlockerType] as! ContentBlockerType
            handler(cbType)
        }
    }
}
