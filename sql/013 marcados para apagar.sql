-- vvvvvvvvvv verificando
SELECT
  ptc.NIVEL_ESTRUTURA
, ptc.GRUPO_ESTRUTURA
, ptc.SUBGRU_ESTRUTURA
, ptc.ITEM_ESTRUTURA
, comb.NIVEL_ITEM
, comb.GRUPO_ITEM
, comb.SUB_ITEM
, comb.ITEM_ITEM
FROM BASI_010 ptc
LEFT JOIN BASI_040 comb
  ON comb.NIVEL_ITEM = ptc.NIVEL_ESTRUTURA
 AND comb.GRUPO_ITEM = ptc.GRUPO_ESTRUTURA
 AND (comb.SUB_ITEM = ptc.SUBGRU_ESTRUTURA
      OR comb.ITEM_ITEM = ptc.ITEM_ESTRUTURA
     )
WHERE ptc.GRUPO_ESTRUTURA like '00613'

-- vvvvvvvvvv executando
-- exclui das combinações cores que não pertencem ao produto dono da estrutura

DELETE FROM BASI_040 comb
WHERE comb.ITEM_ITEM <> '000000'
  AND NOT EXISTS (
	  SELECT
	    ptc.GRUPO_ESTRUTURA
	  FROM BASI_010 ptc
	  where comb.NIVEL_ITEM = ptc.NIVEL_ESTRUTURA
	    AND comb.GRUPO_ITEM = ptc.GRUPO_ESTRUTURA
	    AND comb.ITEM_ITEM = ptc.ITEM_ESTRUTURA
  )

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

SELECT
  estr.GRUPO_ITEM
, ptc.GRUPO_ESTRUTURA
, estr.ITEM_ITEM
, ptc.ITEM_ESTRUTURA
, estr.*
FROM BASI_050 estr
JOIN BASI_010 ptc
  ON ptc.NIVEL_ESTRUTURA = estr.NIVEL_ITEM
 AND ptc.GRUPO_ESTRUTURA = estr.GRUPO_ITEM
 --AND estr.ITEM_ITEM = ptc.ITEM_ESTRUTURA
 AND estr.SUB_ITEM in (
	SELECT
	  MIN( ptc2.SUBGRU_ESTRUTURA )
	FROM BASI_010 ptc2
	WHERE ptc2.NIVEL_ESTRUTURA = ptc.NIVEL_ESTRUTURA
	  AND ptc2.GRUPO_ESTRUTURA = ptc.GRUPO_ESTRUTURA
	  --AND ptc2.ITEM_ESTRUTURA = ptc.ITEM_ESTRUTURA
 )
WHERE estr.ITEM_ITEM = '000000'
  AND estr.GRUPO_ITEM = '0156R'

---

SELECT
  estr.NIVEL_ITEM
, estr.GRUPO_ITEM
, estr.ALTERNATIVA_ITEM
, estr.SEQUENCIA
, estr.NIVEL_COMP
, estr.GRUPO_COMP
, ptc.ITEM_ESTRUTURA
, estr.*
FROM BASI_050 estr
JOIN BASI_010 ptc
  ON ptc.NIVEL_ESTRUTURA = estr.NIVEL_ITEM
 AND ptc.GRUPO_ESTRUTURA = estr.GRUPO_ITEM
 AND ptc.SUBGRU_ESTRUTURA in (
	SELECT
	  MIN( ptc2.SUBGRU_ESTRUTURA )
	FROM BASI_010 ptc2
	WHERE ptc2.NIVEL_ESTRUTURA = estr.NIVEL_ITEM
	  AND ptc2.GRUPO_ESTRUTURA = estr.GRUPO_ITEM
 )
 AND NOT EXISTS (
	SELECT
	  comb.ITEM_ITEM
	FROM BASI_040 comb
	WHERE comb.NIVEL_ITEM = estr.NIVEL_ITEM
	  AND comb.GRUPO_ITEM = estr.GRUPO_ITEM
      AND comb.ALTERNATIVA_ITEM = estr.ALTERNATIVA_ITEM
      AND comb.SEQUENCIA = estr.SEQUENCIA
      AND comb.ITEM_ITEM = ptc.ITEM_ESTRUTURA
 )
WHERE estr.ITEM_COMP = '000000'
  AND estr.GRUPO_ITEM = '0156R'
