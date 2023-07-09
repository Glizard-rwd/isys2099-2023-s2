-- 2.1
SELECT DISTINCT Fname FROM Employee JOIN Department
ON Dno = Dnumber JOIN Works_on
ON Essn = Ssn
WHERE hours >= 10 AND Dname = 'Research';

-- 2.2
SELECT DISTINCT Emp.Fname
FROM Employee Mgr JOIN Department ON Mgr.Ssn = Mgr_ssn
JOIN Employee Emp ON Mgr.Ssn = Emp.Super_ssn
WHERE Dname = 'Research';

-- Below is a shorter solution suggested from one student
SELECT DISTINCT Fname
FROM Employee JOIN Department ON Super_ssn = Mgr_ssn
WHERE Dname = 'Research';

-- 2.3
SELECT Fname FROM Employee JOIN Department
ON Mgr_ssn = Ssn
WHERE Ssn NOT IN
  (SELECT Essn FROM works_on);

-- 2.4
SELECT Pname, SUM(Hours) AS Total_hour
FROM Project JOIN Works_on ON Pnumber = Pno
GROUP BY Pname;

-- 2.5
SELECT DISTINCT Fname
FROM Employee
WHERE Ssn NOT IN
(
  SELECT Essn
  FROM Project JOIN Works_on ON Pnumber = Pno
  WHERE Plocation = 'Houston'
);

-- 2.6
SELECT DISTINCT Fname
FROM Employee JOIN Works_on w_out ON Ssn = Essn
WHERE NOT EXISTS
(
  SELECT Pnumber
  FROM Project LEFT JOIN (SELECT * FROM Works_on w_in WHERE w_out.Essn = W_in.Essn) AS Prj_Emp
  ON Pnumber = Prj_Emp.Pno
  WHERE Plocation = 'Houston' AND Prj_Emp.Pno IS NULL
);

-- Explanation 1: first, the DIFFERENCE (MINUS) operator:
-- {A, B, C} DIFFERENCE {B, C, D} = {A}
-- But, MySQL doesn't support DIFFERENCE. However, we can use OUTER JOIN instead.
-- What is the result of {A, B, C} LEFT JOIN {B, C, D}?
-- {B, C} have matching records, but not {A}
-- So, {A, B, C} LEFT JOIN {B, C, D} = {(A, NULL), B, C}
-- By using IS NULL, we can keep only (A, NULL)

-- Explanation 2: the outer query find all employees and their projects.
-- Then, for each combination of (Employee, Project), we calculate
-- (all 'Houston' projects DIFFERENCE all projects being done by this employee)
-- if the result is empty (NOT EXISTS) => this employee is working on
-- all Houston projects

-- Explanation 3: MySQL 8.0.31 added the EXCEPT operator
-- which is another name for DIFFERENCE/MINUS
-- https://dev.mysql.com/doc/refman/8.0/en/except.html

-- Another solution: some students suggested to compare COUNT(all 'Houston' projects
-- being done by an employee) with COUNT(all 'Houston' projects)
-- Can you implement that SQL query?

-- 2.7
SELECT Fname, Salary
FROM Employee
WHERE (Dno, Salary) IN
(
  SELECT Dno, Max(Salary)
  FROM Employee
  GROUP BY Dno
);

-- 2.8
SELECT Dname, COUNT(*) No_Emp
FROM Department JOIN Employee ON Dnumber = Dno
GROUP BY Dname
HAVING COUNT(*) >= 3;

-- 2.9
SELECT Supervisee.Fname, Supervisee.Bdate, Supervisor.Fname, Supervisor.Bdate
FROM Employee Supervisee JOIN Employee Supervisor ON Supervisee.Super_ssn = Supervisor.Ssn
WHERE Supervisee.Bdate <= Supervisor.Bdate;
