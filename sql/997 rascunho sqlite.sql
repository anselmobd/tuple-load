SELECT
  l.cor
, l.tamanho
, l.caixa_id
, l.*
FROM fo2_cd_lote l
WHERE l.op = 4889
ORDER by
  l.cor
, l.ordem_tamanho
, l.caixa_id
;

SELECT
  l.cor
, l.tamanho
, l.caixa_id
, l.*
FROM fo2_cd_lote l
WHERE l.op = 4889
ORDER by
  l.caixa_id
, l.cor
, l.ordem_tamanho
;

DELETE FROM fo2_cd_lote;
DELETE FROM fo2_cd_caixa;

SELECT
  le.op
, le.qtd_produzir
, le.lote
, substr(le.lote, 9, 1)encontrado
--, le.qtd_produzir*(1+substr(le.lote, 9, 1))
, sum(le.qtd_produzir*(1+substr(le.lote, 9, 1))) prog
--, sum(le.qtd_produzir*cast(LEFT(le.lote, 1) as integer)) prog
FROM fo2_cd_lote le
GROUP BY
  le.op
ORDER BY
  1
;

SELECT
  le.lote
, le.lote % 10
FROM fo2_cd_lote le
;

SELECT
  ROWID
, _ROWID_
, OID
, le.*
FROM fo2_cd_lote le
;

SELECT
  *
FROM fo2_cd_lote
WHERE op = 200
  AND tamanho = 'P'
;

DELETE
FROM fo2_cd_lote
WHERE op = 13
  AND tamanho = 'P'
;

SELECT
  count(*)
FROM fo2_cd_lote
;

SELECT
  *
FROM fo2_cd_lote
--where lote = '181400860'
;

SELECT
  *
FROM fo2_cd_lote
where "local" is not NULL and "local" <> ''
;

SELECT DISTINCT
  op
FROM fo2_cd_lote
where op < 1000
ORDER BY
  op DESC
;

CREATE TABLE "fo2_cd_lote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "lote" varchar(20) NOT NULL, "op" integer NULL, "referencia" varchar(5) NOT NULL, "tamanho" varchar(3) NOT NULL, "cor" varchar(6) NOT NULL, "qtd_produzir" integer NOT NULL, "create_at" datetime NULL, "update_at" datetime NULL);

ALTER TABLE "fo2_cd_lote" RENAME TO "fo2_cd_lote__old";
CREATE TABLE "fo2_cd_lote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "ordem_tamanho" smallint NOT NULL, "lote" varchar(20) NOT NULL, "op" integer NULL, "referencia" varchar(5) NOT NULL, "tamanho" varchar(3) NOT NULL, "cor" varchar(6) NOT NULL, "qtd_produzir" integer NOT NULL, "create_at" datetime NULL, "update_at" datetime NULL);
INSERT INTO "fo2_cd_lote" ("update_at", "referencia", "create_at", "id", "op", "cor", "qtd_produzir", "lote", "ordem_tamanho", "tamanho") SELECT "update_at", "referencia", "create_at", "id", "op", "cor", "qtd_produzir", "lote", 0, "tamanho" FROM "fo2_cd_lote__old";
DROP TABLE "fo2_cd_lote__old";

ALTER TABLE "fo2_cd_lote" RENAME TO "fo2_cd_lote__old";
CREATE TABLE "fo2_cd_lote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "caixa_id" integer NULL REFERENCES "fo2_cd_caixa" ("id"), "lote" varchar(20) NOT NULL, "op" integer NULL, "referencia" varchar(5) NOT NULL, "tamanho" varchar(3) NOT NULL, "cor" varchar(6) NOT NULL, "qtd_produzir" integer NOT NULL, "create_at" datetime NULL, "update_at" datetime NULL, "ordem_tamanho" smallint NOT NULL);
INSERT INTO "fo2_cd_lote" ("update_at", "cor", "qtd_produzir", "op", "caixa_id", "id", "tamanho", "lote", "create_at", "ordem_tamanho", "referencia") SELECT "update_at", "cor", "qtd_produzir", "op", NULL, "id", "tamanho", "lote", "create_at", "ordem_tamanho", "referencia" FROM "fo2_cd_lote__old";
DROP TABLE "fo2_cd_lote__old";
CREATE INDEX "fo2_cd_lote_caixa_id_98fd45ee" ON "fo2_cd_lote" ("caixa_id");