ORDER BY
  estr.NIVEL_ITEM
, estr.GRUPO_ITEM
, estr.ALTERNATIVA_ITEM
, estr.NIVEL_COMP
, estr.GRUPO_COMP
, ptc.ITEM_ESTRUTURA

---

SELECT
  estr.NIVEL_ITEM
, estr.GRUPO_ITEM
, '000'
, ptc.ITEM_ESTRUTURA
, estr.ALTERNATIVA_ITEM
, estr.SEQUENCIA
, estr.SUB_COMP
, CASE WHEN EXISTS (
    SELECT
      pcomb.ITEM_ESTRUTURA
    FROM BASI_010 pcomb
    WHERE pcomb.NIVEL_ESTRUTURA = estr.NIVEL_COMP
      AND pcomb.GRUPO_ESTRUTURA = estr.GRUPO_COMP
      AND pcomb.SUBGRU_ESTRUTURA = estr.SUB_COMP
      AND pcomb.ITEM_ESTRUTURA = ptc.ITEM_ESTRUTURA
  )
  THEN ptc.ITEM_ESTRUTURA
  ELSE (
    SELECT
      min( pcomb2.ITEM_ESTRUTURA )
    FROM BASI_010 pcomb2
    WHERE pcomb2.NIVEL_ESTRUTURA = estr.NIVEL_COMP
      AND pcomb2.GRUPO_ESTRUTURA = estr.GRUPO_COMP
      AND pcomb2.SUBGRU_ESTRUTURA = estr.SUB_COMP
  )
  END ITEM_COMP
, estr.CONSUMO
, 0        CONS_UNID_MED_GENERICA
, 0        SEQUENCIA_TAMANHO
, 1        ALTERNATIVA_COMP
, '000000' CODIGO_PROJETO
, 0        SEQUENCIA_PROJETO
, estr.NIVEL_COMP
, estr.GRUPO_COMP
, estr.*
FROM BASI_050 estr
JOIN BASI_010 ptc
  ON ptc.NIVEL_ESTRUTURA = estr.NIVEL_ITEM
 AND ptc.GRUPO_ESTRUTURA = estr.GRUPO_ITEM
 AND ptc.SUBGRU_ESTRUTURA in (
	SELECT
	  MIN( ptc2.SUBGRU_ESTRUTURA )
	FROM BASI_010 ptc2
	WHERE ptc2.NIVEL_ESTRUTURA = estr.NIVEL_ITEM
	  AND ptc2.GRUPO_ESTRUTURA = estr.GRUPO_ITEM
 )
 AND NOT EXISTS (
	SELECT
	  comb.ITEM_ITEM
	FROM BASI_040 comb
	WHERE comb.NIVEL_ITEM = estr.NIVEL_ITEM
	  AND comb.GRUPO_ITEM = estr.GRUPO_ITEM
      AND comb.ALTERNATIVA_ITEM = estr.ALTERNATIVA_ITEM
      AND comb.SEQUENCIA = estr.SEQUENCIA
      AND comb.ITEM_ITEM = ptc.ITEM_ESTRUTURA
 )
WHERE estr.ITEM_COMP = '000000'
  AND estr.GRUPO_ITEM = '0156R'
ORDER BY
  estr.NIVEL_ITEM
, estr.GRUPO_ITEM
, estr.ALTERNATIVA_ITEM
, estr.NIVEL_COMP
, estr.GRUPO_COMP
, ptc.ITEM_ESTRUTURA

-- vvvvvvvvvv executando
-- inclui combinações cores faltantes

INSERT INTO SYSTEXTIL.BASI_040 (
  NIVEL_ITEM
, GRUPO_ITEM
, SUB_ITEM
, ITEM_ITEM
, ALTERNATIVA_ITEM
, SEQUENCIA
, SUB_COMP
, ITEM_COMP
, CONSUMO
, CONS_UNID_MED_GENERICA
, SEQUENCIA_TAMANHO
, ALTERNATIVA_COMP
, CODIGO_PROJETO
, SEQUENCIA_PROJETO
)
SELECT
  estr.NIVEL_ITEM
