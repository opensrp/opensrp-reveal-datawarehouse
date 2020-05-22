SELECT CONCAT(jsonb_set(s.json, '{task}', t.json), ',') as structure_with_task FROM core.structure s, core.task t where s.json->>'id' = t.json->>'for';
