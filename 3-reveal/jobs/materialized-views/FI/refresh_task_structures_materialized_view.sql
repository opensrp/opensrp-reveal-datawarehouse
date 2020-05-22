-- Suggestion is to refresh this every 10min
-- This is one of the most expensive views used in Reveal
SELECT refresh_mat_view('task_structures_materialized_view', TRUE);