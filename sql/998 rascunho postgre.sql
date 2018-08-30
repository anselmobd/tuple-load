SELECT
  CAST( FLOOR(le.op/100) AS integer ) OP
, sum(le.qtd_produzir) prog
FROM fo2_cd_lote le
GROUP BY
  FLOOR(le.op/100)
ORDER BY
  1
;

SELECT
  le.op
, sum(le.qtd_produzir) prog
FROM fo2_cd_lote le
GROUP BY
  le.op
ORDER BY
  1
;

SELECT
  le.op
, sum( le.qtd_produzir
       * ( 1
         + CAST( substr(le.lote, 9, 1) as INTEGER )
         )
     ) prog
FROM fo2_cd_lote le
--WHERE le.OP < 20
GROUP BY
  le.op
ORDER BY
  1
;

SELECT DISTINCT
  *
FROM fo2_cd_lote
where op < 1000
ORDER BY
  op DESC
;

SELECT
  l.*
FROM fo2_cd_lote l
where
  ( l."local" <> ' '
  and l."local" <> ''
  and l."local" is not null
  )
  or l.local_at is not null
  or l.local_usuario_id is not null
;

update fo2_cd_lote
set
  "local" = ''
, local_at = null
, local_usuario_id = null
where
  ( "local" <> ' '
  and "local" <> ''
  and "local" is not null
  )
  or local_at is not null
  or local_usuario_id is not null
;

SELECT
  r.*
FROM fo2_ger_rolo_bipado r
order by
  r."date" desc
;


where r."date" > '20/04/2018 13:40:14'
order by
  r."date"
;

SELECT
  le.op
, sum( le.qtd_produzir
       * ( 1
         + CAST( substr(le.lote, 9, 1) as INTEGER )
         )
     ) prog
FROM fo2_cd_lote le
WHERE le.OP = 4535
GROUP BY
  le.op
ORDER BY
  1
;

SELECT
  le.*
FROM fo2_cd_lote le
--WHERE le.OP = 5829
order by
  le.op
, le.lote
;

--select
--  count(*) -- 1.537.238
--  min(length(r.log)) minlen
--, max(length(r.log)) maxlen
--, r.*
delete
FROM public.fo2_ger_record_tracking r
where r."table" = 'Lote'
  and r.iud = 'u'
  and r.log not like '%qtd_produzir%'
  and r.log not like '%caixa_id%'
  and r.log not like '%local%'
--order by
--  1 desc
;

select
--  count(*) -- 1.537.238
--  min(length(r.log)) minlen
--, max(length(r.log)) maxlen
--,
  r.*
FROM public.fo2_ger_record_tracking r
where r."table" = 'Lote'
  and r.iud = 'u'
  and (r.log like '%qtd_produzir%'
       or r.log like '%caixa_id%'
       or r.log like '%local%'
       )
--group by
--  r.*
order by
  1
;

select
  'feito'
, count(o.*)
from
(
  select distinct
    le.op
  FROM fo2_cd_lote le
  WHERE le.trail <> 0
  order by
    le.op
) as o
union
select
  'fazer'
, count(o.*)
from
(
  select distinct
    le.op
  FROM fo2_cd_lote le
  WHERE le.trail = 0
  order by
    le.op
) as o
;

select
  count(*)
from fo2_ger_record_tracking
;

select distinct
  le.*
FROM fo2_cd_lote le
where le.local is not null
  and le.local <> ''
  and le.qtd <> le.qtd_produzir
;

select
  le.op
FROM fo2_cd_lote le
where le.local is not null
  and le.local <> ''
;

SELECT
  fo2_cd_lote."local"
, fo2_cd_lote."op"
, fo2_cd_lote."referencia"
, fo2_cd_lote."cor"
, fo2_cd_lote."tamanho"
, SUM(fo2_cd_lote."qtd") AS "qtdsum"
, COUNT(fo2_cd_lote."lote") AS "qlotes"
FROM fo2_cd_lote
WHERE (   NOT (fo2_cd_lote."local" IS NULL)
      AND NOT (fo2_cd_lote."local" = '' AND fo2_cd_lote."local" IS NOT NULL)
      )
