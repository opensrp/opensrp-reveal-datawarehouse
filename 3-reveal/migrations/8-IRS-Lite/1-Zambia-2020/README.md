# Zambia 2020 IRS-Lite Migrations

These migrations are to support IRS-Lite in Zambia for the 2020 season.

## Materialized views


- [irs_lite_plans] (deploy/irs_lite_plans): Exposes the IRS Lite plans
- [zambia_irs_lite_structures] (deploy/zambia_irs_lite_structures): Exposes the "structures" are their most recent entry from the irs_lite_verification form
- [zambia_irs_lite_operational_areas] (deploy/zambia_irs_lite_operational_areas): Exposes IRS Lite metrics calculated for operational areas
- [zambia_irs_lite_jurisdictions] (deploy/zambia_irs_lite_jurisdictions): Exposes IRS Lite metrics calculated for jurisdictions other than operational areas and unioned with operational areas to reduce slice calls

## Reveal Web Usage

For Zambia Lite IRS reports,The Reveal web UI makes use of the following tables and views:

- irs_lite_plans: this is for displaying the initial list of IRS-Lite plans in the IRS-Lite reporting section
- zambia_irs_lite_jurisdictions: this powers the jurisdictions hierarchy in the IRS-Lite reporting section
- zambia_irs_lite_operational_areas: this powers the lowest level of the jurisdictions hierarchy in the IRS-Lite reporting section
- zambia_irs_lite_structures: this is for displaying the structures on the IRS-Lite reporting map
