-- chapter 9

-- page 352
USE master
GO
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE = ON
GO
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE (OPERATION_MODE = READ_WRITE)

-- page 353
SELECT * FROM sys.database_query_store_options

SELECT TerritoryID, COUNT(*)
FROM Sales.SalesOrderHeader
GROUP BY TerritoryID
ORDER BY TerritoryID

SELECT * FROM Sales.SalesOrderdetail s
JOIN Production.Product p ON s.ProductID = p.ProductID
WHERE SalesOrderID = 43659
OPTION (MERGE JOIN)

SELECT h.SalesOrderID, s.SalesOrderDetailID, OrderDate
FROM Sales.SalesOrderHeader h
JOIN Sales.SalesOrderDetail s ON h.SalesOrderID = s.SalesOrderID

SELECT e.BusinessEntityID, TerritoryID
FROM HumanResources.Employee AS e
JOIN Sales.SalesPerson AS s ON e.BusinessEntityID = s.BusinessEntityID

SELECT SalesOrderID, SUM(LineTotal)FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID 

SELECT c.CustomerID, COUNT(*)
FROM Sales.Customer c JOIN Sales.SalesOrderHeader s
ON c.CustomerID = s.CustomerID
WHERE c.TerritoryID = 4
GROUP BY c.CustomerID

SELECT DISTINCT pp.LastName, pp.FirstName
FROM Person.Person pp JOIN HumanResources.Employee e
ON e.BusinessEntityID = pp.BusinessEntityID
JOIN Sales.SalesOrderHeader soh
ON pp.BusinessEntityID = soh.SalesPersonID
JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p
ON sod.ProductID = p.ProductID
WHERE ProductNumber = 'BK-M18B-44'

SELECT soh.SalesOrderID, sod.SalesOrderDetailID, SalesReasonID
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod
ON soh.SalesOrderID = soh.SalesOrderID
JOIN Sales.SalesOrderHeaderSalesReason sohsr
ON sohsr.SalesOrderID = soh.SalesOrderID
WHERE soh.SalesOrderID = 43697

-- page 355
CREATE OR ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @pid

-- page 356
EXEC test @pid = 897
GO 100
EXEC test @pid = 870
GO 100

ALTER DATABASE AdventureWorks2019 SET QUERY_STORE = ON (WAIT_STATS_CAPTURE_MODE = ON)

-- page 357
SELECT * FROM Sales.SalesOrderDetail sod1 CROSS JOIN Sales.SalesOrderDetail sod2

-- page 358
SELECT rs.avg_logical_io_reads, qt.query_sql_text,
q.query_id, execution_type_desc, qt.query_text_id, p.plan_id,
rs.runtime_stats_id,
rsi.start_time, rsi.end_time, rs.avg_rowcount, rs.count_executions
FROM sys.query_store_query_text AS qt
JOIN sys.query_store_query AS q
ON qt.query_text_id = q.query_text_id
JOIN sys.query_store_plan AS p
ON q.query_id = p.query_id
JOIN sys.query_store_runtime_stats AS rs
ON p.plan_id = rs.plan_id
JOIN sys.query_store_runtime_stats_interval AS rsi
ON rsi.runtime_stats_interval_id = rs.runtime_stats_interval_id
WHERE execution_type_desc IN ('Aborted', 'Exception')

SELECT TOP 20
p.query_id query_id,
qt.query_sql_text query_text,
CONVERT(float, SUM(rs.avg_cpu_time * rs.count_executions))
total_cpu_time,
SUM(rs.count_executions) count_executions,
COUNT(DISTINCT p.plan_id) num_plans
FROM sys.query_store_runtime_stats rs
JOIN sys.query_store_plan p ON p.plan_id = rs.plan_id
JOIN sys.query_store_query q ON q.query_id = p.query_id
JOIN sys.query_store_query_text qt ON q.query_text_id =
qt.query_text_id
GROUP BY p.query_id, qt.query_sql_text
ORDER BY total_cpu_time DESC

-- page 359
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE = OFF








