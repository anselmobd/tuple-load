UPDATE BASI_050 e
SET
  e.ESTAGIO = 60
--SELECT
--  e.*
--FROM BASI_050 e
WHERE e.GRUPO_COMP = 'ET009'

-- baseado em e-mail da Giselle de 09/06/2017 - baseado em reunião com Bersange e etc.
-- Modificar o estagio do elástico 15 da alternativa 1 no MD para o estagio 33 . ( el ou ep ).

UPDATE BASI_050 upe
SET
  upe.ESTAGIO = 33
WHERE EXISTS (
	SELECT
	  e.*
	FROM BASI_050 e
	WHERE
	  (  e.GRUPO_COMP like 'EL%'
	  OR e.GRUPO_COMP like 'EL%'
	  )
	  AND e.ALTERNATIVA_ITEM = 1
	  AND e.ESTAGIO = 15
	  --
	  AND e.NIVEL_ITEM=upe.NIVEL_ITEM
	  AND e.GRUPO_ITEM=upe.GRUPO_ITEM
	  AND e.SUB_ITEM=upe.SUB_ITEM
	  AND e.ITEM_ITEM=upe.ITEM_ITEM
	  AND e.ALTERNATIVA_ITEM=upe.ALTERNATIVA_ITEM
	  AND e.SEQUENCIA=upe.SEQUENCIA
)
;

-- obs: Não utilizei o filtro abaixo, mas deveria
AND e.GRUPO_ITEM > '99999'


-- baseado em e-mail da Giselle de 09/06/2017 - baseado em reunião com Bersange e etc.
-- Modificar o estagio do MA001 24 da alternativa 3 (malha) para 54 no PA

UPDATE BASI_050 upe
SET
  upe.ESTAGIO = 54
WHERE EXISTS (
	SELECT
	  e.*
	FROM BASI_050 e
	WHERE e.GRUPO_COMP = 'MA001'
	  AND e.ALTERNATIVA_ITEM = 3
	  AND e.ESTAGIO = 24
	  AND e.GRUPO_ITEM < '99999'
	  --
	  AND e.NIVEL_ITEM=upe.NIVEL_ITEM
	  AND e.GRUPO_ITEM=upe.GRUPO_ITEM
	  AND e.SUB_ITEM=upe.SUB_ITEM
	  AND e.ITEM_ITEM=upe.ITEM_ITEM
	  AND e.ALTERNATIVA_ITEM=upe.ALTERNATIVA_ITEM
	  AND e.SEQUENCIA=upe.SEQUENCIA
)
;

-- acertando gargalos - baseado em reunião com Bersange e etc.

SELECT
  r.*
FROM MQOP_050 r
WHERE r.NUMERO_ALTERNATI <> r.NUMERO_ROTEIRO
;

SELECT
  r.IND_ESTAGIO_GARGALO
, r.*
FROM MQOP_050 r
WHERE 1=1
  AND r.GRUPO_ESTRUTURA = 'M0417'
  AND r.NUMERO_ALTERNATI = 1
  AND r.NUMERO_ROTEIRO = 1
;

SELECT distinct
  r.NUMERO_ROTEIRO
FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA < '99999'
;

SELECT
  r.GRUPO_ESTRUTURA
, r.NUMERO_ROTEIRO
, r.SEQ_OPERACAO
, r.CODIGO_OPERACAO
, r.IND_ESTAGIO_GARGALO
, r.*
FROM MQOP_050 r
WHERE 1=1
  AND r.GRUPO_ESTRUTURA < '99999'
  AND r.NUMERO_ROTEIRO IN (1,4,5,6,7)
  --AND r.CODIGO_OPERACAO = 33
  --AND r.IND_ESTAGIO_GARGALO = 1
ORDER BY
  r.GRUPO_ESTRUTURA
, r.SEQ_OPERACAO
;

UPDATE MQOP_050 r
SET
  r.IND_ESTAGIO_GARGALO =
	CASE WHEN r.CODIGO_OPERACAO = 60 THEN 1
	ELSE 0
	END
WHERE r.GRUPO_ESTRUTURA < '99999'
  AND r.NUMERO_ROTEIRO IN (1,4,5,6,7)
;

UPDATE MQOP_050 r
SET
  r.IND_ESTAGIO_GARGALO =
	CASE WHEN r.CODIGO_OPERACAO = 24 THEN 1
	ELSE 0
	END
WHERE r.GRUPO_ESTRUTURA < '99999'
  AND r.NUMERO_ROTEIRO IN (2,3)
;

