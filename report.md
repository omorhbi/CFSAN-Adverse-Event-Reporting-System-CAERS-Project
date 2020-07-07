

# Database Design
![ER Diagram](./ER_diagram.png)

* I made the three entities product, event and symptoms because I felt that all had a set of columns that closely related to each other, for example:
	* Product Entity:
		* Product Name
		* Product Type
		* Product Code
		* Product Description

* Since I determined that product description, outcomes, and terms were multi-valued so I indicated that with that inner oval inside the attribute
* I determined that both product and symptoms had a relation to event because of their connection to the artificial primary key in Caers_event_id.
	* Since caers_event_id is a primary key, I indicated that by placing an underline on the attribute name.
* I determined there wasn't a relation between product and symptoms because I couldn't locate columns that would serve as a foreign key for each other.
* I determined that both relations are many-to-many because of my findings under my explore queries (queries 7 and 8).
* Lastly, I determined that both product and symptoms are weak entities because they both require an event for it to exist. It wouldn't make sense to have products and/or symptoms listed on a row without a created event for it.


# Database Information

## Exploring Data
1. This query checks to see if all the report IDs are unique, to see if it can be a primary key
```
unique_id | caers_event_rows 
-----------+------------------
     46198 |            80024
(1 row)
```
- It seems like it can't be a primary key since the whole column doesn't have unique values.

2. This query determines the relation product code and description have on each other
```
 product_code |                  description                  | description_count 
--------------+-----------------------------------------------+-------------------
 20           |  Fruit/Fruit Prod                             |               368
 12           |  Cheese/Cheese Prod                           |               154
 29           |  Soft Drink/Water                             |               812
 41           |  Dietary Conventional Foods/Meal Replacements |               748
 18           |  Vegetable Protein Prod                       |                29
 53           |  Cosmetics                                    |             31561
 45           |  Food Additives (Human Use)                   |               197
 40P          | P Powder Formula                              |                22
 22           |  Fruit/Fruit Prod                             |               117
 30           |  Beverage Bases/Conc/Nectar                   |                49
(10 rows)
```
- It seems that each unique product code leads to the same description

3. This query looks to see if they both share the same shape (for a possible candidate key)(part 1)
```
 created_date_count | report_id_count 
--------------------+-----------------
              80024 |           80024
(1 row)
```
- It looks like they have the same shape, so this helps it being a possible composite key

Part 2 - Check if either of the columns has a null value, if it does, then it doesn't work as a composite key
```
 null_dates 
------------
          0
(1 row)
```
- No null dates, so still looking good.

(Part 3) Check if a dupe created date has the same report_ids
```
 created_date | report_id 
--------------+-----------
 2014-01-01   | 172940
 2014-01-01   | 172945
 2014-01-01   | 172944
 2014-01-01   | 172937
 2014-01-01   | 172934
 2014-01-01   | 172939
 2014-01-01   | 172941
 2014-01-02   | 172947
 2014-01-02   | 172960
 2014-01-02   | 172947
(10 rows)
```
- It seems like 2014-01-02 has a dupe with the same report id (172947) so it turns it can't be used as a composite key.

4. This query explores how many products are found from a description.
```
                              product                              |                  description                  
-------------------------------------------------------------------+-----------------------------------------------
                                                                   | 
 PROFESSIONAL STYLER GEL ARAGON OIL                                |  Cosmetics
 SLIMFAST MEAL REPLACEMENT BEVERAGE                                |  Dietary Conventional Foods/Meal Replacements
 SPRING VALLEY CHROMIUM PICOLINATE                                 |  Vit/Min/Prot/Unconv Diet(Human/Animal)
 THE BREAD GUY CRANBERRY WALNUT LOAF                               |  Bakery Prod/Dough/Mix/Icing
 PROCERA AVH 1515MG                                                |  Vit/Min/Prot/Unconv Diet(Human/Animal)
 PURITANS PRIDE POTASSIUM 99 MG CAPLETS(DIETARY SUPPLEMENT) CAPLET |  Vit/Min/Prot/Unconv Diet(Human/Animal)
 WINCO FOOD SRAW PINE NUTS, BULK                                   |  Nuts/Edible Seed
 Bacon Ranch Salad with Crispy Chicken                             |  Vegetables/Vegetable Products
 NATUREMADE VITAMIN B 12                                           |  Vit/Min/Prot/Unconv Diet(Human/Animal)
(10 rows)

```
- It seems that a description and product have a one to many relationship

5. This query checks to see if these columns need to rely on each other having a non-null value for the other to have a non-null value.
```
 event_date | patient_age | age_units | sex 
------------+-------------+-----------+-----
            |             |           | 
            |             |           | 
            |             |           | 
            |             |           | 
 2013-12-05 |             |           | 
            |             |           | 
 2013-12-16 |             |           | 
            |          64 | year(s)   | F
            |             |           | 
            |          64 | year(s)   | F
(10 rows)
```
- It seems that event_date can have a non-null value even though patient_age, age_units and sex are null for that row, and vice versa.

