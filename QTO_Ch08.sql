-- chapter 8

-- page 318
DBCC FREEPROCCACHE
GO
CREATE OR ALTER PROCEDURE test
AS
CREATE TABLE #table1 (name varchar(40))
SELECT * FROM #table1
GO
EXEC test

-- page 319
SELECT map_key, map_value FROM sys.dm_xe_map_values
WHERE name = 'statement_recompile_cause'

-- page 321
SELECT * FROM sys.dm_os_memory_cache_counters
WHERE type IN ('CACHESTORE_OBJCP', 'CACHESTORE_SQLCP',
'CACHESTORE_PHDR', 'CACHESTORE_XPROC')

-- page 323
DBCC FREEPROCCACHE
GO
SELECT * FROM Person.Address
WHERE StateProvinceID = 79
GO
SELECT * FROM Person.Address
WHERE StateProvinceID = 59
GO
SELECT * FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE text like '%Person%'

-- page 324
SELECT text, query_plan FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
CROSS APPLY sys.dm_exec_query_plan(plan_handle)
WHERE text like '%Person%'

DBCC FREEPROCCACHE
GO
SELECT * FROM Person.Address
WHERE AddressID = 12
GO
SELECT * FROM Person.Address
WHERE AddressID = 37
GO
SELECT * FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE text like '%Person%'

-- page 325
EXEC sp_configure 'optimize for ad hoc workloads', 1
RECONFIGURE
DBCC FREEPROCCACHE
GO
SELECT * FROM Person.Address
WHERE StateProvinceID = 79
GO
SELECT * FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE text like '%Person%'

-- page 326
SELECT * FROM Person.Address
WHERE StateProvinceID = 79
GO
SELECT * FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE text like '%Person%'

EXEC sp_configure 'optimize for ad hoc workloads', 0
RECONFIGURE

-- page 327
ALTER DATABASE AdventureWorks2019 SET PARAMETERIZATION FORCED

DBCC FREEPROCCACHE
GO
SELECT * FROM Person.Address
WHERE StateProvinceID = 79
GO
SELECT * FROM Person.Address
WHERE StateProvinceID = 59
GO
SELECT * FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE text like '%Person%'

-- page 328
ALTER DATABASE AdventureWorks2019 SET PARAMETERIZATION SIMPLE

CREATE OR ALTER PROCEDURE test (@stateid int)
AS
SELECT * FROM Person.Address
WHERE StateProvinceID = @stateid

-- page 329
DBCC FREEPROCCACHE
GO
exec test @stateid = 79
GO
exec test @stateid = 59
GO
SELECT * FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE text like '%Person%'

DBCC FREEPROCCACHE
GO
exec test @stateid = 59
GO
exec test @stateid = 79
GO
SELECT * FROM sys.dm_exec_cached_plans
CROSS APPLY sys.dm_exec_sql_text(plan_handle)
WHERE text like '%Person%'

-- page 330
CREATE OR ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @pid

EXEC test @pid = 897

SET STATISTICS IO ON
GO
EXEC test @pid = 870
GO

DBCC FREEPROCCACHE
GO
EXEC test @pid = 870
GO

-- page 333
ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @pid
OPTION (OPTIMIZE FOR (@pid = 897))

EXEC test @pid = 870

ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @pid
OPTION (RECOMPILE)

-- page 334
ALTER PROCEDURE test (@pid int)
AS
DECLARE @p int = @pid
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @p
GO
ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @pid
OPTION (OPTIMIZE FOR UNKNOWN)

-- page 335
ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @pid
OPTION (OPTIMIZE FOR (@pid UNKNOWN))

ALTER PROCEDURE test (@pid int)
AS
DECLARE @p int = @pid
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @p
OPTION (RECOMPILE)

EXEC test @pid = 897

-- page 338
CREATE DATABASE Test
GO
USE Test
GO
SELECT * INTO dbo.SalesOrderDetail
FROM AdventureWorks2019.Sales.SalesOrderDetail
GO
CREATE NONCLUSTERED INDEX IX_SalesOrderDetail_ProductID
ON dbo.SalesOrderDetail(ProductID)
GO
CREATE OR ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM dbo.SalesOrderDetail
WHERE ProductID = @pid

DBCC FREEPROCCACHE

