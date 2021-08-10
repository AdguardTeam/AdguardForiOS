ALTER TABLE [filters] ADD [subscriptionUrl] TEXT;

UPDATE [version] set [schema_version] = "0.101";