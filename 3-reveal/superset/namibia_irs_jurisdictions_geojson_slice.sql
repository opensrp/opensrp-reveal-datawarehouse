SELECT
    structure_id,
    structure_jurisdiction_id as jurisdiction_id,
    task_id,
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
        nSprayableTotal,
        nSprayedTotalFirst,
        nSprayedTotalMop,
        householdAccessible,
        unsprayedReasonFirst,
        unsprayedReasonMop
    FROM namibia_irs_jurisdictions
) row;
