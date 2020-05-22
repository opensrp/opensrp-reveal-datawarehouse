# Some Cleanup or Export SQL Queries

## Structures with tasks

A GeoJSON export of structures with task [SQL](structures_with_task.sql) from opensrp DB.

```sh
psql -U opensrp -h postgres.reveal-zm.smartregister.org opensrp -f structures_with_task.sql > structures_with_task_`date +"%d%m%Y"`.json
```

## Tasks per Jurisdiction

A CSV export of tasks per jurisdiction [SQL](tasks_per_jurisdiction.sql) from opensrp DB.

```sh
 psql -U opensrp -h postgres.reveal-zm.smartregister.org opensrp -f tasks_per_jurisdiction.sql > tasks_per_jurisdiction_not_cancelled_`date +"%d%m%Y"`.csv
```

## Structures per Jurisdiction

A CSV export of structures per jurisdiction [SQL](structures_per_jurisdiction_.sql) from opensrp DB.

```sh
psql -U opensrp -h postgres.reveal-zm.smartregister.org opensrp -f structures_per_jurisdiction.sql > structures_per_jurisdiction_`date +"%d%m%Y"`.csv

```

## Events with tasks

A GeoJSON export of events with linked tasks [SQL](events_with_task.sql) form opensrp DB.

```sh
psql -U opensrp -h postgres.reveal-zm.smartregister.org opensrp -f events_with_task.sql > events_with_task_`date +"%Y%m%d-%H%M%S"`.json
```

## Points

A GeoJSON export of all Points [SQL](points.sql) from opensrp DB.

```sh
psql -U opensrp -h postgres.reveal-zm.smartregister.org opensrp -f points.sql > pts.json
```
