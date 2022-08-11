-- chapter 2

-- page 67
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
GO
SELECT * FROM Production.Product p1 CROSS JOIN Production.Product p2

SELECT cpu_time, reads, total_elapsed_time, logical_reads, row_count
FROM sys.dm_exec_requests
WHERE session_id = 56
GO
SELECT cpu_time, reads, total_elapsed_time, logical_reads, row_count
FROM sys.dm_exec_sessions
WHERE session_id = 56

-- page 69
CREATE OR ALTER PROC test
AS
SELECT * FROM Sales.SalesOrderDetail WHERE SalesOrderID = 60677
SELECT * FROM Person.Address WHERE AddressID = 21
SELECT * FROM HumanResources.Employee WHERE BusinessEntityID = 229

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
GO
EXEC test
GO
SELECT * FROM sys.dm_exec_query_stats
CROSS APPLY sys.dm_exec_sql_text(sql_handle)
WHERE objectid = OBJECT_ID('dbo.test')

-- page 72
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
GO
EXEC test
GO
SELECT SUBSTRING(text, (statement_start_offset/2) + 1,
((CASE statement_end_offset
WHEN -1
THEN DATALENGTH(text)
ELSE
statement_end_offset
END
- statement_start_offset)/2) + 1) AS statement_text, *
FROM sys.dm_exec_query_stats
CROSS APPLY sys.dm_exec_sql_text(sql_handle)
WHERE objectid = OBJECT_ID('dbo.test')

-- page 73
SELECT SUBSTRING(text, 44 / 2 + 1, (168 - 44) / 2 + 1)
FROM sys.dm_exec_sql_text(0x03000500996DB224E0B27201B7A1000001000000000000000000000000000000000000000000000000000000)

SELECT * from sys.dm_exec_sql_text(0x03000500996DB224E0B27201B7A1000001000000000000000000000000000000000000000000000000000000)

SELECT * FROM sys.dm_os_memory_objects
WHERE type = 'MEMOBJ_SQLMGR'

-- page 74
SELECT * FROM sys.dm_exec_query_plan(0x05000500996DB224B0C9B8F80100000001000000000000000000000000000000000000000000000000000000)

DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
GO
SELECT * FROM Person.Address
WHERE AddressID = 12
GO
SELECT * FROM Person.Address
WHERE AddressID = 37
GO
SELECT * FROM sys.dm_exec_query_stats

-- page 75
DBCC FREEPROCCACHE
DBCC DROPCLEANBUFFERS
GO
SELECT * FROM Person.Address
WHERE StateProvinceID = 79
GO
SELECT * FROM Person.Address
WHERE StateProvinceID = 59
GO
SELECT * FROM sys.dm_exec_query_stats

