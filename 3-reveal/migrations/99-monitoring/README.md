# Reveal Monitoring

## Data Types

- [object_type](deploy/object_type.psql): this is a data type which is essentially an enum that represents all valid Reveal data types

## Tables

- [data_integrity_validation](deploy/data_integrity_validation.psql): stores data integrity validations
- [failed_flowfiles](deploy/failed_flowfiles.psql): stores information about failed flow files

## Functions

### [data_integrity_validation_functions](deploy/data_integrity_validation_functions.psql)

- **orphaned_jurisdictions**: Returns an array of jurisdiction ids for jurisdictions with a non-empty parent id that doesn't exist as another known jurisdiction
- **missing_goal_actions**: Returns an array of action ids for actions with goals that don't match goals in known plans
- **missing_subject_tasks**: Returns an array of task ids for tasks with subjects that don't exist as structures, jurisdictions (structures), or clients

```sql
-- example usage
SELECT orphaned_jurisdictions(NULL);
SELECT missing_goal_actions(NULL);
SELECT missing_subject_tasks(NULL);
```

### [check_data_integrity](deploy/check_data_integrity.psql)

This function is used to run data integrity validation functions and then record the result in the data_integrity_validation table.

This function should be run periodically.  The idea is to populate the `data_integrity_validation` whenever there are data integrity issues so that the database administrator(s) can be made aware.

The data integrity validation functions supported must have the following qualities:

1. Must take on input/parameter that is an Integer
2. Must output an array of text i.e. `TEXT[]`

```sql
-- example usage
SELECT check_data_integrity(
    'missing_goal_actions',  -- this is the data integrity validation function to run
    'actions'  -- this is the data type
);
SELECT check_data_integrity('missing_subject_tasks', 'tasks');

-- which would result in something like
SELECT * FROM data_integrity_validation;
--            name            |    type     | object_ids  |       last_modified
-- ---------------------------+-------------+-------------+----------------------------
--     missing_goal_actions   |   actions   | {1337,7331} | 2020-05-15 20:10:02.514467
```
