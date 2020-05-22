# Superset Slice Queries

These queries are used to build Superset slices which are consumed by the Reveal web application.

- **[jurisdictions_data_slice.sql](jurisdictions_data_slice.sql)**: return jurisdictions data without the geometry field
- **[jurisdictions_geojson_slice.sql](jurisdictions_geojson_slice.sql)**: return jurisdictions as geoJSON Features
- **[namibia_irs_export_slice.sql](namibia_irs_export_slice.sql)**: return namibia_irs_export without structure_geometry_centroid field
- **[namibia_irs_jurisdictions_data_slice.sql](namibia_irs_jurisdictions_data_slice.sql)**: return namibia_irs_jurisdictions without the geometry
- **[namibia_irs_jurisdictions_geojson_slice.sql](namibia_irs_jurisdictions_geojson_slice.sql)**: return namibia_irs_jurisdictions as geoJSON Features
- **[namibia_irs_structures_geojson_slice.sql](namibia_irs_structures_geojson_slice.sql)**: return namibia_irs_structures as geoJSON Features
- **[structures_geojson_slice.sql](structures_geojson_slice.sql)**: return structures as geoJSON Features
- **[task_structures_geojson_slice.sql](task_structures_geojson_slice.sql)**: return task_structures_materialized_view as geoJSON Features
- **[zambia_irs_focus_areas_data_slice.sql](zambia_irs_focus_areas_data_slice.sql)**: return zambia_irs_focus_areas_data_slice without the geometry
- **[zambia_irs_jurisdictions_data_slice.sql](zambia_irs_focus_areas_data_slice.sql)**: return zambia_irs_jurisdictions_data_slice without the geometry
- **[zambia_irs_structures_goejson_slice.sql](zambia_irs_jurisdictions_data_slice.sql)**: return zambia_irs_structures as geoJSON features
