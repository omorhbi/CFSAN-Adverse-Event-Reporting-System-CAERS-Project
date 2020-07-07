
-- event table is being populated here
INSERT INTO event_table (caers_event_id, report_id, created_date, event_date, patient_age, age_units, sex) (
	SELECT caers_event_id, report_id, created_date, event_date, patient_age, age_units, sex 
		FROM staging_caers_events
);

-- product table is being populated here
INSERT INTO product_table(product, product_type, product_code, description) (
	SELECT UPPER(TRIM(product)), product_type, product_code, description
		FROM staging_caers_events
);

-- event/product join table being populated here
INSERT INTO event_product_join_table (event_id, product_id) (
	SELECT caers_event_id, product_id
		FROM staging_caers_events 
		FULL JOIN product_table on staging_caers_events.caers_event_id = product_table.product_id
);

-- symptoms table being populated here
INSERT INTO symptoms_table (terms, outcomes, event_id) (
	SELECT UPPER(TRIM(unnest(string_to_array(terms, ',')))), outcomes, caers_event_id
		FROM staging_caers_events
);

-- event/symptoms join table being populated here
INSERT INTO event_symptoms_join_table (event_id, symptoms_id) (
	SELECT staging_caers_events.caers_event_id, symptoms_table.symptoms_id
		FROM staging_caers_events
		RIGHT OUTER JOIN symptoms_table on staging_caers_events.caers_event_id = symptoms_table.event_id
	
);

