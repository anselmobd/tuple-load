SELECT
  le.*
FROM pcpc_040 le
WHERE le.PERIODO_PRODUCAO = 1743
  AND le.ORDEM_CONFECCAO IN (10127, 10128)
  AND le.CODIGO_ESTAGIO in (48, 51)
;


SELECT
  l2.*
FROM pcpc_045 l2
WHERE l2.PCPC040_PERCONF = 1743
  AND l2.PCPC040_ORDCONF IN (10127, 10128)
  AND l2.PCPC040_ESTCONF in (51)
;


SELECT
  l2.*
FROM pcpc_045 l2
JOIN pcpc_040 l
  ON l.PERIODO_PRODUCAO = l2.PCPC040_PERCONF
 AND l.ORDEM_CONFECCAO = l2.PCPC040_ORDCONF
 AND l.CODIGO_ESTAGIO = l2.PCPC040_ESTCONF
WHERE l.ORDEM_PRODUCAO = 3160
--  AND l.QTDE_PECAS_PROD <> 0
--  AND l2.PCPC040_ORDCONF NOT IN (10127, 10128)
  AND l2.PCPC040_ESTCONF = 51
ORDER BY
  l2.PCPC040_ORDCONF
, l2.SEQUENCIA
;


UPDATE SYSTEXTIL.PCPC_040
SET
  PROCONF_NIVEL99 = PROCONF_NIVEL99
, PROCONF_GRUPO = PROCONF_GRUPO
, PROCONF_SUBGRUPO = PROCONF_SUBGRUPO
, PROCONF_ITEM = PROCONF_ITEM
, QTDE_PECAS_PROG = QTDE_PECAS_PROG
, QTDE_PECAS_PROD = 0 ----------------
, QTDE_CONSERTO = QTDE_CONSERTO
, QTDE_PECAS_2A = QTDE_PECAS_2A
, ESTAGIO_ANTERIOR = ESTAGIO_ANTERIOR
, SITUACAO_ORDEM = SITUACAO_ORDEM
, NUMERO_ORDEM = NUMERO_ORDEM
, SEQ_ORDEM_SERV = SEQ_ORDEM_SERV
, DIV_PROD_INT = DIV_PROD_INT
, ORDEM_PRODUCAO = ORDEM_PRODUCAO
, QTDE_PERDAS = QTDE_PERDAS
, QTDE_PROGRAMADA = QTDE_PROGRAMADA
, SEQUENCIA_ESTAGIO = SEQUENCIA_ESTAGIO
, ESTAGIO_DEPENDE = ESTAGIO_DEPENDE
, USUARIO = USUARIO
, CODIGO_FAMILIA = CODIGO_FAMILIA
, POSICAO_FILA = POSICAO_FILA
, POSICAO_FILA_MANUAL = POSICAO_FILA_MANUAL
, SEQ_OPERACAO = SEQ_OPERACAO
, DATA_PREV_INICIO = DATA_PREV_INICIO
, QTDE_PESSOAS_PREV = QTDE_PESSOAS_PREV
, CODIGO_BALANCEIO = CODIGO_BALANCEIO
, NUM_PACOTE_I = NUM_PACOTE_I
, NUM_PACOTE_F = NUM_PACOTE_F
, NUMERO_ID_TMRP_650 = NUMERO_ID_TMRP_650
, EXPORTADO_PMS = EXPORTADO_PMS
, EXECUTA_TRIGGER = EXECUTA_TRIGGER
, SEQUENCIA_ENFESTO = SEQUENCIA_ENFESTO
, EXCLUI_PACOTE = EXCLUI_PACOTE
, SEQ_QUEBRA = SEQ_QUEBRA
, DATA_ALTERACAO = DATA_ALTERACAO
, QTDE_EM_PRODUCAO_PACOTE = QTDE_PECAS_PROD ----------------
, QTDE_A_PRODUZIR_PACOTE = QTDE_PECAS_PROD ----------------
, QTDE_DISPONIVEL_BAIXA = QTDE_PECAS_PROD ----------------
, SITUACAO_EM_PROD_A_PROD = SITUACAO_EM_PROD_A_PROD
, QTDE_PECAS_PROD_RECALC = QTDE_PECAS_PROD_RECALC
, QTDE_CONSERTO_RECALC = QTDE_CONSERTO_RECALC
, QTDE_PECAS_2A_RECALC = QTDE_PECAS_2A_RECALC
, QTDE_PERDAS_RECALC = QTDE_PERDAS_RECALC
, NOME_PROGRAMA_CRIACAO = NOME_PROGRAMA_CRIACAO
, NOME_PROGRAMA = 'pcpc_f046' ----------------
, CODIGO_EMPRESA = CODIGO_EMPRESA
WHERE PERIODO_PRODUCAO = 1743
  AND ORDEM_CONFECCAO = 10128
  AND CODIGO_ESTAGIO = 51
