-- chapter 4

-- page 166
SELECT * FROM DatabaseLog

-- page 167
SELECT * FROM Person.Address

-- page 168
SELECT * FROM Person.Address
ORDER BY AddressID

SELECT AddressID, City, StateProvinceID
FROM Person.Address

-- page 169
SELECT AddressID, City, StateProvinceID FROM Person.Address
WHERE AddressID = 12037

SELECT AddressID, StateProvinceID FROM Person.Address
WHERE StateProvinceID = 32

-- page 170
SELECT AddressID, StateProvinceID FROM Person.Address
WHERE StateProvinceID = 9

SELECT AddressID, City, StateProvinceID FROM Person.Address
WHERE AddressID BETWEEN 10000 and 20000

SELECT AddressID, City, StateProvinceID, ModifiedDate
FROM Person.Address
WHERE StateProvinceID = 32

-- page 171
SET SHOWPLAN_TEXT ON
GO
SELECT AddressID, City, StateProvinceID, ModifiedDate
FROM Person.Address
WHERE StateProvinceID = 32
GO
SET SHOWPLAN_TEXT OFF
GO

-- page 172
SELECT AddressID, City, StateProvinceID, ModifiedDate
FROM Person.Address
WHERE StateProvinceID = 20

-- page 174
CREATE INDEX IX_Object ON DatabaseLog(Object)

SELECT * FROM DatabaseLog
WHERE Object = 'City'

-- page 175
DROP INDEX DatabaseLog.IX_Object

-- page 176
SELECT AVG(ListPrice) FROM Production.Product

SET SHOWPLAN_TEXT ON
GO
SELECT AVG(ListPrice) FROM Production.Product
GO
SET SHOWPLAN_TEXT OFF

-- page 177
SELECT ProductLine, COUNT(*) FROM Production.Product
GROUP BY ProductLine

SELECT SalesOrderID, SUM(LineTotal)FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID

-- page 178
SELECT TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID

-- page 179
CREATE INDEX IX_TerritoryID ON Sales.
SalesOrderHeader(TerritoryID)

DROP INDEX Sales.SalesOrderHeader.IX_TerritoryID

SELECT TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
ORDER BY TerritoryID

-- page 180
SELECT DISTINCT(JobTitle)
FROM HumanResources.Employee
GO
SELECT JobTitle
FROM HumanResources.Employee
GROUP BY JobTitle

-- page 180
CREATE INDEX IX_JobTitle ON HumanResources.Employee(JobTitle)

DROP INDEX HumanResources.Employee.IX_JobTitle

SELECT DISTINCT(TerritoryID)
FROM Sales.SalesOrderHeader
GO
SELECT TerritoryID
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID

SELECT e.BusinessEntityID, TerritoryID
FROM HumanResources.Employee AS e
JOIN Sales.SalesPerson AS s ON e.BusinessEntityID =
s.BusinessEntityID

-- page 183
SELECT e.BusinessEntityID, HireDate
FROM HumanResources.Employee AS e
JOIN Sales.SalesPerson AS s ON e.BusinessEntityID =
s.BusinessEntityID
WHERE TerritoryID = 1

SELECT h.SalesOrderID, s.SalesOrderDetailID, OrderDate
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail s ON h.SalesOrderID =
s.SalesOrderID

-- page 184
SELECT * FROM Sales.SalesOrderDetail s
JOIN Production.Product p ON s.ProductID = p.ProductID
WHERE SalesOrderID = 43659

-- page 185
SELECT * FROM Sales.SalesOrderdetail s
JOIN Production.Product p ON s.ProductID = p.ProductID
WHERE SalesOrderID = 43659
OPTION (MERGE JOIN)

-- page 186
SELECT h.SalesOrderID, s.SalesOrderDetailID FROM Sales.
SalesOrderHeader h
JOIN Sales.SalesOrderDetail s ON h.SalesOrderID =
s.SalesOrderID

