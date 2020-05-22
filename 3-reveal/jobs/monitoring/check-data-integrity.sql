-- Suggestion is to run this every 1 hr
SELECT check_data_integrity('orphaned_jurisdictions', 'jurisdictions');
SELECT check_data_integrity('missing_goal_actions', 'actions');
SELECT check_data_integrity('missing_subject_tasks', 'tasks');
