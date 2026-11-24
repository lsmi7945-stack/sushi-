SELECT
    table_name,
    index_name,
    column_name,
    seq_in_index,
    non_unique,
    index_type
FROM information_schema.statistics
WHERE table_schema = 'sdg9_school_tech_revised'
ORDER BY
    table_name,
    index_name,
    seq_in_index;

SELECT
    COUNT(DISTINCT table_name, index_name)
        AS total_indexes
FROM information_schema.statistics
WHERE table_schema = 'sdg9_school_tech_revised';

EXPLAIN
SELECT survey_id
FROM surveys
WHERE school_id = 1
    AND wifi_works = 'no';