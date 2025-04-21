USE [CMS_KBANK];
GO

-- Step 1: Declare variables
DECLARE @DBCODE NVARCHAR(50) = DB_NAME();
DECLARE @LOG_FILE NVARCHAR(255);
DECLARE @LOG_SIZE DECIMAL(18,2);
DECLARE @CLEAN_SIZE DECIMAL(18,2);
DECLARE @LOG_ID NVARCHAR(50) = NEWID();
DECLARE @RECOVERY_MODEL NVARCHAR(20);

-- Step 2: Get the current recovery model
SELECT @RECOVERY_MODEL = recovery_model_desc
FROM sys.databases
WHERE name = 'CMS_KBANK';  -- Fixed: Use literal database name

-- Step 3: Get the log file name and size before shrinking
SELECT @LOG_FILE = name, 
       @LOG_SIZE = size * 8 / 1024.0  -- Convert pages to MB
FROM sys.master_files 
WHERE database_id = DB_ID('CMS_KBANK') AND type_desc = 'LOG';  -- Fixed: Use DB_ID('CMS_KBANK')

-- Step 4: Change database recovery model to SIMPLE if it's FULL
IF @RECOVERY_MODEL = 'FULL'
BEGIN
    ALTER DATABASE [CMS_KBANK] SET RECOVERY SIMPLE;  -- Fixed: Hardcoded DB name
END

-- Step 5: Shrink the transaction log
DBCC SHRINKFILE (@LOG_FILE, 1);

-- Step 6: Get the log file size after shrinking
SELECT @CLEAN_SIZE = size * 8 / 1024.0  
FROM sys.master_files 
WHERE database_id = DB_ID('CMS_KBANK') AND type_desc = 'LOG';  -- Fixed: Use DB_ID('CMS_KBANK')

-- Step 7: Restore the recovery model if it was FULL before
IF @RECOVERY_MODEL = 'FULL'
BEGIN
    ALTER DATABASE [CMS_KBANK] SET RECOVERY FULL;  -- Fixed: Hardcoded DB name
END

-- Step 8: Insert shrink log details into LOG_PURGE_CMS_KBANK table
INSERT INTO D_CLEANLOG(LOGCODE, FILEPATH, LOGSIZE, CLEANSIZE, LOGDT,CLEANDT, LOGREF)
VALUES (@DBCODE, @LOG_FILE, @LOG_SIZE, @CLEAN_SIZE,CAST(GETDATE() as date),GETDATE(), @LOG_ID); 

select * from D_CLEANLOG
truncate table D_CLEANLOG