SELECT * FROM table
WHERE ###conditions
AND
OR
COUNT () ###function
DISTINCT () ##return rows with unique values

ORDER BY DESC/ASC ##order rows by coumns 
LIMIT
BETWEEN AND
IN ##list of conditions 
LIKE % _ ##pattern matching
ILIKE
AVG()
MIN()
MAX()
SUM()

GROUP BY

HAVING

###assessment  Test1
SELECT customer_id,SUM(amount) FROM payment
WHERE staff_id =2
GROUP BY customer_id
HAVING SUM(amount) >=110;

SELECT COUNT(*) FROM film
WHERE title LIKE 'J%';

SELECT first_name,last_name FROM customer
WHERE first_name LIKE 'E%' AND address_id <500
ORDER BY customer_id DESC
LIMIT 1;


####JOIN
AS 
INNER JOIN ...ON 
FULL OUTER JOIN 
WHERE .. IS NUL
LEFT OUTER JOIN 
RIGHT OUTER JOIN 
UNION

###timestamps and extract
SHOW ALL
SHOW TIMEZONE

SELECT NOW()
SELECT TIMEOFDAY()
SELECT CURRENT_DATE
SELECT CURRENT_TIME

EXTRACT()
AGE()
TO_CHAR()

###mathematical functions and operators
###string functions anf operators
###subquery
SELF-JOIN



###assessment  Test2
SELECT * FROM cd.facilities;

SELECT name,membercost FROM cd.facilities;

SELECT name,membercost FROM cd.facilities
WHERE membercost != 0;

SELECT facid,name,membercost,monthlymaintenance FROM cd.facilities
WHERE membercost !=0 AND membercost < monthlymaintenance/50;

SELECT name FROM cd.facilities
WHERE name LIKE '%Tennis%';

SELECT * FROM cd.facilities
WHERE facid IN (1,5);

SELECT members.memid,surname,firstname,joindate FROM cd.members
WHERE joindate>='2012-09-01' AND memid !=0;

SELECT DISTINCT(surname) FROM cd.members
ORDER BY surname
LIMIT 10;

#solution1
SELECT joindate FROM cd.members
ORDER BY joindate DESC
LIMIT 1;
#solution2
SELECT MAX(joindate)
FROM cd.members


SELECT COUNT(*) FROM cd.facilities
WHERE guestcost>=10;

SELECT facid,SUM(slots) FROM cd.bookings
WHERE EXTRACT(MONTH FROM starttime)=9
GROUP BY facid
ORDER BY SUM(slots);


SELECT facid,SUM(slots) FROM cd.bookings
GROUP BY facid
HAVING SUM(slots)>1000
ORDER BY SUM(facid);

SELECT starttime,name FROM cd.bookings
INNER JOIN cd.facilities
ON cd.bookings.facid=cd.facilities.facid
WHERE TO_CHAR(starttime,'YYYY-MM-DD')='2012-09-21'
AND name LIKE 'Tennis%'
ORDER BY starttime;



SELECT starttime FROM cd.bookings
INNER JOIN cd.members
ON cd.bookings.memid=cd.members.memid
WHERE firstname='David' AND surname='Farrell';



###creat tables
CREATE TABLE account(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR (50) NOT NULL,
	email VARCHAR(250) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
	last_login TIMESTAMP  
)

CREATE TABLE job(
	job_id SERIAL PRIMARY KEY,
	job_name VARCHAR(200) UNIQUE NOT NULL
)

CREATE TABLE account_job(
	user_id INTEGER REFERENCES account(user_id),
	job_id INTEGER REFERENCES job(job_id),
	hire_date TIMESTAMP 
)

##INSERT VALUES
INSERT INTO account(username,password,email,created_on)
VALUES
('Jose','password','jose@gmail.com',CURRENT_TIMESTAMP)
###UPDATE table

UPDATE account_job
SET hire_date=account.created_on
FROM account
WHERE account_job.user_id=account.user_id

##ALTER
##RENAME TABLE
ALTER TABLE information
RENAME TO new_info

##RENAME COLUMN
ALTER TABLE new_info
RENAME COLUMN person TO people
###drop
ALTER TABLE new_info 
DROP COLUMN IF EXISTS people CASCADE

###check
CREAT TABLE example(
ex_id SERIAL PRIMARY KEY,
age SMALLINT CHECK(age>21),
parent_age SMALLINT CHECK(parent_age>age)
);

CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50)NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birthdate DATE CHECK(birthdate>'1900-01-01'),
	hire_date DATE CHECK(hire_date>birthdate),
	salary INTEGER CHECK (salary>0)
)

####assessment test3
CREATE TABLE student(
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	homeroom_number INTEGER,
	phone VARCHAR(100) UNIQUE NOT NULL,
	email VARCHAR(250) UNIQUE,
	grad_year INTEGER
)

INSERT INTO student(
	first_name,
	last_name,
	phone,
	email,
	grad_year,
	homeroom_number
)
VALUES(
	'Mark',
	'Watney',
	'777-555-1234',
	NULL,
	2035,
	5
)


CREATE TABLE teachers(
	teacher_id SERIAL PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	homeroom_number INTEGER,
	phone VARCHAR(100) UNIQUE NOT NULL,
	email VARCHAR(250) UNIQUE
)

INSERT INTO teachers(
	first_name,
	last_name,
	phone,
	email,
	homeroom_number
)
VALUES(
	'Jonas',
	'Salk',
	'777-555-4321',
	'jsalk@school.org',
	5
)

###General CASE
SELECT customer_id,  
CASE
	WHEN customer_id<=100 THEN 'Premium'
	WHEN customer_id BETWEEN 100 AND 200 THEN 'Plus'
	ELSE 'Normal' 
END	AS customer_class
FROM customer

##CASE expression
SELECT customer_id,
CASE customer_id
	WHEN 2 THEN 'Winner'
	WHEN 5 THEN 'second Place'
	ELSE 'Normal'
END AS raffle_results
FROM customer

###
SELECT
SUM(CASE rental_rate 
	WHEN 0.99 THEN 1
	ELSE 0
END	) AS number_of_bargains
FROM film
###
SELECT 
SUM(CASE rental_rate 
	WHEN 0.99 THEN 1
	ELSE 0
END) AS bargains,
SUM(CASE rental_rate
	WHEN 2.99 THEN 1
	ELSE 0
END) AS regular
FROM film

##coalesce: chnang NULL into 0
SELECT item,(price-COALESCE(discount,0)) 
AS final FROM table

EG:SELECT CHAR_LENGTH(CAST(customer_id AS VARCHAR)) FROM rental

###CAST FUNCTION
SELECT CAST(date AS TIMESTAMP) FROM table
###CAST operator
SELECT '5'::INTEGER

###NULLIF
CREATE TABLE depts(
	first_name VARCHAR(50),
	department VARCHAR(50)
)

INSERT INTO depts(
first_name,
department
)
VALUES
('Vinton','A'),
('Lauren','A'),
('Claire','B');


DELETE FROM depts
WHERE department='B'

SELECT(
	SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END)/
	NULLIF(SUM(CASE WHEN department='B' THEN 1 ELSE 0 END),0)	
) AS dept_ratio
FROM depts

###VIEW

CREATE OR REPLACE VIEW customer_info AS
SELECT first_name,last_name,address,district FROM customer
INNER JOIN address
ON customer.address_id = address.address_id
SELECT * FROM customer_info
ALTER VIEW customer_info RENAME TO cust_info
DROP VIEW IF EXISTS cust_info


###postgresql with python
https://wiki.postgresql.org/wiki/Psycopg2_Tutorial