ALTER TABLE "fo2_cd_lote" RENAME TO "fo2_cd_lote__old";
CREATE TABLE "fo2_cd_lote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "ordem_tamanho" integer NOT NULL, "lote" varchar(20) NOT NULL, "op" integer NULL, "referencia" varchar(5) NOT NULL, "tamanho" varchar(3) NOT NULL, "cor" varchar(6) NOT NULL, "qtd_produzir" integer NOT NULL, "create_at" datetime NULL, "update_at" datetime NULL, "caixa_id" integer NULL REFERENCES "fo2_cd_caixa" ("id"));
INSERT INTO "fo2_cd_lote" ("id", "create_at", "referencia", "op", "update_at", "ordem_tamanho", "caixa_id", "lote", "qtd_produzir", "tamanho", "cor") SELECT "id", "create_at", "referencia", "op", "update_at", "ordem_tamanho", "caixa_id", "lote", "qtd_produzir", "tamanho", "cor" FROM "fo2_cd_lote__old";
DROP TABLE "fo2_cd_lote__old";
CREATE INDEX "fo2_cd_lote_caixa_id_98fd45ee" ON "fo2_cd_lote" ("caixa_id");

ALTER TABLE "fo2_cd_lote" RENAME TO "fo2_cd_lote__old";
CREATE TABLE "fo2_cd_lote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "local" varchar(3) NOT NULL, "lote" varchar(20) NOT NULL, "op" integer NULL, "referencia" varchar(5) NOT NULL, "tamanho" varchar(3) NOT NULL, "cor" varchar(6) NOT NULL, "qtd_produzir" integer NOT NULL, "create_at" datetime NULL, "update_at" datetime NULL, "ordem_tamanho" integer NOT NULL, "caixa_id" integer NULL REFERENCES "fo2_cd_caixa" ("id"));
INSERT INTO "fo2_cd_lote" ("lote", "id", "ordem_tamanho", "cor", "qtd_produzir", "op", "create_at", "referencia", "local", "tamanho", "caixa_id", "update_at") SELECT "lote", "id", "ordem_tamanho", "cor", "qtd_produzir", "op", "create_at", "referencia", '', "tamanho", "caixa_id", "update_at" FROM "fo2_cd_lote__old";
DROP TABLE "fo2_cd_lote__old";
CREATE INDEX "fo2_cd_lote_caixa_id_98fd45ee" ON "fo2_cd_lote" ("caixa_id");

ALTER TABLE "fo2_cd_lote" RENAME TO "fo2_cd_lote__old";
CREATE TABLE "fo2_cd_lote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "local" varchar(3) NOT NULL, "lote" varchar(20) NOT NULL, "op" integer NULL, "referencia" varchar(5) NOT NULL, "tamanho" varchar(3) NOT NULL, "cor" varchar(6) NOT NULL, "qtd_produzir" integer NOT NULL, "create_at" datetime NULL, "update_at" datetime NULL, "ordem_tamanho" integer NOT NULL, "caixa_id" integer NULL REFERENCES "fo2_cd_caixa" ("id"));
INSERT INTO "fo2_cd_lote" ("referencia", "lote", "qtd_produzir", "local", "ordem_tamanho", "id", "cor", "tamanho", "op", "caixa_id", "update_at", "create_at") SELECT "referencia", "lote", "qtd_produzir", "local", "ordem_tamanho", "id", "cor", "tamanho", "op", "caixa_id", "update_at", "create_at" FROM "fo2_cd_lote__old";
DROP TABLE "fo2_cd_lote__old";
CREATE INDEX "fo2_cd_lote_caixa_id_98fd45ee" ON "fo2_cd_lote" ("caixa_id");

ALTER TABLE "fo2_cd_lote" RENAME TO "fo2_cd_lote__old";
CREATE TABLE "fo2_cd_lote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "local_at" datetime NULL, "lote" varchar(20) NOT NULL, "op" integer NULL, "referencia" varchar(5) NOT NULL, "tamanho" varchar(3) NOT NULL, "cor" varchar(6) NOT NULL, "qtd_produzir" integer NOT NULL, "create_at" datetime NULL, "update_at" datetime NULL, "ordem_tamanho" integer NOT NULL, "caixa_id" integer NULL REFERENCES "fo2_cd_caixa" ("id"), "local" varchar(3) NOT NULL);
INSERT INTO "fo2_cd_lote" ("lote", "caixa_id", "id", "local", "tamanho", "op", "local_at", "referencia", "qtd_produzir", "ordem_tamanho", "update_at", "cor", "create_at") SELECT "lote", "caixa_id", "id", "local", "tamanho", "op", NULL, "referencia", "qtd_produzir", "ordem_tamanho", "update_at", "cor", "create_at" FROM "fo2_cd_lote__old";
DROP TABLE "fo2_cd_lote__old";
CREATE INDEX "fo2_cd_lote_caixa_id_98fd45ee" ON "fo2_cd_lote" ("caixa_id");

