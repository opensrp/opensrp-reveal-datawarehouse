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
        COALESCE(SUM(nPzqDistribute), 0) AS nPzqDistribute,
        COALESCE(SUM(availableForTreatment), 0) AS availableForTreatment,
        COALESCE(SUM(nPzqDistributedQuantity), 0) AS nPzqDistributedQuantity
    FROM ntd_dispense_tasks2
    WHERE
        ntd_dispense_tasks2.plan_id = plans.identifier
        AND (
            ntd_dispense_tasks2.jurisdiction_id = jurisdictions_materialized_view.jurisdiction_id
            OR ntd_dispense_tasks2.jurisdiction_path @> ARRAY[jurisdictions_materialized_view.jurisdiction_id]
        )
) AS npzq_query ON TRUE
LEFT JOIN LATERAL (
    SELECT
        COALESCE(SUM(structures_visited), 0) AS structures_visited,
        COALESCE(SUM(sacregistered), 0) AS sacregistered
    FROM ntd_visit_structures
    WHERE
        ntd_visit_structures.plan_id = plans.identifier
        AND (
            ntd_visit_structures.jurisdiction_id = jurisdictions_materialized_view.jurisdiction_id
            OR ntd_visit_structures.jurisdiction_path @> ARRAY[jurisdictions_materialized_view.jurisdiction_id]
        )
) AS nsac_query ON TRUE
LEFT JOIN LATERAL (
    SELECT COUNT(id) AS structure_count FROM structures AS locations
    LEFT JOIN jurisdictions_materialized_view AS j1
        ON jurisdictions_materialized_view.jurisdiction_id = locations.jurisdiction_id
    WHERE (
        locations.jurisdiction_id = jurisdictions_materialized_view.jurisdiction_id
        OR j1.jurisdiction_path @> ARRAY[jurisdictions_materialized_view.jurisdiction_id]
    )
    AND locations.status NOT IN ('Inactive')
) AS structures_query ON TRUE
WHERE
    plans.intervention_type = 'Dynamic-MDA'
    AND plans.status IN ('active', 'complete');
    AND plans.identifier = 'c9d28842-f5df-5112-b4ae-2ac24d20795f'
    AND jurisdictions_materialized_view.jurisdiction_id
        IN ('842f7aff-572b-44bc-b1ce-c6387b1afafz', '9c7b5883-c5e2-443f-b089-9afb9cfff34z');
    -- AND jurisdictions_materialized_view.jurisdiction_id = '842f7aff-572b-44bc-b1ce-c6387b1afafz';