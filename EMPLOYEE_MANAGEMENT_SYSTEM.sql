-- CREATING A DATABASE
CREATE DATABASE EMPLOYEE_MANAGEMENT;

-- FOR CREATING TABLES WE NEED DATATYPES AND CONSTRAINTS

-- DATA TYPES: DEFINE WHAT KIND OF DATA A COLUMN CAN STORE.
--------------------------------------------------------------------------
-- CHARACTER DATA TYPES:

-- CHAR(N) : FIXED-LENGTH CHARACTER STRING.
--           IF THE VALUE IS SHORTER THAN N, IT IS PADDED WITH SPACES.
-- EXAMPLE: CHAR(10) → ‘HELLO’ STORED AS 'HELLO '

-- VARCHAR(N): VARIABLE-LENGTH CHARACTER STRING WITH A MAXIMUM LIMIT N.
--             DOES NOT USE PAD SPACES.
-- EXAMPLE: VARCHAR(50) → SUITABLE FOR NAMES, EMAILS.

-- TEXT: USED FOR LARGE STRINGS WITHOUT ANY LENGTH LIMIT.
-- EXAMPLE: TEXT → USED FOR DESCRIPTIONS, COMMENTS, ETC.
------------------------------------------------------------------------------
-- NUMERIC DATA TYPES

-- SMALLINT : STORES SMALL INTEGER VALUES (-32768 TO 32767).

-- INT :STANDARD WHOLE NUMBER TYPE (UP TO ~2 BILLION).

-- BIGINT:FOR VERY LARGE WHOLE NUMBERS.

-- NUMERIC(P,S) OR DECIMAL(P,S) → FOR FIXED PRECISION NUMBERS (SUCH AS MONEY).
-- P → TOTAL DIGITS
-- S → DIGITS AFTER DECIMAL
-- EXAMPLE: NUMERIC(10,2) → 12345678.90

-- REAL / DOUBLE PRECISION → USED FOR FLOATING POINT (DECIMAL) NUMBERS.
-------------------------------------------------------------------------
-- BOOLEAN : STORES TRUE OR FALSE.( 't'/'f', 'yes'/'no', '1'/'0')
-- EXAMPLE: IS_ACTIVE BOOLEAN DEFAULT TRUE
-------------------------------------------------------------------------
-- DATE AND TIME:

-- DATE : STORES DATE ONLY (YYYY-MM-DD).

-- TIME : STORES TIME OF DAY (HH:MM:SS).

-- TIMESTAMP : STORES BOTH DATE AND TIME.

-- TIMESTAMPTZ : TIMESTAMP WITH TIME ZONE.

-- INTERVAL : REPRESENTS A DURATION OR TIME DIFFERENCE.
-------------------------------------------------------------------------
-- SERIAL: USED FOR AUTO-INCREMENTING INTEGER VALUES.
--         AUTOMATICALLY CREATES A SEQUENCE.
-------------------------------------------------------------------------

-- CONSTRAINTS: ADD RULES TO ENSURE DATA ACCURACY AND CONSISTENCY.

-- NOT NULL : ENSURES THAT A COLUMN CANNOT STORE NULL VALUES.

-- UNIQUE : ENSURES THAT ALL VALUES IN A COLUMN ARE DIFFERENT.

-- PRIMARY KEY: UNIQUELY IDENTIFIES EACH RECORD IN A TABLE.
--              CANNOT HAVE NULL VALUES.
--              COMBINES UNIQUE AND NOT NULL.

-- FOREIGN KEY:CREATES A LINK BETWEEN TWO TABLES.
--             REFERENCES THE PRIMARY KEY OF ANOTHER TABLE.

-- CHECK: ENSURES THAT VALUES IN A COLUMN MEET A SPECIFIC CONDITION.

-- DEFAULT: PROVIDES A DEFAULT VALUE IF NONE IS SPECIFIED.

-- AUTO INCREMENT: AUTOMATICALLY GENERATES A UNIQUE VALUE WHEN A NEW ROW IS INSERTED.

-- ON DELETE / ON UPDATE ACTIONS (FOR FOREIGN KEYS) :
--           DEFINE WHAT HAPPENS WHEN A REFERENCED ROW IS DELETED OR UPDATED.
-- COMMON ACTIONS:
-- ON DELETE CASCADE → DELETE CHILD RECORDS AUTOMATICALLY.
-- ON DELETE SET NULL → SET VALUE TO NULL.
-- ON DELETE RESTRICT → PREVENT DELETION.
--------------------------------------------------------------------------------

------------------------CREATING TABLES--------------------
-- SYNTAX :
-- CREATE TABLE TABLE_NAME (
--   COLUMN_NAME DATA_TYPE CONSTRAINT
-- );

-- DEPARTMENTS TABLE
CREATE TABLE DEPARTMENT (
    DEPT_ID SERIAL PRIMARY KEY,
    DEPT_NAME VARCHAR(100) NOT NULL UNIQUE,
    LOCATION VARCHAR(100)
);

-- JOB_ROLE TABLE
CREATE TABLE JOB_ROLE (
    ROLE_ID SERIAL PRIMARY KEY,
    ROLE_NAME VARCHAR(100) NOT NULL UNIQUE,
    MIN_SALARY NUMERIC(10,2) CHECK (MIN_SALARY > 0),
    MAX_SALARY NUMERIC(10,2) CHECK (MAX_SALARY > MIN_SALARY)
);

--EMPLOYEE TABLE
CREATE TABLE EMPLOYEE (
    EMP_ID SERIAL PRIMARY KEY,
    FIRST_NAME VARCHAR(50) NOT NULL,
    LAST_NAME VARCHAR(50),
    EMAIL VARCHAR(100) UNIQUE NOT NULL,
    PHONE_NO VARCHAR(15),
    HIRE_DATE DATE DEFAULT CURRENT_DATE,
    DEPT_ID INT REFERENCES DEPARTMENT(DEPT_ID) ON DELETE SET NULL,
    ROLE_ID INT REFERENCES JOB_ROLE(ROLE_ID) ON DELETE SET NULL,
    SALARY NUMERIC(10,2) CHECK (SALARY > 0)
);

