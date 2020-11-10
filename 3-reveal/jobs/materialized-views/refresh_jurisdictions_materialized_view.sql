-- Suggestion is to refresh this every 1 hr
SELECT refresh_mat_view('jurisdictions_materialized_view', TRUE);
SELECT refresh_mat_view('jurisdictions_tree', TRUE);