-- page 76
SELECT TOP 20 query_stats.query_hash,
SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count)
AS avg_cpu_time,
MIN(query_stats.statement_text) AS statement_text
FROM
(SELECT qs.*,
SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
((CASE statement_end_offset
WHEN -1 THEN DATALENGTH(ST.text)
ELSE qs.statement_end_offset END
- qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st) AS
query_stats
GROUP BY query_stats.query_hash
ORDER BY avg_cpu_time DESC

-- page 77
SELECT TOP 20 query_plan_hash,
SUM(total_worker_time) / SUM(execution_count) AS avg_cpu_time,
MIN(plan_handle) AS plan_handle, MIN(text) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) AS st
GROUP BY query_plan_hash
ORDER BY avg_cpu_time DESC

SELECT TOP 20 SUBSTRING(st.text, (er.statement_start_offset/2)
+ 1,
((CASE statement_end_offset
WHEN -1
THEN DATALENGTH(st.text)
ELSE
er.statement_end_offset
END
- er.statement_start_offset)/2) + 1) AS statement_text
, *
FROM sys.dm_exec_requests er
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
ORDER BY total_elapsed_time DESC

-- page 78
BEGIN TRANSACTION
UPDATE Sales.SalesOrderHeader
SET Status = 1
WHERE SalesOrderID = 43659

SELECT * FROM Sales.SalesOrderHeader

SELECT * FROM sysprocesses
WHERE blocked <> 0

-- page 79
SELECT * FROM sys.dm_exec_requests
WHERE blocking_session_id <> 0

SELECT * FROM sys.dm_exec_input_buffer(70, 0)

ROLLBACK TRANSACTION

BEGIN TRANSACTION
UPDATE Sales.SalesOrderDetail
SET OrderQty = 3
WHERE SalesOrderDetailID = 1

SELECT * FROM Sales.SalesOrderDetail
ORDER BY OrderQty

SELECT * FROM sys.dm_os_waiting_tasks
WHERE session_id = 63

-- page 80
ROLLBACK TRANSACTION

-- page 81
SELECT * FROM Sales.SalesOrderDetail WHERE SalesOrderID = 60677

-- page 82
CREATE OR ALTER PROC test
AS
SELECT * FROM HumanResources.Employee WHERE BusinessEntityID = 229

EXEC test

-- page 83
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
            cnn = new SqlConnection("Data Source=(local);Initial Catalog=AdventureWorks2019;Integrated Security=SSPI");
            SqlCommand cmd = new SqlCommand();
            cmd.Connection = cnn;
            cmd.CommandText = "dbo.test";
            cmd.CommandType = CommandType.StoredProcedure;
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

-- page 85
SELECT name, description
FROM sys.dm_xe_objects
WHERE object_type = 'event' AND
(capabilities & 1 = 0 OR capabilities IS NULL)
ORDER BY name

SELECT o.name, c.name as column_name, c.description
FROM sys.dm_xe_objects o
JOIN sys.dm_xe_object_columns c
ON o.name = c.object_name
WHERE object_type = 'event' AND
c.column_type <> 'readonly' AND
(o.capabilities & 1 = 0 OR o.capabilities IS NULL)
ORDER BY o.name, c.name

-- page 86
SELECT name, description
FROM sys.dm_xe_objects
WHERE object_type = 'action' AND
(capabilities & 1 = 0 OR capabilities IS NULL)
ORDER BY name

SELECT name, description
FROM sys.dm_xe_objects
WHERE object_type = 'pred_source' AND
(capabilities & 1 = 0 OR capabilities IS NULL)
ORDER BY name

SELECT name, description
FROM sys.dm_xe_objects
WHERE object_type = 'target' AND
(capabilities & 1 = 0 OR capabilities IS NULL)
ORDER BY name

-- page 87
SELECT te.trace_event_id, name, package_name, xe_event_name
FROM sys.trace_events te
JOIN sys.trace_xe_event_map txe ON te.trace_event_id = txe.trace_event_id
WHERE te.trace_event_id IS NOT NULL
ORDER BY name

SELECT * FROM sys.traces

SELECT te.trace_event_id, name, package_name, xe_event_name
FROM sys.trace_events te
JOIN sys.trace_xe_event_map txe ON te.trace_event_id = txe.trace_event_id
WHERE te.trace_event_id IN (
SELECT DISTINCT(eventid) FROM sys.fn_trace_geteventinfo(2))
ORDER BY name

-- page 92
CREATE EVENT SESSION test ON SERVER
ADD EVENT sqlserver.module_end(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text)),
ADD EVENT sqlserver.rpc_completed(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text)),
ADD EVENT sqlserver.sp_statement_completed(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text)),
ADD EVENT sqlserver.sql_batch_completed(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text)),
ADD EVENT sqlserver.sql_statement_completed(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text))
ADD TARGET package0.ring_buffer
WITH (STARTUP_STATE=OFF)

-- page 93
ALTER EVENT SESSION [test]
ON SERVER
STATE=START

SELECT * FROM Sales.SalesOrderDetail WHERE SalesOrderID = 60677
GO
SELECT * FROM Person.Address WHERE AddressID = 21
GO
SELECT * FROM HumanResources.Employee WHERE BusinessEntityID = 229
GO

SELECT name, target_name, execution_count, CAST(target_data AS
xml)
AS target_data
FROM sys.dm_xe_sessions s
JOIN sys.dm_xe_session_targets t
ON s.address = t.event_session_address
WHERE s.name = 'test'

