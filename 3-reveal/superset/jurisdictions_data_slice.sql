CREATE OR REPLACE VIEW jurisdictions_data_slice AS
SELECT
    id as id,
    geographic_level as geographic_level,
    parent_id as parent_id,
    name as name
FROM jurisdictions;
