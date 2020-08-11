--DROP VIEW pending.ntd_client_dispense_tasks CASCADE
CREATE MATERIALIZED VIEW pending.ntd_client_dispense_tasks AS
SELECT
    ntd_plans.identifier AS plan_id,
    plan_jurisdictions.jurisdiction_id AS jurisdiction_id,
    clients.id AS client_id,
    clients.residence AS client_location_id,
    ntd_tasks.identifier AS task_id,
    task_locations.id AS task_location_id,
    task_locations.parent_id AS task_jurisdiction_id,
    task_events.event_id AS event_id
--
-- Get all MDA-Point plans and clients
--
FROM
    (
        SELECT *
        FROM reveal_stage.plans
        WHERE
            intervention_type = 'MDA-Point' AND
            status = 'active'
    ) AS ntd_plans
LEFT JOIN(
SELECT jurisdiction_id, plan_id
FROM reveal_stage.plan_jurisdiction) plan_jurisdictions
    ON ntd_plans.identifier = plan_jurisdictions.plan_id
INNER JOIN reveal_stage.locations
    ON plan_jurisdictions.jurisdiction_id = locations.jurisdiction_id
INNER JOIN reveal_stage.clients
    ON locations.id = clients.residence
--
-- Get any tasks assigned to those clients
--
LEFT JOIN
    (
        SELECT *
        FROM reveal_stage.tasks
        WHERE code = 'MDA Dispense'
    ) AS ntd_tasks
    ON ntd_plans.identifier = ntd_tasks.plan_identifier AND
       clients.baseentityid = ntd_tasks.task_for
LEFT JOIN locations AS task_locations
    ON ntd_tasks.group_identifier = task_locations.id
--
-- ... and get the latest event attached to the task
--
LEFT JOIN
    (
        SELECT
            DISTINCT ON (events.task_id) task_id,
            events.id as event_id,
            events.base_entity_id as base_entity_id
        FROM reveal_stage.events events
        WHERE event_type = 'mda_dispense'
        ORDER BY
            events.task_id,
            events.server_version DESC
    ) AS task_events
    ON clients.baseentityid = task_events.base_entity_id AND
       ntd_tasks.identifier = task_events.task_id;
