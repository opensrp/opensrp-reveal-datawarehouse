
CREATE OR REPLACE VIEW _meta_num_to_delete AS
SELECT 'events' as table_name, COUNT(*) AS num_to_delete
FROM events
WHERE
  events.event_type = 'Spray' AND
  events.server_version < ALL (
   SELECT max_server_version FROM _meta_server_versions WHERE table_name = 'events'
  ) AND
  NOT EXISTS (
    SELECT _meta_event_spray_ids.id FROM _meta_event_spray_ids WHERE _meta_event_spray_ids.id = events.id
  )
UNION ALL
SELECT 'structures' as table_name, COUNT(*) AS num_to_delete
FROM structures
WHERE
  structures.server_version < ALL (
   SELECT max_server_version FROM _meta_server_versions WHERE table_name = 'structures'
  ) AND
  NOT EXISTS (
    SELECT _meta_structure_ids.id FROM _meta_structure_ids WHERE _meta_structure_ids.id = structures.id
  )
UNION ALL
SELECT 'tasks' AS table_name, COUNT(*) AS num_to_delete
FROM tasks
WHERE
  tasks.server_version < ALL (
   SELECT max_server_version FROM _meta_server_versions WHERE table_name = 'tasks'
  ) AND
  NOT EXISTS (
    SELECT _meta_task_ids.id FROM _meta_task_ids WHERE _meta_task_ids.id = tasks.identifier
  );


CREATE OR REPLACE FUNCTION cleanup_deleted_data() RETURNS void AS
$$

BEGIN
  
  DELETE FROM events
  WHERE
    events.event_type = 'Spray' AND
    events.server_version < ALL (
     SELECT max_server_version FROM _meta_server_versions WHERE table_name = 'events'
    ) AND
    NOT EXISTS (
      SELECT _meta_event_spray_ids.id FROM _meta_event_spray_ids WHERE _meta_event_spray_ids.id = events.id
    );

  DELETE FROM structures
  WHERE
    structures.server_version < ALL (
     SELECT max_server_version FROM _meta_server_versions WHERE table_name = 'structures'
    ) AND
    NOT EXISTS (
      SELECT _meta_structure_ids.id FROM _meta_structure_ids WHERE _meta_structure_ids.id = structures.id
    );

  DELETE FROM tasks
  WHERE
    tasks.server_version < ALL (
     SELECT max_server_version FROM _meta_server_versions WHERE table_name = 'tasks'
    ) AND
    NOT EXISTS (
      SELECT _meta_task_ids.id FROM _meta_task_ids WHERE _meta_task_ids.id = tasks.identifier
    );

END

$$
LANGUAGE plpgsql;
