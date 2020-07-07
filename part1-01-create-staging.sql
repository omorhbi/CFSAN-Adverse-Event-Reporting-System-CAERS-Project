-- write your table creation sql here!
DROP TABLE IF EXISTS staging_caers_events;
CREATE TABLE staging_caers_events (
	caers_event_id SERIAL PRIMARY KEY,
	report_id VARCHAR (255),
	created_date DATE,
	event_date DATE,
	product_type TEXT,
	product TEXT,
	product_code TEXT,
	description TEXT,
	patient_age INTEGER,
	age_units VARCHAR(255),
	sex VARCHAR(255),
	terms TEXT,
	outcomes TEXT
);