--SALARY TABLE
CREATE TABLE SALARY (
    SALARY_ID SERIAL PRIMARY KEY,
    EMP_ID INT REFERENCES EMPLOYEE(EMP_ID) ON DELETE CASCADE,
    BASIC_SALARY NUMERIC(10,2) NOT NULL,
    BONUS NUMERIC(10,2) DEFAULT 0,
    DEDUCTION NUMERIC(10,2) DEFAULT 0,
    NET_SALARY NUMERIC(10,2) GENERATED ALWAYS AS (BASIC_SALARY + BONUS - DEDUCTION) STORED,
    PAY_DATE DATE DEFAULT CURRENT_DATE
);

--ATTENCANCE TABLE
CREATE TABLE ATTENDANCE (
    ATTENDANCE_ID SERIAL PRIMARY KEY,
    EMP_ID INT REFERENCES EMPLOYEE(EMP_ID) ON DELETE CASCADE,
    ATTENDANCE_DATE DATE DEFAULT CURRENT_DATE,
    STATUS VARCHAR(10) CHECK (STATUS IN ('PRESENT', 'ABSENT', 'LEAVE'))
);

--PROJECT TABLE
CREATE TABLE PROJECT (
    PROJECT_ID SERIAL PRIMARY KEY,
    PROJECT_NAME VARCHAR(100) NOT NULL,
    START_DATE DATE,
    END_DATE DATE,
    DEPT_ID INT REFERENCES DEPARTMENT(DEPT_ID),
    EMP_ID INT REFERENCES EMPLOYEE(EMP_ID)
);

---------------INSERTING INTO TABLES AND SELECTING THE TABLES---------------------
-- INSERT: INSERT INTO table_name (column1, column2, column3, ...)
--         VALUES (value1, value2, value3, ...);

-- SELECT:SELECT column1, column2, ...
--       FROM table_name;
    
--       SELECT * FROM table_name;

-- INSERTING INTO DEPARTMENT TABLE
INSERT INTO DEPARTMENT (DEPT_NAME, LOCATION)
VALUES
('Human Resources', 'Mumbai'),
('Finance', 'Delhi'),
('Engineering', 'Bangalore'),
('Marketing', 'Hyderabad');

---SELECTING
SELECT * FROM DEPARTMENT;

-- INSERTING INTO JOB_ROLE
INSERT INTO JOB_ROLE (ROLE_NAME, MIN_SALARY, MAX_SALARY)
VALUES
('HR Manager', 60000, 90000),
('Software Engineer', 50000, 80000),
('Accountant', 40000, 70000),
('Marketing Lead', 45000, 75000),


SELECT * FROM JOB_ROLE;

-- INSERTING INTO EMPLOYEE
INSERT INTO EMPLOYEE (FIRST_NAME, LAST_NAME, EMAIL, PHONE_NO, HIRE_DATE, DEPT_ID, ROLE_ID, SALARY)
VALUES
('Aarav', 'Sharma', 'aarav.sharma@company.com', '9876543210', '2022-05-12', 1, 1, 85000),
('Diya', 'Patel', 'diya.patel@company.com', '9876500010', '2023-01-18', 3, 2, 75000),
('Karan', 'Singh', 'karan.singh@company.com', '9876500020', '2021-09-25', 2, 3, 65000),
('Meera', 'Rao', 'meera.rao@company.com', '9876500030', '2024-03-05', 4, 4, 72000);

SELECT * FROM EMPLOYEE;

-- INSERTING INTO SALARY
INSERT INTO SALARY (EMP_ID, BASIC_SALARY, BONUS, DEDUCTION)
VALUES
(1, 80000, 5000, 2000),
(2, 70000, 8000, 1500),
(3, 60000, 4000, 1000),
(4, 68000, 6000, 1200);

SELECT * FROM SALARY;

-- INSERTING INTO ATTENDANCE
INSERT INTO ATTENDANCE (EMP_ID, ATTENDANCE_DATE, STATUS)
VALUES
(1, '2025-10-28', 'PRESENT'),
(2, '2025-10-28', 'PRESENT'),
(3, '2025-10-28', 'ABSENT'),
(4, '2025-10-28', 'LEAVE');

SELECT * FROM ATTENDANCE;

-- INSERTING INTO PROJECT
INSERT INTO PROJECT (PROJECT_NAME, START_DATE, END_DATE, DEPT_ID, EMP_ID)
VALUES
('HR Portal Upgrade', '2024-02-01', '2024-06-30', 1, 1),
('Payroll Automation', '2024-03-10', '2024-08-15', 2, 3),
('Website Redesign', '2024-05-01', '2024-09-20', 3, 2),
('Marketing Analytics', '2024-04-01', '2024-07-31', 4, 4);

SELECT * FROM PROJECT;



--------------------SELECT SPECIFIC COLUMNS----------------
--  Display only FIRST_NAME, LAST_NAME, and SALARY of all employees
 
SELECT FIRST_NAME,LAST_NAME,SALARY FROM EMPLOYEE;

--------------------DISTINCT (SELECT ONLY UNIQUE VALUES) -----------------------------------
--  Display all unique department IDs from the EMPLOYEE table
SELECT DISTINCT DEPT_ID FROM EMPLOYEE;

-----------------WHERE CLAUSE--------------------------
-- The WHERE clause filters records based on a condition
-- Syntax :
--              SELECT column1, column2
--              FROM table_name
--              WHERE condition;
-- Display all employees whose salary is greater than 60000.
SELECT * FROM EMPLOYEE WHERE SALARY >60000;


-----------------------ALTER TABLE (USED TO CHANGE THE STRUCTURE OF AN EXISTING TABLE)----------------------------------
--   ADD, MODIFY, OR DELETE COLUMNS OR CONSTRAINTS.

--------------ADD COLUMN---------------
-- ALTER TABLE TABLE_NAME
-- ADD COLUMN COLUMN_NAME DATA_TYPE [CONSTRAINT];

