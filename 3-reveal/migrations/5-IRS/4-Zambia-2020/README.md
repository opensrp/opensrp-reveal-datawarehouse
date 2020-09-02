# Zambia IRS Performance Reports

These migrations are to generate IRS performance reports for different levels in Zambia.

## Materialized Views

- [spray_event_materialized_view](deploy/general_performance_report.psql): assembles field required to generate the different reports in to a single view.
- [districts_materialized_view](deploy/district_performance_report.psql): exposes performance reports calculated for each districts in a particular plan.
- [data_collectors_report](deploy/collector_performance_report.psql): exposes calculated data collector performance reports for a particular district.
- [sop_materialized_view](deploy/sop_performance_report.psql): exposes caculated sprayer operator reports under a particular data collector.
- [sop_date_materialized_view](deploy/performance_report_by_date.psql): exposes caculated reports for a sprayer operator based on different dates.

## Reveal Web Usage

The Reveal web UI makes use of the following views:

- districts_materialized_view: this is for displaying districts reports
- data_collectors_report: this is for displaying data collector reports
- sop_materialized_view: this is for displaying sprayer operator reports
- sop_date_materialized_view: this is for displaying sprayer operator reports by date
