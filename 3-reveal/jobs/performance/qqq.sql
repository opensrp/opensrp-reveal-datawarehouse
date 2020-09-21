SELECT
    public.uuid_generate_v5(
        '6ba7b810-9dad-11d1-80b4-00c04fd430c8',
        concat(plans.identifier, jurisdictions_materialized_view.jurisdiction_id)
    ) AS id,
    plans.identifier AS plan_id,
    jurisdictions_materialized_view.jurisdiction_id AS jurisdiction_id,
    jurisdictions_materialized_view.jurisdiction_parent_id AS jurisdiction_parent_id,
    jurisdictions_materialized_view.jurisdiction_name AS jurisdiction_name,
    jurisdictions_materialized_view.jurisdiction_depth AS jurisdiction_depth,
    jurisdictions_materialized_view.jurisdiction_path AS jurisdiction_path,
    jurisdictions_materialized_view.jurisdiction_name_path AS jurisdiction_name_path,
    COALESCE(jurisdiction_target_query.target, 0) AS jurisdiction_target,
    COALESCE(nsac_query.structures_visited, 0) AS structures_visited,
    COALESCE(structures_query.structure_count, 0) AS structure_count,
    COALESCE(nsac_query.sacregistered, 0) AS sacregistered,
    COALESCE(npzq_query.nPzqDistributedQuantity, 0) AS total_pzqdistributed,
    CASE WHEN COALESCE(structures_query.structure_count, 0) <> 0 THEN COALESCE(nsac_query.structures_visited, 0)::DECIMAL/structures_query.structure_count::DECIMAL ELSE 0 END AS structures_visited_per,
    CASE WHEN COALESCE(nsac_query.sacregistered, 0) <> 0 THEN COALESCE(npzq_query.nPzqDistribute, 0)::DECIMAL/nsac_query.sacregistered::DECIMAL ELSE 0 END AS registeredchildrentreated_per,
    CASE WHEN COALESCE(jurisdiction_target_query.target, 0) <> 0 THEN COALESCE(nsac_query.sacregistered, 0)::DECIMAL/jurisdiction_target_query.target::DECIMAL ELSE 0 END AS expectedchildren_found,
    CASE WHEN COALESCE(jurisdiction_target_query.target, 0) <> 0 THEN COALESCE(npzq_query.nPzqDistribute, 0)::DECIMAL/jurisdiction_target_query.target::DECIMAL ELSE 0 END AS expectedchildren_treated
FROM plans AS plans
LEFT JOIN jurisdictions_materialized_view AS jurisdictions_materialized_view ON
    jurisdictions_materialized_view.jurisdiction_id IN (
        SELECT DISTINCT(plan_jurisdictions.jurisdiction_id)
        FROM plan_jurisdictions_materialized_view AS plan_jurisdictions
        WHERE plan_jurisdictions.plan_id = plans.identifier
    )
-- LEFT JOIN plan_jurisdictions_materialized_view AS plan_jurisdictions
--     ON plans.identifier = plan_jurisdictions.plan_id
--     AND plan_jurisdictions.jurisdiction_id = jurisdictions_materialized_view.jurisdiction_id
LEFT JOIN LATERAL (
    SELECT
        key as jurisdiction_id,
        COALESCE(data->>'value', '0')::INTEGER AS target
    FROM opensrp_settings
    WHERE
        identifier = 'jurisdiction_metadata-population'
        AND jurisdictions_materialized_view.jurisdiction_id = opensrp_settings.key
    ORDER BY COALESCE(data->>'serverVersion', '0')::BIGINT DESC
    LIMIT 1
) AS jurisdiction_target_query ON true
LEFT JOIN LATERAL (
    SELECT
        -- events.id AS event_id,
        -- tasks.plan_identifier AS plan_id,
        -- tasks.group_identifier AS jurisdiction_id,
        -- CASE
        --     WHEN events.form_data->>'nPzqDistribute' = 'Yes' THEN 1
        --     ELSE 0
        -- END AS nPzqDistribute,
        -- CASE
        --     WHEN events.form_data->>'availableForTreatment' = 'Yes' THEN 1
        --     ELSE 0
        -- END AS availableForTreatment,
        COALESCE(COUNT(events.id) FILTER (WHERE events.form_data->>'nPzqDistribute' IN ('Yes')), 0) AS nPzqDistribute,
        COALESCE(COUNT(events.id) FILTER (WHERE events.form_data->>'availableForTreatment' IN ('Yes')), 0) AS availableForTreatment,
        COALESCE(SUM(COALESCE(events.form_data->>'nPzqDistributedQuantity', '0')::DECIMAL), 0) AS nPzqDistributedQuantity
    FROM events
    LEFT JOIN clients ON clients.baseentityid = events.base_entity_id
    LEFT JOIN tasks ON events.task_id = tasks.identifier
    WHERE event_type = 'mda_dispense'
        AND tasks.plan_identifier = plans.identifier
        AND tasks.group_identifier = jurisdictions_materialized_view.jurisdiction_id
    GROUP BY tasks.group_identifier
) AS npzq_query ON TRUE
LEFT JOIN LATERAL (
    SELECT
        -- t1.identifier AS task_id,
        -- t1.plan_identifier AS plan_id,
        -- t1.group_identifier AS jurisdiction_id,
        -- array_concat_agg(jurisdictions_materialized_view.jurisdiction_path) AS pathx,
        COUNT(t1.identifier) AS structures_visited,
        COALESCE(SUM(COALESCE(c1.attributes->>'nsac', '0')::DECIMAL), 0) AS sacregistered
    FROM tasks AS t1
    LEFT JOIN events AS e1
        ON t1.identifier = e1.task_id AND e1.event_type IN ('Family Registration', 'Family_Registration')
    LEFT JOIN clients AS c1
        ON e1.base_entity_id = c1.baseentityid
    LEFT JOIN jurisdictions_materialized_view AS j1
        ON jurisdictions_materialized_view.jurisdiction_id = t1.group_identifier
    WHERE t1.code IN ('Structure_Visited', 'Structure Visited')
        AND t1.status IN ('Completed')
        AND t1.plan_identifier = plans.identifier
        -- AND t1.group_identifier = jurisdictions_materialized_view.jurisdiction_id
        -- -- AND t1.group_identifier = ANY(jurisdictions_materialized_view.jurisdiction_path)

        AND (t1.group_identifier = jurisdictions_materialized_view.jurisdiction_id
        OR j1.jurisdiction_path @> ARRAY[jurisdictions_materialized_view.jurisdiction_id])
    GROUP BY t1.group_identifier
) AS nsac_query ON TRUE
LEFT JOIN LATERAL (
    SELECT COUNT(id) AS structure_count FROM structures AS locations
    WHERE locations.jurisdiction_id = jurisdictions_materialized_view.jurisdiction_id
    AND locations.status NOT IN ('Inactive')
) AS structures_query ON TRUE
WHERE
    plans.intervention_type = 'Dynamic-MDA'
    AND plans.status IN ('active', 'complete')
    AND plans.identifier = 'c9d28842-f5df-5112-b4ae-2ac24d20795f'
    AND jurisdictions_materialized_view.jurisdiction_id IN ('842f7aff-572b-44bc-b1ce-c6387b1afafz', '9c7b5883-c5e2-443f-b089-9afb9cfff34z');
    -- AND jurisdictions_materialized_view.jurisdiction_id = '842f7aff-572b-44bc-b1ce-c6387b1afafz';