ALTER TABLE EMPLOYEE
ADD COLUMN GENDER VARCHAR(10);

----------ADD DATATYPE-----------------
-- ALTER TABLE TABLE_NAME
-- ALTER COLUMN COLUMN_NAME TYPE NEW_DATA_TYPE;

ALTER TABLE EMPLOYEE
ALTER COLUMN PHONE_NO TYPE VARCHAR(20);

---------DROP COLUMN-------------------
-- ALTER TABLE TABLE_NAME
-- DROP COLUMN COLUMN_NAME;

ALTER TABLE EMPLOYEE
DROP COLUMN GENDER;

---------ADD/DROP CONSTRAINT----------

-- ALTER TABLE TABLE_NAME
-- ADD CONSTRAINT CONSTRAINT_NAME CONSTRAINT_DEFINITION;

ALTER TABLE EMPLOYEE
ADD CONSTRAINT CHK_SALARY CHECK (SALARY > 0);

-- ALTER TABLE TABLE_NAME
-- DROP CONSTRAINT CONSTRAINT_NAME;

ALTER TABLE EMPLOYEE
DROP CONSTRAINT CHK_SALARY;

---------------UPDATE(MODIFY EXISTING DATA IN A TABLE)----------------------
-- UPDATE TABLE_NAME
-- SET COLUMN1 = VALUE1, COLUMN2 = VALUE2, ...
-- WHERE CONDITION;

UPDATE EMPLOYEE
SET PHONE_NO = '9876543211', EMAIL = 'HARHIKA.DARSE@COMPANY.COM'
WHERE EMP_ID = 2;

-------------DELETE( SPECIFIC ROWS FROM A TABLE)-------------------
-- DELETE FROM TABLE_NAME
-- WHERE CONDITION;

DELETE FROM EMPLOYEE
WHERE EMP_ID = 10;

------------------COMPARISON OPERATORS(USED TO COMPARE VALUES IN SQL QUERIES)----------

-- OPERATOR 	MEANING	        EXAMPLE

-- =	        EQUAL TO	    SALARY = 50000

-- <> OR !=	    NOT EQUAL TO	DEPT_ID <> 3

-- >	        GREATER THAN	SALARY > 60000

-- <	        LESS THAN	    SALARY < 60000

-- >=	        GREATER THAN 
--             OR EQUAL TO	    SALARY >= 50000
            
-- <=	        LESS THAN 
--             OR EQUAL TO	    SALARY <= 40000


-------------------LOGICAL OPERATORS(USED TO COMBINE MULTIPLE CONDITIONS IN A WHERE CLAUSE)-------------------------

-- OPERATOR  	MEANING
-- AND	        RETURNS TRUE IF ALL CONDITIONS ARE TRUE
-- OR	        RETURNS TRUE IF ANY CONDITION IS TRUE
-- NOT	        REVERSES THE RESULT (TRUE → FALSE, FALSE → TRUE)

-- SELECT COLUMN1, COLUMN2
-- FROM TABLE_NAME
-- WHERE CONDITION1 [AND | OR | NOT] CONDITION2;

-- FETCH ALL EMPLOYEES WHOSE
-- SALARY IS GREATER THAN 50000 AND LESS THAN 100000
-- AND THEY WORK IN DEPARTMENT 2 OR 3
-- BUT NOT IN DEPARTMENT 5
-- ALSO, THEIR JOB ROLE ID SHOULD BE GREATER THAN OR EQUAL TO 2


SELECT * FROM EMPLOYEE WHERE SALARY >50000 AND SALARY <100000
AND (DEPT_ID=2 OR DEPT_ID= 3)
AND NOT (DEPT_ID=5 )
AND ROLE_ID>=2;


---------------BETWEEN OPERATOR(USED TO FILTER RESULTS WITHIN A RANGE - INCLUSIVE OF BOTH LIMITS)---------------------------------------------------
-- SYNTAX:
    --   SELECT * FROM TABLE_NAME
    --   WHERE COLUMN_NAME BETWEEN VALUE1 AND VALUE2;

-- FETCH EMPLOYEES WHO HAVE SALARY BETWEEN 40000 AND 80000.

SELECT * FROM EMPLOYEE WHERE SALARY BETWEEN 40000 AND 80000;

---------------IN OPERATOR ( FILTERS RECORDS BY CHECKING IF A VALUE MATCHES ANY VALUE IN A LIST)------------------------------------------------
-- SYNTAX:
         --SELECT * FROM TABLE_NAME
         -- WHERE COLUMN_NAME IN (VALUE1, VALUE2, VALUE3);

         -- WHERE COLUMN_NAME NOT IN (VALUE1, VALUE2, VALUE3);

-- FETCH EMPLOYEES WHO WORK IN DEPT 2, 3, OR 5 AND HAVE SALARY ABOVE 60000.

SELECT * FROM EMPLOYEE WHERE DEPT_ID IN(2,3,5)
AND SALARY >60000;
 
----------------LIKE OPERATOR(USED FOR PATTERN MATCHING WITH WILDCARDS)---------------

-- % : MATCHES ANY SEQUENCE OF CHARACTERS

-- _ : MATCHES A SINGLE CHARACTER

-- EXAMPLE:
      -- LIKE '%A'    → ENDS WITH A  
      -- LIKE '%A%'   → CONTAINS A  
      -- LIKE '_A%'   → SECOND CHARACTER IS A

-- FETCH EMPLOYEES WHOSE FIRST NAME STARTS WITH A
SELECT * FROM EMPLOYEE
WHERE FIRST_NAME LIKE 'A%';


-------------------------ILIKE OPERATOR (POSTGRESQL ONLY)-------------------
-- CASE-INSENSITIVE VERSION OF LIKE
-- FETCH EMPLOYEES WHOSE FIRST NAME STARTS WITH A OR a 

SELECT * FROM EMPLOYEE
WHERE FIRST_NAME ILIKE 'a%';

