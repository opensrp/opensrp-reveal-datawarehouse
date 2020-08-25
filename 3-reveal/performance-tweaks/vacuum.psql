--- vacuum the structures, tasks, and events tables
--- run every night at around 3am

-- stop running queries
SELECT
  pg_cancel_backend(pid) as canceled
FROM pg_stat_activity
WHERE (now() - pg_stat_activity.query_start) > interval '1 minutes'
AND usename in ('canopy', 'reveal');

-- vacuum stuff
SELECT NOW();
VACUUM (FULL, ANALYZE) tasks;
SELECT NOW();
VACUUM (FULL, ANALYZE) locations;
SELECT NOW();
VACUUM (FULL, ANALYZE) events;
SELECT NOW();
