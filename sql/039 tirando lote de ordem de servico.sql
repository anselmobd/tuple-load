-- !!! Verificar na view se já tem data de faturamento da OS. Se tem, não deve excluir.
SELECT DISTINCT
  l.ORDEM_PRODUCAO
, l.NUMERO_ORDEM
, l.SEQ_ORDEM_SERV
, l.PERIODO_PRODUCAO
, l.ORDEM_CONFECCAO
, l.*
FROM pcpc_040 l
--UPDATE pcpc_040 l
--SET
--  l.NUMERO_ORDEM = 0
--, l.SEQ_ORDEM_SERV = 0
WHERE l.ORDEM_PRODUCAO = 297
  AND l.NUMERO_ORDEM = 170
  AND l.PERIODO_PRODUCAO = 1719
  AND l.ORDEM_CONFECCAO IN (
    9811
  , 9812
  , 9813
  )
