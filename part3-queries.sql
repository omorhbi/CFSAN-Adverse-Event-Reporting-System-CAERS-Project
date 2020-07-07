
-- Query #2
SELECT DISTINCT p.product, p.product_code
	FROM symptoms_table s, product_table p
	WHERE terms = 'NIGHTMARE' and s.event_id = p.product_id
	ORDER BY p.product DESC
	LIMIT 5;

-- QUERY 3
SELECT event_id, string_agg(terms, ',') as comma_delimited_terms
	FROM symptoms_table
	GROUP BY event_id
	LIMIT 5;

-- QUERY 4
SELECT event_date, report_id, product
	FROM staging_caers_events
	WHERE event_date IS NOT NULL AND (event_date >= '2013-09-01' AND event_date < '2013-10-01')
	ORDER BY report_id
	LIMIT 24; -- limit in place since there are 124 event dates from september 2013

-- QUERY 7
SELECT terms, count(terms) as term_count
	FROM symptoms_table
	GROUP BY terms
	ORDER BY term_count DESC
	LIMIT 3;

-- QUERY 8
SELECT report_id, patient_age, product, product_code, CASE
	WHEN age_units like 'year%' THEN round(patient_age:: decimal * 365.2425, 2)
	WHEN age_units like 'month%' THEN round(patient_age:: decimal * 30.4167, 2)
	WHEN age_units like 'day%' THEN patient_age
END AS age, age_units
FROM staging_caers_events
WHERE patient_age IS NOT NULL AND age_units = 'day(s)' AND patient_age = (SELECT MIN(patient_age)
	FROM staging_caers_events
	WHERE age_units = 'day(s)')
ORDER BY age;

-- Indexing
DROP INDEX IF EXISTS idx_terms;
CREATE INDEX idx_terms ON symptoms_table(terms);

-- EXPLAIN view
EXPLAIN SELECT terms, count(terms) as term_count
	FROM symptoms_table
	GROUP BY terms
	ORDER BY term_count DESC
	LIMIT 3;

-- EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT terms, count(terms) as term_count
	FROM symptoms_table
	GROUP BY terms
	ORDER BY term_count DESC
	LIMIT 3;

DROP VIEW IF EXISTS staging_master;
CREATE VIEW staging_master AS
	SELECT s.outcomes, e.caers_event_id, p.product
	FROM event_table e
		INNER JOIN symptoms_table s on  e.caers_event_id = s.symptoms_id
		INNER JOIN product_table p  on s.event_id = p.product_id;

SELECT *
	FROM staging_master
	LIMIT 10;

SELECT count(*) as num_rows
	FROM staging_master;