6. This query checks to see how values look in each field
```
 caers_event_id | report_id | created_date | event_date | product_type |                             product                             | product_code |         description          | patient_age | age_units | sex |                                  terms                                  |                       outcomes                       
----------------+-----------+--------------+------------+--------------+-----------------------------------------------------------------+--------------+------------------------------+-------------+-----------+-----+-------------------------------------------------------------------------+------------------------------------------------------
              1 | 172940    | 2014-01-01   |            | SUSPECT      | DANNON DANNON LITE & FIT GREEK YOGURT CHERRY                    | 09           |  Milk/Butter/Dried Milk Prod |             |           |     | NAUSEA                                                                  | Other Outcome
              2 | 172945    | 2014-01-01   |            | SUSPECT      | SAVORITZ ORIGINAL BUTTERY ROUND CRACKERS                        | 03           |  Bakery Prod/Dough/Mix/Icing |             |           |     | VOMITING                                                                | Other Outcome
              3 | 172944    | 2014-01-01   |            | SUSPECT      | WELCH'S 100% GRAPE JUICE, FROM CONCENTRATE WITH ADDED VITAMIN C | 20           |  Fruit/Fruit Prod            |             |           |     | SLEEP DISORDER, SALIVARY GLAND DISORDER, ANXIETY                        | Other Outcome
              4 | 172937    | 2014-01-01   |            | SUSPECT      | DAVID'S SUNFLOWER SEEDS, RANCH FLAVORED                         | 23           |  Nuts/Edible Seed            |             |           |     | TENDERNESS, PAIN, MUCOSAL ULCERATION, CAUSTIC INJURY, BURNING SENSATION | Hospitalization, Patient Visited Healthcare Provider
              5 | 172934    | 2014-01-01   | 2013-12-05 | SUSPECT      | VALUED NATIONAL PINE NUTS                                       | 23           |  Nuts/Edible Seed            |             |           |     | HYPERSENSITIVITY, DYSGEUSIA                                             | Other Outcome
(5 rows)
```
- It seems notably that products and preferred terms have comma-delimited values, indicating that it could be put in an array or list.

7. This query checks to see if report_id and outcomes have a many to many relationship.
```
 report_id |                    outcomes                     | count 
-----------+-------------------------------------------------+-------
 172947    | Medically Important                             |     3
 172964    | Hospitalization                                 |     2
 172967    | Disability, Patient Visited Healthcare Provider |     2
 172969    | Disability, Patient Visited Healthcare Provider |     2
 172980    | Medically Important, Patient Visited ER         |     3
 173015    | Disability, Patient Visited Healthcare Provider |    11
 173018    | Medically Important                             |     2
 173030    | Medically Important                             |     2
 173062    | Medically Important, Patient Visited ER         |     2
 173066    | Medically Important                             |     5
(10 rows)
```
- It seems like it has a many to many relationship as multiple outcomes also connect to multiple report_id dupes.

8. This query checks to see if product and report_id has a many to many relationship
```
                     product                     |    report_id    | count 
-------------------------------------------------+-----------------+-------
 ACT DRY MOUTH LOZENGES                          | 2018-CFS-004950 |     2
 ADVOCARE REHYDRATE MANGO PINEAPPLE STICK PACKET | 2018-CFS-010361 |     2
 ALIPOTEC TEJOCOTE ROOT                          | 2018-CFS-001823 |     2
 ALL DAY ENERGY GREENS                           | 210166          |     2
 ALL DAY ENERGY GREENS                           | 197894          |     2
 ALL DAY ENERGY GREENS                           | 197922          |     2
 ALL DAY ENERGY GREENS                           | 210148          |     2
 ALL DAY ENERGY GREENS FRUITY                    | 196459          |     2
 ARBONNE ESSENTIALS ENERGY FIZZ STICKS           | 212064          |     2
 ARBONNE ESSENTIALS ENERGY FIZZ STICKS           | 2018-CFS-008656 |     2
(10 rows)
```
- It seems like it has a many to many relationship as multiple products connects to multiple report_id dupes.


# Query Results

