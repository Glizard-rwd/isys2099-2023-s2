-- Exercise 1

-- Analysis steps:
-- How many partitions are needed?
-- What are the conditions for partitioning?
-- What is the distribution of data?
-- What optimization strategy is preferred? (worst-case, best-case)

-- Partition requirements:
-- Partitioned column data types are allowed?
-- Partitioned columns are part of all keys?
-- => Make changes if needed

ALTER TABLE cities
PARTITION BY RANGE(FLOOR(lat)) (
  PARTITION p0 VALUES LESS THAN v0,
  PARTITION p1 VALUES LESS THAN v1,
  PARTITION p2 VALUES LESS THAN v2,
  PARTITION p3 VALUES LESS THAN MAXVALUE
);

-- In the above query, you must replace v0, v1, v2 with appropriate values

-- Use EXPLAIN to check if MySQL can use partition information
-- to answer your queries efficiently

-- In case MySQL can't use partition information, you can help it:
SELECT * FROM cities PARTITION (p0, p1)
WHERE lat < some_value;

-- To partition a table using two or more columns
-- use either RANGE COLUMNS or LIST COLUMNS

--------------------------------------------

-- Exercise 2

-- Some changes to the people table's keys are required
-- before partitions can be created successfully

ALTER TABLE people
PARTITION BY RANGE(YEAR(birth_date)) (
  PARTITION p0 VALUES LESS THAN 1960,
  PARTITION p1 VALUES LESS THAN 1980,
  PARTITION p2 VALUES LESS THAN 2000,
  PARTITION p3 VALUES LESS THAN MAXVALUE
);

-- This query may not use partition information properly
SELECT * FROM people WHERE YEAR(birth_date) < 1970;

-- This one can use partition information
SELECT * FROM people WHERE birth_date < '1970-01-01';

-- => Make your queries as simple as possible

--------------------------------------------

-- Exercise 3

-- Some changes to the provinces table's keys are required
-- before partitions can be created successfully

ALTER TABLE provinces
PARTITION BY LIST(administrative_region_id) (
  PARTITION pNorth VALUES IN (1, 2, 3),
  PARTITION pCentral VALUES IN (4, 5, 6),
  PARTITION pSouth VALUES IN (7, 8)
);
