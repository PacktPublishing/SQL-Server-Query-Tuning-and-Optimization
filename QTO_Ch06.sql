-- chapter 6

-- page 244
SELECT * FROM sys.stats
WHERE object_id = OBJECT_ID('Sales.SalesOrderDetail')

-- page 244
DBCC SHOW_STATISTICS ('Sales.SalesOrderDetail', UnitPrice)

SELECT * FROM Sales.SalesOrderDetail
WHERE UnitPrice = 35

-- page 245
SELECT * FROM sys.dm_db_stats_properties(OBJECT_ID('Sales.SalesOrderDetail'), 4)
SELECT * FROM sys.dm_db_stats_histogram(OBJECT_ID('Sales.SalesOrderDetail'), 4)

-- page 246
DBCC SHOW_STATISTICS ('Sales.SalesOrderDetail', IX_SalesOrderDetail_ProductID)

-- page 247
SELECT ProductID FROM Sales.SalesOrderDetail
GROUP BY ProductID

-- page 248
DECLARE @ProductID int
SET @ProductID = 921
SELECT ProductID FROM Sales.SalesOrderDetail
WHERE ProductID = @ProductID

DECLARE @pid int = 897
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID < @pid

-- page 250
DBCC SHOW_STATISTICS ('Sales.SalesOrderDetail', IX_SalesOrderDetail_ProductID)

SELECT ProductID, COUNT(*) AS Total
FROM Sales.SalesOrderDetail
WHERE ProductID BETWEEN 827 AND 831
GROUP BY ProductID

-- page 251
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = 831

-- page 252
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID < 714

-- page 255
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 110

SELECT * FROM Person.Address WHERE City = 'Burbank'

SELECT * FROM Person.Address WHERE PostalCode = '91502'

SELECT * FROM Person.Address
WHERE City = 'Burbank' AND PostalCode = '91502'

-- page 256
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO
SELECT * FROM Person.Address WHERE City = 'Burbank' AND
PostalCode = '91502'

-- page 257
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 110
GO
SELECT * FROM Person.Address WHERE City = 'Burbank' OR
PostalCode = '91502'

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO
SELECT * FROM Person.Address WHERE City = 'Burbank' OR
PostalCode = '91502'

-- page 258
ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO
SELECT * FROM Person.Address WHERE City = 'Burbank' AND
PostalCode = '91502'
OPTION (QUERYTRACEON 9481)

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 110
GO
SELECT * FROM Person.Address
WHERE City = 'Burbank' AND PostalCode = '91502'
OPTION (QUERYTRACEON 4137)

-- page 259
SET STATISTICS PROFILE ON
GO
SELECT * FROM Sales.SalesOrderDetail
WHERE OrderQty * UnitPrice > 10000
GO
SET STATISTICS PROFILE OFF
GO

-- page 262
CREATE PARTITION FUNCTION TransactionRangePF1 (datetime)
AS RANGE RIGHT FOR VALUES
(
'20130901', '20131001', '20131101', '20131201',
'20140101', '20140201', '20140301', '20140401',
'20140501', '20140601', '20140701'
)
GO
CREATE PARTITION SCHEME TransactionsPS1 AS PARTITION
TransactionRangePF1 TO
(
[PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY],
[PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY], [PRIMARY],
[PRIMARY], [PRIMARY], [PRIMARY]
)
GO
CREATE TABLE dbo.TransactionHistory
(
TransactionID int NOT NULL,
ProductID int NOT NULL,
ReferenceOrderID int NOT NULL,
ReferenceOrderLineID int NOT NULL DEFAULT (0),
TransactionDate datetime NOT NULL DEFAULT (GETDATE()),
TransactionType nchar(1) NOT NULL,
Quantity int NOT NULL,
ActualCost money NOT NULL,
ModifiedDate datetime NOT NULL DEFAULT (GETDATE()),
CONSTRAINT CK_TransactionType
CHECK (UPPER(TransactionType) IN (N'W', N'S', N'P'))
)
ON TransactionsPS1 (TransactionDate)
GO

INSERT INTO dbo.TransactionHistory
SELECT * FROM Production.TransactionHistory
WHERE TransactionDate < '2014-07-01'

