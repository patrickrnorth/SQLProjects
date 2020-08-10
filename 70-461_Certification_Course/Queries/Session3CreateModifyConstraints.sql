USE [70-461]
GO

--QUERYs adding improper data that should not be allowed. No Constraints.
select * from tblEmployee

--Displays all transactions with NULL Employee number in tblEmployee, should not be allowed to insert null values for field
SELECT T.EmployeeNumber as TEmployeeNumber,
	   E.EmployeeNumber as EEmployeeNumber,
	   SUM(Amount) as SumAmount
FROM tblTransaction AS T
LEFT JOIN tblEmployee AS E
ON T.EmployeeNumber = E.EmployeeNumber
GROUP BY T.EmployeeNumber, E.EmployeeNumber
ORDER BY EEmployeeNumber

--updating a field to inclue an invalid date for example what should not be allowed
BEGIN TRAN
UPDATE tblEmployee
SET DateOfBirth = '2101-01-01'
WHERE EmployeeNumber = 537
SELECT * FROM tblEmployee 
ORDER BY DateOfBirth DESC
ROLLBACK TRAN

--updating multiple employees to have the same GovernmentID should not be possible 
BEGIN TRAN
UPDATE tblEmployee
SET EmployeeGovernmentID = 'aaaa'
WHERE EmployeeNumber BETWEEN 530 AND 539
SELECT * FROM tblEmployee ORDER BY EmployeeGovernmentID ASC
ROLLBACK TRAN

--UNIQUE Contraints prevent duplicate values in whichever fields you specify
--NOT ALLOWED due to duplicate data in field
ALTER TABLE tblEmployee
ADD CONSTRAINT unqGovernmentID UNIQUE (EmployeeGovernmentID);




 


