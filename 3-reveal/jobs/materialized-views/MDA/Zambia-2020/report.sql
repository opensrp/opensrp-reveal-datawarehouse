-- Suggestion is to refresh this every 25min
SELECT refresh_mat_view('ntd_dispense_task_metrics', TRUE);
SELECT refresh_mat_view('ntd_visit_structure_task_metrics', TRUE);
SELECT refresh_mat_view('ntd_structure_metrics', TRUE);
SELECT refresh_mat_view('ntd_dispense_plan_metrics', TRUE);
SELECT refresh_mat_view('ntd_visit_structure_plan_metrics', TRUE);
SELECT refresh_mat_view('ntd_structure_plan_metrics', TRUE);
--
SELECT refresh_mat_view('ntd_mda_jurisdictions', TRUE);