SELECT * FROM sys.partitions
WHERE object_id = OBJECT_ID('dbo.TransactionHistory')

-- page 262
CREATE STATISTICS incrstats ON dbo.
TransactionHistory(TransactionDate)
WITH FULLSCAN, INCREMENTAL = ON

DBCC SHOW_STATISTICS('dbo.TransactionHistory', incrstats)

INSERT INTO dbo.TransactionHistory
SELECT * FROM Production.TransactionHistory
WHERE TransactionDate >= '2014-07-01'

UPDATE STATISTICS dbo.TransactionHistory(incrstats)
WITH RESAMPLE ON PARTITIONS(12)

-- page 264
UPDATE STATISTICS dbo.TransactionHistory(incrstats)
WITH FULLSCAN, INCREMENTAL = OFF

DROP TABLE dbo.TransactionHistory
DROP PARTITION SCHEME TransactionsPS1
DROP PARTITION FUNCTION TransactionRangePF1

-- page 264
SELECT * FROM Sales.SalesOrderDetail
WHERE OrderQty * UnitPrice > 10000

ALTER TABLE Sales.SalesOrderDetail
ADD cc AS OrderQty * UnitPrice

-- page 266
SELECT * FROM sys.stats
WHERE object_id = OBJECT_ID('Sales.SalesOrderDetail')

DBCC SHOW_STATISTICS ('Sales.SalesOrderDetail', _WA_Sys_0000000E_44CA3770)

DBCC SHOW_STATISTICS ('Sales.SalesOrderDetail', cc)

SELECT * FROM Sales.SalesOrderDetail
WHERE UnitPrice * OrderQty > 10000

ALTER TABLE Sales.SalesOrderDetail
DROP COLUMN cc

-- page 267
SELECT * FROM Person.Address
WHERE City = 'Los Angeles'

SELECT * FROM Person.Address
WHERE StateProvinceID = 9

SELECT * FROM Person.Address
WHERE City = 'Los Angeles' AND StateProvinceID = 9

-- page 268
CREATE STATISTICS california
ON Person.Address(City)
WHERE StateProvinceID = 9

DBCC FREEPROCCACHE
GO
SELECT * FROM Person.Address
WHERE City = 'Los Angeles' AND StateProvinceID = 9

-- page 269
DBCC SHOW_STATISTICS('Person.Address', california)

-- page 270
DROP STATISTICS Person.Address.california

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 110
GO
CREATE TABLE dbo.SalesOrderHeader (
SalesOrderID int NOT NULL,
RevisionNumber tinyint NOT NULL,
OrderDate datetime NOT NULL,
DueDate datetime NOT NULL,
ShipDate datetime NULL,
Status tinyint NOT NULL,
OnlineOrderFlag dbo.Flag NOT NULL,
SalesOrderNumber nvarchar(25) NOT NULL,
PurchaseOrderNumber dbo.OrderNumber NULL,
AccountNumber dbo.AccountNumber NULL,
CustomerID int NOT NULL,
SalesPersonID int NULL,
TerritoryID int NULL,
BillToAddressID int NOT NULL,
ShipToAddressID int NOT NULL,
ShipMethodID int NOT NULL,
CreditCardID int NULL,
CreditCardApprovalCode varchar(15) NULL,
CurrencyRateID int NULL,
SubTotal money NOT NULL,
TaxAmt money NOT NULL,
Freight money NOT NULL,
TotalDue money NOT NULL,
Comment nvarchar(128) NULL,
rowguid uniqueidentifier NOT NULL,
ModifiedDate datetime NOT NULL
)

-- page 271
INSERT INTO dbo.SalesOrderHeader SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate < '2014-06-19 00:00:00.000'
CREATE INDEX IX_OrderDate ON SalesOrderHeader(OrderDate)

-- page 272
SELECT * FROM dbo.SalesOrderHeader 
WHERE OrderDate = '2014-06-18 00:00:00.000'

INSERT INTO dbo.SalesOrderHeader SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate = '2014-06-19 00:00:00.000'

SELECT * FROM dbo.SalesOrderHeader 
WHERE OrderDate = '2014-06-19 00:00:00.000'

-- page 273
DBCC TRACEON (2388)
DBCC TRACEON (2389)

