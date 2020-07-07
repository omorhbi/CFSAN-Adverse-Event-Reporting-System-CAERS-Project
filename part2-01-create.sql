DROP TABLE IF EXISTS event_table CASCADE;
CREATE TABLE event_table (
	caers_event_id SERIAL PRIMARY KEY,
	report_id VARCHAR (255),
	created_date DATE,
	event_date DATE,
	patient_age INTEGER,
	age_units VARCHAR (255),
	sex VARCHAR (255)
);

DROP TABLE IF EXISTS product_table CASCADE;
CREATE TABLE product_table (
	product_id SERIAL PRIMARY KEY,
	product TEXT,
	product_type TEXT,
	product_code TEXT,
	description TEXT
);

DROP TABLE IF EXISTS event_product_join_table;
CREATE TABLE event_product_join_table (
	event_id INTEGER REFERENCES event_table(caers_event_id),
	product_id INTEGER REFERENCES product_table(product_id)
);

DROP TABLE IF EXISTS symptoms_table CASCADE;
CREATE TABLE symptoms_table (
	symptoms_id SERIAL PRIMARY KEY,
	terms TEXT,
	outcomes TEXT,
	event_id INTEGER REFERENCES event_table(caers_event_id)
);

DROP TABLE IF EXISTS event_symptoms_join_table;
CREATE TABLE event_symptoms_join_table (
	event_id INTEGER REFERENCES event_table(caers_event_id),
	symptoms_id INTEGER REFERENCES symptoms_table(symptoms_id)
);