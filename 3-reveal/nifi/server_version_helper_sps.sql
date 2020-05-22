
CREATE OR REPLACE FUNCTION record_pending_server_version(TEXT) RETURNS void AS
$$

DECLARE
  sql TEXT;
BEGIN

	CREATE TABLE IF NOT EXISTS  _meta_server_versions (
		table_name TEXT PRIMARY KEY,
		max_server_version BIGINT,
		ts TIMESTAMP WITH TIME ZONE,
		pending_server_version BIGINT,
		pending_ts TIMESTAMP WITH TIME ZONE);

	sql := FORMAT('INSERT INTO _meta_server_versions (table_name, pending_server_version, pending_ts) ' ||
		          '(SELECT ''%s'', MAX(server_version), NOW() FROM %s) ' ||
		          'ON CONFLICT (table_name) DO UPDATE SET pending_server_version = EXCLUDED.pending_server_version, pending_ts = NOW();', $1, $1);

	EXECUTE sql;
END

$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION promote_pending_server_version(TEXT) RETURNS void AS
$$

DECLARE
  sql TEXT;
BEGIN
	
	sql := FORMAT('UPDATE _meta_server_versions ' ||
				  'SET max_server_version = pending_server_version, ts = pending_ts ' ||
				  'WHERE table_name = ''%s''', $1);

	EXECUTE sql;
END

$$
LANGUAGE plpgsql;