UPDATE MQOP_050 r
SET
  r.IND_ESTAGIO_GARGALO =
	CASE
	WHEN r.NUMERO_ROTEIRO = 1 AND r.CODIGO_OPERACAO = 33 THEN 1
	WHEN r.NUMERO_ROTEIRO = 2 AND r.CODIGO_OPERACAO = 12 THEN 1
	WHEN r.NUMERO_ROTEIRO = 3 AND r.CODIGO_OPERACAO = 12 THEN 1
	WHEN r.NUMERO_ROTEIRO = 4 AND r.CODIGO_OPERACAO = 27 THEN 1
	WHEN r.NUMERO_ROTEIRO = 5 AND r.CODIGO_OPERACAO = 24 THEN 1
	WHEN r.NUMERO_ROTEIRO = 6 AND r.CODIGO_OPERACAO = 25 THEN 1
	WHEN r.NUMERO_ROTEIRO = 7 AND r.CODIGO_OPERACAO = 33 THEN 1
	ELSE 0
	END
WHERE r.GRUPO_ESTRUTURA > '99999'
;

-- Eliminação do CD1 - baseado em reunião com Bersange e etc.
-- Modificar o estagio de todos os materiais de PA das alternativas 1,4,5,6,7 de 57 para 60
-- renomear estágio para "CD1(<=13/06/2017)" indicando que só pode aparecer em OPs criadas até essa data
-- apagar estágio 57 dos roteiros em questão

UPDATE BASI_050 upe
SET
  upe.ESTAGIO = 60
WHERE EXISTS (
	SELECT
	  e.*
	FROM BASI_050 e
	WHERE e.ALTERNATIVA_ITEM in (1, 4, 5, 6, 7)
	  AND e.ESTAGIO = 57
	  AND e.GRUPO_ITEM < '99999' -- PA
	  --
	  AND e.NIVEL_ITEM=upe.NIVEL_ITEM
	  AND e.GRUPO_ITEM=upe.GRUPO_ITEM
	  AND e.SUB_ITEM=upe.SUB_ITEM
	  AND e.ITEM_ITEM=upe.ITEM_ITEM
	  AND e.ALTERNATIVA_ITEM=upe.ALTERNATIVA_ITEM
	  AND e.SEQUENCIA=upe.SEQUENCIA
)
;

SELECT
  *
FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA < '99999'
  AND r.CODIGO_OPERACAO = 57
  AND r.NUMERO_ROTEIRO IN (1,4,5,6,7)
;

DELETE FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA < '99999'
  AND r.CODIGO_OPERACAO = 57
  AND r.NUMERO_ROTEIRO IN (1,4,5,6,7)
;

-- Troca de estágio 54 por 55 nos roteiros 5 e 6 - baseado em reunião com Bersange e etc.

-- Primeiro verificar se há insumos no estágio

SELECT
  e.*
FROM BASI_050 e
WHERE e.ALTERNATIVA_ITEM IN (5, 6)
  AND e.ESTAGIO = 54 -- terceiro MG
  AND e.GRUPO_ITEM > '99999' -- MD

-- # tem vários
-- Monta update

UPDATE BASI_050 upe
SET
  upe.ESTAGIO = 55 -- terceiro RJ
WHERE EXISTS (
  SELECT
    e.*
  FROM BASI_050 e
  WHERE e.ALTERNATIVA_ITEM IN (5, 6)
    AND e.ESTAGIO = 54 -- terceiro MG
    AND e.GRUPO_ITEM > '99999' -- MD
	  --
	  AND e.NIVEL_ITEM=upe.NIVEL_ITEM
	  AND e.GRUPO_ITEM=upe.GRUPO_ITEM
	  AND e.SUB_ITEM=upe.SUB_ITEM
	  AND e.ITEM_ITEM=upe.ITEM_ITEM
	  AND e.ALTERNATIVA_ITEM=upe.ALTERNATIVA_ITEM
	  AND e.SEQUENCIA=upe.SEQUENCIA
)
;

-- lista roteiros MD 5 e 6 com o estágio 54

SELECT
  *
FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA > '99999' -- MD
  AND r.CODIGO_OPERACAO = 54 -- terceiro MG
  AND r.NUMERO_ROTEIRO IN (5,6)
;

-- Monta update

UPDATE MQOP_050 r
SET
  r.CODIGO_OPERACAO = 55 -- terceiro RJ
WHERE r.GRUPO_ESTRUTURA > '99999' -- MD
  AND r.CODIGO_OPERACAO = 54 -- terceiro MG
  AND r.NUMERO_ROTEIRO IN (5,6)
;

-- lista roteiros MD 5 e 6 com o operacão 55 e estágio 54

SELECT
  r.*
FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA > '99999' -- MD
  AND r.CODIGO_OPERACAO = 55 -- terceiro RJ
  AND r.CODIGO_ESTAGIO = 54 -- terceiro MG
  AND r.NUMERO_ROTEIRO IN (5,6)
;

-- Monta update

UPDATE MQOP_050 r
SET
  r.CODIGO_ESTAGIO = 55 -- terceiro RJ
