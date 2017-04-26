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
