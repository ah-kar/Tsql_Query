USE [CMS_KBANK]
GO

DECLARE @SQL VARCHAR(MAX) = '';

-- Loop through all user tables and get the first column
SELECT @SQL = @SQL + 
'ALTER TABLE ' + QUOTENAME(TABLE_NAME) + 
' ALTER COLUMN ' + QUOTENAME(COLUMN_NAME) + ' ' + DATA_TYPE + 
    CASE 
        WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
        THEN '(' + CAST(CHARACTER_MAXIMUM_LENGTH AS NVARCHAR) + ')' 
        ELSE '' 
    END + 
    ' NOT NULL;' + CHAR(10)
FROM (
    SELECT 
        TABLE_NAME, 
        COLUMN_NAME, 
        DATA_TYPE, 
        CHARACTER_MAXIMUM_LENGTH,
        ROW_NUMBER() OVER (PARTITION BY TABLE_NAME ORDER BY ORDINAL_POSITION) AS RowNum
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = 'dbo' -- Change schema if needed
) AS FirstColumns
WHERE RowNum = 1; -- Select only the first column

-- Print the generated SQL for review
PRINT @SQL

-- Uncomment the next line to execute the generated SQL
-- EXEC sp_executesql @SQL
