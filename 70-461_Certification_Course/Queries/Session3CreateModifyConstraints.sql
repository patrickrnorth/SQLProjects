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

--CREATE a TABLE while adding a UNIQUE CONSTRAINT
CREATE TABLE tblTransaction2
(Amount smallmoney NOT NULL,
DateOfTransaction smalldatetime NOT NULL,
EmployeeNumber INT NOT NULL,
CONSTRAINT unqTransaction2 UNIQUE (Amount,DateOfTransaction,EmployeeNumber))

--For a UNIQUE CONSTRAINT you have to drop the table, remake it, you can not alter it after it is made.
DROP TABLE tblTransaction2

--DEFAULT CONSTRAINTS
ALTER TABLE tblTransaction
ADD DateOfEntry datetime

--Only use FOR when altering a constraint not when creating a table with a constraint.
ALTER TABLE tblTransaction
ADD CONSTRAINT defDateOfEntry DEFAULT GETDATE() FOR DateOfEntry

DELETE FROM tblTransaction WHERE EmployeeNumber < 3

INSERT INTO tblTransaction(Amount, DateOfTransaction, EmployeeNumber)
VALUES (1, '2014-01-01' ,1)
INSERT INTO tblTransaction(Amount,DateOfTransaction,EmployeeNumber,DateOfEntry)
VALUES(2, '2014-01-02', 1, '2013-01-01')

SELECT * FROM tblTransaction WHERE EmployeeNumber < 3

--Create a table while adding a CONSTRAINT at the same time
CREATE TABLE tblTransaction2
(Amount smallmoney NOT NULL,
DateOfTransaction smalldatetime NOT NULL,
EmployeeNumber INT NOT NULL,
DateOfEntry DATETIME NULL CONSTRAINT tblTransaction_2defDateOfEntry DEFAULT GETDATE()) --CANT use the same constraint name is two different tables, 
																					   --use the tbl name in the constraint name
INSERT INTO tblTransaction2(Amount, DateOfTransaction, EmployeeNumber)
VALUES(1, '2014-01-01', 1)

INSERT INTO tblTransaction2(Amount, DateOfTransaction, EmployeeNumber, DateOfEntry)
VALUES(1, '2014-01-01', 1, 2013-01-01)

SELECT * FROM tblTransaction2 WHERE EmployeeNumber <3

DROP TABLE tblTransaction2


ALTER TABLE tblTransaction
DROP COLUMN DateOfEntry
--Cant drop the column due to the fact there is a constraint on it

ALTER TABLE tblTransaction
DROP CONSTRAINT defDateOfEntry--drop constraint so we can delete the column that had the constraint

--CHECK CONSTRAINT filters an entire row and selects certain criteria you are looking for
--i.e. to prevent salaries from being entered beyone the regular salaray range. salary >= 15000 AND salary <= 100000
--i.e. dates inputed are reasonable, cannot input a date 2000 years in the future.
 
--ALTER TABLE to add a check constraint
 ALTER TABLE tblTransaction
 ADD CONSTRAINT chkAmount CHECK (Amount>-1000 AND Amount <1000)

--Cannot insert this row due to being outside the check constraint
INSERT INTO tblTransaction
VALUES (1010, '2014-01-01', 1)

INSERT INTO tblTransaction
VALUES (999, '2014-01-01', 1)

ALTER TABLE tblEmployee WITH NOCHECK --alter table without looking for checks
ADD CONSTRAINT chkMiddleName CHECK --add check to EmployeeMiddleName
(REPLACE(EmployeeMiddleName, '.', '') = EmployeeMiddleName OR EmployeeMiddleName IS NULL)

BEGIN TRAN
	INSERT INTO tblEmployee
	VALUES(2003, 'A', NULL, 'C', 'D', '2014-01-01', 'Accounts')
	SELECT * FROM tblEmployee WHERE EmployeeNumber = 2003
ROLLBACK TRAN

ALTER TABLE tblEmployee WITH NOCHECK
ADD CONSTRAINT chkDateOfBirth CHECK (DateOfBirth BETWEEN '1900-01-01' and getDate())