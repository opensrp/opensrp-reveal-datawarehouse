CREATE OR REPLACE VIEW ntd_dispense_tasks2 AS
SELECT
    -- events.id AS event_id,
    tasks.plan_identifier AS plan_id,
    tasks.group_identifier AS jurisdiction_id,
    -- jurisdictions_materialized_view.jurisdiction_path AS pathx,
    -- CASE
    --     WHEN events.form_data->>'nPzqDistribute' = 'Yes' THEN 1
    --     ELSE 0
    -- END AS nPzqDistribute,
    -- CASE
    --     WHEN events.form_data->>'availableForTreatment' = 'Yes' THEN 1
    --     ELSE 0
    -- END AS availableForTreatment,
    -- COALESCE(COALESCE(events.form_data->>'nPzqDistributedQuantity', '0')::DECIMAL, 0) AS nPzqDistributedQuantity
    array_concat_agg(DISTINCT jurisdictions_materialized_view.jurisdiction_path) AS jurisdiction_path,
    COALESCE(COUNT(events.id) FILTER (WHERE events.form_data->>'nPzqDistribute' IN ('Yes')), 0) AS nPzqDistribute,
    COALESCE(COUNT(events.id) FILTER (WHERE events.form_data->>'availableForTreatment' IN ('Yes')), 0) AS availableForTreatment,
    COALESCE(SUM(COALESCE(events.form_data->>'nPzqDistributedQuantity', '0')::DECIMAL), 0) AS nPzqDistributedQuantity
FROM events
LEFT JOIN clients ON clients.baseentityid = events.base_entity_id
LEFT JOIN tasks ON events.task_id = tasks.identifier
LEFT JOIN jurisdictions_materialized_view ON jurisdictions_materialized_view.jurisdiction_id = tasks.group_identifier
WHERE event_type = 'mda_dispense'
    -- AND tasks.plan_identifier = 'c9d28842-f5df-5112-b4ae-2ac24d20795f'
    -- AND tasks.group_identifier = '842f7aff-572b-44bc-b1ce-c6387b1afafz'
GROUP BY tasks.plan_identifier, tasks.group_identifier;

CREATE OR REPLACE VIEW ntd_visit_structures AS
SELECT
    -- t1.identifier AS task_id,
    t1.plan_identifier AS plan_id,
    t1.group_identifier AS jurisdiction_id,
    -- COALESCE(c1.attributes->>'nsac', '0') AS nsac
    array_concat_agg(DISTINCT jurisdictions_materialized_view.jurisdiction_path) AS jurisdiction_path,
    COUNT(t1.identifier) AS structures_visited,
    COALESCE(SUM(COALESCE(c1.attributes->>'nsac', '0')::DECIMAL), 0) AS sacregistered
FROM tasks AS t1
LEFT JOIN events AS e1
    ON t1.identifier = e1.task_id AND e1.event_type IN ('Family Registration', 'Family_Registration')
LEFT JOIN clients AS c1
    ON e1.base_entity_id = c1.baseentityid
LEFT JOIN jurisdictions_materialized_view
    ON jurisdictions_materialized_view.jurisdiction_id = t1.group_identifier
WHERE t1.code IN ('Structure_Visited', 'Structure Visited')
    AND t1.status IN ('Completed')
    -- AND t1.plan_identifier = 'c9d28842-f5df-5112-b4ae-2ac24d20795f'
    -- AND t1.group_identifier = '842f7aff-572b-44bc-b1ce-c6387b1afafz'
GROUP BY t1.plan_identifier, t1.group_identifier;