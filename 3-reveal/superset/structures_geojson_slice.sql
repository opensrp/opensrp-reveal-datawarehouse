SELECT
    id,
    jurisdiction_id,
    jsonb_build_object(
        'type',         'Feature',
        'id',           id,
        'geometry',     ST_AsGeoJSON(geometry)::jsonb,
        'properties',   to_jsonb(row) - 'id' - 'geometry'
    ) AS geojson
FROM structures
row;
