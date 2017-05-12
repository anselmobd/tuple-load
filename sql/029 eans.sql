SELECT
  c.CODIGO_BARRAS
, c.NIVEL_ESTRUTURA
  || c.GRUPO_ESTRUTURA
  || '.' || c.SUBGRU_ESTRUTURA
  || '.' || c.ITEM_ESTRUTURA
, c.*
FROM basi_010 c
WHERE c.NIVEL_ESTRUTURA = 1
  AND c.GRUPO_ESTRUTURA > '99999'
  AND c.GRUPO_ESTRUTURA = 'M0103'
;

UPDATE basi_010 c
SET
  c.CODIGO_BARRAS = c.NIVEL_ESTRUTURA
  || c.GRUPO_ESTRUTURA
  || '.' || c.SUBGRU_ESTRUTURA
  || '.' || c.ITEM_ESTRUTURA
WHERE c.NIVEL_ESTRUTURA = 1
  AND c.GRUPO_ESTRUTURA > '99999'
  AND c.GRUPO_ESTRUTURA = 'M0103'
  AND c.CODIGO_BARRAS IS NULL
;

UPDATE basi_010 c
SET
  c.CODIGO_BARRAS = c.NIVEL_ESTRUTURA
  || c.GRUPO_ESTRUTURA
  || '.' || c.SUBGRU_ESTRUTURA
  || '.' || c.ITEM_ESTRUTURA
WHERE c.NIVEL_ESTRUTURA = 1
  AND c.GRUPO_ESTRUTURA > '99999'
  AND c.CODIGO_BARRAS IS NULL
;

SELECT
  c.CODIGO_BARRAS
, c.*
FROM basi_010 c
WHERE c.GRUPO_ESTRUTURA = '06027'
;

UPDATE basi_010 c
SET
  c.CODIGO_BARRAS = '7896896286078'
WHERE c.GRUPO_ESTRUTURA = '06027'
;
