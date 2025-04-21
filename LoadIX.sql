select
CONCAT('create index NONCLUS_',B.name,' ON ',A.name,' (',B.name,')'),A.name,B.name
from sys.objects A,sys.columns B
where A.type = 'U'
and B.object_id = A.object_id
order by A.name,B.column_id