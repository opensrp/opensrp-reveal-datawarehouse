INSERT INTO goal_target
    (goal_id, plan_id, measure, due, detail_quantity_value, detail_quantity_comparator, detail_quantity_unit)
VALUES
    (
        '${goal_id}',
        '${identifier}',
        '${measure}',
        '${due}',
        ${detail_quantity_value},
        replace(replace(E'${detail_quantity_comparator}', 'u003e', '>'), 'u003d', '='),
        '${detail_quantity_unit}'
)
ON CONFLICT (goal_id, plan_id) DO
UPDATE
SET
    goal_id = '${goal_id}',
    plan_id = '${identifier}',
    measure = '${measure}',
    due = '${due}',
    detail_quantity_value = ${detail_quantity_value},
    detail_quantity_comparator = replace(replace(E'${detail_quantity_comparator}', 'u003e', '>'), 'u003d', '='),
    detail_quantity_unit = '${detail_quantity_unit}';