-- page 187
SELECT *
INTO #temp
FROM Sales.SalesOrderDetail
UNION ALL SELECT * FROM Sales.SalesOrderDetail
UNION ALL SELECT * FROM Sales.SalesOrderDetail
UNION ALL SELECT * FROM Sales.SalesOrderDetail
UNION ALL SELECT * FROM Sales.SalesOrderDetail
UNION ALL SELECT * FROM Sales.SalesOrderDetail

SELECT IDENTITY(int, 1, 1) AS ID, CarrierTrackingNumber,
OrderQty, ProductID,
UnitPrice, LineTotal, rowguid, ModifiedDate
INTO dbo.SalesOrderDetail FROM #temp

SELECT IDENTITY(int, 1, 1) AS ID, CarrierTrackingNumber,
OrderQty, ProductID,
UnitPrice, LineTotal, rowguid, ModifiedDate
INTO dbo.SalesOrderDetail2 FROM #temp

DROP TABLE #temp

SELECT ProductID, COUNT(*)
FROM dbo.SalesOrderDetail
GROUP BY ProductID

SELECT ProductID, COUNT(*)
FROM dbo.SalesOrderDetail
GROUP BY ProductID
OPTION (MAXDOP 1)

-- page 189
EXEC sp_configure 'cost threshold for parallelism', 10
GO
RECONFIGURE
GO

EXEC sp_configure 'cost threshold for parallelism', 5
GO
RECONFIGURE
GO

-- page 190
SELECT * FROM dbo.SalesOrderDetail
WHERE LineTotal > 3234

-- page 192
SELECT ProductID, COUNT(*)
FROM dbo.SalesOrderDetail
GROUP BY ProductID
GO
SELECT ProductID, COUNT(*)
FROM dbo.SalesOrderDetail
GROUP BY ProductID
ORDER BY ProductID

-- page 192
SELECT * FROM dbo.SalesOrderDetail s1 JOIN dbo.SalesOrderDetail2 s2
ON s1.id = s2.id

-- page 193
SELECT * FROM dbo.SalesOrderDetail s1
JOIN dbo.SalesOrderDetail2 s2 ON s1.ProductID = s2.ProductID
WHERE s1.id = 123

-- page 195
CREATE FUNCTION dbo.ufn_test(@ProductID int)
RETURNS int
AS
BEGIN
RETURN @ProductID
END
GO
SELECT dbo.ufn_test(ProductID), ProductID, COUNT(*)
FROM dbo.SalesOrderDetail
GROUP BY ProductID

SELECT ProductID, COUNT(*)
FROM Sales.SalesOrderDetail
GROUP BY ProductID

SELECT ProductID, COUNT(*)
FROM Sales.SalesOrderDetail
GROUP BY ProductID
OPTION (QUERYTRACEON 8649)

-- page 196
INSERT INTO Person.CountryRegion (CountryRegionCode, Name)
VALUES ('ZZ', 'New Country')

-- page 197
DELETE FROM Person.CountryRegion
WHERE CountryRegionCode = 'ZZ'

-- page 198
DELETE FROM Sales.SalesOrderDetail
WHERE SalesOrderDetailID = 61130

-- page 199
CREATE NONCLUSTERED INDEX AK_SalesOrderDetail_rowguid
ON dbo.SalesOrderDetail (rowguid)
CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_ProductID
ON dbo.SalesOrderDetail (ProductID)

DELETE FROM dbo.SalesOrderDetail WHERE ProductID < 953

DROP TABLE dbo.SalesOrderDetail
DROP TABLE dbo.SalesOrderDetail2

-- page 200
DELETE FROM Sales.SalesOrderDetail
WHERE SalesOrderDetailID < 43740
OPTION (QUERYTRACEON 8790)

SELECT * INTO dbo.Product FROM Production.Product

UPDATE dbo.Product SET ListPrice = ListPrice * 1.2

-- page 201
CREATE CLUSTERED INDEX CIX_ListPrice ON dbo.Product(ListPrice)

DROP TABLE dbo.Product




















