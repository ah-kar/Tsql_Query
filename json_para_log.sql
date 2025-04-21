-- J_ADD_USR_LOG_EXEC
USE [CMS_KBANK]
GO

-- Insert each row from YourTable into YourJsonTable as a separate JSON object
DECLARE @ID INT;

DECLARE row_cursor CURSOR FOR
SELECT ID
FROM D_DPTACLIST WHERE ACSTS = 'P';

OPEN row_cursor;
FETCH NEXT FROM row_cursor INTO @ID;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Insert each row as a separate JSON object into YourJsonTable
    INSERT INTO SYSUSERLOG(LOG_BODY)
    SELECT 
        (SELECT *
         FROM D_DPTACLIST
         WHERE ID = @ID AND ACSTS = 'P'
         FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS JsonData;
    
    FETCH NEXT FROM row_cursor INTO @ID;
END

CLOSE row_cursor;
DEALLOCATE row_cursor;

-- update
begin tran;
update SYSUSERLOG
set LOGREF = REPLACE(LOWER(NEWID()),'-',''),
LOGDT = GETDATE(),
ACTION_USRID = 'system',
TARGET_USRID = 'D_DPTACLIST',
ACTION_TYPE = 'ADD_DPTACCOUNT',
LOGSTS = 'S'
WHERE ACTION_TYPE IS NULL;
commit tran;