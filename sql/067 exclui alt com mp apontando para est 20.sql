--------------------- Pesquisando

-- alternativas de referencias com algum componente no estágio 40
SELECT DISTINCT
  e.NIVEL_ITEM
, e.GRUPO_ITEM
, e.ALTERNATIVA_ITEM
FROM BASI_050 e -- componentes de alternativas de estrutura
WHERE e.NIVEL_ITEM = 1
--  AND e.GRUPO_ITEM LIKE 'F%'
--  AND e.ALTERNATIVA_ITEM = 6
  AND e.ESTAGIO = 40
;
-- apenas pesquisa

-- componentes de alternativas de referencias com algum componente no estágio 40
SELECT
  c.*
FROM
(
SELECT DISTINCT
  e.NIVEL_ITEM
, e.GRUPO_ITEM
, e.ALTERNATIVA_ITEM
FROM BASI_050 e -- componentes de alternativas de estrutura
WHERE e.NIVEL_ITEM = 1
--  AND e.GRUPO_ITEM = '110VO'
--  AND e.ALTERNATIVA_ITEM = 6
  AND e.ESTAGIO = 40
) alt
JOIN BASI_050 c -- componentes de alternativas de estrutura
  ON c.NIVEL_ITEM = alt.NIVEL_ITEM
 AND c.GRUPO_ITEM = alt.GRUPO_ITEM
 AND c.ALTERNATIVA_ITEM = alt.ALTERNATIVA_ITEM
--WHERE c.ESTAGIO <> 40
ORDER BY
  c.NIVEL_ITEM
, c.GRUPO_ITEM
, c.ALTERNATIVA_ITEM
;
-- apenas pesquisa

-- componentes de alternativas de referencias com algum componente no estágio 40
SELECT
  c.*
FROM
(
SELECT DISTINCT
  e.NIVEL_ITEM
, e.GRUPO_ITEM
, e.ALTERNATIVA_ITEM
FROM BASI_050 e -- componentes de alternativas de estrutura
WHERE e.NIVEL_ITEM = 1
--  AND e.GRUPO_ITEM = '110VO'
--  AND e.ALTERNATIVA_ITEM = 6
  AND e.ESTAGIO = 40
) alt
JOIN BASI_040 c -- combinações de cor e tamanho de componentes de alternativa de estrutura
  ON c.NIVEL_ITEM = alt.NIVEL_ITEM
 AND c.GRUPO_ITEM = alt.GRUPO_ITEM
 AND c.ALTERNATIVA_ITEM = alt.ALTERNATIVA_ITEM
--WHERE c.ESTAGIO <> 40
ORDER BY
  c.NIVEL_ITEM
, c.GRUPO_ITEM
, c.ALTERNATIVA_ITEM
;
-- apenas pesquisa

SELECT
  c.ROWID
, c.*
FROM BASI_040 c -- combinações de cor e tamanho de componentes de alternativa de estrutura
JOIN
(
SELECT DISTINCT
  e.NIVEL_ITEM
, e.GRUPO_ITEM
, e.ALTERNATIVA_ITEM
FROM BASI_050 e -- componentes de alternativas de estrutura
WHERE e.NIVEL_ITEM = 1
  AND e.GRUPO_ITEM = '110VO'
--  AND e.ALTERNATIVA_ITEM = 6
  AND e.ESTAGIO = 40
) alt
  ON c.NIVEL_ITEM = alt.NIVEL_ITEM
 AND c.GRUPO_ITEM = alt.GRUPO_ITEM
 AND c.ALTERNATIVA_ITEM = alt.ALTERNATIVA_ITEM
--WHERE c.ESTAGIO <> 40
ORDER BY
  c.NIVEL_ITEM
, c.GRUPO_ITEM
, c.ALTERNATIVA_ITEM
;
-- apenas pesquisa

-- apagando combinações de cor e tamanho de componentes de alternativas de referencias com algum componente no estágio 40
DELETE FROM BASI_040 cd
WHERE cd.ROWID IN (
  SELECT
    c.ROWID
  FROM BASI_040 c -- combinações de cor e tamanho de componentes de alternativa de estrutura
  JOIN
  (
    SELECT DISTINCT
      e.NIVEL_ITEM
    , e.GRUPO_ITEM
    , e.ALTERNATIVA_ITEM
    FROM BASI_050 e -- componentes de alternativas de estrutura
    WHERE e.NIVEL_ITEM = 1
      AND e.GRUPO_ITEM = '110VO'
    --  AND e.ALTERNATIVA_ITEM = 6
      AND e.ESTAGIO = 40
  ) alt
    ON c.NIVEL_ITEM = alt.NIVEL_ITEM
   AND c.GRUPO_ITEM = alt.GRUPO_ITEM
   AND c.ALTERNATIVA_ITEM = alt.ALTERNATIVA_ITEM
  --WHERE c.ESTAGIO <> 40
)
;
-- apagado 14

