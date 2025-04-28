USE [CMS_KBANK]

DECLARE @DBName NVARCHAR(128) = 'CMS_KBANK'
DECLARE @BackupPath NVARCHAR(500) = 'C:\SQLBackups\'
DECLARE @FileName NVARCHAR(500)

-- Generate filename with date (YYYYMMDD)
SET @FileName = @BackupPath + @DBName + '_FULL_' + 
    CONVERT(VARCHAR(8), GETDATE(), 112) + '.bak'

-- Run the backup
BACKUP DATABASE @DBName
TO DISK = @FileName
WITH FORMAT,
     INIT,
     NAME = 'Full Backup of ' + @DBName,
     SKIP,
     NOREWIND,
     NOUNLOAD,
     STATS = 10;