GROUP BY
  fo2_cd_lote."local"
, fo2_cd_lote."op"
, fo2_cd_lote."referencia"
, fo2_cd_lote."cor"
, fo2_cd_lote."tamanho"
, fo2_cd_lote."ordem_tamanho"
ORDER BY
  fo2_cd_lote."local" ASC
, fo2_cd_lote."op" ASC
, fo2_cd_lote."referencia" ASC
, fo2_cd_lote."cor" ASC
, fo2_cd_lote."ordem_tamanho" ASC
;

select
  s.*
from fo2_lot_impresso
;

select
  le.*
FROM fo2_cd_lote le
where le.lote = '174605884'
;

select distinct
  case
  when l.tamanho = 'P' then 110
  else 999
  end ordem_tamanho
, l.tamanho
from fo2_cd_solicita_lote_qtd s
join fo2_cd_lote l
  on l.id = s.lote_id
where l.referencia = '02156'
order by
  1
;


                select distinct
                  case
                    when l.tamanho = '35A' then 311
  when l.tamanho = '39A' then 322
  when l.tamanho = '2' then 902
  when l.tamanho = 'PP' then 110
  when l.tamanho = 'P' then 120
  when l.tamanho = 'M' then 130
  when l.tamanho = 'G' then 140
  when l.tamanho = 'GG' then 150
  when l.tamanho = 'EG' then 160
  when l.tamanho = '35-' then 310
  when l.tamanho = '39-' then 320
  when l.tamanho = '1' then 901
  when l.tamanho = '3' then 903
  when l.tamanho = '4' then 904
  when l.tamanho = '5' then 905
  when l.tamanho = '6' then 906
  when l.tamanho = '7' then 907
  when l.tamanho = '8' then 908
  when l.tamanho = '9' then 909
  when l.tamanho = '10' then 910
  when l.tamanho = '11' then 911
  when l.tamanho = '12' then 912
  when l.tamanho = '13' then 913
  when l.tamanho = '14' then 914
  when l.tamanho = '15' then 915
  when l.tamanho = '16' then 916
  when l.tamanho = '17' then 917
  when l.tamanho = '18' then 918
  when l.tamanho = '19' then 919
  when l.tamanho = '20' then 920
  when l.tamanho = '21' then 921
  when l.tamanho = '22' then 922
  when l.tamanho = '23' then 923
  when l.tamanho = '24' then 924
  when l.tamanho = '25' then 925
  when l.tamanho = '26' then 926
  when l.tamanho = '27' then 927
  when l.tamanho = '28' then 928
  when l.tamanho = '29' then 929
  when l.tamanho = '30' then 930
  when l.tamanho = '31' then 931
  when l.tamanho = '32' then 932
  when l.tamanho = '33' then 933
  when l.tamanho = '34' then 934
  when l.tamanho = '35' then 935
  when l.tamanho = '36' then 936
  when l.tamanho = '37' then 937
  when l.tamanho = '38' then 938
  when l.tamanho = '39' then 939
  when l.tamanho = '40' then 940
  when l.tamanho = '41' then 941
  when l.tamanho = '42' then 942
  when l.tamanho = '43' then 943
  when l.tamanho = '44' then 944
  when l.tamanho = '45' then 945
  when l.tamanho = '46' then 946
  when l.tamanho = '47' then 947
  when l.tamanho = '48' then 948
  when l.tamanho = '49' then 949
  when l.tamanho = '50' then 950
  when l.tamanho = 'UNI' then 999
                  else 9999
                  end ordem_tamanho
                , l.tamanho
                , s.codigo
                from fo2_cd_solicita_lote_qtd sq
                join fo2_cd_lote l
                  on l.id = sq.lote_id
                join fo2_cd_solicita_lote s
                  on s.id = sq.solicitacao_id
                where l.referencia = '02156'
                order by
                  1
;

select distinct
  l.cor
from fo2_cd_solicita_lote_qtd sq
join fo2_cd_lote l
  on l.id = sq.lote_id
join fo2_cd_solicita_lote s
  on s.id = sq.solicitacao_id
where sq.solicitacao_id = 6
  and l.referencia = '02156'
order by
  1
