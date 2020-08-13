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
ADD CONSTRAINT unqGovernmentID UNIQUE (EmployeeGovernmentID); -- duplicate key was found, could not create constraint or index

--Find all EmployeeGovernmentID's that are duplicates
SELECT EmployeeGovernmentID, COUNT(EmployeeGovernmentID) AS MyCount FROM tblEmployee
GROUP BY EmployeeGovernmentID
HAVING COUNT(EmployeeGovernmentID) > 1

--Begin the test for multiple EmployeeNumber and EmployeeGovernmentID
BEGIN TRAN
--DELETE all duplicates if there are more than three of them from EmployeeNumber
DELETE FROM tblEmployee
WHERE EmployeeNumber < 3

--DELETE the top 2 duplicates of EmployeeGovernmentID for the only ID that is a duplicate in the DB
DELETE TOP(2) FROM tblEmployee
WHERE EmployeeGovernmentID = 'AB123456G'

--Check to make sure all the only duplicates are deleted
SELECT * FROM tblEmployee WHERE EmployeeGovernmentID = 'AB123456G'

COMMIT TRAN--COMMIT the query to the DB

--ADD UNIQUE CONSTRAINT to the table
ALTER TABLE tblTransaction
ADD CONSTRAINT unqTransaction UNIQUE(Amount, DateOfTransaction, EmployeeNumber)

--DELETE employee 131 field
DELETE FROM tblTransaction
WHERE EmployeeNumber = 131

--INSERT new data into table
INSERT INTO tblTransaction
VALUES (1, '2015-01-01', 131)
--INSERT DUPLICATE data into table and it will not work due to constraint
INSERT INTO tblTransaction
VALUES (1, '2015-01-01', 131)

--if you want to remove a constraint
ALTER TABLE tblTransaction
DROP CONSTRAINT unqTransaction

CREATE TABLE tblTransaction2
(Amount smallmoney NOT NULL,
DateOfTransaction smalldatetime NOT NULL,
EmployeeNumber INT NOT NULL,
CONSTRAINT unqTransaction2 UNIQUE (Amount,DateOfTransaction,EmployeeNumber))

--For a UNIQUE CONSTRAINT you have to drop the table, remake it, you can not alter it after it is made.
DROP TABLE tblTransaction2


 


