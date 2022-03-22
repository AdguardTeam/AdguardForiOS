import Foundation

final class RemoteMigrationServiceImpl : RemoteMigrationService {

    private let httpRequestService: HttpRequestServiceProtocol
    private let userNotificationCenter: UserNotificationServiceProtocol
    private let keyChainService: KeychainServiceProtocol
    private let resources: AESharedResourcesProtocol

    private let workingQueue = DispatchQueue(label: "\(RemoteMigrationServiceImpl.self).workingQueue")
    private let completionQueue = DispatchQueue(label: "\(RemoteMigrationServiceImpl.self).completionQueue")
    private let syncQueue = DispatchQueue(label: "\(RemoteMigrationServiceImpl.self).syncQueue")

    private var _remoteMigrationShowed = false
    private var _isNeedRemoteMigration: Bool = false

    var remoteMigrationDialogShown: Bool {
        get {
            syncQueue.sync { _remoteMigrationShowed }
        }
        set {
            syncQueue.sync { _remoteMigrationShowed = newValue }
        }
    }

    var isNeedRemoteMigration: Bool {
        get {
            syncQueue.sync { _isNeedRemoteMigration }
        }
        set {
            syncQueue.sync { _isNeedRemoteMigration = newValue }
        }
    }

    init(httpRequestService: HttpRequestServiceProtocol,
         userNotificationCenter: UserNotificationServiceProtocol,
         keyChainService: KeychainServiceProtocol,
         resources: AESharedResourcesProtocol
    ) {
        self.httpRequestService = httpRequestService
        self.userNotificationCenter = userNotificationCenter
        self.keyChainService = keyChainService
        self.resources = resources

        _isNeedRemoteMigration = resources.backgroundFetchRemoteMigrationRequestResult
    }

    func checkRemoteMigration(_ completion: @escaping (_ isNeedMigration: Bool) -> Void) {
        DDLogInfo("(RemoteMigrationServiceImpl) - Start checking remote migration")
        guard let appId = keyChainService.appId else {
            DDLogError("(RemoteMigrationServiceImpl) - Failed ro retrieve appId")
            return
        }
        workingQueue.async {
            self.checkRemoteMigrationInternal(appId) {
                self.isNeedRemoteMigration = $0
                completion($0)
                DDLogInfo("(RemoteMigrationServiceImpl) - Start posting 'need for migration' notification")
                NotificationCenter.default.post(name: .needForMigration, object: self, userInfo: nil)
            }
        }
    }

    private func checkRemoteMigrationInternal(_ appId: String, _ completion: @escaping (_ isNeedMigration: Bool) -> Void) {
        httpRequestService.checkRemoteMigration(appId) { result in
            let isNeedRemoteMigration: Bool
            switch result {
                case .success(let status):
                    DDLogInfo("(RemoteMigrationServiceImpl) - Successfully check migration status. Is migration need = \(status)")
                    isNeedRemoteMigration = status
                case .failure(let error):
                    DDLogError("(RemoteMigrationServiceImpl) - Failed to check migration status. Return false as default status. Error: \(error)")
                    isNeedRemoteMigration = false
            }

            self.completionQueue.async { completion(isNeedRemoteMigration) }
        }
    }
}
