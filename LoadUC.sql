USE [CMS_KBANK]
GO

DECLARE @SQL VARCHAR(MAX) = '';

-- Loop through all user tables
SELECT @SQL = @SQL + 
'ALTER TABLE ' + QUOTENAME(TABLE_NAME) + 
' ADD CONSTRAINT UC_' + TABLE_NAME + 
' UNIQUE (' + QUOTENAME(COLUMN_NAME) + ');' + CHAR(10)
FROM (
    SELECT 
        TABLE_NAME, 
        COLUMN_NAME, 
        ROW_NUMBER() OVER (PARTITION BY TABLE_NAME ORDER BY ORDINAL_POSITION) AS RowNum
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo' -- Adjust schema if needed
) AS FirstColumns
WHERE RowNum = 1; -- Select only the first column

-- Print or execute
PRINT @SQL
-- EXEC sp_executesql @SQL -- Uncomment to execute