-- page 95
SELECT
event_data.value('(event/@name)[1]', 'varchar(50)') AS event_name,
event_data.value('(event/action[@name="query_hash"]/value)[1]',
'varchar(max)') AS query_hash,
event_data.value('(event/data[@name="cpu_time"]/value)[1]',
'int')
AS cpu_time,
event_data.value('(event/data[@name="duration"]/value)[1]',
'int')
AS duration,
event_data.value('(event/data[@name="logical_reads"]/value)
[1]', 'int')
AS logical_reads,
event_data.value('(event/data[@name="physical_reads"]/value)
[1]', 'int')
AS physical_reads,
event_data.value('(event/data[@name="writes"]/value)[1]',
'int') AS writes,
event_data.value('(event/data[@name="statement"]/value)[1]',
'varchar(max)')
AS statement
FROM(SELECT evnt.query('.') AS event_data
FROM
(SELECT CAST(target_data AS xml) AS target_data
FROM sys.dm_xe_sessions s
JOIN sys.dm_xe_session_targets t
ON s.address = t.event_session_address
WHERE s.name = 'test'
AND t.target_name = 'ring_buffer'
) AS data
CROSS APPLY target_data.nodes('RingBufferTarget/event') AS
xevent(evnt)
) AS xevent(event_data)

-- page 96
SELECT query_hash, SUM(cpu_time) AS cpu_time, SUM(duration) AS
duration,
SUM(logical_reads) AS logical_reads, SUM(physical_reads) AS
physical_reads,
SUM(writes) AS writes, MAX(statement) AS statement
FROM #eventdata
GROUP BY query_hash

-- page 97
ALTER EVENT SESSION [test]
ON SERVER
STATE=STOP
GO
DROP EVENT SESSION [test] ON SERVER

CREATE EVENT SESSION test ON SERVER
ADD EVENT sqlserver.module_end(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text)),
ADD EVENT sqlserver.rpc_completed(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text)),
ADD EVENT sqlserver.sp_statement_completed(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text)),
ADD EVENT sqlserver.sql_batch_completed(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text)),
ADD EVENT sqlserver.sql_statement_completed(
ACTION(sqlserver.plan_handle,sqlserver.query_hash,sqlserver.
query_plan_hash,
sqlserver.sql_text))
ADD TARGET package0.event_file(SET filename=N'C:\Data\test.xel')
WITH (STARTUP_STATE=OFF)

-- page 98
SELECT
event_data.value('(event/@name)[1]', 'varchar(50)') AS event_name,
event_data.value('(event/action[@name="query_hash"]/value)[1]',
'varchar(max)') AS query_hash,
event_data.value('(event/data[@name="cpu_time"]/value)[1]',
'int')
AS cpu_time,
event_data.value('(event/data[@name="duration"]/value)[1]',
'int')
AS duration,
event_data.value('(event/data[@name="logical_reads"]/value)
[1]', 'int')
AS logical_reads,
event_data.value('(event/data[@name="physical_reads"]/value)
[1]', 'int')
AS physical_reads,
event_data.value('(event/data[@name="writes"]/value)[1]',
'int') AS writes,
event_data.value('(event/data[@name="statement"]/value)[1]',
'varchar(max)')
AS statement
FROM
(
SELECT CAST(event_data AS xml)
FROM sys.fn_xe_file_target_read_file
(
'C:\Data\test*.xel',
NULL,
NULL,
NULL
)
) AS xevent(event_data)

-- page 99
CREATE EVENT SESSION [test] ON SERVER
ADD EVENT sqlos.wait_info(
WHERE ([sqlserver].[session_id]=(61)))
ADD TARGET package0.ring_buffer
WITH (STARTUP_STATE=OFF)

ALTER EVENT SESSION [test]
ON SERVER
STATE=START

SELECT * FROM Production.Product p1 CROSS JOIN
Production.Product p2

SELECT
event_data.value('(event/@name)[1]', 'varchar(50)') AS event_name,
event_data.value('(event/data[@name="wait_type"]/text)[1]',
'varchar(40)')
AS wait_type,
event_data.value('(event/data[@name="duration"]/value)[1]',
'int')
AS duration,
event_data.value('(event/data[@name="opcode"]/text)[1]',
'varchar(40)')
AS opcode,
event_data.value('(event/data[@name="signal_duration"]/value)
[1]', 'int')
AS signal_duration
FROM(SELECT evnt.query('.') AS event_data
FROM
(SELECT CAST(target_data AS xml) AS target_data
FROM sys.dm_xe_sessions s
JOIN sys.dm_xe_session_targets t
ON s.address = t.event_session_address
WHERE s.name = 'test'
AND t.target_name = 'ring_buffer'
) AS data
CROSS APPLY target_data.nodes('RingBufferTarget/event') AS
xevent(evnt)
) AS xevent(event_data)

-- page 106
SELECT sii.instance_name, collection_time, [path] AS counter_name,
formatted_value AS counter_value_percent
FROM snapshots.performance_counter_values pcv
JOIN snapshots.performance_counter_instances pci
ON pcv.performance_counter_instance_id = pci.performance_counter_id
JOIN core.snapshots_internal si ON pcv.snapshot_id = si.snapshot_id
JOIN core.source_info_internal sii ON sii.source_id = si.source_id
WHERE pci.[path] = '\Processor(_Total)\% Processor Time'
ORDER BY pcv.collection_time desc

