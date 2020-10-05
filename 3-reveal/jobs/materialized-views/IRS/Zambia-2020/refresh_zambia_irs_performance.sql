-- Suggestion is to refresh this every 1 hour
SELECT refresh_mat_view('zambia_irs_spray_event', TRUE);
SELECT refresh_mat_view('zambia_daily_summary_event', TRUE);
SELECT refresh_mat_view('zambia_irs_sop_performance', TRUE);
SELECT refresh_mat_view('zambia_irs_sop_date_performance', TRUE);
SELECT refresh_mat_view('zambia_irs_data_collector_performance', TRUE);
SELECT refresh_mat_view('zambia_irs_district_performance', TRUE);