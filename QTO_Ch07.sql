-- chapter 7

-- page 290
CREATE DATABASE Test
ON PRIMARY (NAME = Test_data,
FILENAME = 'C:\DATA\Test_data.mdf', SIZE=500MB),
FILEGROUP Test_fg CONTAINS MEMORY_OPTIMIZED_DATA
(NAME = Test_fg, FILENAME = 'C:\DATA\Test_fg')
LOG ON (NAME = Test_log, Filename='C:\DATA\Test_log.ldf',
SIZE=500MB)
COLLATE Latin1_General_100_BIN2

CREATE DATABASE Test
ON PRIMARY (NAME = Test_data,
FILENAME = 'C:\DATA\Test_data.mdf', SIZE=500MB)
LOG ON (NAME = Test_log, Filename='C:\DATA\Test_log.ldf',
SIZE=500MB)
GO
ALTER DATABASE Test ADD FILEGROUP Test_fg CONTAINS MEMORY_OPTIMIZED_DATA
GO
ALTER DATABASE Test ADD FILE (NAME = Test_fg, FILENAME = N'C:\DATA\Test_fg')
TO FILEGROUP Test_fg
GO

-- page 291
CREATE TABLE TransactionHistoryArchive (
TransactionID int NOT NULL,
ProductID int NOT NULL,
ReferenceOrderID int NOT NULL,
ReferenceOrderLineID int NOT NULL,
TransactionDate datetime NOT NULL,
TransactionType nchar(1) NOT NULL,
Quantity int NOT NULL,
ActualCost money NOT NULL,
ModifiedDate datetime NOT NULL
) WITH (MEMORY_OPTIMIZED = ON)

-- page 292
DROP TABLE TransactionHistoryArchive

CREATE TABLE TransactionHistoryArchive (
TransactionID int NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH
(BUCKET_COUNT = 100000),
ProductID int NOT NULL,
ReferenceOrderID int NOT NULL,
ReferenceOrderLineID int NOT NULL,
TransactionDate datetime NOT NULL,
TransactionType nchar(1) NOT NULL,
Quantity int NOT NULL,
ActualCost money NOT NULL,
ModifiedDate datetime NOT NULL
) WITH (MEMORY_OPTIMIZED = ON)

-- page 293
CREATE TABLE TransactionHistoryArchive (
TransactionID int NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH
(BUCKET_COUNT = 100000),
ProductID int NOT NULL,
ReferenceOrderID int NOT NULL,
ReferenceOrderLineID int NOT NULL,
TransactionDate datetime NOT NULL,
TransactionType nchar(1) NOT NULL,
Quantity int NOT NULL,
ActualCost money NOT NULL,
ModifiedDate datetime NOT NULL,
INDEX IX_ProductID NONCLUSTERED (ProductID)
) WITH (MEMORY_OPTIMIZED = ON)

-- page 294
INSERT INTO TransactionHistoryArchive
SELECT * FROM AdventureWorks2019.Production.
TransactionHistoryArchive

SELECT * FROM TransactionHistoryArchive tha
JOIN AdventureWorks2019.Production.TransactionHistory ta
ON tha.TransactionID = ta.TransactionID

SELECT * INTO #temp
FROM AdventureWorks2019.Production.TransactionHistoryArchive
GO
INSERT INTO TransactionHistoryArchive
SELECT * FROM #temp

CREATE TABLE TransactionHistory (
TransactionID int,
ProductID int)
GO
SELECT * FROM TransactionHistoryArchive tha
JOIN TransactionHistory ta ON tha.TransactionID =
ta.TransactionID

-- page 296
SELECT * FROM Table WHERE City = 'Beijing'

-- page 297
DROP TABLE TransactionHistoryArchive

CREATE TABLE TransactionHistoryArchive (
TransactionID int NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH
(BUCKET_COUNT = 100000),
ProductID int NOT NULL,
ReferenceOrderID int NOT NULL,
ReferenceOrderLineID int NOT NULL,
TransactionDate datetime NOT NULL,
TransactionType nchar(1) NOT NULL,
Quantity int NOT NULL,
ActualCost money NOT NULL,
ModifiedDate datetime NOT NULL
) WITH (MEMORY_OPTIMIZED = ON)

SELECT * FROM sys.dm_db_xtp_hash_index_stats

-- page 298
DROP TABLE #temp
GO
SELECT * INTO #temp
FROM AdventureWorks2019.Production.TransactionHistoryArchive
GO
INSERT INTO TransactionHistoryArchive
SELECT * FROM #temp

-- page 299
DROP TABLE #temp
GO
SELECT TOP 65536 * INTO #temp
FROM AdventureWorks2019.Production.TransactionHistoryArchive
GO
INSERT INTO TransactionHistoryArchive
SELECT * FROM #temp

-- page 301
CREATE TABLE TransactionHistoryArchive (
TransactionID int NOT NULL PRIMARY KEY NONCLUSTERED HASH WITH
(BUCKET_COUNT = 100000),
ProductID int NOT NULL,
ReferenceOrderID int NOT NULL,
ReferenceOrderLineID int NOT NULL,
TransactionDate datetime NOT NULL,
TransactionType nchar(1) NOT NULL,
Quantity int NOT NULL,
ActualCost money NOT NULL,
ModifiedDate datetime NOT NULL,
INDEX IX_ProductID NONCLUSTERED (ProductID)
) WITH (MEMORY_OPTIMIZED = ON)

SELECT * FROM TransactionHistoryArchive
WHERE TransactionID = 8209

-- page 302
SELECT * FROM TransactionHistoryArchive
WHERE TransactionID > 8209

SELECT * FROM TransactionHistoryArchive
WHERE ProductID = 780

SELECT * FROM TransactionHistoryArchive
WHERE ProductID < 10

-- page 303
SELECT * FROM TransactionHistoryArchive
ORDER BY TransactionID

SELECT * FROM TransactionHistoryArchive
ORDER BY ProductID

-- page 304
CREATE TABLE TransactionHistoryArchive (
TransactionID int NOT NULL,
ProductID int NOT NULL,
ReferenceOrderID int NOT NULL,
ReferenceOrderLineID int NOT NULL,
TransactionDate datetime NOT NULL,
TransactionType nchar(1) NOT NULL,
Quantity int NOT NULL,
ActualCost money NOT NULL,
ModifiedDate datetime NOT NULL,
CONSTRAINT PK_TransactionID_ProductID PRIMARY KEY NONCLUSTERED
HASH (TransactionID, ProductID) WITH (BUCKET_COUNT = 100000)
) WITH (MEMORY_OPTIMIZED = ON)

SELECT * FROM TransactionHistoryArchive
WHERE TransactionID = 7173 AND ProductID = 398

SELECT * FROM TransactionHistoryArchive
WHERE TransactionID = 7173

-- page 304
CREATE PROCEDURE test
WITH NATIVE_COMPILATION, SCHEMABINDING, EXECUTE AS OWNER
AS
BEGIN ATOMIC WITH (TRANSACTION ISOLATION LEVEL = SNAPSHOT,
LANGUAGE = 'us_english')
SELECT TransactionID, ProductID, ReferenceOrderID
FROM dbo.TransactionHistoryArchive
WHERE ProductID = 780
END

EXEC test

-- page 309
SELECT name, description FROM sys.dm_os_loaded_modules
where description = 'XTP Native DLL'

-- page 310
DROP PROCEDURE test
DROP TABLE TransactionHistoryArchive