ALTER TABLE "fo2_cd_lote" RENAME TO "fo2_cd_lote__old";
CREATE TABLE "fo2_cd_lote" (
  "id" integer NOT NULL PRIMARY KEY AUTOINCREMENT
, "local_usuario_id" integer NULL REFERENCES "auth_user" ("id")
, "lote" varchar(20) NOT NULL
, "op" integer NULL
, "referencia" varchar(5) NOT NULL
, "tamanho" varchar(3) NOT NULL
, "cor" varchar(6) NOT NULL
, "qtd_produzir" integer NOT NULL
, "create_at" datetime NULL
, "update_at" datetime NULL
, "ordem_tamanho" integer NOT NULL
, "caixa_id" integer NULL REFERENCES "fo2_cd_caixa" ("id")
, "local" varchar(3) NOT NULL
, "local_at" datetime NULL);
INSERT INTO "fo2_cd_lote" ("referencia", "create_at", "local_at", "update_at", "id", "op", "local", "tamanho", "lote", "local_usuario_id", "qtd_produzir", "ordem_tamanho", "caixa_id", "cor") SELECT "referencia", "create_at", "local_at", "update_at", "id", "op", "local", "tamanho", "lote", NULL, "qtd_produzir", "ordem_tamanho", "caixa_id", "cor" FROM "fo2_cd_lote__old";
DROP TABLE "fo2_cd_lote__old";
CREATE INDEX "fo2_cd_lote_local_usuario_id_a9d1bab2" ON "fo2_cd_lote" ("local_usuario_id");
CREATE INDEX "fo2_cd_lote_caixa_id_98fd45ee" ON "fo2_cd_lote" ("caixa_id");

UPDATE fo2_cd_lote
set trail = 0
where trail <> 0
;

SELECT
  *
FROM fo2_cd_lote
where 1=1
  AND lote = '172903269'
--  AND op = 181
--  AND lote LIKE '%00009'
;

select DISTINCT
  le.op
FROM fo2_cd_lote le
where le.local is not null
  and le.local <> ''
;

select
  s.*
from fo2_cd_solicita_lote s
;

select
  s.*
from fo2_cd_solicita_lote_qtd s
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
                from fo2_cd_solicita_lote_qtd s
                join fo2_cd_lote l
                  on l.id = s.lote_id
                where s.solicitacao_id = 2
                  and l.referencia = '0257L'
                order by
                  1


SELECT distinct
  l.ordem_tamanho
, l.tamanho
from fo2_cd_lote l
join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = 'M2513'
--  and sq.solicitacao_id = 1
order by
  1
;

SELECT distinct
  l.ordem_tamanho
, l.tamanho
from fo2_cd_lote l
where l.referencia = 'M2513'
order by
  1
;

SELECT distinct
  l.cor
from fo2_cd_lote l
join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = '02513' -- 'M2513'
  and sq.solicitacao_id = 1
order by
  1
;

SELECT distinct
  l.cor
from fo2_cd_lote l
where l.referencia = '02513' -- 'M2513'
order by
  1
;

SELECT distinct
  l.tamanho
, l.cor
, sum(sq.qtd) qtd
from fo2_cd_lote l
join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = '02513' -- 'M2513'
  and sq.solicitacao_id = 1
group by
  l.tamanho
, l.cor
order by
  l.tamanho
, l.cor
;

SELECT distinct
  l.tamanho
, l.cor
, sum(l.qtd) qtd
from fo2_cd_lote l
where l.referencia = '0257L' -- 'M2513'
group by
  l.tamanho
, l.cor
order by
  l.tamanho
, l.cor
;

SELECT distinct
  l.tamanho
, l.cor
, sum(l.qtd) - sum(coalesce(sq.qtd, 0)) qtd
from fo2_cd_lote l
left join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = '0257L'
group by
  l.tamanho
, l.cor
order by
  l.tamanho
, l.cor
;

SELECT distinct
  l.cor
from fo2_cd_lote l
left join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = '0257L'
group by
  l.cor
having
  sum(l.qtd) - sum(coalesce(sq.qtd, 0)) > 0
order by
  l.cor
;


SELECT distinct
  l.tamanho
from fo2_cd_lote l
left join fo2_cd_solicita_lote_qtd sq
  on sq.lote_id = l.id
where l.referencia = '0257L'
group by
  l.ordem_tamanho
, l.tamanho
having
  sum(l.qtd) - sum(coalesce(sq.qtd, 0)) > 0
