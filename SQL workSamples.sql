-- Work Samples

--Database used : AdventureWorks2019

--1. WINDOW FUNCTIONS

-- Finding 4rd highest salary 

With CTE as(

SELECT *, DENSE_RANK() OVER (ORDER BY  Rate desc ) as salary_rank
FROM  [HumanResources].[EmployeePayHistory]

)

SELECT ROUND(rate,2) as salary, salary_rank
FROM CTE
WHERE salary_rank = 4

-- Finding duplicate records

WITH cte AS (
SELECT *, ROW_NUMBER() over (PARTITION BY  name,groupname, modifieddate ORDER BY name,groupname, modifieddate ) as row_num
FROM dbo.[HRE_Department]
)

SELECT * FROM cte WHERE row_num > 1

GO

--2. SUB QUERIES

--Finding 2nd highest salary


SELECT ROUND(MAX(rate),2) AS Salary
FROM [HumanResources].[EmployeePayHistory]
WHERE rate NOT IN (	SELECT MAX(rate)  
					FROM [HumanResources].[EmployeePayHistory] )

GO

-- 3.USER DEFINED FUNCTIONS (UDFs)

-- Retrieving Employee's information given the employee ID

---multi-line Table valued function
 

CREATE OR ALTER FUNCTION UDF_GetEmployeeInfo(@Empid int)
RETURNS @tablevariable TABLE(ID int,EMPLOYEENAME varchar(20))

AS
  BEGIN
      INSERT INTO @tablevariable
	  
	  SELECT BusinessEntityID,FirstName AS EMPLOYEENAME
	  FROM [Person].[Person]
	  WHERE BusinessEntityID = @Empid
	  
	  RETURN
  END

  GO

-- calling the function

  SELECT * FROM UDF_GetEmployeeInfo(7)

  GO

 --4. STORED PROCEDURE USING DEFAULT PARAMETER (SPs)

 -- stored procedure that gives fullname and job title 

CREATE OR ALTER PROCEDURE sp_GetEmployeeInfo(@id int= null , @lname varchar(40) = null) AS

BEGIN
 IF @id IS NOT NULL AND @lname IS NULL
      SELECT P.FirstName + ' ' + P.LastName AS FULLNAME,Title AS JOBTITLE
	  FROM [Person].[Person] P
	  WHERE @id = BusinessEntityID

ELSE IF @id IS NULL AND @lname IS NOT NULL
     SELECT P.FirstName + ' ' + P.LastName AS FULLNAME,Title AS JOBTITLE
	 FROM [Person].[Person] P
	 WHERE @lname = LastName 

ELSE IF @id IS NOT NULL AND @lname IS NOT NULL 
      SELECT P.FirstName + ' ' + P.LastName AS FULLNAME,Title AS JOBTITLE
	  FROM [Person].[Person] P
	  WHERE @lname = LastName AND @id = BusinessEntityID
ELSE
   PRINT 'PLEASE ENTER ID OR LASTNAME'

END

--Executing the stored procedure

EXEC sp_GetEmployeeInfo 3 