, estr.GRUPO_ITEM
, '000'
, ptc.ITEM_ESTRUTURA
, estr.ALTERNATIVA_ITEM
, estr.SEQUENCIA
, estr.SUB_COMP
, CASE WHEN EXISTS (
    SELECT
      pcomb.ITEM_ESTRUTURA
    FROM BASI_010 pcomb
    WHERE pcomb.NIVEL_ESTRUTURA = estr.NIVEL_COMP
      AND pcomb.GRUPO_ESTRUTURA = estr.GRUPO_COMP
      AND pcomb.SUBGRU_ESTRUTURA = estr.SUB_COMP
      AND pcomb.ITEM_ESTRUTURA = ptc.ITEM_ESTRUTURA
  )
  THEN ptc.ITEM_ESTRUTURA
  ELSE (
    SELECT
      min( pcomb2.ITEM_ESTRUTURA )
    FROM BASI_010 pcomb2
    WHERE pcomb2.NIVEL_ESTRUTURA = estr.NIVEL_COMP
      AND pcomb2.GRUPO_ESTRUTURA = estr.GRUPO_COMP
      AND pcomb2.SUBGRU_ESTRUTURA = estr.SUB_COMP
  )
  END ITEM_COMP
, estr.CONSUMO
, 0        CONS_UNID_MED_GENERICA
, 0        SEQUENCIA_TAMANHO
, 1        ALTERNATIVA_COMP
, '000000' CODIGO_PROJETO
, 0        SEQUENCIA_PROJETO
FROM BASI_050 estr
JOIN BASI_010 ptc
  ON ptc.NIVEL_ESTRUTURA = estr.NIVEL_ITEM
 AND ptc.GRUPO_ESTRUTURA = estr.GRUPO_ITEM
 AND ptc.SUBGRU_ESTRUTURA in (
	SELECT
	  MIN( ptc2.SUBGRU_ESTRUTURA )
	FROM BASI_010 ptc2
	WHERE ptc2.NIVEL_ESTRUTURA = estr.NIVEL_ITEM
	  AND ptc2.GRUPO_ESTRUTURA = estr.GRUPO_ITEM
 )
 AND NOT EXISTS (
	SELECT
	  comb.ITEM_ITEM
	FROM BASI_040 comb
	WHERE comb.NIVEL_ITEM = estr.NIVEL_ITEM
	  AND comb.GRUPO_ITEM = estr.GRUPO_ITEM
      AND comb.ALTERNATIVA_ITEM = estr.ALTERNATIVA_ITEM
      AND comb.SEQUENCIA = estr.SEQUENCIA
      AND comb.ITEM_ITEM = ptc.ITEM_ESTRUTURA
 )
WHERE estr.ITEM_COMP = '000000'
  -- AND estr.GRUPO_ITEM = '0156R'
ORDER BY
  estr.NIVEL_ITEM
, estr.GRUPO_ITEM
, estr.ALTERNATIVA_ITEM
, estr.NIVEL_COMP
, estr.GRUPO_COMP
, ptc.ITEM_ESTRUTURA

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

SELECT
  ptc.NIVEL_ESTRUTURA
, ptc.GRUPO_ESTRUTURA
, ptc.SUBGRU_ESTRUTURA
, ptc.ITEM_ESTRUTURA
, ptc.DESCRICAO_15
, comb.NIVEL_ITEM
, comb.GRUPO_ITEM
, comb.SUB_ITEM
, comb.ITEM_ITEM
FROM BASI_010 ptc
LEFT JOIN BASI_040 comb
  ON comb.NIVEL_ITEM = ptc.NIVEL_ESTRUTURA
 AND comb.GRUPO_ITEM = ptc.GRUPO_ESTRUTURA
 AND (comb.SUB_ITEM = ptc.SUBGRU_ESTRUTURA
      OR comb.ITEM_ITEM = ptc.ITEM_ESTRUTURA
     )
WHERE ptc.NIVEL_ESTRUTURA = 1
  AND ptc.DESCRICAO_15 like '-%'

---

SELECT
  comb.NIVEL_ITEM
, comb.GRUPO_ITEM
, comb.SUB_ITEM
, comb.ITEM_ITEM
, comb.ALTERNATIVA_ITEM
FROM BASI_040 comb
WHERE comb.ITEM_ITEM <> '000000'
  AND EXISTS (
	  SELECT
	    ptc.ITEM_ESTRUTURA
	  FROM BASI_010 ptc
	  where comb.NIVEL_ITEM = ptc.NIVEL_ESTRUTURA
	    AND comb.GRUPO_ITEM = ptc.GRUPO_ESTRUTURA
	    AND comb.ITEM_ITEM = ptc.ITEM_ESTRUTURA
	    AND ptc.DESCRICAO_15 like '-%'
  )

