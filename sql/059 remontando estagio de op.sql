-- lotes devem estar em estágio anterior ao que será alterado
-- estágio a ser alterado não pode ter OS
-- verificando OS
SELECT DISTINCT
  l.ORDEM_PRODUCAO
, l.NUMERO_ORDEM
, l.SEQ_ORDEM_SERV
, l.PERIODO_PRODUCAO
, l.ORDEM_CONFECCAO
, l.PROCONF_SUBGRUPO
, l.*
FROM pcpc_040 l
WHERE 1=1
  AND l.ORDEM_PRODUCAO = 733
  --AND l.PROCONF_SUBGRUPO = G -- G 1; GG 2; P 3; M 4
  --AND l.NUMERO_ORDEM = 487
  --AND l.CODIGO_ESTAGIO = 39
  --AND l.PERIODO_PRODUCAO = 1721
  --AND l.ORDEM_CONFECCAO IN (
  --  3679
  --, 3708
  --)
  AND l.NUMERO_ORDEM <> 0
  AND l.SEQ_ORDEM_SERV <> 0
ORDER BY
  l.SEQ_ORDEM_SERV
, l.ORDEM_CONFECCAO
;
-- excluindo OS dos lotes
UPDATE pcpc_040 l
SET
  l.NUMERO_ORDEM = 0
, l.SEQ_ORDEM_SERV = 0
WHERE 1=1
  AND l.ORDEM_PRODUCAO = 733
  AND l.NUMERO_ORDEM <> 0
  AND l.SEQ_ORDEM_SERV <> 0
;
-- em pcpc_f350
-- digita OP
-- F7
-- excluir estágios do último até o que quer alterar
-- reincluir o alterado (atenção à sequência do roteiro)
-- reincluir os outros até o último
-- na OS alterar o Código serviço
-- F2
-- digita OP
-- F9
-- F2
-- os lotes já apareceram incluídos - Verifiquei com o SQL acima
-- F1 - produtos de retorno OK
-- F2 - insumos OK!!!