-------------------------SIMILAR TO (SAME LIKE "LIKE" BUT USED FOR EXPRESSION)--------------------
-----CASE SENSITIVE
-----employees whose first name either:
                                    -- STARTS WITH A OR ENDS WITH a
SELECT * FROM EMPLOYEE
WHERE FIRST_NAME SIMILAR TO 'A%|%a';

----------------ORDER BY(SORT THE RESULT SET IN ASC OR DESC)-------------------------------------------
-- SELECT column1, column2, ...
-- FROM table_name
-- ORDER BY column_name [ASC | DESC];

-- Display all employees ordered by their SALARY in Ascending order.
SELECT * FROM EMPLOYEE ORDER BY SALARY ;

-- Display FIRST_NAME, DEPT_ID, and SALARY of employees
--who earn more than 50000, and order them by SALARY in descending order.

SELECT FIRST_NAME, DEPT_ID,SALARY FROM EMPLOYEE
WHERE SALARY>50000 
ORDER BY SALARY DESC;

--------------------------LIMIT AND OFFSET---------------------------------------------------
-- LIMIT : USED TO CONTROL HOW MANY ROWS TO RETURN
--OFFSET : FROM WHERE TO START THE RETURING OF ROWS 

-- SYNTAX:
-- SELECT * FROM TABLE_NAME
-- LIMIT N OFFSET M;   

SELECT * FROM EMPLOYEE
ORDER BY EMP_ID
LIMIT 1 OFFSET 2;

------------------------------------------------------------------------------------------
-- FETCH EMPLOYEES WHOSE FIRST NAME STARTS WITH ‘A’ OR ENDS WITH ‘N’,
-- HAVE SALARY BETWEEN 40000 AND 90000,
-- BELONG TO DEPT 1 OR 3,
-- IGNORE CASE IN NAME SEARCH,
-- AND DISPLAY ONLY FIRST 3 RESULTS AFTER SKIPPING THE FIRST 2.

SELECT * FROM EMPLOYEE
WHERE (FIRST_NAME ILIKE 'A%' OR FIRST_NAME ILIKE '%N') AND
SALARY BETWEEN 40000 AND 90000 AND
DEPT_ID IN(1,2,3)
LIMIT 3 OFFSET 1;

---------------------------------------------------AGGREGATE FUNCTIONS AND GROUPING (calculates on a set of values, returning a single value)------------------------------------------------------------------

-- COMMON AGGREGATE FUNCTIONS:
--     COUNT() — RETURNS THE NUMBER OF ROWS
--     SUM() — RETURNS THE SUM OF A NUMERIC COLUMN
--     AVG() — RETURNS THE AVERAGE VALUE
--     MIN() — RETURNS THE MINIMUM VALUE
--     MAX() — RETURNS THE MAXIMUM VALUE
    
-- COUNTS EMPLOYEES WHO EARN ABOVE 50K
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SALARY>50000;

--MAXIMUM BONUS
SELECT MAX(BONUS) FROM SALARY;

    
--------------------------------GROUP BY-----------------------------------
--  IS USED TO ARRANGE ROWS THAT HAVE THE SAME VALUE INTO GROUPS.
-- IT’S ALMOST ALWAYS USED WITH AGGREGATE FUNCTIONS (COUNT, SUM, AVG, MIN, MAX).
    
-- SYNTAX: SELECT column_name, AGGREGATE_FUNCTION(column_name)
--         FROM table_name
--         GROUP BY column_name;

-- AVERAGE SALARY BY DEPARTMENT

SELECT DEPT_ID, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_ID;

------------------------------HAVING(SIMILAR TO WHERE)------------------------------------
-- HAVING IS LIKE WHERE, BUT IT WORKS AFTER GROUPING.
-- YOU USE HAVING TO FILTER GROUPS BASED ON AGGREGATE VALUES.

-- SYNTAX:
-- SELECT column_name, AGGREGATE_FUNCTION(column_name)
-- FROM table_name
-- GROUP BY column_name
-- HAVING condition;

-- SHOW DEPARTMENTS WHERE AVERAGE SALARY > 60000
SELECT DEPT_ID, AVG(SALARY) AS AVG_SALARY
FROM EMPLOYEE
GROUP BY DEPT_ID
HAVING AVG(SALARY) > 60000;
------------------------------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO DEPARTMENT (DEPT_NAME, LOCATION)
VALUES
('Sales', 'Chennai'),
('Customer Support', 'Pune');



INSERT INTO JOB_ROLE (ROLE_NAME, MIN_SALARY, MAX_SALARY)
VALUES
('Sales Executive', 35000, 65000),
('Support Engineer', 30000, 60000);

SELECT * FROM JOB_ROLE;

INSERT INTO EMPLOYEE (FIRST_NAME, LAST_NAME, EMAIL, PHONE_NO, HIRE_DATE, DEPT_ID, ROLE_ID, SALARY)
VALUES
('Rohan', 'Verma', 'rohan.verma@company.com', '9876500040', '2022-06-10', 5, 6, 55000),
('Anika', 'Nair', 'anika.nair@company.com', '9876500050', '2023-11-02', 6, 7, 48000),
('Vikram', 'Seth', 'vikram.seth@company.com', '9876500060', '2021-12-15', 3, 2, 78000),
('Sara', 'Ali', 'sara.ali@company.com', '9876500070', '2024-01-25', 4, 4, 69000);

SELECT * FROM EMPLOYEE
ORDER BY EMP_ID;
----------- DELETING SOME ROWS TO REASSIGN MY EMPID TO BE IN ORDER----------------------
DELETE FROM EMPLOYEE
WHERE EMP_ID > 4;

SELECT setval('employee_emp_id_seq', 4);