1. Query #2
```
                                              product                                              | product_code 
---------------------------------------------------------------------------------------------------+--------------
 ZINC                                                                                              | 54
 ZARBEE'S NATURALS CHILDREN'S SLEEP WITH MELATONIN SUPPLEMENT & COUGH SYRUP W/DARK HONEY NIGHTTIME | 54
 WEN CLEANSING CONDITIONER                                                                         | 53
 VITAMIN D                                                                                         | 54
 VITAMIN D                                                                                         | 
(5 rows)
```
2. Query #3
```
 event_id |                        comma_delimited_terms                        
----------+---------------------------------------------------------------------
        1 | NAUSEA
        2 | VOMITING
        3 | SLEEP DISORDER,SALIVARY GLAND DISORDER,ANXIETY
        4 | BURNING SENSATION,TENDERNESS,PAIN,MUCOSAL ULCERATION,CAUSTIC INJURY
        5 | HYPERSENSITIVITY,DYSGEUSIA
(5 rows)
```
3. Query #4
```
 event_date | report_id |                        product                        
------------+-----------+-------------------------------------------------------
 2013-09-29 | 172989    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-29 | 172990    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-29 | 172991    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-29 | 172992    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-29 | 172993    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-29 | 172994    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-29 | 172995    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-29 | 172996    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-29 | 173006    | RESER'S STONEMILL KITCHENS COUNTRY RED POTATO SALAD
 2013-09-12 | 173016    | MOVE FREE
 2013-09-13 | 173073    | NEW ZEALAND GRANNY SMITH APPLES
 2013-09-26 | 173122    | OCUVITE EYE VITAMIN & MINERAL SUPPLEMENT & LUTEIN
 2013-09-01 | 173247    | WEN BY CHAZ DEAN
 2013-09-01 | 173291    | BEE SWEET SPOT
 2013-09-03 | 173427    | GERBER YOGURT BLENDS APPLE CINAMMON WITH WHOLE GRAINS
 2013-09-29 | 173503    | WOMENS ULTRA MEGA ENERGY AND METABOLISM
 2013-09-29 | 173503    | GNC TOTAL LEAN CLA SOFT CHEW
 2013-09-29 | 173503    | VITAMIN B-12 SOFT CHEW
 2013-09-01 | 173648    | USP LABS OXYELITE PRO
 2013-09-07 | 173712    | VITAMIN D-3
 2013-09-07 | 173712    | OMEGA-3
 2013-09-07 | 173712    | VITAMIN B-12
 2013-09-07 | 173712    | Prevagen
 2013-09-07 | 173712    | Biotin
(24 rows)
```
4. Query #7
```
     terms      | term_count 
----------------+------------
 OVARIAN CANCER |      20227
 ALOPECIA       |       6986
 DIARRHOEA      |       6610
(3 rows)
```
5. Query #8
```
 report_id | patient_age |                                  product                                  | product_code | age | age_units 
-----------+-------------+---------------------------------------------------------------------------+--------------+-----+-----------
 189355    |           1 | ROUNDY'S LARGE GRADE A ORGANIC BROWN EGGS                                 | 15           |   1 | day(s)
 190179    |           1 | FLINTSTONES PLUS OMEGA 3 DHA GUMMIES (MULTIVITAMINS, OMEGA-3 FATTY ACIDS) | 54           |   1 | day(s)
 198453    |           1 | FLINTSTONES COMPLETE (MULTIVITAMINS + MINERALS) CHEWABLE TABLET           | 54           |   1 | day(s)
(3 rows)

```
```


                                                  QUERY PLAN                                                  
--------------------------------------------------------------------------------------------------------------
 Limit  (cost=5918.28..5918.28 rows=3 width=22)
   ->  Sort  (cost=5918.28..5923.12 rows=1939 width=22)
         Sort Key: (count(terms)) DESC
         ->  Finalize HashAggregate  (cost=5873.82..5893.21 rows=1939 width=22)
               Group Key: terms
               ->  Gather  (cost=5650.84..5864.13 rows=1939 width=22)
                     Workers Planned: 1
                     ->  Partial HashAggregate  (cost=4650.84..4670.23 rows=1939 width=22)
                           Group Key: terms
                           ->  Parallel Seq Scan on symptoms_table  (cost=0.00..3948.89 rows=140389 width=14)
(10 rows)
```
```
                                                                          QUERY PLAN                                                                          
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=5918.28..5918.28 rows=3 width=22) (actual time=126.214..126.215 rows=3 loops=1)
   ->  Sort  (cost=5918.28..5923.12 rows=1939 width=22) (actual time=126.212..126.213 rows=3 loops=1)
         Sort Key: (count(terms)) DESC
         Sort Method: top-N heapsort  Memory: 25kB
         ->  Finalize HashAggregate  (cost=5873.82..5893.21 rows=1939 width=22) (actual time=123.237..124.819 rows=3444 loops=1)
               Group Key: terms
               ->  Gather  (cost=5650.84..5864.13 rows=1939 width=22) (actual time=116.084..119.135 rows=5124 loops=1)
                     Workers Planned: 1
                     Workers Launched: 1
                     ->  Partial HashAggregate  (cost=4650.84..4670.23 rows=1939 width=22) (actual time=83.713..84.813 rows=2562 loops=2)
                           Group Key: terms
                           ->  Parallel Seq Scan on symptoms_table  (cost=0.00..3948.89 rows=140389 width=14) (actual time=0.020..20.418 rows=119331 loops=2)
 Planning Time: 0.073 ms
 Execution Time: 126.344 ms
(14 rows)
```
- These two queries (EXPLAIN and EXPLAIN ANALYZE) were taken from the query I did from query #7.
```
                                                  QUERY PLAN                                                  
--------------------------------------------------------------------------------------------------------------
 Limit  (cost=5912.07..5912.08 rows=3 width=22)
   ->  Sort  (cost=5912.07..5916.80 rows=1894 width=22)
         Sort Key: (count(terms)) DESC
         ->  Finalize HashAggregate  (cost=5868.65..5887.59 rows=1894 width=22)
               Group Key: terms
               ->  Gather  (cost=5650.84..5859.18 rows=1894 width=22)
                     Workers Planned: 1
                     ->  Partial HashAggregate  (cost=4650.84..4669.78 rows=1894 width=22)
                           Group Key: terms
                           ->  Parallel Seq Scan on symptoms_table  (cost=0.00..3948.89 rows=140389 width=14)
(10 rows)
```
```
                                                                          QUERY PLAN                                                                          
--------------------------------------------------------------------------------------------------------------------------------------------------------------
 Limit  (cost=5912.07..5912.08 rows=3 width=22) (actual time=115.568..115.568 rows=3 loops=1)
   ->  Sort  (cost=5912.07..5916.80 rows=1894 width=22) (actual time=115.566..115.566 rows=3 loops=1)
         Sort Key: (count(terms)) DESC
         Sort Method: top-N heapsort  Memory: 25kB
         ->  Finalize HashAggregate  (cost=5868.65..5887.59 rows=1894 width=22) (actual time=114.402..114.991 rows=3444 loops=1)
               Group Key: terms
               ->  Gather  (cost=5650.84..5859.18 rows=1894 width=22) (actual time=109.749..125.018 rows=4955 loops=1)
                     Workers Planned: 1
                     Workers Launched: 1
                     ->  Partial HashAggregate  (cost=4650.84..4669.78 rows=1894 width=22) (actual time=77.117..77.848 rows=2478 loops=2)
                           Group Key: terms
                           ->  Parallel Seq Scan on symptoms_table  (cost=0.00..3948.89 rows=140389 width=14) (actual time=0.020..18.449 rows=119331 loops=2)
 Planning Time: 0.080 ms
 Execution Time: 129.357 ms
(14 rows)
```
- Same as above but with indexing. It seems like it didn't really help. Possibly because the query planner didn't really have a use for it. 

