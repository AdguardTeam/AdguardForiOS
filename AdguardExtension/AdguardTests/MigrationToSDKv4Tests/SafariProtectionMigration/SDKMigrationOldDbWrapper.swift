import SQLite

/// This object is a helper for SDK migraitons test
/// It is responsible for creating tables that were used in app 4.2 and earlier
final class SDKMigrationOldDbWrapper {

    private let oldDb: Connection

    init(dbUrl: URL) throws {
        self.oldDb = try Connection(dbUrl.path, readonly: false)
        try createOldTables()
    }

    func addGroup(
        groupId: Int,
        isEnabled: Bool
    ) throws {
        try oldDb.run(
            """
            INSERT INTO filter_groups (group_id, is_enabled)
            VALUES (?, ?)
            """,
            groupId, isEnabled
        )
    }

    func addFilter(
        filterId: Int,
        groupId: Int,
        isEnabled: Bool,
        version: String? = nil,
        lastUpdateTime: Int? = nil,
        displayNumber: Int = 0,
        name: String? = nil,
        description: String? = nil,
        homePage: String? = nil,
        subscriptionUrl: String? = nil
    ) throws {
        try oldDb.run(
            """
            INSERT INTO filters (filter_id, group_id, is_enabled, version, last_update_time, display_number, name, description, homepage, subscriptionUrl)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            filterId, groupId, isEnabled, version, lastUpdateTime, displayNumber, name, description, homePage, subscriptionUrl
        )
    }

    func addFilterRules(_ rules: [(
        filterId: Int,
        ruleId: Int,
        ruleText: String,
        isEnabled: Bool,
        affinity: Int?
    )]) throws {
        try rules.forEach {
            try oldDb.run(
                """
                INSERT INTO filter_rules (filter_id, rule_id, rule_text, is_enabled, affinity)
                VALUES (?, ?, ?, ?, ?)
                """,
                $0.filterId, $0.ruleId, $0.ruleText, $0.isEnabled, $0.affinity
            )
        }
    }

    /// For testing SDK migration we don't need all tables, they aren't used
    /// Create only useful tables
    private func createOldTables() throws {
        try oldDb.execute("""
            BEGIN TRANSACTION;

            CREATE TABLE filter_groups (
                group_id INTEGER NOT NULL PRIMARY KEY,
                is_enabled BOOLEAN NOT NULL DEFAULT 0
            );

            CREATE TABLE filter_rules (
                filter_id INTEGER NOT NULL,
                rule_id INTEGER NOT NULL,
                rule_text TEXT NOT NULL,
                is_enabled BOOLEAN NOT NULL DEFAULT 1,
                affinity INTEGER,
                CONSTRAINT filter_rules_pkey PRIMARY KEY (filter_id, rule_id)
            );

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

            COMMIT TRANSACTION;
            """
        )
    }
}
