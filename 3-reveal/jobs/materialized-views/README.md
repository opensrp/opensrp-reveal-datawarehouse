# Refreshing materialized views

This section contains queries that should be run periodically so as to keep the various materialized views fresh, and the analytical systems that rely on them up-to-date.

## How the refreshing is done

The aim is to refresh the views using the [refresh_mat_view](../../../1-utils/deploy/refresh_mat_views.psql) stored procedure.  Using this will ensure that we can track when a particular materialized view was last refreshed, and how long it took to do so.  This information is stored in the [materialized_view_tracking](../../../1-utils/deploy/materialized_view_tracking.psql) table.

## Included Views

### Generic Materialized Views

- [refresh_jurisdictions_materialized_view](refresh_jurisdictions_materialized_view.sql)
- [refresh_plans_materialzied_view](refresh_plans_materialzied_view.sql)
- [refresh_reporting_lag](refresh_reporting_lag.sql)
- [refresh_reporting_time](refresh_reporting_time.sql)

### Focus Investigation (FI)

- [refresh_targets_materialized_view](FI/refresh_targets_materialized_view.sql)
- [refresh_task_structures_materialized_view](FI/refresh_task_structures_materialized_view.sql)

### Indoor Residual Spraying (IRS)

#### Generic

- [refresh_irs_plans](IRS/refresh_irs_plans.sql)

#### Namibia 2019

- [refresh_namibia_focus_area_irs](IRS/Namibia-2019/refresh_namibia_focus_area_irs.sql)
- [refresh_namibia_irs_export](IRS/Namibia-2019/refresh_namibia_irs_export.sql)
- [refresh_namibia_irs_jurisdictions](IRS/Namibia-2019/refresh_namibia_irs_jurisdictions.sql)
- [refresh_namibia_irs_structures](IRS/Namibia-2019/refresh_namibia_irs_structures.sql)

#### Zambia 2019

- [process_structure_geo_hierarchy_jurisdiction_queue](IRS/Zambia-2019/process_structure_geo_hierarchy_jurisdiction_queue.sql)
- [process_structure_geo_hierarchy_structure_queue](IRS/Zambia-2019/process_structure_geo_hierarchy_structure_queue.sql)
- [refresh_zambia_focus_area_irs](IRS/Zambia-2019/refresh_zambia_focus_area_irs.sql)
- [refresh_zambia_irs_export](IRS/Zambia-2019/refresh_zambia_irs_export.sql)
- [refresh_zambia_irs_jurisdictions](IRS/Zambia-2019/refresh_zambia_irs_jurisdictions.sql)
- [refresh_zambia_irs_structures](IRS/Zambia-2019/refresh_zambia_irs_structures.sql)
- [refresh_zambia_jurisdictions](IRS/Zambia-2019/refresh_zambia_jurisdictions.sql)
- [refresh_zambia_plan_jurisdictions](IRS/Zambia-2019/refresh_zambia_plan_jurisdictions.sql)
- [refresh_zambia_structure_jurisdictions](IRS/Zambia-2019/refresh_zambia_structure_jurisdictions.sql)
