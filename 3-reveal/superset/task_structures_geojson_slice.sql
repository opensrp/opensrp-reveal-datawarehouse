SELECT
    task_identifier,
    plan_id,
    jurisdiction_id,
    goal_id,
    jsonb_build_object(
        'type',         'Feature',
        'id',           task_identifier,
        'geometry',     ST_AsGeoJSON(structure_geometry)::jsonb,
        'properties',   to_jsonb(row) - 'task_identifier' - 'structure_geometry'
    ) AS geojson
FROM (
    SELECT
        task_identifier,
        plan_id,
        jurisdiction_id,
        task_status,
        task_business_status,
        task_focus,
        task_task_for,
        task_execution_start_date,
        task_execution_end_date,
        goal_id,
        action_code,
        jurisdiction_name,
        jurisdiction_parent_id,
        structure_id,
        structure_code,
        structure_name,
        structure_type,
        structure_geometry
    FROM task_structures_materialized_view
) row;
