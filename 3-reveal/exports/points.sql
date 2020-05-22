COPY ( SELECT CONCAT(json, ',') FROM core.structure WHERE json->'geometry'->>'type' = 'Point' ) TO STDOUT;
