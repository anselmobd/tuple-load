SELECT
  a.*
FROM BASI_070 a -- alternativas de estrutura
;

SELECT
  e.*
FROM BASI_050 e -- componentes de alternativas de estrutura
;

SELECT
  comb.*
FROM BASI_040 comb -- combinações de cor e tamanho de componentes de alternativa de estrutura
;

SELECT
  r.*
FROM BASI_030 r -- referencia (produto)
;

SELECT
  t.*
FROM BASI_020 t -- tamanho de referencio (subgrupo de grupo de produto)
;

SELECT
  c.*
FROM BASI_010 c -- cor de tamanho de referencio (item de subgrupo de grupo de produto)
;

SELECT
  r.*
FROM MQOP_050 r -- operaçẽs das alternativas de roteiro
;

  -- por produto/tamanho/cor, porém
  -- não comuns nos cadastros de PA, PG e MDs - início

  SELECT
    ptcp.*
  FROM BASI_015 ptcp -- parâmetros de produto/tamanho/cor (utilizado para nível 2 e 9)
  ;

  SELECT
    s.*
  FROM supr_060 s -- parâmetros por fornecedor de produto/tamanho/cor (utilizado todos os níveis)
  ;

  SELECT
    s.*
  FROM supr_067 s -- item de requisição de produto/tamanho/cor (só observado para nível 2 e 9)
  ;

  -- por produto/tamanho/cor, porém
  -- não comuns nos cadastros de PA, PG e MDs - fim

  -- Cadastros gerais - início

  SELECT
    e.*
  FROM MQOP_005 e -- tabela de estagios
  ;

  SELECT
    o.*
  FROM MQOP_040 o -- tabela de operações
  ;

  SELECT
    ce.*
  FROM BASI_150 ce -- conta de estoque
  ;

  SELECT
    lin.*
  FROM BASI_120 lin -- linha de produto
  ;

  SELECT
    col.*
  FROM BASI_140 col -- coleção de produto
  ;

  SELECT
    ac.*
  FROM BASI_290 ac -- artigo de cotas de produto
  ;

  SELECT
    cf.*
  FROM BASI_240 cf -- classificação fiscal
  ;

  -- Cadastros gerais - fim

SELECT
  r.COLECAO
, r.*
FROM BASI_030 r -- referencia (produto)
WHERE r.COLECAO = 3
;

-- alternativas de estrutura

SELECT
  a.NIVEL
, a.GRUPO
, a.ITEM
, a.SUBGRUPO
, a.ALTERNATIVA
, r.DESCR_REFERENCIA
, a.*
FROM BASI_070 a -- alternativas de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = a.NIVEL
 AND r.REFERENCIA = a.GRUPO
WHERE a.ALTERNATIVA = 2
  AND r.COLECAO <> 3
;

SELECT
  a.NIVEL || a.GRUPO || a.ITEM || a.SUBGRUPO || a.ALTERNATIVA
FROM BASI_070 a -- alternativas de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = a.NIVEL
 AND r.REFERENCIA = a.GRUPO
WHERE a.ALTERNATIVA = 2
  AND r.COLECAO <> 3
;

SELECT
  count( a.NIVEL || a.GRUPO || a.ITEM || a.SUBGRUPO || a.ALTERNATIVA )
FROM BASI_070 a -- alternativas de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = a.NIVEL
 AND r.REFERENCIA = a.GRUPO
WHERE a.ALTERNATIVA = 2
  AND r.COLECAO <> 3
;

DELETE FROM BASI_070 aa -- alternativas de estrutura
WHERE aa.NIVEL || aa.GRUPO || aa.ITEM || aa.SUBGRUPO || aa.ALTERNATIVA IN
(
SELECT
  a.NIVEL || a.GRUPO || a.ITEM || a.SUBGRUPO || a.ALTERNATIVA
FROM BASI_070 a -- alternativas de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = a.NIVEL
 AND r.REFERENCIA = a.GRUPO
WHERE a.ALTERNATIVA = 2
  AND r.COLECAO <> 3
);

-- -- -- -- --

SELECT
  comb.NIVEL_ITEM
