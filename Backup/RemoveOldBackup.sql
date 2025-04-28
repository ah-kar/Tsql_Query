-- Step 1: Enable xp_cmdshell
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;
RECONFIGURE;

-- Step 2: Call the PowerShell script
DECLARE @psCommand NVARCHAR(4000);

-- Change this path to your PowerShell script location
SET @psCommand = 'powershell.exe -ExecutionPolicy Bypass -File "E:\Script\RemoveOldBackup.ps1"';

EXEC xp_cmdshell @psCommand;

-- Step 3: Disable xp_cmdshell again
EXEC sp_configure 'xp_cmdshell', 0;
RECONFIGURE;
EXEC sp_configure 'show advanced options', 0;
RECONFIGURE;
