-- J_MOV_USR_SYS_LOG_HIS_EXEC

USE [CMS_KBANK]
GO

-- Move Historical Data
BEGIN TRANSACTION;

-- Insert the data into SYSUSERLOG from SYSUSERLOGHIS based on the conditions
;WITH CTE_Transaction AS (
    SELECT 
	[LOGREF],
	[LOGDT],
	[ACTION_USRID],
	[TARGET_USRID],
	[ACTION_TYPE],
	[LOG_BODY],
	[LOGSTS]
    FROM SYSUSERLOG
    WHERE [LOGDT] < CAST(GETDATE() AS DATE)
)
-- Insert the selected records into R_LOGTRAN and also delete from D_LOGTRAN
DELETE CTE_Transaction
OUTPUT 
	DELETED.[LOGREF],
	DELETED.[LOGDT],
	DELETED.[ACTION_USRID],
	DELETED.[TARGET_USRID],
	DELETED.[ACTION_TYPE],
	DELETED.[LOG_BODY],
	DELETED.[LOGSTS]
INTO SYSUSERLOGHIS;

COMMIT TRANSACTION;

-- J_MOV_SMS_OUT_HIS_EXEC

USE [CMS_KBANK]
GO

-- Move Historical Data
BEGIN TRANSACTION;

-- Insert the data into R_OTPOUT from D_OTPOUT based on the conditions
;WITH CTE_Transaction AS (
    SELECT 
    [TXREFID],  
	[REFNUM],
	[TXDT],
	[SMSINFO],
	[SMSSTS],
	[SENTDT],
	[EXPIREDT]
    FROM D_SMSOUT
    WHERE [TXDT] < CAST(GETDATE() AS DATE)
)
-- Insert the selected records into R_LOGTRAN and also delete from D_LOGTRAN
DELETE CTE_Transaction
OUTPUT 
	deleted.[TXREFID],  
	deleted.[REFNUM],
	deleted.[TXDT],
	deleted.[SMSINFO],
	deleted.[SMSSTS],
	deleted.[SENTDT],
	deleted.[EXPIREDT]
INTO R_SMSOUT;

COMMIT TRANSACTION;

-- J_MOV_EMS_OUT_HIS_EXEC

USE [CMS_KBANK]
GO

-- Move Historical Data
BEGIN TRANSACTION;

-- Insert the data into R_OTPOUT from D_OTPOUT based on the conditions
;WITH CTE_Transaction AS (
    SELECT 
    [TXREFID],  
	[REFNUM],
	[TXDT],
	[MAILINFO],
	[MAILSTS],
	[SENTDT],
	[EXPIREDT]
    FROM D_EMAILOUT
    WHERE [TXDT] < CAST(GETDATE() AS DATE)
)
-- Insert the selected records into R_LOGTRAN and also delete from D_LOGTRAN
DELETE CTE_Transaction
OUTPUT 
	deleted.[TXREFID],  
	deleted.[REFNUM],
	deleted.[TXDT],
	deleted.[MAILINFO],
	deleted.[MAILSTS],
	deleted.[SENTDT],
	deleted.[EXPIREDT]
INTO R_EMAILOUT;

COMMIT TRANSACTION;

