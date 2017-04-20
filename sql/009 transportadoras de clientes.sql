SELECT
  cup.cgc_9
, cip.ESTADO
, cup.tran_cli_forne9
FROM pedi_010 cup
JOIN basi_160 cip ON cip.COD_CIDADE = cup.COD_CIDADE
WHERE
cup.ROWID in (
	SELECT
	  cl.ROWID
	FROM pedi_010 cl
	JOIN basi_160 ci ON ci.COD_CIDADE = cl.COD_CIDADE
	WHERE ci.ESTADO = 'PR'
	  AND cl.tran_cli_forne9 = 0
)
-------------------
CGC: 43244631/0024-55
'PR', 'RS', 'SC', 'SP'
---
UPDATE pedi_010 cup
SET
  cup.tran_cli_forne9 = 43244631
, cup.tran_cli_forne4 = 24
, cup.tran_cli_forne2 = 55
WHERE
cup.ROWID in (
	SELECT
	  cl.ROWID
	FROM pedi_010 cl
	JOIN basi_160 ci ON ci.COD_CIDADE = cl.COD_CIDADE
	WHERE ci.ESTADO in ('PR', 'RS', 'SC', 'SP')
	  AND cl.tran_cli_forne9 = 0
)
;
---
CGC: 17463456/0002-71
'BA', 'ES', 'MG'
---
UPDATE pedi_010 cup
SET
  cup.tran_cli_forne9 = 17463456
, cup.tran_cli_forne4 = 0002
, cup.tran_cli_forne2 = 71
WHERE
cup.ROWID in (
	SELECT
	  cl.ROWID
	FROM pedi_010 cl
	JOIN basi_160 ci ON ci.COD_CIDADE = cl.COD_CIDADE
	WHERE ci.ESTADO in ('BA', 'ES', 'MG')
	  AND cl.tran_cli_forne9 = 0
)
;

---
CGC: 00634453/0008-46
'AC', 'DF', 'GO', 'MS', 'MT', 'RO', 'TO'
---
UPDATE pedi_010 cup
SET
  cup.tran_cli_forne9 = 00634453
, cup.tran_cli_forne4 = 0008
, cup.tran_cli_forne2 = 46
WHERE
cup.ROWID in (
	SELECT
	  cl.ROWID
	FROM pedi_010 cl
	JOIN basi_160 ci ON ci.COD_CIDADE = cl.COD_CIDADE
	WHERE ci.ESTADO in ('AC', 'DF', 'GO', 'MS', 'MT', 'RO', 'TO')
	  AND cl.tran_cli_forne9 = 0
)
;
---
CGC: 88317847/0014-60
'RJ'
---
UPDATE pedi_010 cup
SET
  cup.tran_cli_forne9 = 88317847
, cup.tran_cli_forne4 = 0014
, cup.tran_cli_forne2 = 60
WHERE
cup.ROWID in (
	SELECT
	  cl.ROWID
	FROM pedi_010 cl
	JOIN basi_160 ci ON ci.COD_CIDADE = cl.COD_CIDADE
	WHERE ci.ESTADO in ('RJ')
	  AND cl.tran_cli_forne9 = 0
)
;
---
CGC: 10970887/0008-70
'AL', 'AM', 'AP', 'CE', 'MA', 'PA', 'PB', 'PE', 'PI', 'RN', 'RR', 'SE'
---
UPDATE pedi_010 cup
SET
  cup.tran_cli_forne9 = 10970887
, cup.tran_cli_forne4 = 0008
, cup.tran_cli_forne2 = 70
WHERE
cup.ROWID in (
	SELECT
	  cl.ROWID
	FROM pedi_010 cl
	JOIN basi_160 ci ON ci.COD_CIDADE = cl.COD_CIDADE
	WHERE ci.ESTADO in ('AL', 'AM', 'AP', 'CE', 'MA', 'PA', 'PB', 'PE', 'PI', 'RN', 'RR', 'SE')
	  AND cl.tran_cli_forne9 = 0
)
;
