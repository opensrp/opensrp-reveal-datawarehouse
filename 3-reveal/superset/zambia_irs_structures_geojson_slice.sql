SELECT
    public.uuid_generate_v5(
    '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
    concat(structure_id, task_id)) AS id,
    structure_id,
    structure_jurisdiction_id as jurisdiction_id,
    task_id,
    plan_id,
    jsonb_build_object(
        'type',         'Feature',
        'id',           structure_id,
        'geometry',     ST_AsGeoJSON(structure_geometry)::jsonb,
        'properties',   to_jsonb(row) - 'structure_id' - 'structure_geometry'
    ) AS geojson
FROM (
    SELECT
        structure_id,
        structure_jurisdiction_id,
        structure_code,
        structure_name,
        structure_type,
        structure_geometry,
        task_id,
        plan_id,
        event_date,
        business_status,
        rooms_eligible,
        rooms_sprayed,
        eligibility,
        structure_sprayed,
        business_status
    FROM zambia_irs_structures
) row;
