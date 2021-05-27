ALTER TABLE [filter_rules] ADD [affinity] INTEGER;

UPDATE [version] set [schema_version] = "0.103";
