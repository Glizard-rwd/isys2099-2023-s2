-- Exercise 1

-- Query 1
SELECT * FROM people WHERE id = 12345;
-- No need to do anything because the `id` field has a primary index on it already (it was defined as the primary key of the people table)

-- Query 2
SELECT * FROM people WHERE first_name LIKE 'Ab%';
-- We should create an index on the first_name field
ALTER TABLE people
ADD INDEX idx_first_name (first_name);

-- But if we want to find people whose first_name ends with a string
-- SELECT * FROM people WHERE first_name LIKE '%Ab';
-- Creating an index on first_name will not help

-- Query 3
SELECT first_name, last_name
FROM people join cities
ON current_location = cities.id
WHERE cities.name = 'Melbourne';
-- We should create an index on the `name` column of the cities table for the WHERE condition
-- and another index on the current_location of the people table for the JOIN condition
ALTER TABLE cities
ADD INDEX idx_name (name);

ALTER TABLE people
ADD INDEX idx_current_location (current_location);

--------------------------------

-- Exercise 2

-- Query 1
SELECT * FROM people WHERE birth_location = current_location;
-- We must examine every record to answer this query
-- With a particular value of birth_location, if current_location is sorted, we can find the matching records faster
-- But we need to do so for all birth_location values, so we must scan the whole table. As such, creating an index will not help here

-- Query 2
SELECT * FROM people WHERE birth_date >= '1990-01-01' AND birth_date <= '2000-02-02';
-- Creating an index on birth_date column will help


-- Query 3
SELECT * FROM cities WHERE lat >= sydney_lat - deltaY AND lat <= sydney_lat + deltaY AND lng >= sydney_lng - deltaX AND lng <= sydney_lng + deltaX
-- Creating an index on (lat, lng) will help improve the search for cities in a bounding rectangle. But that's all. The cities in the result are not necessarily nearer to Sedney than the cities not in the results (why?). Furthermore, an additional step is required to process the results


--------------------------------

-- Exercise 3

CREATE FULLTEXT INDEX idx_text
ON articles(text);