order by
  l.ordem_tamanho
;

SELECT DISTINCT
  l.referencia
--, l.lote
from fo2_cd_lote l
WHERE l.qtd > 0
--WHERE l.referencia like '0619B'
;

SELECT
  l.*
from fo2_cd_lote l
WHERE l.op = 1742
  and l.lote like '%07390'
;

SELECT
  l.lote
, count(*)
from fo2_cd_lote l
GROUP BY
  l.lote
ORDER BY 2 DESC
;

DELETE from fo2_cd_lote
WHERE lote in ('180701672', '180703364', '180903804', '180904572', '180904591', '180904601')
;

select
  o.*
from fo2_prod_op o
order by
  o.op
;

SELECT
  l.*
from fo2_cd_lote l
where l.op = 6563
;


update fo2_cd_lote
set
  trail = 0
where qtd <> qtd_produzir
  and op > 6700
;

select
  date(l.local_at) data
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

SELECT
  l.tamanho
, l.cor
, sum(l.qtd) qtd
from fo2_cd_lote l
join fo2_prod_op o
  on o.op = l.op
where l.referencia = '00455'
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

SELECT
  s.*
, l.*
from fo2_cd_solicita_lote_qtd s
join fo2_cd_lote l
  on l.id = s.lote_id
where 1=1
--  and l.id = 3273
  and l.referencia = '00455'
;

SELECT
  l.*
from fo2_cd_lote l
where 1=1
--  and l.id = 3273
  and l.referencia = '00455'
  and l.local is not null
  and l.local <> ''
;


SELECT
  l.tamanho
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
where l.referencia = '00455'
  and l.local is not null
  and l.local <> ''
group by
  l.tamanho
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

SELECT
  l.tamanho
, l.ordem_tamanho
from fo2_cd_lote l
where l.referencia = '00455'
  and l.local is not null
  and l.local <> ''
group by
  l.tamanho
, l.ordem_tamanho
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
  l.ordem_tamanho
;

SELECT
  l.cor
from fo2_cd_lote l
where l.referencia = '00455'
  and l.local is not null
  and l.local <> ''
group by
  l.cor
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
  l.cor
;

-- sortimento disponibilidade
SELECT
  l.tamanho
, l.cor
, sum( l.qtd -
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
where l.referencia = '00455'
  and l.local is not null
  and l.local <> ''
group by
  l.tamanho
, l.cor
having
  sum( l.qtd -
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

-- tamanho disponibilidade
SELECT
  l.tamanho
from fo2_cd_lote l
where l.referencia = '00455'
  and l.local is not null
  and l.local <> ''
group by
  l.tamanho
, l.ordem_tamanho
having
  sum( l.qtd -
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
  l.ordem_tamanho
;

-- cor disponibilidade
SELECT
  l.cor
from fo2_cd_lote l
where l.referencia = '00455'
  and l.local is not null
  and l.local <> ''
group by
  l.cor
having
  sum( l.qtd -
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
  l.cor
;

-- sortimento solicitação + pedido
SELECT
  l.tamanho
, l.cor
, sum(
    l.qtd
  - case
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
join fo2_prod_op o
  on o.op = l.op
where l.referencia = '02513'
  and l.local is not null
  and l.local <> ''
  and ( o.pedido <> 0
      or coalesce(
        ( select
            sum(ss.qtd) qtd
          from fo2_cd_solicita_lote_qtd ss
          where ss.lote_id = l.id
        ), 0) > 0
      )
group by
  l.tamanho
, l.cor
having
  sum(
    l.qtd
  - case
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

SELECT
  l.tamanho
, l.cor
, sum(
    l.qtd
  - case when o.pedido <> 0 then l.qtd
    else
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
    end
  ) qtd
from fo2_cd_lote l
join fo2_prod_op o
  on o.op = l.op
where l.referencia = '0257L'
  and l.local is not null
  and l.local <> ''
group by
  l.tamanho
, l.cor
having
  sum(
    l.qtd
  - case when o.pedido <> 0 then l.qtd
    else
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
    end
  ) > 0
order by
  l.tamanho
, l.cor
;


SELECT
  l.referencia
, o.pedido
, l.*
, o.*
from fo2_cd_lote l
join fo2_prod_op o
  on o.op = l.op
where 1=1
--  and l.id = 3273
  and l.estagio != 999
--  and l.referencia = 'A6027'
  and l.referencia like '%6027%'
  and l.cor = '0000PR'
--  and l.tamanho = 'G'
--  and l.local is not null
--  and l.local <> ''
--  and o.pedido <> 0
order by
  l.referencia
, o.pedido
;
