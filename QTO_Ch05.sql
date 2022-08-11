-- chapter 5

-- page 205
CREATE TABLE table1 (
col1 int NOT NULL,
col2 nchar(10) NULL,
CONSTRAINT PK_table1 PRIMARY KEY(col1)
)

-- page 206
CREATE TABLE table1
(
col1 int NOT NULL,
col2 nchar(10) NULL
)
GO
ALTER TABLE table1 ADD CONSTRAINT
PK_table1 PRIMARY KEY
(
col1
)

ALTER TABLE table1 ADD CONSTRAINT
PK_table1 PRIMARY KEY CLUSTERED
(
col1
)

ALTER TABLE table1 ADD CONSTRAINT
PK_table1 PRIMARY KEY NONCLUSTERED
(
col1
)

-- page 207
SELECT * INTO dbo.SalesOrderDetail
FROM Sales.SalesOrderDetail

SELECT * FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.SalesOrderDetail')

-- page 208
CREATE INDEX IX_ProductID ON dbo.SalesOrderDetail(ProductID)

CREATE CLUSTERED INDEX IX_SalesOrderID_SalesOrderDetailID
ON dbo.SalesOrderDetail(SalesOrderID, SalesOrderDetailID)

DROP INDEX dbo.SalesOrderDetail.IX_ProductID

-- page 209
DROP INDEX dbo.SalesOrderDetail.IX_SalesOrderID_SalesOrderDetailID

-- page 214
SELECT SalesOrderID, CustomerID FROM Sales.SalesOrderHeader
WHERE CustomerID = 16448

SELECT SalesOrderID, CustomerID, SalesPersonID FROM Sales.SalesOrderHeader
WHERE CustomerID = 16448

-- page 215
CREATE INDEX IX_SalesOrderHeader_CustomerID_SalesPersonID
ON Sales.SalesOrderHeader(CustomerID)
INCLUDE (SalesPersonID)

DROP INDEX Sales.SalesOrderHeader.IX_SalesOrderHeader_CustomerID_SalesPersonID

-- page 215
SELECT CustomerID, OrderDate, AccountNumber FROM Sales.SalesOrderHeader
WHERE CustomerID = 13917 AND TerritoryID = 4

CREATE INDEX IX_CustomerID ON Sales.
SalesOrderHeader(CustomerID)
WHERE TerritoryID = 4

-- page 217
DECLARE @territory int
SET @territory = 4
SELECT CustomerID, OrderDate, AccountNumber FROM Sales.SalesOrderHeader
WHERE CustomerID = 13917 AND TerritoryID = @territory

DROP INDEX Sales.SalesOrderHeader.IX_CustomerID

-- page 218
SELECT ProductID, SalesOrderID, SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE ProductID = 771

SELECT ProductID, SalesOrderID, SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE ABS(ProductID) = 771

-- page 219
SELECT ProductID, SalesOrderID, SalesOrderDetailID
FROM Sales.SalesOrderDetail
WHERE ProductID = 771 AND ABS(SalesOrderID) = 45233

-- page 221
SELECT * INTO dbo.SalesOrderDetail
FROM Sales.SalesOrderDetail

SELECT * FROM dbo.SalesOrderDetail
WHERE ProductID = 897

SELECT * FROM msdb..DTA_reports_query

-- page 222
CREATE CLUSTERED INDEX [_dta_index_
SalesOrderDetail_c_5_1440724185__K5]
ON [dbo].[SalesOrderDetail]
(
[ProductID] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF)
ON [PRIMARY]

CREATE CLUSTERED INDEX cix_ProductID ON dbo.SalesOrderDetail(ProductID)
WITH STATISTICS_ONLY

-- page 223
SELECT * FROM sys.indexes
WHERE object_id = OBJECT_ID('dbo.SalesOrderDetail')
AND name = 'cix_ProductID'

DROP INDEX dbo.SalesOrderDetail.cix_ProductID

DBCC FREEPROCCACHE
GO
SELECT SalesOrderID, OrderQty, ProductID
FROM dbo.SalesOrderDetail
WHERE CarrierTrackingNumber = 'D609-4F2A-9B'

-- page 224
CREATE NONCLUSTERED INDEX [_dta_index_
SalesOrderDetail_5_807673925__K3_1_4_5]
ON [dbo].[SalesOrderDetail]
(
[CarrierTrackingNumber] ASC
)
INCLUDE ([SalesOrderID],
[OrderQty],
[ProductID]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF,
ONLINE = OFF)
ON [PRIMARY]

DROP TABLE dbo.SalesOrderDetail

-- page 226
SELECT * FROM AdventureWorks2019.Sales.SalesOrderDetail
WHERE ProductID = 898

-- page 227
dta -ix input.xml -S production_instance -s session1

-- page 229
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = 898

CREATE SCHEMA Sales

-- page 230
SELECT * INTO dbo.SalesOrderDetail
FROM Sales.SalesOrderDetail

-- page 231
SELECT * FROM dbo.SalesOrderDetail
WHERE SalesOrderID = 43670 AND SalesOrderDetailID > 112

CREATE INDEX IX_ProductID ON dbo.SalesOrderDetail(ProductID)

-- page 233
CREATE NONCLUSTERED INDEX IX_SalesOrderID_SalesOrderDetailID
ON [dbo].[SalesOrderDetail]([SalesOrderID],
[SalesOrderDetailID])

-- page 233
DROP TABLE dbo.SalesOrderDetail

SELECT a.index_id, name, avg_fragmentation_in_percent,
fragment_count, avg_fragment_size_in_pages
FROM sys.dm_db_index_physical_stats (DB_ID('AdventureWorks2019'),
OBJECT_ID('Sales.SalesOrderDetail'), NULL, NULL, NULL) AS a
JOIN sys.indexes AS b ON a.object_id = b.object_id AND a.index_id = b.index_id

-- page 234
ALTER INDEX ALL ON Sales.SalesOrderDetail REBUILD

ALTER INDEX ALL ON Sales.SalesOrderDetail REORGANIZE

-- page 235
SELECT * INTO dbo.SalesOrderDetail
FROM Sales.SalesOrderDetail

CREATE NONCLUSTERED INDEX IX_ProductID ON dbo.SalesOrderDetail(ProductID)

SELECT DB_NAME(database_id) AS database_name,
OBJECT_NAME(s.object_id) AS object_name, i.name, s.*
FROM sys.dm_db_index_usage_stats s JOIN sys.indexes i
ON s.object_id = i.object_id AND s.index_id = i.index_id
AND OBJECT_ID('dbo.SalesOrderDetail') = s.object_id

-- page 236
SELECT * FROM dbo.SalesOrderDetail

SELECT ProductID FROM dbo.SalesOrderDetail
WHERE ProductID = 773

SELECT * FROM dbo.SalesOrderDetail
WHERE ProductID = 773

UPDATE dbo.SalesOrderDetail
SET ProductID = 666
WHERE ProductID = 927

-- page 237
DROP TABLE dbo.SalesOrderDetail
