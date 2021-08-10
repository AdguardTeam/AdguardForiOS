ALTER TABLE [filter_groups] ADD [is_enabled] BOOLEAN NOT NULL DEFAULT 0;
ALTER TABLE [filters] ADD [recommended] BOOLEAN NOT NULL DEFAULT 0;

CREATE TABLE [filter_tags] (
    [filter_id] INTEGER NOT NULL,
    [tag_id] INTEGER NOT NULL,
    [type] INTEGER NOT NULL,
    [name] TEXT,
    CONSTRAINT [filter_tag_pkey] PRIMARY KEY ([filter_id], [tag_id])
);

UPDATE [version] set [schema_version] = "0.102";
