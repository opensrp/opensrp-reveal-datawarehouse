INSERT INTO structures
VALUES
(
    '${id}',
    '${uid}',
    '${jurisdiction_id}',
    '${code}',
    '${type}',
    '${name:replace("'", "''")}',
    '${status}',
    ST_GeomFromGeoJSON('${geometry}'),
    ${geographicLevel},
    ${effective_start_date},
    ${effective_end_date},
    ${version},
    ${serverVersion}
)
ON CONFLICT (id) DO UPDATE
SET
    uid = '${uid}',
    jurisdiction_id = '${jurisdiction_id}',
    code = '${code}',
    type = '${type}',
    name = '${name:replace("'", "''")}',
    status = '${status}',
    geometry = ST_GeomFromGeoJSON('${geometry}'),
    geographic_level = ${geographicLevel},
    effective_start_date = ${effective_start_date},
    effective_end_date = ${effective_end_date},
    version = ${version},
    server_version = ${serverVersion};