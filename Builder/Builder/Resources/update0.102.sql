ALTER TABLE [filter_rules] ADD [affinity] INTEGER NOT NULL DEFAULT 0;

UPDATE [version] set [schema_version] = "0.103";
