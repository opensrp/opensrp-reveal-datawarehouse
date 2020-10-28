# Zambia IRS Performance Reports

These migrations are to generate IRS performance reports for different levels in Zambia.

## Materialized Views

- [zambia_irs_spray_event](deploy/zambia_irs_spray_event.psql): assembles field required to generate the different reports in to a single view.
- [zambia_irs_district_performance](deploy/zambia_irs_district_performance.psql): exposes performance reports calculated for each districts for a particular plan.
- [zambia_irs_data_collector_performance](deploy/zambia_irs_data_collector_performance.psql): exposes calculated data collector performance reports for a particular district.
- [zambia_irs_sop_performance](deploy/zambia_irs_sop_performance.psql): exposes caculated sprayer operator reports under a particular data collector.
- [zambia_irs_sop_date_performance](deploy/zambia_irs_sop_date_performance.psql): exposes caculated reports for a sprayer operator based on different dates.
- [zambia_spray_areas_irs](deploy/zambia_irs_mop_up.psql#L151-L164): exposes spray areas only

## Reveal Web Usage

The Reveal web UI makes use of the following views:

- zambia_irs_district_performance: this is for displaying districts reports
- zambia_irs_data_collector_performance: this is for displaying data collector reports
- zambia_irs_sop_performance: this is for displaying sprayer operator reports
- zambia_irs_sop_date_performance: this is for displaying sprayer operator reports by date
- zambia_spray_areas_irs: this for displaying the lower focus areas only