INSERT INTO EMPLOYEE (FIRST_NAME, LAST_NAME, EMAIL, PHONE_NO, HIRE_DATE, DEPT_ID, ROLE_ID, SALARY)
VALUES
('Rohan', 'Verma', 'rohan.verma@company.com', '9876500040', '2022-06-10', 5, 6, 55000),
('Anika', 'Nair', 'anika.nair@company.com', '9876500050', '2023-11-02', 6, 7, 48000),
('Vikram', 'Seth', 'vikram.seth@company.com', '9876500060', '2021-12-15', 3, 2, 78000),
('Sara', 'Ali', 'sara.ali@company.com', '9876500070', '2024-01-25', 4, 4, 69000);


SELECT * FROM EMPLOYEE ORDER BY EMP_ID;

INSERT INTO SALARY (EMP_ID, BASIC_SALARY, BONUS, DEDUCTION)
VALUES
(5, 52000, 4000, 1200),
(6, 45000, 3000, 900),
(7, 75000, 6000, 1500),
(8, 68000, 5000, 1000);

INSERT INTO ATTENDANCE (EMP_ID, ATTENDANCE_DATE, STATUS)
VALUES
(5, CURRENT_DATE, 'PRESENT'),
(6, CURRENT_DATE, 'ABSENT'),
(7, CURRENT_DATE, 'PRESENT'),
(8, CURRENT_DATE, 'LEAVE');

INSERT INTO PROJECT (PROJECT_NAME, START_DATE, END_DATE, DEPT_ID, EMP_ID)
VALUES
('Sales CRM Upgrade', '2024-01-05', '2024-05-30', 5, 5),
('Customer Support AI Bot', '2024-02-10', '2024-08-15', 6, 6),
('Backend Optimization', '2024-06-01', '2024-10-20', 3, 7),
('Brand Campaign Launch', '2024-07-01', '2024-09-30', 4, 8);

-----------------------------JOINS (used to combine rows from two or more tables based on a related column (usually a foreign key))------------------------------------------------------------
-- TYPES:
--      JOIN TYPE           MEANING
--      INNER JOIN	     Matching rows only
--      LEFT JOIN	     All rows from left + matching from right
--      RIGHT JOIN	     All rows from right + matching from left
--      FULL JOIN	     All rows from both tables
--      CROSS JOIN	     Cartesian product 

-------------------------------INNER JOIN---------------------------

-- Fetch employee names with their department names
SELECT 
    E.EMP_ID,
    E.FIRST_NAME,
    E.LAST_NAME,
    D.DEPT_NAME
FROM EMPLOYEE E
INNER JOIN DEPARTMENT D
ON E.DEPT_ID = D.DEPT_ID;

-----------------------LEFT JOIN (ALL ROWS FROM LEFT + MATCHING FROM RIGHT)-------------------------

INSERT INTO EMPLOYEE (FIRST_NAME, LAST_NAME, EMAIL, PHONE_NO, HIRE_DATE, DEPT_ID, ROLE_ID, SALARY)
VALUES
('Ritika', 'Mishra', 'ritika.m@company.com', '9876500091', '2024-05-15', NULL, NULL, 50000);

-- Filtering only employees who do NOT have department assigned (DEPT_NAME IS NULL)

SELECT E.EMP_ID, E.FIRST_NAME, D.DEPT_NAME
FROM EMPLOYEE E
LEFT JOIN DEPARTMENT D ON E.DEPT_ID = D.DEPT_ID
WHERE DEPT_NAME IS NULL;

-------------------RIGHT JOIN (ALL ROWS FROM RIGHT + MATCHING FROM LEFT)-----------------------------
--INSERTING NEW DEPARTMENT ROW
INSERT INTO DEPARTMENT (DEPT_NAME, LOCATION)
VALUES ('Research', 'Kolkata'); 

--ADDING A DEPT_ID COLUMN TO JOB_ROLE USING FORIEGN KEY
ALTER TABLE JOB_ROLE ADD COLUMN DEPT_ID INT REFERENCES DEPARTMENT(DEPT_ID);

--ADDING DEPT_ID TO THE ROLES
UPDATE JOB_ROLE SET DEPT_ID = 1 WHERE ROLE_NAME = 'HR Manager';
UPDATE JOB_ROLE SET DEPT_ID = 2 WHERE ROLE_NAME = 'Accountant';
UPDATE JOB_ROLE SET DEPT_ID = 3 WHERE ROLE_NAME = 'Software Engineer';
UPDATE JOB_ROLE SET DEPT_ID = 4 WHERE ROLE_NAME = 'Marketing Lead';
UPDATE JOB_ROLE SET DEPT_ID = 5 WHERE ROLE_NAME = 'Sales Executive';
UPDATE JOB_ROLE SET DEPT_ID = 6 WHERE ROLE_NAME = 'Support Engineer';


-- RIGHT JOIN to show all departments including those without job roles

SELECT 
    JOB_ROLE.ROLE_ID,
    JOB_ROLE.ROLE_NAME,
    DEPARTMENT.DEPT_NAME
FROM JOB_ROLE
RIGHT JOIN DEPARTMENT
ON JOB_ROLE.DEPT_ID = DEPARTMENT.DEPT_ID;

-------------------------- FULL OUTER JOIN (all records — matched + unmatched from both tables)---------------------
-- Shows all employees & all departments
-- Even if an employee has no department OR a department has no employees

SELECT 
    E.EMP_ID,
    E.FIRST_NAME,
    D.DEPT_NAME
FROM EMPLOYEE E
FULL OUTER JOIN DEPARTMENT D
ON E.DEPT_ID = D.DEPT_ID;

---------------------------CROSS JOIN(CARTESIAN PRODUCT) -----------------------------------------------------------------
-- Create all combinations of employees with departments

SELECT 
    E.EMP_ID,
    E.FIRST_NAME,
    D.DEPT_NAME
FROM EMPLOYEE E
CROSS JOIN DEPARTMENT D;
------------------------------------SELF JOIN-----------------------------------------------------------------------------
--ADD MANAGER_ID COLUMN TO THE EMPLOYEE TABLE
ALTER TABLE EMPLOYEE
ADD COLUMN MANAGER_ID INT REFERENCES EMPLOYEE(EMP_ID);

--ASSIGNING THE MANAGERS FROM THE EMPLOYEES 

