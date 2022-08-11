-- chapter 1

-- page 27
SELECT DISTINCT(City) FROM Person.Address

-- page 36
SET SHOWPLAN_XML ON
GO
SELECT DISTINCT(City) FROM Person.Address
GO
SET SHOWPLAN_XML OFF

SELECT * FROM Sales.SalesOrderDetail
WHERE OrderQty = 1

-- page 37
SET SHOWPLAN_TEXT ON
GO
SELECT DISTINCT(City) FROM Person.Address
GO
SET SHOWPLAN_TEXT OFF
GO

-- page 38
SET SHOWPLAN_ALL ON
GO
SELECT DISTINCT(City) FROM Person.Address
GO
SET SHOWPLAN_ALL OFF
GO

SET STATISTICS PROFILE ON
GO
SELECT * FROM Sales.SalesOrderDetail
WHERE OrderQty * UnitPrice > 25000
GO
SET STATISTICS PROFILE OFF

-- page 41
SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43666

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43666
OPTION (QUERYTRACEON 8757)

-- page 42
SELECT pm.ProductModelID, pm.Name, Description, pl.CultureID,
cl.Name AS Language
FROM Production.ProductModel AS pm
JOIN Production.ProductModelProductDescriptionCulture AS pl
ON pm.ProductModelID = pl.ProductModelID
JOIN Production.Culture AS cl
ON cl.CultureID = pl.CultureID
JOIN Production.ProductDescription AS pd
ON pd.ProductDescriptionID = pl.ProductDescriptionID
ORDER BY pm.ProductModelID

-- page 43
SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43666
OPTION (MAXDOP 1)

SELECT CustomerID,('AW' + dbo.ufnLeadingZeros(CustomerID))
AS GenerateAccountNumber
FROM Sales.Customer
ORDER BY CustomerID

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 43666
OPTION (MAXDOP 8)

-- page 44
SELECT DISTINCT(CustomerID)
FROM Sales.SalesOrderHeader

-- page 46
DBCC TRACEON (2371, -1)
DBCC TRACEON (4199, -1)

-- page 47
DBCC TRACEOFF (2371, -1)
DBCC TRACEOFF (4199, -1)

-- page 48
DROP STATISTICS HumanResources.Employee._WA_Sys_0000000C_70DDC3D8

ALTER DATABASE AdventureWorks2019 SET AUTO_CREATE_STATISTICS OFF

SELECT * FROM HumanResources.Employee
WHERE VacationHours = 48

-- page 49
ALTER DATABASE AdventureWorks2019 SET AUTO_CREATE_STATISTICS ON

SELECT * FROM Sales.SalesOrderHeader soh, Sales.
SalesOrderDetail sod
WHERE soh.SalesOrderID = sod.SalesOrderID

-- page 50
SELECT * FROM Sales.SalesOrderHeader soh JOIN Sales.
SalesOrderDetail sod
-- ON soh.SalesOrderID = sod.SalesOrderID

DECLARE @code nvarchar(15)
SET @code = '95555Vi4081'
SELECT * FROM Sales.SalesOrderHeader
WHERE CreditCardApprovalCode = @code

-- page 51
SELECT * FROM Sales.SalesOrderDetail
ORDER BY UnitPrice

-- page 52
CREATE INDEX IX_Color ON Production.Product(Name,
ProductNumber)
WHERE Color = 'White'

DECLARE @color nvarchar(15)
SET @color = 'White'
SELECT Name, ProductNumber FROM Production.Product
WHERE Color = @color

-- page 53
SELECT Name, ProductNumber FROM Production.Product
WHERE Color = 'White'

DROP INDEX Production.Product.IX_Color

-- page 54
SELECT * FROM sys.dm_exec_requests
CROSS APPLY sys.dm_exec_query_plan(plan_handle)

SELECT * FROM sys.dm_exec_query_stats
CROSS APPLY sys.dm_exec_query_plan(plan_handle)

SELECT TOP 10
total_worker_time/execution_count AS avg_cpu_time, plan_handle,
query_plan
FROM sys.dm_exec_query_stats
CROSS APPLY sys.dm_exec_query_plan(plan_handle)
ORDER BY avg_cpu_time DESC

-- page 58
CREATE EVENT SESSION [test] ON SERVER
ADD EVENT sqlserver.query_post_execution_showplan(
ACTION(sqlserver.plan_handle)
WHERE ([sqlserver].[database_name]=N'AdventureWorks2019'))
ADD TARGET package0.ring_buffer
WITH (STARTUP_STATE=OFF)
GO

ALTER EVENT SESSION [test]
ON SERVER
STATE=START

SELECT
event_data.value('(event/@name)[1]', 'varchar(50)') AS event_name,
event_data.value('(event/action[@name="plan_handle"]/value)
[1]',
'varchar(max)') as plan_handle,
event_data.query('event/data[@name="showplan_xml"]/value/*') as
showplan_xml,
event_data.value('(event/action[@name="sql_text"]/value)[1]',
'varchar(max)') AS sql_text
FROM( SELECT evnt.query('.') AS event_data
FROM
( SELECT CAST(target_data AS xml) AS target_data
FROM sys.dm_xe_sessions AS s
JOIN sys.dm_xe_session_targets AS t
ON s.address = t.event_session_address
WHERE s.name = 'test'
AND t.target_name = 'ring_buffer'
) AS data
CROSS APPLY target_data.nodes('RingBufferTarget/event') AS
xevent(evnt)
) AS xevent(event_data)

-- page 59
ALTER EVENT SESSION [test]
ON SERVER
STATE=STOP
GO
DROP EVENT SESSION [test] ON SERVER

-- page 60
SET STATISTICS TIME ON

SELECT DISTINCT(CustomerID)
FROM Sales.SalesOrderHeader

SET STATISTICS TIME OFF

-- page 61
SET STATISTICS IO ON

DBCC DROPCLEANBUFFERS

SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = 870

-- page 62
SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID = 51119

SELECT * FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 51119

SELECT * FROM Sales.SalesOrderHeader
WHERE SalesOrderID IN (51119, 43664, 63371, 75119)