DBCC SHOW_STATISTICS ('dbo.SalesOrderHeader', 'IX_OrderDate')

UPDATE STATISTICS dbo.SalesOrderHeader WITH FULLSCAN

INSERT INTO dbo.SalesOrderHeader 
SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate = '2014-06-20 00:00:00.000'

-- page 274
SELECT * FROM dbo.SalesOrderHeader 
WHERE OrderDate = '2014-06-20 00:00:00.000'

UPDATE STATISTICS dbo.SalesOrderHeader WITH FULLSCAN

INSERT INTO dbo.SalesOrderHeader SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate = '2014-06-21 00:00:00.000'

UPDATE STATISTICS dbo.SalesOrderHeader WITH FULLSCAN

-- page 275
INSERT INTO dbo.SalesOrderHeader SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate = '2014-06-22 00:00:00.000'

SELECT * FROM dbo.SalesOrderHeader 
WHERE OrderDate = '2014-06-22 00:00:00.000'

SELECT * FROM dbo.SalesOrderHeader 
WHERE OrderDate = '2014-06-23 00:00:00.000'

SELECT * FROM dbo.SalesOrderHeader 
WHERE OrderDate = '2014-06-22 00:00:00.000'
OPTION (QUERYTRACEON 2389, QUERYTRACEON 2390)

-- page 276
DROP TABLE dbo.SalesOrderHeader

DBCC TRACEOFF (2388)
DBCC TRACEOFF (2389)

INSERT INTO dbo.SalesOrderHeader SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate < '2014-06-19 00:00:00.000'
CREATE INDEX IX_OrderDate ON SalesOrderHeader(OrderDate)

INSERT INTO dbo.SalesOrderHeader SELECT * FROM Sales.SalesOrderHeader
WHERE OrderDate = '2014-06-19 00:00:00.000'

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 110
GO
SELECT * FROM dbo.SalesOrderHeader 
WHERE OrderDate = '2014-06-19 00:00:00.000'

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160
GO

-- page 277
SELECT * FROM dbo.SalesOrderHeader 
WHERE OrderDate = '2014-06-19 00:00:00.000'

-- page 278
SELECT * INTO dbo.Address
FROM Person.Address

SELECT * FROM sys.dm_db_partition_stats
WHERE object_id = OBJECT_ID('dbo.Address')

SELECT * FROM dbo.Address
WHERE City = 'London'

-- page 279
UPDATE STATISTICS dbo.Address WITH ROWCOUNT = 1000000,
PAGECOUNT = 100000

DBCC FREEPROCCACHE
GO
SELECT * FROM dbo.Address WHERE City = 'London'

DBCC UPDATEUSAGE(AdventureWorks2019, 'dbo.Address') 
WITH COUNT_ROWS

-- page 280
DROP TABLE dbo.Address

-- page 281
SELECT * INTO dbo.SalesOrderDetail FROM Sales.SalesOrderDetail

SELECT name, auto_created, STATS_DATE(object_id, stats_id) AS
update_date
FROM sys.stats
WHERE object_id = OBJECT_ID('dbo.SalesOrderDetail')

SELECT * FROM dbo.SalesOrderDetail
WHERE SalesOrderID = 43670 AND OrderQty = 1

CREATE INDEX IX_ProductID ON dbo.SalesOrderDetail(ProductID)

-- page 282
UPDATE STATISTICS dbo.SalesOrderDetail WITH FULLSCAN, COLUMNS

UPDATE STATISTICS dbo.SalesOrderDetail WITH FULLSCAN, INDEX

UPDATE STATISTICS dbo.SalesOrderDetail WITH FULLSCAN
UPDATE STATISTICS dbo.SalesOrderDetail WITH FULLSCAN, ALL

ALTER INDEX ix_ProductID ON dbo.SalesOrderDetail REBUILD

ALTER INDEX ix_ProductID on dbo.SalesOrderDetail REORGANIZE

DROP TABLE dbo.SalesOrderDetail

-- page 283
SELECT * FROM Sales.SalesOrderDetail
WHERE LineTotal = 35

-- page 284
SELECT in_row_data_page_count, row_count
FROM sys.dm_db_partition_stats
WHERE object_id = OBJECT_ID('Sales.SalesOrderDetail')
AND index_id = 1

