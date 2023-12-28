CREATE TABLE Emp(Id int NOT NULL PRIMARY KEY, Name VARCHAR(50));
DESC emp;                                #describes the table;
DROP TABLE Emp;
--------------------------------------------------------------------------------
ALTER TABLE Emp
ADD(DOB datetime, email varchar(50));    #Adds required extra columns
ALTER TABLE Emp
DROP COLUMN email;                       #To drop the column
-------------------------------------------------------------------------------
Create Table emp_info As
Select Id, Name FROM emp;                #creating another table from Emp table
DROP TABLE emp_info;
---------------------------------------------------------------------------------
INSERT INTO Emp(Id, Name)
VALUES (1,'Emp1'), (2,'Emp2'), (3,'Emp3'), (4,'Emp4'), (5,'Emp5'), (6,'Emp6'), (7,'Emp7'), (8,'Emp8');
-----------------------------------------------------------------------------------------------------------------------
WITH cte AS (
SELECT *, CONCAT(Id, ' ', Name) AS con,
NTILE(4) OVER(ORDER BY(Id)) AS groupname
FROM Emp)
SELECT group_concat(con) AS Result, groupname
FROM cte
GROUP BY groupname
ORDER BY groupname;




