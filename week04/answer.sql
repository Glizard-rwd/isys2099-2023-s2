-- Exercise 1

-- First query
SELECT * FROM Employee
WHERE Sex = 'F' AND Dno = 5;

-- Second query
SELECT * FROM Employee
WHERE Sex = 'F' OR Dno = 5;

-- Note 1: we should create an index on a column 
-- with more unique values
-- An index on (Dno) is better than on (Sex)

-- Note 2: the condition order we specified in
-- WHERE does not matter
-- (condition1 AND condition2) is the same as
-- (condition2 AND condition1) in terms of performance

-- Note 3: The logical OR makes some indexes useless
-- In this case, individual indexes on individual columns work

--------------------------------------------

-- Exercise 2

SELECT fname, dname, dependent_name
FROM Employee JOIN Department
ON Dno = Dnumber
JOIN Dependent
ON Essn = Ssn;

-- MySQL provides optimizer hints
-- among those are the ability to specify JOIN order
-- but it looks like we can give hints only (not "force" as
-- mentioned in the documentation)

-- But creating appropriate indexes
-- can help improve JOIN performance

--------------------------------------------

-- Exercise 3

SELECT Dname
FROM Department
WHERE Dnumber IN (
  SELECT Dno
  FROM Employee
  WHERE Ssn IN (
    SELECT Essn
    FROM Dependent
  )
);

-- MySQL always evaluates queries with sub-queries
-- from outer to inner
-- For correlated subqueries, that is the correct 
-- and efficient way to process them
-- But for independent subqueries, that way of
-- processing is not efficient

-- In this situation, we can break a query with sub-queries
-- into multiple queries. The inner-most subquery is processed
-- first and its results can be used directly in the second inner-most
-- subquery and so on.

-- Another approach is to convert sub-query queries into join queries
