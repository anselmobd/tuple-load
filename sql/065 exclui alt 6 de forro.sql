--------------------- Pesquisando

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