, comb.GRUPO_ITEM
, comb.ITEM_ITEM
, comb.SUB_ITEM
, comb.ALTERNATIVA_ITEM
, comb.SEQUENCIA
, r.DESCR_REFERENCIA
, comb.*
FROM BASI_040 comb -- combinações de cor e tamanho de componentes de alternativa de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = comb.NIVEL_ITEM
 AND r.REFERENCIA = comb.GRUPO_ITEM
WHERE comb.ALTERNATIVA_ITEM = 2
  AND r.COLECAO <> 3
;

SELECT
  comb.NIVEL_ITEM || comb.GRUPO_ITEM || comb.ITEM_ITEM || comb.SUB_ITEM || comb.ALTERNATIVA_ITEM || comb.SEQUENCIA
FROM BASI_040 comb -- combinações de cor e tamanho de componentes de alternativa de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = comb.NIVEL_ITEM
 AND r.REFERENCIA = comb.GRUPO_ITEM
WHERE comb.ALTERNATIVA_ITEM = 2
  AND r.COLECAO <> 3
;

SELECT
  count( comb.NIVEL_ITEM || comb.GRUPO_ITEM || comb.ITEM_ITEM || comb.SUB_ITEM || comb.ALTERNATIVA_ITEM || comb.SEQUENCIA )
FROM BASI_040 comb -- combinações de cor e tamanho de componentes de alternativa de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = comb.NIVEL_ITEM
 AND r.REFERENCIA = comb.GRUPO_ITEM
WHERE comb.ALTERNATIVA_ITEM = 2
  AND r.COLECAO <> 3
;

DELETE FROM BASI_040 combd -- combinações de cor e tamanho de componentes de alternativa de estrutura
WHERE
  combd.NIVEL_ITEM || combd.GRUPO_ITEM || combd.ITEM_ITEM || combd.SUB_ITEM || combd.ALTERNATIVA_ITEM || combd.SEQUENCIA
IN
(
  SELECT
    comb.NIVEL_ITEM || comb.GRUPO_ITEM || comb.ITEM_ITEM || comb.SUB_ITEM || comb.ALTERNATIVA_ITEM || comb.SEQUENCIA
  FROM BASI_040 comb -- combinações de cor e tamanho de componentes de alternativa de estrutura
  JOIN BASI_030 r -- referencia (produto)
    ON r.NIVEL_ESTRUTURA = comb.NIVEL_ITEM
   AND r.REFERENCIA = comb.GRUPO_ITEM
  WHERE comb.ALTERNATIVA_ITEM = 2
    AND r.COLECAO <> 3
);

SELECT
  ce.NIVEL_ITEM
, ce.GRUPO_ITEM
, ce.ITEM_ITEM
, ce.SUB_ITEM
, ce.ALTERNATIVA_ITEM
, ce.SEQUENCIA
, r.DESCR_REFERENCIA
, ce.*
FROM BASI_050 ce -- componentes de alternativas de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = ce.NIVEL_ITEM
 AND r.REFERENCIA = ce.GRUPO_ITEM
WHERE ce.ALTERNATIVA_ITEM = 2
  AND r.COLECAO <> 3
ORDER BY
  ce.NIVEL_ITEM
, ce.GRUPO_ITEM
, ce.ITEM_ITEM
, ce.SUB_ITEM
, ce.ALTERNATIVA_ITEM
, ce.SEQUENCIA
;

SELECT
  ce.NIVEL_ITEM
|| ce.GRUPO_ITEM
|| ce.ITEM_ITEM
|| ce.SUB_ITEM
|| ce.ALTERNATIVA_ITEM
|| ce.SEQUENCIA
FROM BASI_050 ce -- componentes de alternativas de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = ce.NIVEL_ITEM
 AND r.REFERENCIA = ce.GRUPO_ITEM
WHERE ce.ALTERNATIVA_ITEM = 2
  AND r.COLECAO <> 3
;

SELECT
  count(
  ce.NIVEL_ITEM
|| ce.GRUPO_ITEM
|| ce.ITEM_ITEM
|| ce.SUB_ITEM
|| ce.ALTERNATIVA_ITEM
|| ce.SEQUENCIA
)
FROM BASI_050 ce -- componentes de alternativas de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = ce.NIVEL_ITEM
 AND r.REFERENCIA = ce.GRUPO_ITEM
