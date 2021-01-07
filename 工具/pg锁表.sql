select a.*,b.relname
from pg_locks a
join pg_class b on a.relation = b.oid
where lower(b.relname) = 'od_biz_unit_config';


SELECT pg_terminate_backend(17226886);
SELECT pg_terminate_backend(17073006);
SELECT pg_terminate_backend(9274146);
SELECT pg_terminate_backend(8837274);
SELECT pg_terminate_backend(9104968);
SELECT pg_terminate_backend(8622653);
SELECT pg_terminate_backend(8748397);
SELECT pg_terminate_backend(9320370);
SELECT pg_terminate_backend(17765953);