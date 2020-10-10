CREATE OR REPLACE VIEW structures_geojson_slice AS
SELECT
    id::VARCHAR,
    jurisdiction_id,
    jsonb_build_object(
        'type',         'Feature',
        'id',           id::VARCHAR,
        'geometry',     public.ST_AsGeoJSON(geometry)::jsonb,
        'properties',   to_jsonb(row) - 'id' - 'geometry'
    ) AS geojson
FROM locations
row;
