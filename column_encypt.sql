-- create master key
USE [DatabaseName];
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '[Pwd]';

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

-- create certificate

USE [DatabaseName];
GO
CREATE CERTIFICATE [CertificateName] WITH SUBJECT = 'Protect my data';
GO

SELECT name CertName, 
    certificate_id CertID, 
    pvt_key_encryption_type_desc EncryptType, 
    issuer_name Issuer
FROM sys.certificates;

-- create symmertic key

CREATE SYMMETRIC KEY [KeyName] WITH ALGORITHM = AES_256 ENCRYPTION BY CERTIFICATE [CertificateName];

SELECT name KeyName, 
    symmetric_key_id KeyID, 
    key_length KeyLength, 
    algorithm_desc KeyAlgorithm
FROM sys.symmetric_keys;

-- exec
-- open key
OPEN SYMMETRIC KEY [KeyName]
DECRYPTION BY CERTIFICATE [CertificateName];
UPDATE [Database].dbo.[Table]
SET [EncryptColumn] = EncryptByKey (Key_GUID('[KeyName]'), [Column])
FROM [Database].dbo.[Table];
GO
-- close key
CLOSE SYMMETRIC KEY [KeyName];
GO
