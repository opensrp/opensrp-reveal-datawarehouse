INSERT INTO plans (
    identifier,
    version,
    name,
    title,
    status,
    date,
    effective_period_start,
    effective_period_end
)
VALUES (
    '${identifier}',
    '${version}',
    '${name}',
    '${title}',
    '${status}',
    '${date}',
    '${effectivePeriod_start}',
    '${effectivePeriod_end}'
)
ON CONFLICT (identifier) DO UPDATE
SET
    version = '${version}',
    name = '${name}',
    title = '${title}',
    status = '${status}',
    date = '${date}',
    effective_period_start = '${effectivePeriod_start}',
    effective_period_end = '${effectivePeriod_end}';
