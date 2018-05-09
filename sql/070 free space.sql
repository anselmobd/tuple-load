
select tablespace_name, Sum(bytes)/1024/1024
from dba_segments
group by tablespace_name
order by sum(bytes) ;


select table_name, blocks from dba_tables
where tablespace_name ='SYSTEXTIL_DADOS'
order by blocks desc;

select
  count(*) segments,
  round(sum(bytes)/1024/1024,2) size_mb
from user_segments
;

ALTER TABLE SYSTEXTIL.HIST_010 ENABLE ROW MOVEMENT;
ALTER TABLE SYSTEXTIL.HIST_010 SHRINK SPACE cascade;
ALTER TABLE SYSTEXTIL.HIST_010 SHRINK SPACE COMPACT;
ALTER TABLE SYSTEXTIL.HIST_010 SHRINK SPACE;
ALTER TABLE SYSTEXTIL.HIST_010 DEALLOCATE UNUSED;
ALTER TABLE SYSTEXTIL.HIST_010 DISABLE ROW MOVEMENT;
commit;

ALTER TABLE SYSTEXTIL.MQOP_050_LOG ENABLE ROW MOVEMENT;
ALTER TABLE SYSTEXTIL.MQOP_050_LOG SHRINK SPACE cascade;
ALTER TABLE SYSTEXTIL.MQOP_050_LOG SHRINK SPACE COMPACT;
ALTER TABLE SYSTEXTIL.MQOP_050_LOG SHRINK SPACE;
ALTER TABLE SYSTEXTIL.MQOP_050_LOG DEALLOCATE UNUSED;
ALTER TABLE SYSTEXTIL.MQOP_050_LOG DISABLE ROW MOVEMENT;
commit;

ALTER TABLE SYSTEXTIL.ESTQ_040_HIST ENABLE ROW MOVEMENT;
ALTER TABLE SYSTEXTIL.ESTQ_040_HIST SHRINK SPACE cascade;
ALTER TABLE SYSTEXTIL.ESTQ_040_HIST SHRINK SPACE COMPACT;
ALTER TABLE SYSTEXTIL.ESTQ_040_HIST SHRINK SPACE;
ALTER TABLE SYSTEXTIL.ESTQ_040_HIST DEALLOCATE UNUSED;
ALTER TABLE SYSTEXTIL.ESTQ_040_HIST DISABLE ROW MOVEMENT;
commit;

SELECT
--  count(*)
  *
FROM SYSTEXTIL.ESTQ_040_LOG
WHERE DATA_OPERACAO < TO_DATE('01/01/2018','DD/MM/YYYY')
ORDER BY
  DATA_OPERACAO
;

DELETE
FROM SYSTEXTIL.ESTQ_040_LOG
WHERE DATA_OPERACAO < TO_DATE('01/01/2018','DD/MM/YYYY')
;

ALTER TABLE SYSTEXTIL.ESTQ_040_LOG ENABLE ROW MOVEMENT;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG SHRINK SPACE cascade;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG SHRINK SPACE COMPACT;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG SHRINK SPACE;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG DEALLOCATE UNUSED;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG DISABLE ROW MOVEMENT;
commit;



---------------------------
---------------------------

SELECT SEGMENT_NAME
FROM DBA_LOBS
WHERE TABLE_NAME like '%ESTQ_040%'
;

SELECT SEGMENT_NAME
FROM DBA_LOBS
WHERE OWNER = 'SCOTT'
  AND TABLE_NAME = 'EMPLOYEES'
  AND COLUMN_NAME = 'DATA';

SELECT SUM(BYTES)/1024/1024 "STORAGE_MB"
FROM DBA_EXTENTS
WHERE SEGMENT_NAME = 'LOBD_EMPLOYEES_DATA';

PURGE RECYCLEBIN;
PURGE DBA_RECYCLEBIN;



break on report
compute sum of data_mb on report
compute sum of indx_mb on report
compute sum of lob_mb on report
compute sum of total_mb on report

select table_name,
decode(partitioned,'/','NO',partitioned) partitioned,
num_rows,
data_mb,
indx_mb,
lob_mb,
total_mb
 from (select data.table_name,
         partitioning_type
           || decode (subpartitioning_type,
                      'none', null,
                      '/' || subpartitioning_type)
                  partitioned,
           num_rows,
           nvl(data_mb,0) data_mb,
           nvl(indx_mb,0) indx_mb,
           nvl(lob_mb,0) lob_mb,
           nvl(data_mb,0) + nvl(indx_mb,0) + nvl(lob_mb,0) total_mb
           from (  select table_name,
                 nvl(min(num_rows),0) num_rows,
                 round(sum(data_mb),2) data_mb
                    from (select table_name, num_rows, data_mb
                        from (select a.table_name,
                              a.num_rows,
                              b.bytes/1024/1024 as data_mb
                                from user_tables a, user_segments b
                                where a.table_name = b.segment_name))
               group by table_name) data,
               (  select a.table_name,
                      round(sum(b.bytes/1024/1024),2) as indx_mb
                   from user_indexes a, user_segments b
                     where a.index_name = b.segment_name
                  group by a.table_name) indx,
               (  select a.table_name,
                     round(sum(b.bytes/1024/1024),2) as lob_mb
                  from user_lobs a, user_segments b
                 where a.segment_name = b.segment_name
                  group by a.table_name) lob,
                 user_part_tables part
           where     data.table_name = indx.table_name(+)
                 and data.table_name = lob.table_name(+)
                 and data.table_name = part.table_name(+))
order by table_name;

SELECT
--  count(*)
  *
FROM HIST_010
ORDER BY
  DATA_OCORR DESC
;

SELECT
  e.*
