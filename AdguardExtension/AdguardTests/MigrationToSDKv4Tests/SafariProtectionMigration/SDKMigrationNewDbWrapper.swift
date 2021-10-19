import SQLite

/// This object is a helper for SDK migraitons test
/// It is responsible for creating mock tables that is used in app 4.3
final class SDKMigrationNewDbWrapper {

    private let dbPath: String

    init(dbPath: String) {
        self.dbPath = dbPath
    }

    func createDbFile() {
        FileManager.default.createFile(atPath: dbPath, contents: nil, attributes: [:])
    }

    func createMockTableForFilters() throws {
        let db = try Connection(dbPath, readonly: false)
        try db.run("""
            CREATE TABLE filters (
                filter_id INTEGER NOT NULL PRIMARY KEY,
                group_id INTEGER NOT NULL DEFAULT 0,
                is_enabled BOOLEAN NOT NULL DEFAULT 1,
                version TEXT,
                last_update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                last_check_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                editable BOOLEAN NOT NULL DEFAULT 0,
                display_number INTEGER NOT NULL DEFAULT 0,
                name TEXT,
                description TEXT,
                homepage TEXT,
                removable BOOLEAN NOT NULL DEFAULT 1,
                expires INTEGER,
                subscriptionUrl TEXT
            );
            """
        )
    }

    func getAllFilters() throws -> [CustomFiltersTable] {
        let db = try Connection(dbPath, readonly: false)
        let query = CustomFiltersTable.table
        return try db.prepare(query).map { row in
            return CustomFiltersTable(dbFilter: row)
        }
    }
}

extension SDKMigrationNewDbWrapper {
    /* SQLite library wrapper for `filters` table */
    struct CustomFiltersTable: Equatable {
        let filterId: Int
        let groupId: Int
        let isEnabled: Bool
        let version: String?
        let lastUpdateTime: Date?
        let lastCheckTime: Date?
        let editable: Bool
        let displayNumber: Int
        let name: String?
        let description: String?
        let homePage: String?
        let removable: Bool
        let expires: Int?
        let subscriptionUrl: String?

        // Table name
        static let table = Table("filters")

        // Columns names
        static let filterId = Expression<Int>("filter_id")
        static let groupId = Expression<Int>("group_id")
        static let isEnabled = Expression<Bool>("is_enabled")
        static let version = Expression<String?>("version")
        static let lastUpdateTime = Expression<Date?>("last_update_time")
        static let lastCheckTime = Expression<Date?>("last_check_time")
        static let editable = Expression<Bool>("editable")
        static let displayNumber = Expression<Int>("display_number")
        static let name = Expression<String?>("name")
        static let description = Expression<String?>("description")
        static let homePage = Expression<String?>("homepage")
        static let removable = Expression<Bool>("removable")
        static let expires = Expression<Int?>("expires")
        static let subscriptionUrl = Expression<String?>("subscriptionUrl")

        init(dbFilter: Row) {
            self.filterId = dbFilter[CustomFiltersTable.filterId]
            self.groupId = dbFilter[CustomFiltersTable.groupId]
            self.isEnabled = dbFilter[CustomFiltersTable.isEnabled]
            self.version = dbFilter[CustomFiltersTable.version]
            self.lastUpdateTime = dbFilter[CustomFiltersTable.lastUpdateTime]
            self.lastCheckTime = dbFilter[CustomFiltersTable.lastCheckTime]
            self.editable = dbFilter[CustomFiltersTable.editable]
            self.displayNumber = dbFilter[CustomFiltersTable.displayNumber]
            self.name = dbFilter[CustomFiltersTable.name]
            self.description = dbFilter[CustomFiltersTable.description]
            self.homePage = dbFilter[CustomFiltersTable.homePage]
            self.removable = dbFilter[CustomFiltersTable.removable]
            self.expires = dbFilter[CustomFiltersTable.expires]
            self.subscriptionUrl = dbFilter[CustomFiltersTable.subscriptionUrl]
        }
    }
}