UPDATE EMPLOYEE SET MANAGER_ID = NULL WHERE EMP_ID = 1;

UPDATE EMPLOYEE SET MANAGER_ID = 1 WHERE EMP_ID IN (3, 4, 2);
UPDATE EMPLOYEE SET MANAGER_ID = 3 WHERE EMP_ID IN (5, 6);
UPDATE EMPLOYEE SET MANAGER_ID = 2 WHERE EMP_ID = 7;
UPDATE EMPLOYEE SET MANAGER_ID = 4 WHERE EMP_ID IN (8);
--FETCH THE EMPLOYEES AND THEIR MANAGERS
SELECT 
    E.EMP_ID AS EMPLOYEE_ID,
    E.FIRST_NAME AS EMPLOYEE_NAME,
    M.FIRST_NAME AS MANAGER_NAME
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE M 
ON E.MANAGER_ID = M.EMP_ID
ORDER BY EMPLOYEE_ID;
     
 --------------SOLVE IT----------------------------     
-- Write an SQL query to display:

-- EMPLOYEE NAME, DEPARTMENT NAME, MANAGER NAME, PROJECT NAME, NET SALARY

-- Conditions:

--           Show all employees, even if:

--           They don’t have a manager

--           They are not assigned to any project

--           Employees without managers should show "NO MANAGER"

--           Order the result by employee name (A→Z)


-- COALESCE RETURNS THE FIRST NON-NULL VALUE FROM A LIST OF VALUES. 

SELECT CONCAT(E1.FIRST_NAME,' ',E1.LAST_NAME) AS EMPLOYEE_NAME,COALESCE(E2.FIRST_NAME||' '||E2.LAST_NAME,'NO MANAGER' )AS MANAGER_NAME,
D.DEPT_NAME,
P.PROJECT_NAME,
S.NET_SALARY
FROM EMPLOYEE E1 LEFT JOIN EMPLOYEE E2
ON E1.MANAGER_ID=E2.EMP_ID
LEFT JOIN DEPARTMENT D
ON E1.DEPT_ID=D.DEPT_ID
LEFT JOIN PROJECT P
ON E1.EMP_ID=P.EMP_ID
LEFT JOIN SALARY S ON E1.EMP_ID = S.EMP_ID
ORDER BY EMPLOYEE_NAME;

SELECT * FROM EMPLOYEE;

SELECT ('AA'||NULL);
--WHILE CONCATING USING " || " THEN IF ONE VALUE IS NULL THEN IT IS RETURING NULL
--O/P:NULL

SELECT CONCAT('AA',NULL);
--WHILE CONCATING WITH KEYWORD THEN IF ONE VALUE IS NULL THEN IT IS RETURING NOT NULL VALUE
--O/P:AA

-- CASE IS USED FOR CONDITIONAL LOGIC IN SQL (LIKE IF-ELSE IN PROGRAMMING).
-- SYNTAX
-- CASE 
--     WHEN CONDITION1 THEN RESULT1
--     WHEN CONDITION2 THEN RESULT2
--     ELSE DEFAULT_RESULT
-- END

SELECT CONCAT(E1.FIRST_NAME,' ',E1.LAST_NAME) AS EMPLOYEE_NAME,
CASE
 WHEN (E2.FIRST_NAME||' '||E2.LAST_NAME) IS NULL THEN 'NO MANAGER'
 ELSE (E2.FIRST_NAME ||' '||E2.LAST_NAME)
  END AS MANAGER_NAME,
  D.DEPT_NAME,
P.PROJECT_NAME,
S.NET_SALARY
FROM EMPLOYEE E1 LEFT JOIN EMPLOYEE E2
ON E1.MANAGER_ID=E2.EMP_ID
LEFT JOIN DEPARTMENT D
ON E1.DEPT_ID=D.DEPT_ID
LEFT JOIN PROJECT P
ON E1.EMP_ID=P.EMP_ID
LEFT JOIN SALARY S ON E1.EMP_ID = S.EMP_ID
ORDER BY EMPLOYEE_NAME;

---------------------------------STRING FUNCTIONS-----------------------------------------------------------------|
-- | Function    | Meaning                                         | Syntax                                          |                                             
-- | ----------- | ----------------------------------------------- | ------------------------------------------------|
-- | UPPER()     | Convert to uppercase                            | `UPPER('string')                                |                                     
-- | LOWER()     | Convert to lowercase                            | `LOWER('STRING')                                |                                     
-- | INITCAP()   | Capitalize first letter of each word *(Oracle)* | `INITCAP('string')                              |
-- | LENGTH()    | Find length of string                           | `LENGTH('string')                               |                                         
-- | CONCAT()    | Combine strings                                 | `CONCAT('str1', 'str2')                         |                                             
-- | SUBSTRING() | Extract text                                    | `SUBSTRING('string' FROM start FOR length)      |                                     
-- | LEFT()      | Get left characters                             | `LEFT('string', number)                         |                                          
-- | RIGHT()     | Get right characters                            | `RIGHT('string', number)                        |
-- | TRIM()      | Remove spaces from both sides                   | `TRIM(' string ')                               |                                           
-- | LTRIM()     | Remove left spaces                              | `LTRIM(' string')                               |
-- | RTRIM()     | Remove right spaces                             | `RTRIM('string ')                               |                                          
-- | REPLACE()   | Replace text                                    | `REPLACE('string', 'old', 'new')                |
-- | POSITION()  | Find index of substring                         | `POSITION('substring' IN 'string')              |                                          
-- | REVERSE()   | Reverse string                                  | `REVERSE('string')                              |
-- -------------------------------------------------------------------------------------------------------------------

------------SOLVE IT--------------------
-- Write an SQL query to display:
    --   Full Name in Uppercase
    --   Username extracted from Email (text before @)
    --   Length of full name
    --   Check if the name contains the letter 'a' (case-insensitive)
    --   If yes → 'HAS A'
    --   If no → 'NO A'
       