;

--
--

INSERT INTO SYSTEXTIL.PCPC_045
(PCPC040_PERCONF, PCPC040_ORDCONF, PCPC040_ESTCONF, SEQUENCIA, DATA_PRODUCAO, HORA_PRODUCAO, QTDE_PRODUZIDA, QTDE_PECAS_2A, QTDE_CONSERTO, TURNO_PRODUCAO, TIPO_ENTRADA_ORD, NOTA_ENTR_ORDEM, SERIE_NF_ENT_ORD, SEQ_NF_ENTR_ORD, ORDEM_PRODUCAO, CODIGO_USUARIO, QTDE_PERDAS, NUMERO_DOCUMENTO, CODIGO_DEPOSITO, CODIGO_FAMILIA, CODIGO_INTERVALO, EXECUTA_TRIGGER, DATA_INSERCAO, PROCESSO_SYSTEXTIL, NUMERO_VOLUME, NR_OPERADORES, ATZ_PODE_PRODUZIR, ATZ_EM_PROD, ATZ_A_PROD, EFICIENCIA_INFORMADA, USUARIO_SYSTEXTIL, CODIGO_OCORRENCIA, COD_OCORRENCIA_ESTORNO, SOLICITACAO_CONSERTO, NUMERO_SOLICITACAO, NUMERO_ORDEM)
SELECT
  PCPC040_PERCONF
, PCPC040_ORDCONF
, PCPC040_ESTCONF
, SEQUENCIA+1 -- SEQUENCIA
, CURRENT_DATE -- DATA_PRODUCAO
, CURRENT_DATE -- HORA_PRODUCAO
, -QTDE_PRODUZIDA -- QTDE_PRODUZIDA
, QTDE_PECAS_2A
, QTDE_CONSERTO
, TURNO_PRODUCAO
, TIPO_ENTRADA_ORD
, NOTA_ENTR_ORDEM
, SERIE_NF_ENT_ORD
, SEQ_NF_ENTR_ORD
, ORDEM_PRODUCAO
, CODIGO_USUARIO
, QTDE_PERDAS
, NUMERO_DOCUMENTO
, CODIGO_DEPOSITO
, CODIGO_FAMILIA
, CODIGO_INTERVALO
, EXECUTA_TRIGGER
, CURRENT_DATE -- DATA_INSERCAO
, 'pcpc_f046' -- PROCESSO_SYSTEXTIL
, NUMERO_VOLUME
, NR_OPERADORES
, ATZ_PODE_PRODUZIR
, ATZ_EM_PROD
, ATZ_A_PROD
, EFICIENCIA_INFORMADA
, USUARIO_SYSTEXTIL
, CODIGO_OCORRENCIA
, COD_OCORRENCIA_ESTORNO
, SOLICITACAO_CONSERTO
, NUMERO_SOLICITACAO
, NUMERO_ORDEM
FROM SYSTEXTIL.PCPC_045
WHERE PCPC040_PERCONF=1743
  AND PCPC040_ORDCONF=10128
  AND PCPC040_ESTCONF=51
  AND SEQUENCIA=1
;

UPDATE SYSTEXTIL.PCPC_045
SET
  DATA_PRODUCAO=TIMESTAMP '2018-01-24 00:00:00.000000'
, HORA_PRODUCAO=TIMESTAMP '1989-11-16 10:54:00.000000'
, QTDE_PRODUZIDA=-40
, QTDE_PECAS_2A=0
, QTDE_CONSERTO=0
, TURNO_PRODUCAO=3
, TIPO_ENTRADA_ORD=0
, NOTA_ENTR_ORDEM=0
, SERIE_NF_ENT_ORD=NULL
, SEQ_NF_ENTR_ORD=0
, ORDEM_PRODUCAO=3160
, CODIGO_USUARIO=8
, QTDE_PERDAS=0
, NUMERO_DOCUMENTO=0
, CODIGO_DEPOSITO=0
, CODIGO_FAMILIA=0
, CODIGO_INTERVALO=0
, EXECUTA_TRIGGER=3
, DATA_INSERCAO=TIMESTAMP '2018-01-24 10:54:43.000000'
, PROCESSO_SYSTEXTIL='SQL'
, NUMERO_VOLUME=0
, NR_OPERADORES=0
, ATZ_PODE_PRODUZIR=0
, ATZ_EM_PROD=0
, ATZ_A_PROD=0
, EFICIENCIA_INFORMADA=0
, USUARIO_SYSTEXTIL='ROSANGELA_PCP'
, CODIGO_OCORRENCIA=0
, COD_OCORRENCIA_ESTORNO=0
, SOLICITACAO_CONSERTO=0
, NUMERO_SOLICITACAO=0
, NUMERO_ORDEM=0
WHERE PCPC040_PERCONF=1743
  AND PCPC040_ORDCONF=10128
  AND PCPC040_ESTCONF=51
  AND SEQUENCIA=2
