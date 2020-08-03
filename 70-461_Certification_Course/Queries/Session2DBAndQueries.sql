CREATE DATABASE [70-461]
GO

USE [70-461]
GO

CREATE TABLE [dbo].[tblEmployee](
	[EmployeeNumber] [int] NOT NULL,
	[EmployeeFirstName] [varchar](50) NOT NULL,
	[EmployeeMiddleName] [varchar](50) NULL,
	[EmployeeLastName] [varchar](50) NOT NULL,
	[EmployeeGovernmentID] [char](10) NULL,
	[DateOfBirth] [date] NOT NULL	
GO

ALTER TABLE tblEmployee
ADD [Department] [varchar](20) NOT NULL
GO


--INSERT INTO TABLE tblEmployee([EmployeeNumber],[EmployeeFirstName],[EmployeeMiddleName],[EmployeeLastName],[EmployeeGovernmentID],[DateOfBirth])
--VALUES
--(included excel spreadsheet of data in repository file: 70+461data)

UPDATE tblEmployee
SET EmployeeMiddleName = NULL
WHERE EmployeeMiddleName = ''
