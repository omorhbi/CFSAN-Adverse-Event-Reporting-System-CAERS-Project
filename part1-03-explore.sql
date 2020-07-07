
-- This query checks to see if all of the event IDs are unique, so it can be used as a primary key
SELECT COUNT(DISTINCT report_id) AS unique_id, COUNT(report_id) as caers_event_rows 
	FROM staging_caers_events;

-- Determines the relation between a product code and description
SELECT product_code, description, COUNT(description) as description_count
	FROM staging_caers_events
	WHERE product_code IS NOT NULL
	GROUP BY description, product_code
	LIMIT 10;

-- Find out how dates are formatted and see if they can serve as a candidate key (Part 1)
SELECT COUNT(created_date) as created_date_count, COUNT(report_id) as report_id_count
	FROM staging_caers_events
	LIMIT 10;

-- describe table shows that created_data has no NOT NULL constraints, so this query is to check if there's a null value
SELECT COUNT(created_date) AS null_dates
	FROM staging_caers_events
	WHERE created_date IS NULL;

-- view created_date and report_id side by side (part 2)
SELECT created_date, report_id
	FROM staging_caers_events
	LIMIT 10;

-- explore how descriptions can relate to the a product
SELECT product, description
	FROM staging_caers_events
	GROUP BY product, description
	LIMIT 10;

-- Sees if date of event is needed for patient age, age units and sex to be filled
SELECT event_date, patient_age, age_units, sex
	FROM staging_caers_events
	LIMIT 10;

-- See the kind of values for each column in the table
SELECT *
	FROM staging_caers_events
	LIMIT 5;

-- See if report_id and outcomes have a many to many relationship
SELECT report_id, outcomes, count(*)
	FROM staging_caers_events
	group by report_id, outcomes
	HAVING count(*) > 1
	LIMIT 10;

-- See if product and report_id have a many to many relationship
SELECT DISTINCT product, report_id, count(*)
	FROM staging_caers_events
	GROUP BY product, report_id
	HAVING COUNT(*) > 1
	ORDER BY product ASC
	LIMIT 10;

select caers_event_id, product, terms 
	from staging_caers_events where caers_event_id = 4;

select unnest(string_to_array(terms, ',')) 
	from staging_caers_events where caers_event_id = 4;
select caers_event_id, product, 
	unnest(string_to_array(terms, ',')) 
	from staging_caers_events where caers_event_id = 4;