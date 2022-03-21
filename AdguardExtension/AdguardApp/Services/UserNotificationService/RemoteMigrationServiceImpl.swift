import Foundation

final class RemoteMigrationServiceImpl : RemoteMigrationService {
    private let httpRequestService: HttpRequestServiceProtocol
    private let userNotificationCenter: UserNotificationServiceProtocol

    private let workingQueue = DispatchQueue(label: "\(RemoteMigrationServiceImpl.self).workingQueue")
    private let completionQueue = DispatchQueue(label: "\(RemoteMigrationServiceImpl.self).completionQueue")
    private let syncQueue = DispatchQueue(label: "\(RemoteMigrationServiceImpl.self).syncQueue")

    private var _remoteMigrationShowed = false
    private var _isNeedMigration = false


    var isNeedMigration: Bool {
        get {
            syncQueue.sync { _isNeedMigration }
        }
        set {
            syncQueue.sync { _isNeedMigration = newValue }
        }
    }

    var remoteMigrationShowed: Bool {
        get {
            syncQueue.sync { _remoteMigrationShowed }
        }
        set {
            syncQueue.sync { _remoteMigrationShowed = newValue }
        }
    }

    init(httpRequestService: HttpRequestServiceProtocol,
         userNotificationCenter: UserNotificationServiceProtocol
    ) {
        self.httpRequestService = httpRequestService
        self.userNotificationCenter = userNotificationCenter
    }

    func checkRemoteMigration(_ completion: @escaping (_ isNeedMigration: Bool) -> Void) {
        DDLogInfo("(RemoteMigrationServiceImpl) - Start checking remote migration")
        workingQueue.async {
            self.checkRemoteMigrationInternal {
                self.isNeedMigration = true // FIXME: Use $0; true or false only for mock backend answers
                completion($0)
                NotificationCenter.default.post(name: .remoteMigrationStatusChanged, object: self, userInfo: nil)
            }
        }
    }

    private func checkRemoteMigrationInternal(_ completion: @escaping (_ isNeedMigration: Bool) -> Void) {
        httpRequestService.checkRemoteMigration { result in
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
