--DROP MATERIALIZED VIEW pending.ntd_dispense_task_report
CREATE MATERIALIZED VIEW pending.ntd_dispense_task_report AS
(WITH ntd_dispense_event_details AS
    (
        SELECT
            id as event_id,
            event_type,
            base_entity_id,
            location_id,
            task_id,
            event_date,
            entity_type,
            -- Retrieval of JSON values required for later analysis and calculation
            form_data ->> 'nPzqDistribute' AS nPzqDistribute,
            form_data ->> 'availableForTreatment' AS availableForTreatment,
            form_data ->> 'nPzqDistributedQuantity' AS nPzqDistributedQuantity,
            form_data ->> 'nPzqNondistributeReason' AS nPzqNondistributeReason
        FROM reveal_stage.events event--, jsonb_array_elements(event.form_data::jsonb) observations
        WHERE event_type='mda_dispense'
        GROUP BY event_id
    )
SELECT
    uuid_generate_v4() AS report_id,
    ntd_client_dispense_tasks.*,
    --
    clients.baseentityid AS client_base_entity_id,
    clients.gender as client_gender,
    clients.birthdate as client_birthdate,
    EXTRACT(YEAR from AGE(clients.birthdate)) as client_age,
    CASE WHEN EXTRACT(YEAR from AGE(clients.birthdate))::INT >=  0  AND EXTRACT(YEAR from AGE(clients.birthdate))::INT < 6  THEN '< 6'
         WHEN EXTRACT(YEAR from AGE(clients.birthdate))::INT >=  6  AND EXTRACT(YEAR from AGE(clients.birthdate))::INT <= 10  THEN '6 - 10'
         WHEN EXTRACT(YEAR from AGE(clients.birthdate))::INT >=  11  AND EXTRACT(YEAR from AGE(clients.birthdate))::INT <= 15  THEN '11 - 15'
         WHEN EXTRACT(YEAR from AGE(clients.birthdate))::INT >=  16  AND EXTRACT(YEAR from AGE(clients.birthdate))::INT <= 18  THEN '16 - 18'
         WHEN EXTRACT(YEAR from AGE(clients.birthdate))::INT > 18  THEN 'Adult'  ELSE NULL END AS client_age_category,
    --
    ntd_dispense_event_details.event_type AS event_type,
    ntd_dispense_event_details.event_date AS event_date,
    CASE WHEN ntd_dispense_event_details.nPzqDistribute = 'Yes' THEN 1 
        WHEN ntd_dispense_event_details.nPzqDistribute = 'No' THEN 0 ELSE NULL END AS nPzqDistribute,
    CASE WHEN ntd_dispense_event_details.availableForTreatment = 'Yes' THEN 1 
        WHEN ntd_dispense_event_details.availableForTreatment = 'No' THEN 0 ELSE NULL END AS availableForTreatment,
    ntd_dispense_event_details.nPzqDistributedQuantity::FLOAT AS nPzqDistributedQuantity,
    ntd_dispense_event_details.nPzqNondistributeReason AS nPzqNondistributeReason,
    --
    tasks.status AS task_status,
    tasks.business_status AS task_business_status,
    CASE WHEN business_status <> 'Ineligile' AND code = 'Structure Visited' THEN 1 ELSE 0 END AS structures_visited,
    --
    COALESCE(task_jurisdiction_paths.jurisdiction_path, client_jurisdiction_paths.jurisdiction_path) AS jurisdiction_id_path,
    COALESCE(task_jurisdiction_paths.jurisdiction_name_path, client_jurisdiction_paths.jurisdiction_name_path) AS jurisdiction_name_path

FROM 
(
    SELECT *
    FROM ntd_dispense_event_details 
    WHERE nPzqDistribute IS NOT NULL ) ntd_dispense_event_details
LEFT JOIN  pending.ntd_client_dispense_tasks AS ntd_client_dispense_tasks
    ON ntd_dispense_event_details.task_id = ntd_client_dispense_tasks.task_id
LEFT JOIN reveal_stage.clients
    ON ntd_client_dispense_tasks.client_id = clients.id
LEFT JOIN reveal_stage.tasks
    ON ntd_client_dispense_tasks.task_id = tasks.identifier
LEFT JOIN (
SELECT jurisdiction_id,
       jurisdiction_parent_id,
       jurisdiction_name,
       jurisdiction_depth,
       jurisdiction_path,
       jurisdiction_name_path,
       jurisdiction_root_parent_id,
       jurisdiction_root_parent_name
FROM reveal_stage.jurisdictions_materialized_view) AS task_jurisdiction_paths
    ON ntd_client_dispense_tasks.task_jurisdiction_id = task_jurisdiction_paths.jurisdiction_id
LEFT JOIN (
SELECT jurisdiction_id,
       jurisdiction_parent_id,
       jurisdiction_name,
       jurisdiction_depth,
       jurisdiction_path,
       jurisdiction_name_path,
       jurisdiction_root_parent_id,
       jurisdiction_root_parent_name
FROM reveal_stage.jurisdictions_materialized_view) AS client_jurisdiction_paths
    ON ntd_client_dispense_tasks.jurisdiction_id = client_jurisdiction_paths.jurisdiction_id) WITH DATA;

-- Create unique ID
CREATE UNIQUE INDEX IF NOT EXISTS ntd_dispense_task_report_index ON pending.ntd_dispense_task_report (report_id);