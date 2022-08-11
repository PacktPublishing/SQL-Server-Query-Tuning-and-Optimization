-- chapter 10

-- page 365
CREATE TABLE dbo.SalesOrderDetail (
SalesOrderID int NOT NULL,
SalesOrderDetailID int NOT NULL,
CarrierTrackingNumber nvarchar(25) NULL,
OrderQty smallint NOT NULL,
ProductID int NOT NULL,
SpecialOfferID int NOT NULL,
UnitPrice money NOT NULL,
UnitPriceDiscount money NOT NULL,
LineTotal money,
rowguid uniqueidentifier ROWGUIDCOL NOT NULL,
ModifiedDate datetime NOT NULL)

INSERT INTO dbo.SalesOrderDetail (
SalesOrderID,
SalesOrderDetailID,
CarrierTrackingNumber,
OrderQty,
ProductID,
SpecialOfferID,
UnitPrice,
UnitPriceDiscount,
LineTotal,
rowguid,
ModifiedDate)
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = 897
-- WHERE ProductID = 870
-- GO 10

-- page 366
-- WHERE ProductID = 897
WHERE ProductID = 870
GO 10

CREATE OR ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM dbo.SalesOrderDetail
WHERE ProductID = @pid
ORDER BY OrderQty

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE = ON
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE CLEAR ALL

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

EXEC test @pid = 897

-- page 367
EXEC test @pid = 897

EXEC test @pid = 870

-- page 368
EXEC test @pid = 897

ALTER DATABASE AdventureWorks2019 SET QUERY_STORE CLEAR ALL
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS

EXEC test @pid = 897
GO 2
EXEC test @pid = 870
GO 3
EXEC test @pid = 897
GO 3

-- page 369
ALTER DATABASE SCOPED CONFIGURATION SET MEMORY_GRANT_FEEDBACK_PERSISTENCE = OFF
ALTER DATABASE SCOPED CONFIGURATION SET MEMORY_GRANT_FEEDBACK_PERCENTILE = OFF

-- page 370
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 110
SELECT City, PostalCode FROM Person.Address WHERE City =
'Burbank' OR PostalCode = '91502'

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
SELECT City, PostalCode FROM Person.Address WHERE City =
'Burbank' OR PostalCode = '91502'

-- 371
SELECT City, PostalCode FROM Person.Address WHERE City =
'Burbank' OR PostalCode = '91502' -- estimates 388.061
OPTION(USE HINT('ASSUME_FULL_INDEPENDENCE_FOR_FILTER_ESTIMATES'))

SELECT * FROM Person.Address WHERE City = 'Burbank' OR
PostalCode = '91502' -- estimates 292.269
OPTION(USE HINT('ASSUME_PARTIAL_CORRELATION_FOR_FILTER_ESTIMATES'))

SELECT City, PostalCode FROM Person.Address WHERE City =
'Burbank' OR PostalCode = '91502' -- estimates 196
OPTION(USE HINT('ASSUME_MIN_SELECTIVITY_FOR_FILTER_ESTIMATES'))

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE = ON
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE CLEAR ALL
ALTER DATABASE SCOPED CONFIGURATION CLEAR PROCEDURE_CACHE
DBCC DROPCLEANBUFFERS

-- page 372
CREATE EVENT SESSION test ON SERVER
ADD EVENT sqlserver.query_feedback_analysis,
ADD EVENT sqlserver.query_feedback_validation

SELECT City, PostalCode FROM Person.Address WHERE City =
'Burbank' OR PostalCode = '91502'
GO 30

-- page 374
CREATE FUNCTION dbo.tvf_Sales(@year int)
RETURNS @Sales TABLE (
SalesOrderID int,
SalesOrderDetailID int,
CarrierTrackingNumber nvarchar(25),
OrderQty smallint,
ProductID int,
SpecialOfferID int,
UnitPrice money,
UnitPriceDiscount money,
LineTotal money,
rowguid uniqueidentifier ROWGUIDCOL,
ModifiedDate datetime)
AS
BEGIN
INSERT @Sales
SELECT * FROM Sales.SalesOrderDetail
WHERE YEAR(ModifiedDate) = @year
RETURN
END

-- page 375
SELECT * FROM dbo.tvf_Sales(2011) s
JOIN Sales.SalesOrderHeader h ON s.SalesOrderID =
h.SalesOrderID
OPTION (USE HINT('DISABLE_INTERLEAVED_EXECUTION_TVF'))

SELECT * FROM dbo.tvf_Sales(2011) s
JOIN Sales.SalesOrderHeader h ON s.SalesOrderID = h.SalesOrderID

-- page 376
DECLARE @Sales TABLE (
SalesOrderID int,
SalesOrderDetailID int,
CarrierTrackingNumber nvarchar(25),
OrderQty smallint,
ProductID int,
SpecialOfferID int,
UnitPrice money,
UnitPriceDiscount money,
LineTotal money,
rowguid uniqueidentifier ROWGUIDCOL,
ModifiedDate datetime)

INSERT @Sales
SELECT * FROM Sales.SalesOrderDetail

SELECT * FROM @Sales s
JOIN Sales.SalesOrderHeader h ON s.SalesOrderID =
h.SalesOrderID
WHERE YEAR(s.ModifiedDate) = 2011
OPTION (USE HINT('DISABLE_DEFERRED_COMPILATION_TV'))

-- page 377
SELECT * FROM @Sales s
JOIN Sales.SalesOrderHeader h ON s.SalesOrderID =
h.SalesOrderID
WHERE YEAR(s.ModifiedDate) = 2011

-- page 378
CREATE TABLE dbo.SalesOrderDetail (
SalesOrderID int NOT NULL,
SalesOrderDetailID int NOT NULL,
CarrierTrackingNumber nvarchar(25) NULL,
OrderQty smallint NOT NULL,
ProductID int NOT NULL,
SpecialOfferID int NOT NULL,
UnitPrice money NOT NULL,
UnitPriceDiscount money NOT NULL,
LineTotal money,
rowguid uniqueidentifier ROWGUIDCOL NOT NULL,
ModifiedDate datetime NOT NULL)

INSERT INTO dbo.SalesOrderDetail (
SalesOrderID,
SalesOrderDetailID,
CarrierTrackingNumber,
OrderQty,
ProductID,
SpecialOfferID,
UnitPrice,
UnitPriceDiscount,
LineTotal,
rowguid,
ModifiedDate)
SELECT * FROM Sales.SalesOrderDetail
GO 50

-- page 379
CREATE CLUSTERED COLUMNSTORE INDEX CIX_SalesOrderDetail
ON dbo.SalesOrderDetail

SELECT * FROM dbo.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID
WHERE ProductID = 897