-- vvvvvvvvvv executando
-- exclui das combinações, cores do produto pai marcadas com '-' no início da descrição

DELETE
--SELECT *
FROM BASI_040 comb
WHERE comb.ITEM_ITEM <> '000000'
  AND (
    EXISTS (
      SELECT
        ptc.ITEM_ESTRUTURA
      FROM BASI_010 ptc
      where comb.NIVEL_ITEM = ptc.NIVEL_ESTRUTURA
        AND comb.GRUPO_ITEM = ptc.GRUPO_ESTRUTURA
        AND comb.ITEM_ITEM = ptc.ITEM_ESTRUTURA
        AND ptc.DESCRICAO_15 like '-%'
    )
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where comb.NIVEL_ITEM = r.NIVEL_ESTRUTURA
        AND comb.GRUPO_ITEM = r.REFERENCIA
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
;

-- vvvvvvvvvv executando
-- exclui das combinações, tamanhos marcadas com '-' no início da descrição

DELETE FROM BASI_040 comb
WHERE comb.SUB_ITEM <> '000'
  AND (
    EXISTS (
  	  SELECT
  	    pt.TAMANHO_REF
  	  FROM BASI_020 pt
  	  where pt.BASI030_NIVEL030 = comb.NIVEL_ITEM
  	    AND pt.BASI030_REFERENC = comb.GRUPO_ITEM
  	    AND pt.TAMANHO_REF = comb.SUB_ITEM
  	    AND pt.DESCR_TAM_REFER like '-%'
    )
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where comb.NIVEL_ITEM = r.NIVEL_ESTRUTURA
        AND comb.GRUPO_ITEM = r.REFERENCIA
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
;

--- --- --- --- --- --- --- --- ---
--- --- --- --- --- --- --- --- ---

-- vvvvvvvvvv executando
-- exclui
-- . parametros
-- . cores
-- de cores marcadas com '-' no início da descrição

DELETE
--SELECT *
FROM BASI_015 ptcp
WHERE
  (
    EXISTS
    ( SELECT
        ptc.ITEM_ESTRUTURA
      FROM BASI_010 ptc
      WHERE ptc.NIVEL_ESTRUTURA = ptcp.NIVEL_ESTRUTURA
        AND ptc.GRUPO_ESTRUTURA = ptcp.GRUPO_ESTRUTURA
        AND ptc.SUBGRU_ESTRUTURA = ptcp.SUBGRU_ESTRUTURA
        AND ptc.ITEM_ESTRUTURA = ptcp.ITEM_ESTRUTURA
        AND ptc.DESCRICAO_15 like '-%'
    )
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where r.NIVEL_ESTRUTURA = ptcp.NIVEL_ESTRUTURA
        AND r.REFERENCIA = ptcp.GRUPO_ESTRUTURA
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
  AND NOT EXISTS
  ( SELECT
      estr.ITEM_COMP
    FROM BASI_050 estr
    WHERE estr.NIVEL_COMP = ptcp.NIVEL_ESTRUTURA
      AND estr.GRUPO_COMP = ptcp.GRUPO_ESTRUTURA
      AND estr.ITEM_COMP = ptcp.ITEM_ESTRUTURA
  )
;

--

DELETE
--SELECT *
FROM BASI_010 ptc
WHERE
  (
    ptc.DESCRICAO_15 like '-%'
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where r.NIVEL_ESTRUTURA = ptc.NIVEL_ESTRUTURA
        AND r.REFERENCIA = ptc.GRUPO_ESTRUTURA
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
  AND NOT EXISTS (
	  SELECT
	    estr.ITEM_COMP
	  FROM BASI_050 estr
	  WHERE estr.NIVEL_COMP = ptc.NIVEL_ESTRUTURA
	    AND estr.GRUPO_COMP = ptc.GRUPO_ESTRUTURA
	    AND estr.ITEM_COMP = ptc.ITEM_ESTRUTURA
  )
;

-- vvvvvvvvvv executando
-- exclui
-- . parametros de fornecedor
-- . requisições (não sei se devo fazer isso)
-- . parametros
-- . cores
-- . tamanhos
-- de tamanhos marcados com '-' no início da descrição

DELETE
--SELECT *
FROM supr_060 s
WHERE
  (
    EXISTS
    ( SELECT
        pt.TAMANHO_REF
      FROM BASI_020 pt
      WHERE pt.BASI030_NIVEL030 = s.ITEM_060_NIVEL99
        AND pt.BASI030_REFERENC = s.ITEM_060_GRUPO
        AND pt.TAMANHO_REF = s.ITEM_060_SUBGRUPO
        AND pt.DESCR_TAM_REFER like '-%'
    )
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where r.NIVEL_ESTRUTURA = s.ITEM_060_NIVEL99
        AND r.REFERENCIA = s.ITEM_060_GRUPO
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
  AND NOT EXISTS
  ( SELECT
      estr.ITEM_COMP
    FROM BASI_050 estr
    WHERE estr.NIVEL_COMP = s.ITEM_060_NIVEL99
      AND estr.GRUPO_COMP = s.ITEM_060_GRUPO
      AND estr.SUB_COMP = s.ITEM_060_SUBGRUPO
  )
;

--

DELETE
--SELECT *
FROM supr_067 s
WHERE
  (
    EXISTS
    ( SELECT
        pt.TAMANHO_REF
      FROM BASI_020 pt
      WHERE pt.BASI030_NIVEL030 = s.ITEM_REQ_NIVEL99
        AND pt.BASI030_REFERENC = s.ITEM_REQ_GRUPO
        AND pt.TAMANHO_REF = s.ITEM_REQ_SUBGRUPO
        AND pt.DESCR_TAM_REFER like '-%'
    )
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where r.NIVEL_ESTRUTURA = s.ITEM_REQ_NIVEL99
        AND r.REFERENCIA = s.ITEM_REQ_GRUPO
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
  AND NOT EXISTS
  ( SELECT
      estr.ITEM_COMP
    FROM BASI_050 estr
    WHERE estr.NIVEL_COMP = s.ITEM_REQ_NIVEL99
      AND estr.GRUPO_COMP = s.ITEM_REQ_GRUPO
      AND estr.SUB_COMP = s.ITEM_REQ_SUBGRUPO
  )
;

--

DELETE
--SELECT *
FROM BASI_015 ptcp
WHERE
  (
    EXISTS
    ( SELECT
        pt.TAMANHO_REF
      FROM BASI_020 pt
      WHERE pt.BASI030_NIVEL030 = ptcp.NIVEL_ESTRUTURA
        AND pt.BASI030_REFERENC = ptcp.GRUPO_ESTRUTURA
        AND pt.TAMANHO_REF = ptcp.SUBGRU_ESTRUTURA
        AND pt.DESCR_TAM_REFER like '-%'
    )
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where r.NIVEL_ESTRUTURA = ptcp.NIVEL_ESTRUTURA
        AND r.REFERENCIA = ptcp.GRUPO_ESTRUTURA
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
  AND NOT EXISTS
  ( SELECT
      estr.ITEM_COMP
    FROM BASI_050 estr
    WHERE estr.NIVEL_COMP = ptcp.NIVEL_ESTRUTURA
      AND estr.GRUPO_COMP = ptcp.GRUPO_ESTRUTURA
      AND estr.SUB_COMP = ptcp.SUBGRU_ESTRUTURA
  )
;

--

DELETE
--SELECT *
FROM BASI_010 ptc
WHERE
  (
    EXISTS
    ( SELECT
        pt.TAMANHO_REF
      FROM BASI_020 pt
      WHERE pt.BASI030_NIVEL030 = ptc.NIVEL_ESTRUTURA
        AND pt.BASI030_REFERENC = ptc.GRUPO_ESTRUTURA
        AND pt.TAMANHO_REF = ptc.SUBGRU_ESTRUTURA
        AND pt.DESCR_TAM_REFER like '-%'
    )
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where r.NIVEL_ESTRUTURA = ptc.NIVEL_ESTRUTURA
        AND r.REFERENCIA = ptc.GRUPO_ESTRUTURA
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
  AND NOT EXISTS
  ( SELECT
      estr.ITEM_COMP
    FROM BASI_050 estr
    WHERE estr.NIVEL_COMP = ptc.NIVEL_ESTRUTURA
      AND estr.GRUPO_COMP = ptc.GRUPO_ESTRUTURA
      AND estr.SUB_COMP = ptc.SUBGRU_ESTRUTURA
  )
;

--

DELETE
--SELECT *
FROM BASI_020 pt
WHERE
  (
    pt.DESCR_TAM_REFER like '-%'
    OR EXISTS (
      SELECT
        r.REFERENCIA
      FROM BASI_030 r
      where r.NIVEL_ESTRUTURA = pt.BASI030_NIVEL030
        AND r.REFERENCIA = pt.BASI030_REFERENC
        AND r.DESCR_REFERENCIA like '-%'
    )
  )
  AND NOT EXISTS (
	  SELECT
	    estr.ITEM_COMP
	  FROM BASI_050 estr
	  WHERE estr.NIVEL_COMP = pt.BASI030_NIVEL030
	    AND estr.GRUPO_COMP = pt.BASI030_REFERENC
	    AND estr.SUB_COMP = pt.TAMANHO_REF
  )
;

-- vvvvvvvvvv executando
-- exclui
-- . produtos
-- sem tamanhos e marcados com '-' no início da descrição

DELETE
-- SELECT *
FROM BASI_030 p
WHERE p.DESCR_REFERENCIA like '-%'
  AND NOT EXISTS (
	  SELECT
	    pt.BASI030_REFERENC
	  FROM BASI_020 pt
	  WHERE pt.BASI030_NIVEL030 = p.NIVEL_ESTRUTURA
	    AND pt.BASI030_REFERENC = p.REFERENCIA
  )
;

-- vvvvvvvvvv executando
-- exclui uma referencia

--DELETE
SELECT *
FROM MQOP_050 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.GRUPO_ESTRUTURA = '00417'
;

--DELETE
SELECT *
FROM BASI_070 p
WHERE p.NIVEL = 1
  AND p.GRUPO = '00417'
;

--DELETE
SELECT *
FROM BASI_040 p
WHERE p.NIVEL_ITEM = 1
  AND p.GRUPO_ITEM = '00417'
;

--DELETE
SELECT *
FROM BASI_050 p
WHERE p.NIVEL_ITEM = 1
  AND p.GRUPO_ITEM = '00417'
;

--DELETE
SELECT *
FROM BASI_010 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.GRUPO_ESTRUTURA = '00417'
;

--DELETE
SELECT *
FROM BASI_020 p
WHERE p.BASI030_NIVEL030 = 1
  AND p.BASI030_REFERENC = '00417'
;

--DELETE
SELECT *
FROM BASI_030 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.REFERENCIA = '00417'
;

----------------

DELETE
FROM MQOP_050 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.GRUPO_ESTRUTURA = 'M0417'
;

DELETE
FROM BASI_070 p
WHERE p.NIVEL = 1
  AND p.GRUPO = 'M0417'
;

DELETE
FROM BASI_040 p
WHERE p.NIVEL_ITEM = 1
  AND p.GRUPO_ITEM = 'M0417'
;

DELETE
FROM BASI_050 p
WHERE p.NIVEL_ITEM = 1
  AND p.GRUPO_ITEM = 'M0417'
;

DELETE
FROM BASI_010 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.GRUPO_ESTRUTURA = 'M0417'
;

DELETE
FROM BASI_020 p
WHERE p.BASI030_NIVEL030 = 1
  AND p.BASI030_REFERENC = 'M0417'
;

DELETE
FROM BASI_030 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.REFERENCIA = 'M0417'
;

DELETE
FROM MQOP_050 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.GRUPO_ESTRUTURA = '00417'
;

DELETE
FROM BASI_070 p
WHERE p.NIVEL = 1
  AND p.GRUPO = '00417'
;

DELETE
FROM BASI_040 p
WHERE p.NIVEL_ITEM = 1
  AND p.GRUPO_ITEM = '00417'
;

DELETE
FROM BASI_050 p
WHERE p.NIVEL_ITEM = 1
  AND p.GRUPO_ITEM = '00417'
;

DELETE
FROM BASI_010 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.GRUPO_ESTRUTURA = '00417'
;

DELETE
FROM BASI_020 p
WHERE p.BASI030_NIVEL030 = 1
  AND p.BASI030_REFERENC = '00417'
;

DELETE
FROM BASI_030 p
WHERE p.NIVEL_ESTRUTURA = 1
  AND p.REFERENCIA = '00417'
;