WHERE r.GRUPO_ESTRUTURA > '99999' -- MD
  AND r.CODIGO_OPERACAO = 55 -- terceiro RJ
  AND r.CODIGO_ESTAGIO = 54 -- terceiro MG
  AND r.NUMERO_ROTEIRO IN (5,6)
;

-- baseado em reuniões com Bersange e etc.
-- estágios 18 e 21 dos roteiros 2 e 3 de MD são excluidos
-- estágios 18 e 21 entram nos roteiros 2 e 3 de PA

-- list estágios 18 e 21 dos roteiros 2 e 3 de MD

SELECT
  *
FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA > '99999'
  AND r.CODIGO_OPERACAO in (18, 21)
  AND r.NUMERO_ROTEIRO IN (2, 3)
;

-- apaga

DELETE FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA > '99999'
  AND r.CODIGO_OPERACAO in (18, 21)
  AND r.NUMERO_ROTEIRO IN (2, 3)
;

-- lista primeiro estágio de roteiros 2 e 3 de PA

SELECT
  r.NIVEL_ESTRUTURA
, r.GRUPO_ESTRUTURA
--, r.NUMERO_ALTERNATI
, r.NUMERO_ROTEIRO
, min( r.SEQ_OPERACAO ) MIN_SEQ
FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA <= '99999'
  AND r.NUMERO_ROTEIRO IN (2, 3)
GROUP BY
  r.NIVEL_ESTRUTURA
, r.GRUPO_ESTRUTURA
--, r.NUMERO_ALTERNATI
, r.NUMERO_ROTEIRO
;

-- # todas as sequências mínimas são 10
-- inserir estágio 18 com sequência de opereção 3 e sequencia de estágio 1
--       e estágio 21 com sequência de opereção 6 e sequencia de estágio 2

-- a SEQUENCIA_ESTAGIO tem que ser acrescida de 2 para todos, de modo a abrir
-- espaço para os novos estágios

-- lista todas as operações

SELECT
  r.NIVEL_ESTRUTURA
, r.GRUPO_ESTRUTURA
, r.NUMERO_ALTERNATI
, r.NUMERO_ROTEIRO
, r.SEQUENCIA_ESTAGIO
FROM MQOP_050 r
WHERE r.GRUPO_ESTRUTURA <= '99999'
  AND r.NUMERO_ROTEIRO IN (2, 3)
ORDER BY
  r.NIVEL_ESTRUTURA
, r.GRUPO_ESTRUTURA
, r.NUMERO_ALTERNATI
, r.NUMERO_ROTEIRO
, r.SEQUENCIA_ESTAGIO
;

-- update SEQUENCIA_ESTAGIO = SEQUENCIA_ESTAGIO + 2

UPDATE MQOP_050 r
SET
  r.SEQUENCIA_ESTAGIO = r.SEQUENCIA_ESTAGIO + 2
WHERE r.GRUPO_ESTRUTURA <= '99999'
  AND r.NUMERO_ROTEIRO IN (2, 3)
;

-- inserir estágio 18 com sequência de opereção 3 e sequencia de estágio 1

INSERT INTO SYSTEXTIL.MQOP_050
(NIVEL_ESTRUTURA, GRUPO_ESTRUTURA, SUBGRU_ESTRUTURA, ITEM_ESTRUTURA, NUMERO_ALTERNATI, NUMERO_ROTEIRO, SEQ_OPERACAO, CODIGO_OPERACAO, MINUTOS, CODIGO_ESTAGIO, CENTRO_CUSTO, SEQUENCIA_ESTAGIO, ESTAGIO_ANTERIOR, ESTAGIO_DEPENDE, SEPARA_OPERACAO, MINUTOS_HOMEM, CCUSTO_HOMEM, NUMERO_CORDAS, NUMERO_ROLOS, VELOCIDADE, CODIGO_FAMILIA, OBSERVACAO, TIPO_PROCESSO, PECAS_1_HORA, PECAS_8_HORAS, CUSTO_MINUTO, PERC_EFICIENCIA, TEMPERATURA, TEMPO_LOTE_PRODUCAO, PECAS_LOTE_PRODUCAO, TIME_CELULA, CODIGO_APARELHO, PERC_EFIC_ROT, NUMERO_OPERADORAS, CONSIDERA_EFIC, SEQ_OPERACAO_AGRUPADORA, CODIGO_PARTE_PECA, SEQ_JUNCAO_PARTE_PECA, SITUACAO, PERC_PERDAS, PERC_CUSTOS, IND_ESTAGIO_GARGALO)
SELECT NIVEL_ESTRUTURA, GRUPO_ESTRUTURA, SUBGRU_ESTRUTURA, ITEM_ESTRUTURA, NUMERO_ALTERNATI, NUMERO_ROTEIRO
, 3 SEQ_OPERACAO
, 18 CODIGO_OPERACAO
, MINUTOS
, 18 CODIGO_ESTAGIO
, CENTRO_CUSTO
, 1 SEQUENCIA_ESTAGIO
, ESTAGIO_ANTERIOR, ESTAGIO_DEPENDE, SEPARA_OPERACAO, MINUTOS_HOMEM, CCUSTO_HOMEM, NUMERO_CORDAS, NUMERO_ROLOS, VELOCIDADE, CODIGO_FAMILIA, OBSERVACAO, TIPO_PROCESSO, PECAS_1_HORA, PECAS_8_HORAS, CUSTO_MINUTO, PERC_EFICIENCIA, TEMPERATURA, TEMPO_LOTE_PRODUCAO, PECAS_LOTE_PRODUCAO, TIME_CELULA, CODIGO_APARELHO, PERC_EFIC_ROT, NUMERO_OPERADORAS, CONSIDERA_EFIC, SEQ_OPERACAO_AGRUPADORA, CODIGO_PARTE_PECA, SEQ_JUNCAO_PARTE_PECA, SITUACAO, PERC_PERDAS, PERC_CUSTOS, IND_ESTAGIO_GARGALO
FROM SYSTEXTIL.MQOP_050 r
WHERE r.GRUPO_ESTRUTURA <= '99999'
  AND r.NUMERO_ROTEIRO IN (2, 3)
  AND r.SEQ_OPERACAO = 10