;

select distinct
  l.tamanho
, l.cor
, sum(sq.qtd) qtd
from fo2_cd_solicita_lote_qtd sq
join fo2_cd_lote l
  on l.id = sq.lote_id
where sq.solicitacao_id = 6
  and l.referencia = '02156'
group by
  l.tamanho
, l.cor
order by
  l.tamanho
, l.cor
;


SELECT
  r.referencia
, regexp_replace(regexp_replace(r.referencia, '[^0-9]+', '', 'g'), '^0*', '', 'g') rr
FROM fo2_cd_lote r
where r.referencia like '%640%'
;

select distinct
  r.referencia
FROM fo2_cd_lote r
where 1=1
--  and r.referencia like '%640%'
  and regexp_replace(regexp_replace(r.referencia, '[^0-9]+', ''), '^0*', '') = '640'
;

select
    "fo2_cd_lote"."id", "fo2_cd_lote"."lote", "fo2_cd_lote"."op", "fo2_cd_lote"."referencia", "fo2_cd_lote"."tamanho", "fo2_cd_lote"."ordem_tamanho"
  , "fo2_cd_lote"."cor", "fo2_cd_lote"."qtd_produzir", "fo2_cd_lote"."estagio", "fo2_cd_lote"."qtd", "fo2_cd_lote"."create_at", "fo2_cd_lote"."update_at"
  , "fo2_cd_lote"."local", "fo2_cd_lote"."local_at", "fo2_cd_lote"."local_usuario_id", "fo2_cd_lote"."caixa_id", "fo2_cd_lote"."trail"
  FROM "fo2_cd_lote"
  WHERE regexp_replace(regexp_replace("fo2_cd_lote"."referencia", '[^0-9]+', ''), '^0*', '') = '2513'
;


SELECT distinct
  l.ordem_tamanho
, l.tamanho
from fo2_cd_lote l
join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = '0156L'
--  and sq.solicitacao_id = 1
  and case when l.qtd < sq.qtd
      then l.qtd
      else sq.qtd
      end > 0
order by
  1
;


SELECT distinct
  l.lote
, l.qtd ll
, sq.qtd sqq
, sum(case when l.qtd < coalesce(sq.qtd, 0)
      then l.qtd
      else coalesce(sq.qtd, 0)
      end) qtd
from fo2_cd_lote l
join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = '00002'
group by
  l.lote
, l.qtd
, sq.qtd
;

SELECT distinct
  l.lote
, l.qtd ll
, sq.qtd sqq
, sum(case when l.qtd < coalesce(sq.qtd, 0)
      then l.qtd
      else coalesce(sq.qtd, 0)
      end) qtd
from fo2_cd_lote l
join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = '00002'
group by
  l.lote
, l.qtd
, sq.qtd
;

SELECT
  l.lote
, count(*)
from fo2_cd_lote l
GROUP BY
  l.lote
ORDER BY 2 DESC
;

select
  o.op
, o.pedido
, o.varejo
, o.cancelada
from fo2_prod_op o
order by
  o.op
;


SELECT
  l.tamanho
, l.cor
, sum(
   case when o.pedido <> 0
   then l.qtd
   else
     case when l.qtd < coalesce(sq.qtd, 0)
     then l.qtd
     else coalesce(sq.qtd, 0)
     end
   end) qtd
from fo2_cd_lote l
join fo2_prod_op o
  on o.op = l.op
left join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where 1=1 -- l.referencia = ''
  and l.local is not null
  and l.local <> ''
  and ( o.pedido <> 0
      or sq.id is not null
      )
group by
  l.tamanho
, l.cor
order by
  l.tamanho
, l.cor
;

update fo2_cd_lote
set
  trail = 0
where qtd <> qtd_produzir
--  and op > 6700
  and "local" is not null
  and "local" <> ''
;

SELECT
  l.*
from fo2_cd_lote l
--where l.op = 6563
order by
  l.op desc
;

select
  count(*)
--  l.*
from fo2_cd_lote l
where l.qtd <> l.qtd_produzir
  and l.local is not null
  and l.local <> ''
--  and op > 6500
  and l.estagio = 66
;

select
  count(*)
