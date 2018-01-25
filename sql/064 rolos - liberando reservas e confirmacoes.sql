
SELECT
  x.*
FROM PCPT_025 x -- confirmação de rolo
;

DELETE
FROM PCPT_025 x -- confirmação de rolo
;

--

SELECT
  x.*
FROM TMRP_141 x -- reserva de rolo para OP
;

DELETE
FROM TMRP_141 x -- reserva de rolo para OP
;

--

SELECT
  x.*
FROM PCPT_020 x -- cadastro de rolos
WHERE x.ROLO_ESTOQUE = 3
;

UPDATE PCPT_020 x -- cadastro de rolos
SET
  x.ROLO_ESTOQUE = 1
WHERE x.ROLO_ESTOQUE = 3
;

--

SELECT
  x.ROLO_ESTOQUE
, x.TRANSACAO_CARDEX
, x.DATA_CARDEX
, x.*
FROM PCPT_020 x -- cadastro de rolos
WHERE 1=1
--  AND x.ROLO_ESTOQUE = 3
--  AND x.CODIGO_ROLO = 1009 -- 11443
  AND x.CODIGO_ROLO = 11443
ORDER BY
  x.CODIGO_ROLO DESC
;