;

UPDATE SYSTEXTIL.PCPC_045
SET
  PROCESSO_SYSTEXTIL='pcpc_f046'
, USUARIO_SYSTEXTIL='ROSANGELA_PCP'
WHERE PCPC040_PERCONF=1743
  AND PCPC040_ORDCONF=10128
  AND PCPC040_ESTCONF=51
  AND SEQUENCIA=2
;

INSERT INTO SYSTEXTIL.PCPC_045
(PCPC040_PERCONF, PCPC040_ORDCONF, PCPC040_ESTCONF, SEQUENCIA, DATA_PRODUCAO, HORA_PRODUCAO, QTDE_PRODUZIDA, QTDE_PECAS_2A, QTDE_CONSERTO, TURNO_PRODUCAO, TIPO_ENTRADA_ORD, NOTA_ENTR_ORDEM, SERIE_NF_ENT_ORD, SEQ_NF_ENTR_ORD, ORDEM_PRODUCAO, CODIGO_USUARIO, QTDE_PERDAS, NUMERO_DOCUMENTO, CODIGO_DEPOSITO, CODIGO_FAMILIA, CODIGO_INTERVALO, EXECUTA_TRIGGER, DATA_INSERCAO, PROCESSO_SYSTEXTIL, NUMERO_VOLUME, NR_OPERADORES, ATZ_PODE_PRODUZIR, ATZ_EM_PROD, ATZ_A_PROD, EFICIENCIA_INFORMADA, USUARIO_SYSTEXTIL, CODIGO_OCORRENCIA, COD_OCORRENCIA_ESTORNO, SOLICITACAO_CONSERTO, NUMERO_SOLICITACAO, NUMERO_ORDEM)
SELECT
  l2.PCPC040_PERCONF
, l2.PCPC040_ORDCONF
, l2.PCPC040_ESTCONF
, l2.SEQUENCIA+1 -- SEQUENCIA
, CURRENT_DATE -- DATA_PRODUCAO
, CURRENT_DATE -- HORA_PRODUCAO
, -l2.QTDE_PRODUZIDA -- QTDE_PRODUZIDA
, l2.QTDE_PECAS_2A
, l2.QTDE_CONSERTO
, l2.TURNO_PRODUCAO
, l2.TIPO_ENTRADA_ORD
, l2.NOTA_ENTR_ORDEM
, l2.SERIE_NF_ENT_ORD
, l2.SEQ_NF_ENTR_ORD
, l2.ORDEM_PRODUCAO
, l2.CODIGO_USUARIO
, l2.QTDE_PERDAS
, l2.NUMERO_DOCUMENTO
, l2.CODIGO_DEPOSITO
, l2.CODIGO_FAMILIA
, l2.CODIGO_INTERVALO
, l2.EXECUTA_TRIGGER
, CURRENT_DATE -- DATA_INSERCAO
, 'pcpc_f046' -- PROCESSO_SYSTEXTIL
, l2.NUMERO_VOLUME
, l2.NR_OPERADORES
, l2.ATZ_PODE_PRODUZIR
, l2.ATZ_EM_PROD
, l2.ATZ_A_PROD
, l2.EFICIENCIA_INFORMADA
, l2.USUARIO_SYSTEXTIL
, l2.CODIGO_OCORRENCIA
, l2.COD_OCORRENCIA_ESTORNO
, l2.SOLICITACAO_CONSERTO
, l2.NUMERO_SOLICITACAO
, l2.NUMERO_ORDEM
FROM pcpc_045 l2
JOIN pcpc_040 l
  ON l.PERIODO_PRODUCAO = l2.PCPC040_PERCONF
 AND l.ORDEM_CONFECCAO = l2.PCPC040_ORDCONF
 AND l.CODIGO_ESTAGIO = l2.PCPC040_ESTCONF
WHERE l.ORDEM_PRODUCAO = 3160
  AND l.QTDE_PECAS_PROD <> 0
  AND l2.PCPC040_ORDCONF NOT IN (10127, 10128)
  AND l2.PCPC040_ESTCONF = 51
;

UPDATE SYSTEXTIL.PCPC_045 l2
SET
  l2.CODIGO_USUARIO = 99001
, l2.PROCESSO_SYSTEXTIL='pcpc_f046'
, l2.USUARIO_SYSTEXTIL='ANSELMO_SIS'
WHERE l2.PCPC040_PERCONF=1743
  AND l2.PCPC040_ORDCONF in
  (
  SELECT
    l.ORDEM_CONFECCAO
  FROM pcpc_040 l
  WHERE l.ORDEM_PRODUCAO = 3160
  )
  AND l2.PCPC040_ESTCONF=51
  AND l2.SEQUENCIA=2
;
