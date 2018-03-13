DELETE FROM BASI_070 rc -- capa de roteiro
--SELECT * FROM BASI_070 rc -- capa de roteiro
WHERE rc.NIVEL='1'
  AND rc.GRUPO IN
(
	SELECT
	  r.REFERENCIA
	FROM basi_030 r -- referência
	WHERE r.NIVEL_ESTRUTURA = 1
	  AND r.RESPONSAVEL IS NOT NULL
    AND (
       r.REFERENCIA like 'T%'
    OR r.REFERENCIA like 'R%'
    )
    AND r.COLECAO IN (1, 2, 3, 4, 13, 14, 15)
)
  AND rc.ROTEIRO IN (3)
;

INSERT INTO SYSTEXTIL.BASI_070
(NIVEL, GRUPO, ITEM, ROTEIRO, SUBGRUPO, ALTERNATIVA, DESCRICAO, LARGURA, GRAMATURA, RENDIMENTO)
SELECT
  rc.NIVEL
, REF.REFERENCIA GRUPO
, rc.ITEM
, rc.ROTEIRO
, rc.SUBGRUPO
, rc.ALTERNATIVA
, rc.DESCRICAO
, rc.LARGURA
, rc.GRAMATURA
, rc.RENDIMENTO
FROM BASI_070 rc -- roteiro capa
,
(
	SELECT
	  r.REFERENCIA
	FROM basi_030 r -- referência
	WHERE r.NIVEL_ESTRUTURA = 1
	  AND r.RESPONSAVEL IS NOT NULL
    AND (
       r.REFERENCIA like 'T%'
    OR r.REFERENCIA like 'R%'
    )
    AND r.COLECAO IN (1, 2, 3, 4, 13, 14, 15)
) ref
WHERE rc.NIVEL='1'
  AND rc.GRUPO='Z01MD'
  AND rc.ROTEIRO IN (3)
;

DELETE FROM MQOP_050 rop -- lista de operações de um roteiro
--SELECT * FROM MQOP_050 rop -- lista de operações de um roteiro
WHERE rop.NIVEL_ESTRUTURA = '1'
  AND rop.GRUPO_ESTRUTURA IN (
	SELECT
	  r.REFERENCIA
	FROM basi_030 r -- referência
	WHERE r.NIVEL_ESTRUTURA = 1
	  AND r.RESPONSAVEL IS NOT NULL
    AND (
       r.REFERENCIA like 'T%'
    OR r.REFERENCIA like 'R%'
    )
    AND r.COLECAO IN (1, 2, 3, 4, 13, 14, 15)
)
  AND rop.NUMERO_ROTEIRO IN (3)
;

INSERT INTO MQOP_050
(NIVEL_ESTRUTURA, GRUPO_ESTRUTURA, SUBGRU_ESTRUTURA, ITEM_ESTRUTURA, NUMERO_ALTERNATI, NUMERO_ROTEIRO, SEQ_OPERACAO, CODIGO_OPERACAO, MINUTOS, CODIGO_ESTAGIO, CENTRO_CUSTO, SEQUENCIA_ESTAGIO, ESTAGIO_ANTERIOR, ESTAGIO_DEPENDE, SEPARA_OPERACAO, MINUTOS_HOMEM, CCUSTO_HOMEM, NUMERO_CORDAS, NUMERO_ROLOS, VELOCIDADE, CODIGO_FAMILIA, OBSERVACAO, TIPO_PROCESSO, PECAS_1_HORA, PECAS_8_HORAS, CUSTO_MINUTO, PERC_EFICIENCIA, TEMPERATURA, TEMPO_LOTE_PRODUCAO, PECAS_LOTE_PRODUCAO, TIME_CELULA, CODIGO_APARELHO, PERC_EFIC_ROT, NUMERO_OPERADORAS, CONSIDERA_EFIC, SEQ_OPERACAO_AGRUPADORA, CODIGO_PARTE_PECA, SEQ_JUNCAO_PARTE_PECA, SITUACAO, PERC_PERDAS, PERC_CUSTOS, IND_ESTAGIO_GARGALO)
SELECT
  rop.NIVEL_ESTRUTURA
, REF.REFERENCIA GRUPO_ESTRUTURA
, rop.SUBGRU_ESTRUTURA
, rop.ITEM_ESTRUTURA
, rop.NUMERO_ALTERNATI
, rop.NUMERO_ROTEIRO
, rop.SEQ_OPERACAO
, rop.CODIGO_OPERACAO
, rop.MINUTOS
, rop.CODIGO_ESTAGIO
, rop.CENTRO_CUSTO
, rop.SEQUENCIA_ESTAGIO
, rop.ESTAGIO_ANTERIOR
, rop.ESTAGIO_DEPENDE
, rop.SEPARA_OPERACAO
, rop.MINUTOS_HOMEM
, rop.CCUSTO_HOMEM
, rop.NUMERO_CORDAS
, rop.NUMERO_ROLOS
, rop.VELOCIDADE
, rop.CODIGO_FAMILIA
, rop.OBSERVACAO
, rop.TIPO_PROCESSO
, rop.PECAS_1_HORA
, rop.PECAS_8_HORAS
, rop.CUSTO_MINUTO
, rop.PERC_EFICIENCIA
, rop.TEMPERATURA
, rop.TEMPO_LOTE_PRODUCAO
, rop.PECAS_LOTE_PRODUCAO
, rop.TIME_CELULA
, rop.CODIGO_APARELHO
, rop.PERC_EFIC_ROT
, rop.NUMERO_OPERADORAS
, rop.CONSIDERA_EFIC
, rop.SEQ_OPERACAO_AGRUPADORA
, rop.CODIGO_PARTE_PECA
, rop.SEQ_JUNCAO_PARTE_PECA
, rop.SITUACAO
, rop.PERC_PERDAS
, rop.PERC_CUSTOS
, rop.IND_ESTAGIO_GARGALO
FROM MQOP_050 rop
,
(
	SELECT
	  r.REFERENCIA
	FROM basi_030 r -- referência
	WHERE r.NIVEL_ESTRUTURA = 1
	  AND r.RESPONSAVEL IS NOT NULL
    AND (
       r.REFERENCIA like 'T%'
    OR r.REFERENCIA like 'R%'
    )
    AND r.COLECAO IN (1, 2, 3, 4, 13, 14, 15)
) ref
WHERE rop.NIVEL_ESTRUTURA = '1'
  AND rop.GRUPO_ESTRUTURA = 'Z01MD'
	AND rop.NUMERO_ROTEIRO IN (3)
;
