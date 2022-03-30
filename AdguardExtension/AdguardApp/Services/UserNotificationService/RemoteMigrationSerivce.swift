import Foundation

protocol RemoteMigrationService {
    /// Checks remote migration status on our backend
    func checkRemoteMigration(_ completion: @escaping (_ isNeedMigration: Bool) -> Void)

    /// Flag meaning that remote migration information dialog has been shown
    var remoteMigrationDialogShown: Bool { get set }

    /// The status of the need for remote migration
    var isNeedRemoteMigration: Bool { get }
}