;

--       e estágio 21 com sequência de opereção 6 e sequencia de estágio 2

INSERT INTO SYSTEXTIL.MQOP_050
(NIVEL_ESTRUTURA, GRUPO_ESTRUTURA, SUBGRU_ESTRUTURA, ITEM_ESTRUTURA, NUMERO_ALTERNATI, NUMERO_ROTEIRO, SEQ_OPERACAO, CODIGO_OPERACAO, MINUTOS, CODIGO_ESTAGIO, CENTRO_CUSTO, SEQUENCIA_ESTAGIO, ESTAGIO_ANTERIOR, ESTAGIO_DEPENDE, SEPARA_OPERACAO, MINUTOS_HOMEM, CCUSTO_HOMEM, NUMERO_CORDAS, NUMERO_ROLOS, VELOCIDADE, CODIGO_FAMILIA, OBSERVACAO, TIPO_PROCESSO, PECAS_1_HORA, PECAS_8_HORAS, CUSTO_MINUTO, PERC_EFICIENCIA, TEMPERATURA, TEMPO_LOTE_PRODUCAO, PECAS_LOTE_PRODUCAO, TIME_CELULA, CODIGO_APARELHO, PERC_EFIC_ROT, NUMERO_OPERADORAS, CONSIDERA_EFIC, SEQ_OPERACAO_AGRUPADORA, CODIGO_PARTE_PECA, SEQ_JUNCAO_PARTE_PECA, SITUACAO, PERC_PERDAS, PERC_CUSTOS, IND_ESTAGIO_GARGALO)
SELECT NIVEL_ESTRUTURA, GRUPO_ESTRUTURA, SUBGRU_ESTRUTURA, ITEM_ESTRUTURA, NUMERO_ALTERNATI, NUMERO_ROTEIRO
, 6 SEQ_OPERACAO
, 21 CODIGO_OPERACAO
, MINUTOS
, 21 CODIGO_ESTAGIO
, CENTRO_CUSTO
, 2 SEQUENCIA_ESTAGIO
, ESTAGIO_ANTERIOR, ESTAGIO_DEPENDE, SEPARA_OPERACAO, MINUTOS_HOMEM, CCUSTO_HOMEM, NUMERO_CORDAS, NUMERO_ROLOS, VELOCIDADE, CODIGO_FAMILIA, OBSERVACAO, TIPO_PROCESSO, PECAS_1_HORA, PECAS_8_HORAS, CUSTO_MINUTO, PERC_EFICIENCIA, TEMPERATURA, TEMPO_LOTE_PRODUCAO, PECAS_LOTE_PRODUCAO, TIME_CELULA, CODIGO_APARELHO, PERC_EFIC_ROT, NUMERO_OPERADORAS, CONSIDERA_EFIC, SEQ_OPERACAO_AGRUPADORA, CODIGO_PARTE_PECA, SEQ_JUNCAO_PARTE_PECA, SITUACAO, PERC_PERDAS, PERC_CUSTOS, IND_ESTAGIO_GARGALO
FROM SYSTEXTIL.MQOP_050 r
WHERE r.GRUPO_ESTRUTURA <= '99999'
  AND r.NUMERO_ROTEIRO IN (2, 3)
  AND r.SEQ_OPERACAO = 10
;

-- baseado em reuniões com Bersange e etc.
-- do roteiro 3 de PA saem os estágios 48, 57 e 60

-- verificar insumos nesses estágios
