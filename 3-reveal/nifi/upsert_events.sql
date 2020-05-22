INSERT INTO events (
    id,
    base_entity_id,
    location_id,
    event_type,
    provider_id,
    date_created,
    event_date,
    entity_type,
    form_data,
    task_id,
    team_id,
    server_version
)
VALUES (
    '${id}',
    '${baseEntityId}',
    '${locationId}',
    '${eventType}',
    '${providerId}',
    to_timestamp(${dateCreated}/1000),
    to_timestamp(${eventDate}/1000),
    '${entityType}',
    '${obs}',
    '${details_taskIdentifier}',
    '${teamId}',
    '${serverVersion}'
)
ON CONFLICT (id) DO UPDATE
SET
    base_entity_id = '${baseEntityId}',
    location_id = '${locationId}',
    event_type = '${eventType}',
    provider_id = '${providerId}',
    date_created = to_timestamp(${dateCreated}/1000),
    event_date = to_timestamp(${eventDate}/1000),
    entity_type = '${entityType}',
    form_data = '${obs}'::jsonb,
    task_id = '${details_taskIdentifier}',
    team_id = '${teamId}',
    server_version = '${serverVersion}';
