CREATE OR REPLACE VIEW jurisdictions_geojson_slice AS
SELECT
    jurisdiction_id,
    jsonb_build_object(
        'type',         'Feature',
        'id',           jurisdiction_id,
        'geometry',     public.ST_AsGeoJSON(jurisdiction_geometry)::jsonb,
        'properties',   to_jsonb(row) - 'jurisdiction_id' - 'jurisdiction_geometry'
    ) AS geojson
FROM (
    SELECT
        jurisdiction_id,
        jurisdiction_name,
        jurisdiction_parent_id,
        jurisdiction_geometry
    FROM plans_materialzied_view
) row;
