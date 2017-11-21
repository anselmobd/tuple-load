
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