WHERE ce.ALTERNATIVA_ITEM = 2
  AND r.COLECAO <> 3
;

DELETE FROM BASI_050 ced -- componentes de alternativas de estrutura
WHERE
   ced.NIVEL_ITEM
|| ced.GRUPO_ITEM
|| ced.ITEM_ITEM
|| ced.SUB_ITEM
|| ced.ALTERNATIVA_ITEM
|| ced.SEQUENCIA
IN
(
SELECT
   ce.NIVEL_ITEM
|| ce.GRUPO_ITEM
|| ce.ITEM_ITEM
|| ce.SUB_ITEM
|| ce.ALTERNATIVA_ITEM
|| ce.SEQUENCIA
FROM BASI_050 ce -- componentes de alternativas de estrutura
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = ce.NIVEL_ITEM
 AND r.REFERENCIA = ce.GRUPO_ITEM
WHERE ce.ALTERNATIVA_ITEM = 2
  AND r.COLECAO <> 3
);

SELECT
  rot.NIVEL_ESTRUTURA
, rot.GRUPO_ESTRUTURA
, rot.ITEM_ESTRUTURA
, rot.SUBGRU_ESTRUTURA
, rot.NUMERO_ALTERNATI
, rot.SEQ_OPERACAO
, r.DESCR_REFERENCIA
, rot.*
FROM MQOP_050 rot -- operaçẽs das alternativas de roteiro
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = rot.NIVEL_ESTRUTURA
 AND r.REFERENCIA = rot.GRUPO_ESTRUTURA
WHERE rot.NUMERO_ALTERNATI = 2
  AND r.COLECAO <> 3
ORDER BY
  rot.NIVEL_ESTRUTURA
, rot.GRUPO_ESTRUTURA
, rot.ITEM_ESTRUTURA
, rot.SUBGRU_ESTRUTURA
, rot.NUMERO_ALTERNATI
, rot.SEQ_OPERACAO
;

SELECT
   rot.NIVEL_ESTRUTURA
|| rot.GRUPO_ESTRUTURA
|| rot.ITEM_ESTRUTURA
|| rot.SUBGRU_ESTRUTURA
|| rot.NUMERO_ALTERNATI
|| rot.SEQ_OPERACAO
FROM MQOP_050 rot -- operaçẽs das alternativas de roteiro
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = rot.NIVEL_ESTRUTURA
 AND r.REFERENCIA = rot.GRUPO_ESTRUTURA
WHERE rot.NUMERO_ALTERNATI = 2
  AND r.COLECAO <> 3
;

SELECT
count(
rot.NIVEL_ESTRUTURA
|| rot.GRUPO_ESTRUTURA
|| rot.ITEM_ESTRUTURA
|| rot.SUBGRU_ESTRUTURA
|| rot.NUMERO_ALTERNATI
|| rot.SEQ_OPERACAO
)
FROM MQOP_050 rot -- operaçẽs das alternativas de roteiro
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = rot.NIVEL_ESTRUTURA
 AND r.REFERENCIA = rot.GRUPO_ESTRUTURA
WHERE rot.NUMERO_ALTERNATI = 2
  AND r.COLECAO <> 3
;

DELETE FROM MQOP_050 rotd -- operaçẽs das alternativas de roteiro
WHERE
   rotd.NIVEL_ESTRUTURA
|| rotd.GRUPO_ESTRUTURA
|| rotd.ITEM_ESTRUTURA
|| rotd.SUBGRU_ESTRUTURA
|| rotd.NUMERO_ALTERNATI
|| rotd.SEQ_OPERACAO
IN
(
SELECT
   rot.NIVEL_ESTRUTURA
|| rot.GRUPO_ESTRUTURA
|| rot.ITEM_ESTRUTURA
|| rot.SUBGRU_ESTRUTURA
|| rot.NUMERO_ALTERNATI
|| rot.SEQ_OPERACAO
FROM MQOP_050 rot -- operaçẽs das alternativas de roteiro
JOIN BASI_030 r -- referencia (produto)
  ON r.NIVEL_ESTRUTURA = rot.NIVEL_ESTRUTURA
 AND r.REFERENCIA = rot.GRUPO_ESTRUTURA
WHERE rot.NUMERO_ALTERNATI = 2
  AND r.COLECAO <> 3
);
