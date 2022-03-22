import Foundation

protocol RemoteMigrationService {
    /// Checks remote migration status on our backend
    func checkRemoteMigration(_ completion: @escaping (_ isNeedMigration: Bool) -> Void)
    var remoteMigrationShowed: Bool { get set }
    var isNeedRemoteMigration: Bool { get }
}
