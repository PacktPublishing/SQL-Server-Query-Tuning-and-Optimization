-- chapter 11

-- page 384
SELECT TOP 10 p.ModelName, p.EnglishDescription,
SUM(f.SalesAmount) AS SalesAmount
FROM FactResellerSales f JOIN DimProduct p
ON f.ProductKey = p.ProductKey
JOIN DimEmployee e
ON f.EmployeeKey = e.EmployeeKey
WHERE f.OrderDateKey >= 20030601
AND e.SalesTerritoryKey = 1
GROUP BY p.ModelName, p.EnglishDescription
ORDER BY SUM(f.SalesAmount) DESC

-- page 386
SELECT TOP 10 p.ModelName, p.EnglishDescription,
SUM(f.SalesAmount) AS SalesAmount
FROM FactResellerSales f JOIN DimProduct p
ON f.ProductKey = p.ProductKey
JOIN DimEmployee e
ON f.EmployeeKey = e.EmployeeKey
WHERE f.OrderDateKey >= 20030601
AND e.SalesTerritoryKey = 1
GROUP BY p.ModelName, p.EnglishDescription
ORDER BY SUM(f.SalesAmount) DESC

-- page 387
UPDATE STATISTICS dbo.FactResellerSales WITH ROWCOUNT = 100000,
PAGECOUNT = 10000

DBCC FREEPROCCACHE

-- page 388
DBCC UPDATEUSAGE (AdventureWorksDW2019, 'dbo.FactResellerSales') 
WITH COUNT_ROWS

-- page 392
CREATE TABLE dbo.FactInternetSales2 (
ProductKey int NOT NULL,
OrderDateKey int NOT NULL,
DueDateKey int NOT NULL,
ShipDateKey int NOT NULL)
GO
CREATE CLUSTERED COLUMNSTORE INDEX csi_FactInternetSales2
ON dbo.FactInternetSales2

-- page 393
CREATE NONCLUSTERED COLUMNSTORE INDEX ncsi_FactInternetSales2
ON dbo.FactInternetSales2
(ProductKey, OrderDateKey)

DROP TABLE FactInternetSales2

-- page 394
USE AdventureWorksDW2019
GO
CREATE TABLE dbo.FactInternetSales2 (
ProductKey int NOT NULL,
OrderDateKey int NOT NULL,
DueDateKey int NOT NULL,
ShipDateKey int NOT NULL,
CustomerKey int NOT NULL,
PromotionKey int NOT NULL,
CurrencyKey int NOT NULL,
SalesTerritoryKey int NOT NULL,
SalesOrderNumber nvarchar(20) NOT NULL,
SalesOrderLineNumber tinyint NOT NULL,
RevisionNumber tinyint NOT NULL,
OrderQuantity smallint NOT NULL,
UnitPrice money NOT NULL,
ExtendedAmount money NOT NULL,
UnitPriceDiscountPct float NOT NULL,
DiscountAmount float NOT NULL,
ProductStandardCost money NOT NULL,
TotalProductCost money NOT NULL,
SalesAmount money NOT NULL,
TaxAmt money NOT NULL,
Freight money NOT NULL,
CarrierTrackingNumber nvarchar(25) NULL,
CustomerPONumber nvarchar(25) NULL,
OrderDate datetime NULL,
DueDate datetime NULL,
ShipDate datetime NULL
)

-- page 395
CREATE CLUSTERED COLUMNSTORE INDEX csi_FactInternetSales2
ON dbo.FactInternetSales2

INSERT INTO dbo.FactInternetSales2
SELECT * FROM AdventureWorksDW2019.dbo.FactInternetSales

SELECT d.CalendarYear,
SUM(SalesAmount) AS SalesTotal
FROM dbo.FactInternetSales2 AS f
JOIN dbo.DimDate AS d
ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear

-- page 397
ALTER INDEX csi_FactInternetSales2 on FactInternetSales2
REBUILD

-- page 398
SELECT * FROM sys.indexes
WHERE object_id = OBJECT_ID('FactInternetSales2')

DROP INDEX FactInternetSales2.csi_FactInternetSales2

CREATE NONCLUSTERED COLUMNSTORE INDEX csi_FactInternetSales
ON dbo.FactInternetSales (
ProductKey,
OrderDateKey,
DueDateKey,
ShipDateKey,
CustomerKey,
PromotionKey,
CurrencyKey,
SalesTerritoryKey,
SalesOrderNumber,
SalesOrderLineNumber,
RevisionNumber,
OrderQuantity,
UnitPrice,
ExtendedAmount,
UnitPriceDiscountPct,
DiscountAmount,
ProductStandardCost,
TotalProductCost,
SalesAmount,
TaxAmt,
Freight,
CarrierTrackingNumber,
CustomerPONumber,
OrderDate,
DueDate,
ShipDate
)

-- page 399
SELECT d.CalendarYear,
SUM(SalesAmount) AS SalesTotal
FROM dbo.FactInternetSales AS f
WITH (INDEX(csi_FactInternetSales))
JOIN dbo.DimDate AS d
ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear

-- page 400
SELECT d.CalendarYear,
SUM(SalesAmount) AS SalesTotal
FROM dbo.FactInternetSales AS f
JOIN dbo.DimDate AS d
ON f.OrderDateKey = d.DateKey
GROUP BY d.CalendarYear
ORDER BY d.CalendarYear
OPTION (IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX)

DROP INDEX FactInternetSales.csi_FactInternetSales
