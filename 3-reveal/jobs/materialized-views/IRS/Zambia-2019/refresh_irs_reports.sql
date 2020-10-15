-- Suggestion is to refresh this every 15min
SELECT refresh_mat_view('zambia_irs_structures', FALSE);
SELECT refresh_mat_view('zambia_irs_structures_data', TRUE);
SELECT refresh_mat_view('zambia_focus_area_irs', TRUE);
SELECT refresh_mat_view('zambia_irs_jurisdictions', TRUE);
