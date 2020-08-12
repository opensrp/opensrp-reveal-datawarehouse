--DROP MATERIALIZED VIEW pending.ntd_dispense_task_jurisdiction_report;
CREATE MATERIALIZED VIEW pending.ntd_dispense_task_jurisdiction_report AS
(WITH all_plan_jurisdiction_paths AS (
    SELECT
        top_level_plan_jurisdictions.plan_id,
        subset_jurisdiction_paths.*
    FROM (
            SELECT
                DISTINCT ntd_dispense_task_report.plan_id AS plan_id, all_plan_jurisdiction_paths.jurisdiction_path[1] AS top_level_jurisdiction_id
            FROM pending.ntd_dispense_task_report
            LEFT JOIN (
                SELECT jurisdiction_id,
                       jurisdiction_parent_id,
                       jurisdiction_name,
                       jurisdiction_depth,
                       jurisdiction_path,
                       jurisdiction_name_path,
                       jurisdiction_root_parent_id,
                       jurisdiction_root_parent_name
                FROM reveal_stage.jurisdictions_materialized_view
                ) AS all_plan_jurisdiction_paths
                ON ntd_dispense_task_report.jurisdiction_id = all_plan_jurisdiction_paths.jurisdiction_id
        ) AS top_level_plan_jurisdictions
    LEFT JOIN (
        SELECT jurisdiction_id,
               jurisdiction_parent_id,
               jurisdiction_name,
               jurisdiction_depth,
               jurisdiction_path,
               jurisdiction_name_path,
               jurisdiction_root_parent_id,
               jurisdiction_root_parent_name
        FROM reveal_stage.jurisdictions_materialized_view) AS subset_jurisdiction_paths
        ON ARRAY[top_level_plan_jurisdictions.top_level_jurisdiction_id] <@ subset_jurisdiction_paths.jurisdiction_path
)
--
-- ... now aggregate across all plan jurisdictions
--
SELECT
    uuid_generate_v5(
            '38f6f2d5-4e1e-42cc-9d21-c2e71710f2b7',
            concat(all_plan_jurisdiction_paths.plan_id, all_plan_jurisdiction_paths.jurisdiction_id)) AS id,
    all_plan_jurisdiction_paths.plan_id,
    all_plan_jurisdiction_paths.jurisdiction_id,
    MAX(all_plan_jurisdiction_paths.jurisdiction_depth) AS jurisdiction_depth,
    MAX(all_plan_jurisdiction_paths.jurisdiction_path) AS jurisdiction_id_path,
    MAX(all_plan_jurisdiction_paths.jurisdiction_name_path) AS jurisdiction_name_path,
    -- Metric for count confirmation
    COALESCE(SUM(registered_child), 0) AS sacregistered,
    -- Required metrics for District level - 2
    COALESCE(CASE WHEN SUM(registered_child) <> 0 AND all_plan_jurisdiction_paths.jurisdiction_depth = 2 AND all_plan_jurisdiction_paths.jurisdiction_name = 'Gwembe' THEN SUM(registered_child::DECIMAL)/25771 ELSE NULL END, 0) AS expectedchildren_found,
    COALESCE(CASE WHEN SUM(registered_child) <> 0 AND all_plan_jurisdiction_paths.jurisdiction_depth = 2 AND all_plan_jurisdiction_paths.jurisdiction_name = 'Gwembe' THEN SUM(nPzqDistribute::DECIMAL)/25771 ELSE NULL END, 0) AS expectedchildren_treated,
    -- Required metrics for each level
    COALESCE(CASE WHEN SUM(all_structures) <> 0 THEN SUM(structures_visited::DECIMAL)/SUM(all_structures) ELSE NULL END, 0) AS structures_visited_per,  
    COALESCE(CASE WHEN SUM(registered_child) <> 0 THEN SUM(nPzqDistribute::DECIMAL)/SUM(registered_child) ELSE NULL END, 0) AS registeredchildrentreated_per,
    COALESCE(SUM(nPzqDistributedQuantity), 0) AS total_pzqdistributed
    
FROM all_plan_jurisdiction_paths
LEFT JOIN
    (
        SELECT
            ntd_dispense_task_report.*,
            -- Transformation of client age for better calculations
            CASE WHEN client_age_category <> 'Adult' THEN 1 ELSE 0 END AS registered_child
        FROM pending.ntd_dispense_task_report
    ) AS ntd_dispense_task_report_ext
    ON all_plan_jurisdiction_paths.plan_id = ntd_dispense_task_report_ext.plan_id AND
       ARRAY[all_plan_jurisdiction_paths.jurisdiction_id] <@ ntd_dispense_task_report_ext.jurisdiction_id_path
GROUP BY
    id, all_plan_jurisdiction_paths.plan_id, all_plan_jurisdiction_paths.jurisdiction_id, all_plan_jurisdiction_paths.jurisdiction_depth, all_plan_jurisdiction_paths.jurisdiction_name)WITH DATA;

 -- Create unique ID
CREATE UNIQUE INDEX IF NOT EXISTS ntd_dispense_task_jurisdiction_report_index ON pending.ntd_dispense_task_jurisdiction_report (id);  