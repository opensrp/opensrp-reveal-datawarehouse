# Zambia MDA (NTD) Reports

This sqitch plan contains all the queries used to generate Zambia MDA (Mass Drug Administration) reports for NTD (Neglected Tropical Diseases).

## MDA Plans

The MDA plans are found in the [mda_plans](deploy/mda_plans.psql) materialized view.

## Jurisdiction Reports

The final report is a materialized view named [ntd_mda_jurisdictions](deploy/mda_jurisdictions.psql) which pulls from views that aggregate data onto locations, which are in the [mda_structures](deploy/mda_structures.psql) migration.
