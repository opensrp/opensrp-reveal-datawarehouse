CREATE OR REPLACE VIEW zambia_irs_structures_geojson AS
SELECT
    id::VARCHAR,
    structure_id,
    structure_jurisdiction_id as jurisdiction_id,
    task_id,
    plan_id,
    jsonb_build_object(
        'type',         'Feature',
        'id',           structure_id,
        'geometry',     public.ST_AsGeoJSON(structure_geometry)::jsonb,
        'properties',   to_jsonb(row) - 'structure_id' - 'structure_geometry'
    ) AS geojson
FROM (
    SELECT
        id,
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