SELECT 
    UPPER(CONCAT(FIRST_NAME, ' ', LAST_NAME)) AS EMPLOYEE_NAME,
    SUBSTRING(EMAIL FROM 1 FOR POSITION('@' IN EMAIL)-1) AS USERNAME,
    LENGTH(CONCAT(FIRST_NAME, ' ', LAST_NAME)) AS NAME_LENGTH,
    CASE 
        WHEN CONCAT(FIRST_NAME, ' ', LAST_NAME) ILIKE '%a%' 
        THEN 'HAS A'
        ELSE 'NO A'
    END AS A_PRESENT
FROM EMPLOYEE;

-- -------------------------MATH FUNCTION-------------------------------------------
-- | FUNCTION               | MEANING                  | EXAMPLE                |
-- | ---------------------- | ------------------------ | ---------------------- |
-- | `ABS()`                | Returns absolute value   | `ABS(-15)` → 15        |
-- | `CEIL()` / `CEILING()` | Rounds number UP         | `CEIL(4.2)` → 5        |
-- | `FLOOR()`              | Rounds number DOWN       | `FLOOR(4.8)` → 4       |
-- | `ROUND()`              | Rounds to nearest number | `ROUND(7.56, 1)` → 7.6 |
-- | `POWER()`              | x raised to y            | `POWER(2,3)` → 8       |
-- | `SQRT()`               | Square root              | `SQRT(16)` → 4         |
-- | `MOD()`                | Remainder                | `MOD(17,5)` → 2        |
-- | `RANDOM()`             | Random number b/w 0 & 1  | `RANDOM()` → 0.345...  |
---------------------------------------------------------------------------------

------------------------SOLVE IT-----------------------------
-- Write a query to calculate:
--       Employee Name
--       Salary
--       Salary Rounded to nearest integer
--       Salary MOD 1000 (to show last 3 digits)

SELECT 
    CONCAT(E.FIRST_NAME, ' ', E.LAST_NAME) AS EMPLOYEE_NAME,
    S.NET_SALARY,
    ROUND(S.NET_SALARY) AS ROUNDED_SALARY,
    MOD(ROUND(S.NET_SALARY), 1000) AS LAST_3_DIGITS
FROM EMPLOYEE E
JOIN SALARY S ON E.EMP_ID = S.EMP_ID
ORDER BY EMPLOYEE_NAME;


-- Write a SQL query to display:
-- Employee full name in uppercase
-- Their original salary
-- Salary rounded to nearest thousand
-- 10% bonus added to salary (display as Bonus_Salary)
-- Show "HIGH SALARY" if Net Salary > 80,000 else "NORMAL" as Salary_Status

-- ROUND(-1) = round to 10 
-- ROUND(-2) = round to 100
-- ROUND(-3) = round to 1000
-- 1.10 = 100% salary + 10% bonus
-- Negative decimal in ROUND → left side rounding
 
 
SELECT 
    UPPER(CONCAT(E.FIRST_NAME,' ',E.LAST_NAME)) AS EMPLOYEE_NAME,
    S.NET_SALARY,
    
    -- ROUND salary to nearest 1000
    ROUND(S.NET_SALARY, -3) AS ROUNDED_TO_1000,
    
    -- Add 10% bonus
    (S.NET_SALARY * 1.10) AS BONUS_SALARY,
    
    -- Salary status
    CASE 
        WHEN S.NET_SALARY > 80000 THEN 'HIGH SALARY'
        ELSE 'NORMAL'
    END AS SALARY_STATUS

FROM EMPLOYEE E
JOIN SALARY S ON E.EMP_ID = S.EMP_ID
ORDER BY EMPLOYEE_NAME;

------------------------------DATE & TIME FUNCTIONS---------------------------------
-- Function	            Purpose	                        Example
-- CURRENT_DATE	       Today's date	                 2025-10-30
-- CURRENT_TIMESTAMP	Date + Time + Timezone	     2025-10-30 12:45:21+05:30
-- NOW()	            Same as current timestamp	
-- AGE(date1, date2)	Difference between 2 dates	 AGE(CURRENT_DATE, '2022-05-12')
-- DATE_PART()	        Extract part of date/time	 DATE_PART('year', hire_date)
-- EXTRACT()	        Extract component	         EXTRACT(MONTH FROM hire_date)
-- TO_CHAR()	        Format date	                 TO_CHAR(hire_date,'DD-Mon-YYYY')

-- Show employee name, hire year, and total experience (in years)
SELECT 
    FIRST_NAME AS EMPLOYEE_NAME,
    EXTRACT(YEAR FROM HIRE_DATE) AS HIRE_YEAR,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, HIRE_DATE)) AS EXPERIENCE_YEARS
FROM EMPLOYEE;

-----------------------------NULL FUNCTIONS------------------------------------------
-- FUNCTION	           PURPOSE	                               EXAMPLE
-- COALESCE()	   Returns first non-NULL value	           COALESCE(manager_id, 'NO MANAGER')
-- NULLIF()	       Returns NULL if both values are equal   NULLIF(100, 100)
-- IS NULL	       Check if value is NULL	               salary IS NULL
-- IS NOT NULL	   Check if value is NOT NULL	           salary IS NOT NULL
-- CAST() / ::	   Convert data type	                   CAST(salary AS TEXT) or salary::TEXT

SELECT * 
FROM EMPLOYEE 
WHERE MANAGER_ID IS NULL;
 
--------------------------NULL IF ,CAST---------------
-- RETURNS NULL IF BOTH VALUES ARE EQUAL, OTHERWISE RETURNS THE FIRST VALUE.
--CAST USED FOR CONVERTING THE DATATYPE
SELECT 
    E.FIRST_NAME,
    S.BASIC_SALARY,
    S.BONUS,
    S.BASIC_SALARY / NULLIF(S.BONUS, 0)::NUMERIC AS BONUS_RATIO
FROM SALARY S
JOIN EMPLOYEE E ON S.EMP_ID = E.EMP_ID;