FROM ESTQ_040_LOG e
WHERE 1=1
--  AND e.USUARIO_REDE like 'ADRIANA%'
--  AND 102 IN (e.DEPOSITO_NEW, e.DEPOSITO_OLD)
--  AND e.DEPOSITO_NEW <> e.DEPOSITO_OLD
  AND e.QTDE_ESTOQUE_ATU_NEW <> e.QTDE_ESTOQUE_ATU_OLD
ORDER BY
--  e.DATA_OCORR DESC
  e.DATA_OPERACAO DESC
;

SELECT
--  x.*,x.ROWID
  count(*)
FROM SYSTEXTIL.MQOP_050_LOG x
WHERE x.data_operacao < TO_DATE('01/01/2018','DD/MM/YYYY')
--  AND x.USUARIO_REDE <> 'anselmo'
--  AND x.USUARIO_REDE <> 'systextil'
ORDER BY
  x.DATA_OPERACAO
;

DELETE FROM SYSTEXTIL.MQOP_050_LOG x
WHERE x.data_operacao < TO_DATE('01/01/2018','DD/MM/YYYY')
;

select table_name, blocks from dba_tables
where tablespace_name ='SYSTEXTIL_DADOS'
order by blocks desc
;

SELECT
  *
FROM PCPC_040 lotes
;

select
  count(*) segments,
  round(sum(bytes)/1024/1024,2) size_mb
from user_segments
;

select table_name,
decode(partitioned,'/','NO',partitioned) partitioned,
num_rows,
data_mb,
indx_mb,
lob_mb,
total_mb
 from (select data.table_name,
         partitioning_type
           || decode (subpartitioning_type,
                      'none', null,
                      '/' || subpartitioning_type)
                  partitioned,
           num_rows,
           nvl(data_mb,0) data_mb,
           nvl(indx_mb,0) indx_mb,
           nvl(lob_mb,0) lob_mb,
           nvl(data_mb,0) + nvl(indx_mb,0) + nvl(lob_mb,0) total_mb
           from (  select table_name,
                 nvl(min(num_rows),0) num_rows,
                 round(sum(data_mb),2) data_mb
                    from (select table_name, num_rows, data_mb
                        from (select a.table_name,
                              a.num_rows,
                              b.bytes/1024/1024 as data_mb
                                from user_tables a, user_segments b
                                where a.table_name = b.segment_name))
               group by table_name) data,
               (  select a.table_name,
                      round(sum(b.bytes/1024/1024),2) as indx_mb
                   from user_indexes a, user_segments b
                     where a.index_name = b.segment_name
                  group by a.table_name) indx,
               (  select a.table_name,
                     round(sum(b.bytes/1024/1024),2) as lob_mb
                  from user_lobs a, user_segments b
                 where a.segment_name = b.segment_name
                  group by a.table_name) lob,
                 user_part_tables part
           where     data.table_name = indx.table_name(+)
                 and data.table_name = lob.table_name(+)
                 and data.table_name = part.table_name(+))
order by table_name;


select a.table_name,
  round(sum(b.bytes/1024/1024),2) as indx_mb
from user_indexes a, user_segments b
where a.index_name = b.segment_name
  AND a.table_name = 'BASI_010'
group by a.table_name
;

select a.table_name,
  round(sum(b.bytes/1024/1024),2) as lob_mb
from user_lobs a, user_segments b
where a.segment_name = b.segment_name
  AND a.table_name = 'BASI_010'
group by a.table_name
;

select table_name,
  nvl(min(num_rows),0) num_rows,
  round(sum(data_mb),2) data_mb
from (
  SELECT
    table_name, num_rows, data_mb
  from (
    SELECT
      a.table_name,
      a.num_rows,
      b.bytes/1024/1024 as data_mb
    from user_tables a, user_segments b
    where a.table_name = b.segment_name
    AND a.table_name = 'BASI_010'
  )
)
group by table_name
;

SELECT
  round(sum(data_mb),2) data_mb
from (
  SELECT
    table_name, num_rows, data_mb
  from (
    SELECT
      a.table_name,
      a.num_rows,
      b.bytes/1024/1024 as data_mb
    from user_tables a, user_segments b
    where a.table_name = b.segment_name
  )
)
;

SELECT
  count(*)
--  *
--DELETE
FROM SYSTEXTIL.ESTQ_040_HIST
--WHERE DATA_OCORR < TO_DATE('01/01/2018','DD/MM/YYYY')
--ORDER BY
--  DATA_OCORR
;

select *
FROM DBA_LOBS
WHERE TABLE_NAME LIKE '%BASI%'
;

select tablespace_name, Sum(bytes)/1024/1024
from dba_segments
group by tablespace_name
order by sum(bytes) ;

select table_name, blocks from dba_tables
where tablespace_name ='SYSTEXTIL_DADOS'
order by blocks desc;

select
  count(*) segments,
  round(sum(bytes)/1024/1024,2) size_mb
from user_segments
;

SELECT
--  count(*)
  *
FROM SYSTEXTIL.ESTQ_040_LOG
WHERE DATA_OPERACAO < TO_DATE('01/01/2018','DD/MM/YYYY')
ORDER BY
  DATA_OPERACAO
;

DELETE
FROM SYSTEXTIL.ESTQ_040_LOG
WHERE DATA_OPERACAO < TO_DATE('01/01/2018','DD/MM/YYYY')
;

ALTER TABLE SYSTEXTIL.ESTQ_040_LOG ENABLE ROW MOVEMENT;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG SHRINK SPACE cascade;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG SHRINK SPACE COMPACT;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG SHRINK SPACE;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG DEALLOCATE UNUSED;
ALTER TABLE SYSTEXTIL.ESTQ_040_LOG DISABLE ROW MOVEMENT;
commit;
