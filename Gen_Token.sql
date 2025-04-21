-- J_ADD_SYS_TOKEN_EXEC

USE [CMS_KBANK]
GO
DECLARE @count INT = 1;
DECLARE @Length INT = 255;
DECLARE @Chars NVARCHAR(62) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

BEGIN
    DECLARE @RandomString NVARCHAR(MAX) = N'';
    DECLARE @RandomChar NVARCHAR(1);
    DECLARE @Counter INT = 0;

    -- Generate a random 255-character string
    WHILE @Counter < @Length
    BEGIN
        SET @RandomChar = SUBSTRING(@Chars, ABS(CHECKSUM(NEWID())) % LEN(@Chars) + 1, 1);
        SET @RandomString = @RandomString + @RandomChar;
        SET @Counter = @Counter + 1;
    END;

    -- Output or use the generated string
    --PRINT @RandomString;
END

SELECT @RandomString