-- Suggestion is to refresh this every 10min
SELECT refresh_mat_view('task_structures_materialized_view', TRUE);
SELECT refresh_mat_view('events_jurisdictions_report', TRUE);
