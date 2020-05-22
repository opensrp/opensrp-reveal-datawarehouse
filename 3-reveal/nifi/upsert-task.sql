INSERT INTO tasks
VALUES
(
    '${task_id}',
    '${plan_identifier}',
    '${groupIdentifier}',
    '${task_status}',
    '${task_business_status}',
    '${task_priority}',
    '${task_code}',
    '${description}',
    '${focus}',
    '${task_for}',
    '${task_execution_start_date}',
    '${task_execution_end_date}',
    '${task_owner}',
    ${note},
    ${serverVersion:replaceEmpty(0)}
)
ON CONFLICT (identifier) DO UPDATE
SET
    plan_identifier = '${plan_identifier}',
    group_identifier = '${groupIdentifier}',
    status = '${task_status}',
    business_status = '${task_business_status}',
    priority = '${task_priority}',
    code = '${task_code}',
    description = '${description}',
    focus = '${focus}',
    task_for = '${task_for}',
    execution_start_date = '${task_execution_start_date}',
    execution_end_date = '${task_execution_end_date}',
    owner = '${task_owner}',
    note = ${note},
    server_version = ${serverVersion:replaceEmpty(0)};