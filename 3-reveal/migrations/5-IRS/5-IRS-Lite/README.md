# Zambia 2020 IRS-Lite Migrations

These migrations are to support IRS-Lite in Zambia for the 2020 season.

## Materialized views

- [zambia_focus_area_irs_lite](deploy/zambia_focus_area_irs_lite.psql): exposes IRS metrics calculated for focus areas
- [zambia_irs_lite_jurisdictions](deploy/zambia_irs_jurisdictions.psql):  exposes IRS metrics calculated for jurisdictions other than focus areas
- [zambia_irs_lite_structures](deploy/zambia_irs_structures.psql): exposes IRS metrics calculated for individual operational areas (which are structures in the database)

### Virtual "remainder" jurisdictions

These views add support for "virtual" jurisdictions.  These jurisdictions result from the fact that some structures do not fall into any known jurisdictions but yet IRS activities were carried out at such structures.  For reporting purposes, it is then necessary to tie these structures to "virtual jurisdictions".

- [zambia_lite_jurisdictions](deploy/zambia_lite_jurisdictions.psql)
- [zambia_lite_plan_jurisdictions](deploy/zambia_lite_plan_jurisdictions.psql)
- [zambia_lite_structure_jurisdictions](deploy/zambia_lite_structure_jurisdictions.psql)

## Reveal Web Usage

For Zambia IRS reports,The Reveal web UI makes use of the following tables and views:

- irs_lite_plans: this is for displaying the initial list of IRS-Lite plans in the IRS-Lite reporting section
- zambia_irs_lite_jurisdictions: this powers the jurisdictions hierarchy in the IRS-Lite reporting section
- zambia_focus_area_irs_lite: this powers the lowest level of the jurisdictions hierarchy in the IRS-Lite reporting section
- zambia_irs_lite_structures: this is for displaying the structures on the IRS-Lite reporting map
