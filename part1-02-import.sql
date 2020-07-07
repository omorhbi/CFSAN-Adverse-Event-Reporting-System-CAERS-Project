-- write your COPY statement to import a csv here
COPY staging_caers_events (
	report_id, created_date, event_date,
	product_type, product, product_code,
	description, patient_age, age_units,
	sex, terms, outcomes
)
FROM 'C:/Users/earth/Documents/Data_Management/omorhbi-homework07/CAERSASCII 2014-20190331.csv'
(format csv, header, encoding 'LATIN1');