--------------------------SUBQUERY----------------------------
-- Is a SQL query written inside another query to fetch data based on the result of the inner query.
-- Syntax:
-- SELECT columns
-- FROM table
-- WHERE column OPERATOR (
--     SELECT column FROM another_table WHERE condition
-- );

-----------Single-Row Subquery 
            -- Returns one value   =, <, >
--EX
-- Find employees earning more than the average salary
SELECT FIRST_NAME, LAST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > (
    SELECT AVG(SALARY) FROM EMPLOYEE
);

------------Multi-Row Subquery
           -----Returns multiple rows IN, ANY, ALL
-- EX:
-- Get employees from departments located IN ‘Mumbai’
SELECT FIRST_NAME, LAST_NAME
FROM EMPLOYEE
WHERE DEPT_ID IN (
    SELECT DEPT_ID
    FROM DEPARTMENT
    WHERE LOCATION = 'Mumbai'
);

-- Employees earning more than ANY salary in the Sales department:
SELECT FIRST_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ANY (SELECT SALARY FROM EMPLOYEE WHERE DEPT_ID = 5);
                --  (MIN)

-- Employees earning more than ALL salaries in the Sales department:
SELECT FIRST_NAME FROM EMPLOYEE
WHERE SALARY > ALL (SELECT SALARY FROM EMPLOYEE WHERE DEPT_ID = 5);
                --   (MAX)

--------------Subquery in SELECT
                    --   Used in SELECT clause
-- EX:
-- Display salary & average difference
SELECT 
    FIRST_NAME,
    SALARY,
    SALARY - (SELECT AVG(SALARY) FROM EMPLOYEE) AS DIFF_FROM_AVG
FROM EMPLOYEE;

--------------Subquery in FROM
                    --   Treat subquery as table
-- EX:
SELECT DEPT_ID, TOTAL_EMP
FROM (
    SELECT DEPT_ID, COUNT(*) AS TOTAL_EMP
    FROM EMPLOYEE
    GROUP BY DEPT_ID
) AS DEPT_SUMMARY;

--------------------------SOLVE IT----------------------------
-- Find employees whose salary is greater than the salary of ALL employees hired before them.
SELECT E1.EMP_ID, E1.FIRST_NAME, E1.SALARY, E1.HIRE_DATE
FROM EMPLOYEE E1
WHERE E1.SALARY > ALL (
    SELECT E2.SALARY
    FROM EMPLOYEE E2
    WHERE E2.HIRE_DATE < E1.HIRE_DATE
);

------------------------SET OPERATIONS------------------------
-- RULES:
--       Same number of columns
--       Same data type
--       Column order must match
------------------UNION(Combines rows, removes duplicates)--
-- Show all department IDs from employees + departments (no duplicates)
SELECT DEPT_ID FROM EMPLOYEE
UNION
SELECT DEPT_ID FROM DEPARTMENT;

------------------UNION ALL(Combines rows, keeps duplicates)--
SELECT DEPT_ID FROM EMPLOYEE
UNION ALL
SELECT DEPT_ID FROM DEPARTMENT;

------------------INTERSECT(Returns common rows)--------------
-- Departments where employees exist
SELECT DEPT_ID FROM EMPLOYEE
INTERSECT
SELECT DEPT_ID FROM DEPARTMENT;

-----------------EXCEPT(Returns rows present in first query only)
-- Departments with NO employees
SELECT DEPT_ID FROM DEPARTMENT
EXCEPT
SELECT DEPT_ID FROM EMPLOYEE;


-----------------VIEW------------------------------
-- A VIEW IS A VIRTUAL TABLE BASED ON A QUERY.
-- IT DOES NOT STORE DATA — IT STORES THE QUERY.
-- WHEN YOU SELECT FROM A VIEW, THE QUERY RUNS AUTOMATICALLY.

-- SYNTAX:
        --  CREATE VIEW view_name AS
        --  SELECT column1, column2, ...
        --  FROM table_name
        --  WHERE condition;

-- SELECT FROM VIEW
-- SELECT * FROM VIEWNAME;

----UPDATE/REPLACE
-- CREATE OR REPLACE VIEW view_name AS
-- SELECT column1, column2, ...
-- FROM table_name
-- WHERE condition;

-- SHOW EMPLOYEE NAME & DEPARTMENT
CREATE VIEW EMPLOYEE_DEPT_VIEW AS
SELECT E.EMP_ID,
       CONCAT(E.FIRST_NAME,' ',E.LAST_NAME) AS FULL_NAME,
       D.DEPT_NAME
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_ID = D.DEPT_ID;

SELECT * FROM EMPLOYEE_DEPT_VIEW;

CREATE OR REPLACE VIEW EMPLOYEE_DEPT_VIEW AS
SELECT E.EMP_ID,
       CONCAT(E.FIRST_NAME,' ',E.LAST_NAME) AS FULL_NAME,
       D.DEPT_NAME,
       E.HIRE_DATE
FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_ID = D.DEPT_ID;

DROP VIEW EMPLOYEE_DEPT_VIEW;

-- Create a view showing:
--           EMPLOYEE NAME
--           DEPARTMENT
--           SALARY
--         EXPERIENCE IN YEARS
--          MANAGER NAME (If NULL show 'NO MANAGER')

CREATE OR REPLACE VIEW EMP_FULL_DETAILS_VIEW AS
SELECT 
    CONCAT(E1.FIRST_NAME,' ',E1.LAST_NAME) AS EMPLOYEE_NAME,
    COALESCE((E2.FIRST_NAME ||' '||E2.LAST_NAME), 'NO MANAGER') AS MANAGER_NAME,
    D.DEPT_NAME,
    E1.SALARY,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, E1.HIRE_DATE)) AS EXPERIENCE_YEARS
FROM EMPLOYEE E1
LEFT JOIN EMPLOYEE E2
    ON E1.MANAGER_ID = E2.EMP_ID
LEFT JOIN DEPARTMENT D
    ON E1.DEPT_ID = D.DEPT_ID

SELECT * FROM  EMP_FULL_DETAILS_VIEW;