-- pesquisa
SELECT
--    c.ROWID
  c.*
FROM
(
  SELECT DISTINCT
    e.NIVEL_ITEM
  , e.GRUPO_ITEM
  , e.ALTERNATIVA_ITEM
  FROM BASI_050 e -- componentes de alternativas de estrutura
  WHERE e.NIVEL_ITEM = 1
--      AND e.GRUPO_ITEM = '110VO'
  --  AND e.ALTERNATIVA_ITEM = 6
    AND e.ESTAGIO = 40
) alt
JOIN BASI_050 c -- componentes de alternativa de estrutura
  ON c.NIVEL_ITEM = alt.NIVEL_ITEM
 AND c.GRUPO_ITEM = alt.GRUPO_ITEM
 AND c.ALTERNATIVA_ITEM = alt.ALTERNATIVA_ITEM
;

-- apagando componentes de alternativas de referencias com algum componente no estágio 40
DELETE FROM BASI_050 cd
WHERE cd.ROWID IN (
  SELECT
    c.ROWID
--    c.*
  FROM
  (
    SELECT DISTINCT
      e.NIVEL_ITEM
    , e.GRUPO_ITEM
    , e.ALTERNATIVA_ITEM
    FROM BASI_050 e -- componentes de alternativas de estrutura
    WHERE e.NIVEL_ITEM = 1
--      AND e.GRUPO_ITEM = '110VO'
    --  AND e.ALTERNATIVA_ITEM = 6
      AND e.ESTAGIO = 40
  ) alt
  JOIN BASI_050 c -- componentes de alternativa de estrutura
    ON c.NIVEL_ITEM = alt.NIVEL_ITEM
   AND c.GRUPO_ITEM = alt.GRUPO_ITEM
   AND c.ALTERNATIVA_ITEM = alt.ALTERNATIVA_ITEM
)
;

-- procurando alternativas sem componentes
SELECT
  a.NIVEL
, a.GRUPO
, a.ALTERNATIVA
, count(*)
FROM BASI_070 a -- alternativas de estrutura
JOIN BASI_050 c -- componentes de alternativa de estrutura
  ON c.NIVEL_ITEM = a.NIVEL
 AND c.GRUPO_ITEM = a.GRUPO
 AND c.ALTERNATIVA_ITEM = a.ALTERNATIVA
WHERE a.NIVEL = 1
GROUP BY
  a.NIVEL
, a.GRUPO
, a.ALTERNATIVA
HAVING
  count(*) = 0
;
-- não achou

-- procurando roteiros sem
--   alternativa
-- ou
--   componente de alternativa
SELECT
  r.NIVEL_ESTRUTURA
, r.GRUPO_ESTRUTURA
, r.NUMERO_ALTERNATI
, a.GRUPO tab_alt
, c.GRUPO_ITEM tab_compo
FROM MQOP_050 r -- operaçẽs das alternativas de roteiro
LEFT JOIN BASI_070 a -- alternativas de estrutura
  ON a.NIVEL = r.NIVEL_ESTRUTURA
 AND a.GRUPO = r.GRUPO_ESTRUTURA
 AND a.ALTERNATIVA = r.NUMERO_ALTERNATI
LEFT JOIN BASI_050 c -- componentes de alternativa de estrutura
  ON c.NIVEL_ITEM = r.NIVEL_ESTRUTURA
 AND c.GRUPO_ITEM = r.GRUPO_ESTRUTURA
 AND c.ALTERNATIVA_ITEM = r.NUMERO_ALTERNATI
WHERE r.NIVEL_ESTRUTURA = 1
  AND (
    a.ALTERNATIVA IS NULL
    OR c.ALTERNATIVA_ITEM IS NULL
  )
;
-- Achou demais - procurar só sem componente de alternativa

-- procurando roteiros sem componente de alternativa
SELECT DISTINCT
  r.NIVEL_ESTRUTURA
, r.GRUPO_ESTRUTURA
, r.NUMERO_ALTERNATI
FROM MQOP_050 r -- operaçẽs das alternativas de roteiro
LEFT JOIN BASI_050 c -- componentes de alternativa de estrutura
  ON c.NIVEL_ITEM = r.NIVEL_ESTRUTURA
 AND c.GRUPO_ITEM = r.GRUPO_ESTRUTURA
 AND c.ALTERNATIVA_ITEM = r.NUMERO_ALTERNATI
WHERE r.NIVEL_ESTRUTURA = 1
  AND c.ALTERNATIVA_ITEM IS NULL
ORDER BY
  r.NIVEL_ESTRUTURA
, r.GRUPO_ESTRUTURA
, r.NUMERO_ALTERNATI
;
-- ok

-- pegando ROWID - procurando roteiros sem componente de alternativa
SELECT
  ro.ROWID