SELECT plan_handle, usecounts, pvt.set_options
FROM (
SELECT plan_handle, usecounts, epa.attribute, epa.value
FROM sys.dm_exec_cached_plans
OUTER APPLY sys.dm_exec_plan_attributes(plan_handle) AS epa
WHERE cacheobjtype = 'Compiled Plan') AS ecpa
PIVOT (MAX(ecpa.value) FOR ecpa.attribute IN ("set_options",
"objectid")) AS pvt
WHERE pvt.objectid = OBJECT_ID('dbo.test')

-- page 340
EXEC test @pid = 898

SELECT * FROM sys.dm_exec_query_plan(0x050007002255970F9042B8F801000000010000000000000000000)

-- page 341
sp_recompile test

-- page 342
DECLARE @set_options int = 4347
IF ((1 & @set_options) = 1) PRINT 'ANSI_PADDING'
IF ((4 & @set_options) = 4) PRINT 'FORCEPLAN'
IF ((8 & @set_options) = 8) PRINT 'CONCAT_NULL_YIELDS_NULL'
IF ((16 & @set_options) = 16) PRINT 'ANSI_WARNINGS'
IF ((32 & @set_options) = 32) PRINT 'ANSI_NULLS'
IF ((64 & @set_options) = 64) PRINT 'QUOTED_IDENTIFIER'
IF ((128 & @set_options) = 128) PRINT 'ANSI_NULL_DFLT_ON'
IF ((256 & @set_options) = 256) PRINT 'ANSI_NULL_DFLT_OFF'
IF ((512 & @set_options) = 512) PRINT 'NoBrowseTable'
IF ((4096 & @set_options) = 4096) PRINT 'ARITH_ABORT'
IF ((8192 & @set_options) = 8192) PRINT 'NUMERIC_ROUNDABORT'
IF ((16384 & @set_options) = 16384) PRINT 'DATEFIRST'
IF ((32768 & @set_options) = 32768) PRINT 'DATEFORMAT'
IF ((65536 & @set_options) = 65536) PRINT 'LanguageID'

using System; 
using System.Data;
using System.Data.SqlClient;
class Test
{
    static void Main()
    {
        SqlConnection cnn = null;
        SqlDataReader reader = null;
        try
        {
            Console.Write("Enter ProductID: ");
            string pid = Console.ReadLine();
            cnn = new SqlConnection("Data Source=(local);Initial Catalog=Test;
                Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = cnn;
            cmd.CommandText = "dbo.test";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.Add
                ("@pid", SqlDbType.Int).Value = pid;
            cnn.Open();
            reader = cmd.ExecuteReader();
            while (reader.Read())
            {
                Console.WriteLine(reader[0]);
            }
            return;
        }
        catch (Exception e)
        {
            throw e;
        }
        finally
        {
            if (cnn != null)
            {
                if (cnn.State != ConnectionState.Closed)
                    cnn.Close();
            }
        }
    }
}

-- page 344
csc test.cs

ALTER DATABASE AdventureWorks2019 SET COMPATIBILITY_LEVEL = 160

ALTER DATABASE AdventureWorks2019 SET QUERY_STORE = ON
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE (OPERATION_MODE = READ_WRITE)
ALTER DATABASE AdventureWorks2019 SET QUERY_STORE CLEAR ALL

-- page 345
CREATE OR ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM Sales.SalesOrderDetail
WHERE ProductID = @pid

EXEC test @pid = 897

EXEC test @pid = 870

CREATE EVENT SESSION psp ON SERVER
ADD EVENT sqlserver.parameter_sensitive_plan_optimization_skipped_reason
WITH (STARTUP_STATE = ON)

ALTER EVENT SESSION psp
ON SERVER
STATE=START

EXEC test @pid = 897

-- page 346
SELECT name, map_value
FROM sys.dm_xe_map_values
WHERE name = 'psp_skipped_reason_enum'

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
-- GO 50

-- page 347
-- WHERE ProductID = 897
WHERE ProductID = 870
GO 50

CREATE INDEX IX_ProductID ON dbo.SalesOrderDetail(ProductID)

ALTER PROCEDURE test (@pid int)
AS
SELECT * FROM dbo.SalesOrderDetail
WHERE ProductID = @pid

DBCC FREEPROCCACHE
GO
EXEC test @pid = 897
GO
EXEC test @pid = 870

-- page 348
DBCC FREEPROCCACHE
GO
EXEC test @pid = 897
GO
EXEC test @pid = 870
GO 4
EXEC test @pid = 897
GO 2
SELECT * FROM sys.dm_exec_cached_plans CROSS APPLY
sys.dm_exec_sql_text(plan_handle)

-- page 349
DBCC SHOW_STATISTICS('dbo.SalesOrderDetail', IX_ProductID)