- Creating a View
```
DROP VIEW
CREATE VIEW
                       outcomes                       | caers_event_id |                             product                             
------------------------------------------------------+----------------+-----------------------------------------------------------------
 Other Outcome                                        |              1 | DANNON DANNON LITE & FIT GREEK YOGURT CHERRY
 Other Outcome                                        |              2 | SAVORITZ ORIGINAL BUTTERY ROUND CRACKERS
 Other Outcome                                        |              3 | WELCH'S 100% GRAPE JUICE, FROM CONCENTRATE WITH ADDED VITAMIN C
 Other Outcome                                        |              4 | WELCH'S 100% GRAPE JUICE, FROM CONCENTRATE WITH ADDED VITAMIN C
 Other Outcome                                        |              5 | WELCH'S 100% GRAPE JUICE, FROM CONCENTRATE WITH ADDED VITAMIN C
 Hospitalization, Patient Visited Healthcare Provider |              6 | DAVID'S SUNFLOWER SEEDS, RANCH FLAVORED
 Hospitalization, Patient Visited Healthcare Provider |              7 | DAVID'S SUNFLOWER SEEDS, RANCH FLAVORED
 Hospitalization, Patient Visited Healthcare Provider |              8 | DAVID'S SUNFLOWER SEEDS, RANCH FLAVORED
 Hospitalization, Patient Visited Healthcare Provider |              9 | DAVID'S SUNFLOWER SEEDS, RANCH FLAVORED
 Hospitalization, Patient Visited Healthcare Provider |             10 | DAVID'S SUNFLOWER SEEDS, RANCH FLAVORED
(10 rows)
```
```
 num_rows 
----------
    80024
(1 row)
```
- These two queries involve making a view that reconstitutes the original staging table. It seems like it returns the same number of rows

## Conclusions
1. This semi-normalized form is better as it helps avoid having duplicate data or helps avoid having any anomalies when modifying data.
2. One way this semi-normalized form is worse that it makes doing tasks on these tables more tedious, as there are more tables to join, making work on the tables become longer and slower.