import Foundation

protocol RemoteMigrationService {
    /// Checks remote migration status on our backend
    func checkRemoteMigration(_ completion: @escaping (_ isNeedMigration: Bool) -> Void)

    /// The status of the need for remote migration
    var isNeedRemoteMigration: Bool { get }
}
