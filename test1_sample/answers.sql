-- Note: you must use MS Word for the test

----------------------------
-- Problem 1 (author: Mike Vo)
SELECT s.ID AS student_id,
       name AS student_name,
       d.dept_name AS department_name,
       build_name AS building_name,
       address AS building_address
FROM student s JOIN department d
ON s.dept_name = d.dept_name
JOIN building b
ON d.building = b.build_name;

ALTER TABLE student ADD INDEX dept_idx(dept_name);
ALTER TABLE department ADD INDEX building_idx(building);

-- Explanation: indexes can be used to answer the above query
-- because the indexed columns are used in the WHERE/JOIN clause
-- (d.dept_name has a primary index on it and s.dept_name
-- has the dept_idx index on it) and (b.build_name has a primary
-- index on it and d.building has the building_idx index on it).
-- As such, index entries are searched to find the matching rows
-- instead of the real data entries. Because length(index entries) <
-- length(real data entries) AND index entries are sorted => less IO reads

-- For screenshots: please watch the recorded video

----------------------------
-- Problem 2 (author: Quynh Le)

CREATE TABLE course (
  title VARCHAR(255),
  dept_name VARCHAR(20),
  credits INT
)
PARTITION BY LIST(credits) (
  PARTITION p1 VALUES IN (1,4,7),
  PARTITION p2 VALUES IN (2,9),
  PARTITION p3 VALUES IN (3,8),
  PARTITION p4 VALUES IN (5,6,10)
);

INSERT INTO course VALUES
  ('Intro to CS', 'Comp. Sci.', 1),
  ('Databases', 'Comp. Sci.', 2),
  ('Algorithms', 'Comp. Sci.', 3),
  ('Web Development', 'Comp. Sci.', 5);

SELECT c.title, c.dept_name, d.building, c.credits
FROM course c JOIN department d
ON c.dept = d.dept_name
WHERE c.credits <= 3;

-- For screenshots: please watch the recorded video

----------------------------
-- Problem 3 (author: Mike Vo)

-- You can draw different execution plans by
-- 1. changing join order
-- 2. applying the SELECT operator before or after JOIN
-- 3. or combining them

-- For calculation:
-- Ignore the last operation cost
-- Assume all operations (JOIN, SELECT) happen in memory (hence, cost = 0)
-- Must save temporary results before proceeding to the next operation
-- IO costs: read data from tables to memory + write data from memory to tables

-- Please watch the recorded video for a sample calculation