, rr.NIVEL_ESTRUTURA
, rr.GRUPO_ESTRUTURA
, rr.NUMERO_ALTERNATI
, ro.SEQ_OPERACAO
FROM MQOP_050 ro -- operaçẽs das alternativas de roteiro
JOIN (
  SELECT DISTINCT
    r.NIVEL_ESTRUTURA
  , r.GRUPO_ESTRUTURA
  , r.NUMERO_ALTERNATI
  FROM MQOP_050 r -- operaçẽs das alternativas de roteiro
  LEFT JOIN BASI_050 c -- componentes de alternativa de estrutura
    ON c.NIVEL_ITEM = r.NIVEL_ESTRUTURA
   AND c.GRUPO_ITEM = r.GRUPO_ESTRUTURA
   AND c.ALTERNATIVA_ITEM = r.NUMERO_ALTERNATI
  WHERE r.NIVEL_ESTRUTURA = 1
    AND c.ALTERNATIVA_ITEM IS NULL
) rr
  ON rr.NIVEL_ESTRUTURA = ro.NIVEL_ESTRUTURA
 AND rr.GRUPO_ESTRUTURA = ro.GRUPO_ESTRUTURA
 AND rr.NUMERO_ALTERNATI = ro.NUMERO_ALTERNATI
ORDER BY
  rr.NIVEL_ESTRUTURA
, rr.GRUPO_ESTRUTURA
, rr.NUMERO_ALTERNATI
, ro.SEQ_OPERACAO
;
-- ok

-- apagando pelo ROWID roteiros sem componente de alternativa
DELETE FROM MQOP_050 rod
WHERE rod.ROWID IN (
  SELECT
    ro.ROWID
  FROM MQOP_050 ro -- operaçẽs das alternativas de roteiro
  JOIN (
    SELECT DISTINCT
      r.NIVEL_ESTRUTURA
    , r.GRUPO_ESTRUTURA
    , r.NUMERO_ALTERNATI
    FROM MQOP_050 r -- operaçẽs das alternativas de roteiro
    LEFT JOIN BASI_050 c -- componentes de alternativa de estrutura
      ON c.NIVEL_ITEM = r.NIVEL_ESTRUTURA
     AND c.GRUPO_ITEM = r.GRUPO_ESTRUTURA
     AND c.ALTERNATIVA_ITEM = r.NUMERO_ALTERNATI
    WHERE r.NIVEL_ESTRUTURA = 1
      AND c.ALTERNATIVA_ITEM IS NULL
  ) rr
    ON rr.NIVEL_ESTRUTURA = ro.NIVEL_ESTRUTURA
   AND rr.GRUPO_ESTRUTURA = ro.GRUPO_ESTRUTURA
   AND rr.NUMERO_ALTERNATI = ro.NUMERO_ALTERNATI
)
;
-- apagado

















SELECT
  r.*
FROM BASI_030 r -- referencia (produto)
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.REFERENCIA LIKE 'F%'
;
-- apenas pesquisa

SELECT
  a.*
FROM BASI_070 a -- alternativas de estrutura
WHERE a.NIVEL = 1
  AND a.GRUPO LIKE 'F%'
;
-- !! nada a apagar

SELECT
  e.*
FROM BASI_050 e -- componentes de alternativas de estrutura
WHERE e.NIVEL_ITEM = 1
  AND e.GRUPO_ITEM LIKE 'F%'
  AND e.ALTERNATIVA_ITEM = 6
;
-- apagar o selecionado depois da tabela slave
-- 2o. apagar

SELECT
  comb.*
FROM BASI_040 comb -- combinações de cor e tamanho de componentes de alternativa de estrutura
WHERE comb.NIVEL_ITEM = 1
  AND comb.GRUPO_ITEM LIKE 'F%'
  AND comb.ALTERNATIVA_ITEM = 6
;
-- apagar o selecionado
-- 1o. apagar

SELECT
  r.*
FROM MQOP_050 r -- operaçẽs das alternativas de roteiro
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.GRUPO_ESTRUTURA LIKE 'F%'
  AND (  r.NUMERO_ROTEIRO = 6
      OR r.NUMERO_ALTERNATI = 6 )
;
-- apagar o selecionado
-- 3o. apagar

--------------------- Apagando

DELETE FROM BASI_040 comb -- combinações de cor e tamanho de componentes de alternativa de estrutura
WHERE comb.NIVEL_ITEM = 1
  AND comb.GRUPO_ITEM LIKE 'F%'
  AND comb.ALTERNATIVA_ITEM = 6
;

DELETE
FROM BASI_050 e -- componentes de alternativas de estrutura
WHERE e.NIVEL_ITEM = 1
  AND e.GRUPO_ITEM LIKE 'F%'
  AND e.ALTERNATIVA_ITEM = 6
;

DELETE
FROM MQOP_050 r -- operaçẽs das alternativas de roteiro
WHERE r.NIVEL_ESTRUTURA = 1
  AND r.GRUPO_ESTRUTURA LIKE 'F%'
  AND (  r.NUMERO_ROTEIRO = 6
      OR r.NUMERO_ALTERNATI = 6 )
;