from fo2_cd_lote l
where l.trail = 0
;

update fo2_cd_lote
set
  trail = 0
where qtd <> qtd_produzir
  and "local" is not null
  and "local" <> ''
  and estagio = 66
;

select
  l.local_at::timestamp::date
, count(*)
, coalesce(l."local", 'SAIU!') endereco
, u.username
from fo2_cd_lote l
join auth_user u
  on u.id = l.local_usuario_id
where l.op = 6509
group by
  l.local_at::timestamp::date
, l."local"
, u.username
order by
  1
, l."local"
, u.username
;

select
  date(l.local_at) dt
, count(*)
, coalesce(l."local", 'SAIU!') endereco
, u.username
from fo2_cd_lote l
left join auth_user u
  on u.id = l.local_usuario_id
where l.op =  1156
group by
  date(l.local_at)
, l."local"
, u.username
order by
  1
, l."local"
, u.username
;

select
  o.*
, l.*
from fo2_prod_op o
join fo2_cd_lote l
  on l.op = o.op
where o.pedido <> 0
  and l.local is not null
  and l.local <> ''
order by
  o.op desc
;

SELECT
  l.tamanho
, l.cor
, sum(l.qtd) qtd
from fo2_cd_lote l
join fo2_prod_op o
  on o.op = l.op
where l.referencia = '02513'
  and l.local is not null
  and l.local <> ''
  and o.pedido <> 0
group by
  l.tamanho
, l.cor
order by
  l.tamanho
, l.cor
;

select distinct
  l.tamanho
, l.ordem_tamanho
from fo2_cd_lote l
join fo2_prod_op o
  on o.op = l.op
where l.referencia = 'A6027'
  and l.local is not null
  and l.local <> ''
  and o.pedido <> 0
order by
  l.ordem_tamanho
;

select distinct
  l.cor
from fo2_cd_lote l
join fo2_prod_op o
  on o.op = l.op
where l.referencia = 'A6027'
  and l.local is not null
  and l.local <> ''
  and o.pedido <> 0
order by
  l.cor
;

SELECT
  l.tamanho
, l.cor
, o.pedido
, sum(l.qtd) qtd
from fo2_cd_lote l
join fo2_prod_op o
  on o.op = l.op
where l.referencia = '02513'
--  and l.local is not null
--  and l.local <> ''
  and o.pedido <> 0
group by
  l.tamanho
, l.cor
, o.pedido
order by
  o.pedido
, l.cor
, l.tamanho
;

SELECT
  l.referencia
, regex_replace(l.referencia, '%ALPHA%', '')
from fo2_cd_lote l
;

select
  l.id
, l.tamanho
, l.cor
, sum(
    case
    when l.qtd < coalesce(
      ( select
          sum(ss.qtd) qtd
        from fo2_cd_solicita_lote_qtd ss
        where ss.lote_id = l.id
      ), 0)
    then l.qtd
    else coalesce(
      ( select
          sum(ss.qtd) qtd
        from fo2_cd_solicita_lote_qtd ss
        where ss.lote_id = l.id
      ), 0)
    end
  ) qtd
from fo2_cd_lote l
where l.referencia = '0620U'
  and l.local is not null
  and l.local <> ''
group by
  l.id
, l.tamanho
, l.cor
having
  sum(
    case
    when l.qtd < coalesce(
      ( select
          sum(ss.qtd) qtd
        from fo2_cd_solicita_lote_qtd ss
        where ss.lote_id = l.id
      ), 0)
    then l.qtd
    else coalesce(
      ( select
          sum(ss.qtd) qtd
        from fo2_cd_solicita_lote_qtd ss
        where ss.lote_id = l.id
      ), 0)
    end
  ) > 0
order by
  l.tamanho
, l.cor
;


select
  ss.*
from fo2_cd_solicita_lote_qtd ss
where ss.lote_id = 40281
;

select
  s.*
from fo2_cd_solicita_lote s
where s.id = 42
;

select
  sq.*
from fo2_cd_solicita_lote_qtd sq
where sq.solicitacao_id = 42
;

SELECT
  l.*
from fo2_cd_lote l
where l.lote = '182800133'
;
