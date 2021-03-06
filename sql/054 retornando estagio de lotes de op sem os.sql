SELECT
  l.CODIGO_ESTAGIO
, l.QTDE_PROGRAMADA Q_P
, l.QTDE_EM_PRODUCAO_PACOTE Q_EP
, l.QTDE_A_PRODUZIR_PACOTE Q_AP
, l.CODIGO_FAMILIA FAMI
, l.NUMERO_ORDEM OS
FROM PCPC_040 l
WHERE l.PERIODO_PRODUCAO = 1725
  AND l.ORDEM_CONFECCAO = 34
ORDER BY
  l.SEQ_OPERACAO
;

INSERT INTO SYSTEXTIL.PCPC_045
(PCPC040_PERCONF, PCPC040_ORDCONF, PCPC040_ESTCONF, SEQUENCIA, DATA_PRODUCAO, HORA_PRODUCAO, QTDE_PRODUZIDA, QTDE_PECAS_2A, QTDE_CONSERTO, TURNO_PRODUCAO, TIPO_ENTRADA_ORD, NOTA_ENTR_ORDEM, SERIE_NF_ENT_ORD, SEQ_NF_ENTR_ORD, ORDEM_PRODUCAO, CODIGO_USUARIO, QTDE_PERDAS, NUMERO_DOCUMENTO, CODIGO_DEPOSITO, CODIGO_FAMILIA, CODIGO_INTERVALO, EXECUTA_TRIGGER, DATA_INSERCAO, PROCESSO_SYSTEXTIL, NUMERO_VOLUME, NR_OPERADORES, ATZ_PODE_PRODUZIR, ATZ_EM_PROD, ATZ_A_PROD, EFICIENCIA_INFORMADA, USUARIO_SYSTEXTIL, CODIGO_OCORRENCIA, COD_OCORRENCIA_ESTORNO, SOLICITACAO_CONSERTO, NUMERO_SOLICITACAO, NUMERO_ORDEM)
SELECT PCPC040_PERCONF, PCPC040_ORDCONF, 48, SEQUENCIA, DATA_PRODUCAO, HORA_PRODUCAO, QTDE_PRODUZIDA, QTDE_PECAS_2A, QTDE_CONSERTO, TURNO_PRODUCAO, TIPO_ENTRADA_ORD, NOTA_ENTR_ORDEM, SERIE_NF_ENT_ORD, SEQ_NF_ENTR_ORD, ORDEM_PRODUCAO, CODIGO_USUARIO, QTDE_PERDAS, NUMERO_DOCUMENTO, CODIGO_DEPOSITO, CODIGO_FAMILIA, CODIGO_INTERVALO, EXECUTA_TRIGGER, DATA_INSERCAO, PROCESSO_SYSTEXTIL, NUMERO_VOLUME, NR_OPERADORES, ATZ_PODE_PRODUZIR, ATZ_EM_PROD, ATZ_A_PROD, EFICIENCIA_INFORMADA, USUARIO_SYSTEXTIL, CODIGO_OCORRENCIA, COD_OCORRENCIA_ESTORNO, SOLICITACAO_CONSERTO, NUMERO_SOLICITACAO, NUMERO_ORDEM
FROM SYSTEXTIL.PCPC_045
WHERE PCPC040_PERCONF=1725 AND PCPC040_ORDCONF=33 AND PCPC040_ESTCONF=51 AND SEQUENCIA=2
;

--

UPDATE SYSTEXTIL.PCPC_045
SET
  PROCESSO_SYSTEXTIL = 'pcpc_f046'
WHERE PCPC040_PERCONF=1725 AND PCPC040_ORDCONF=33 AND PCPC040_ESTCONF=48 AND SEQUENCIA=2
;

--

UPDATE SYSTEXTIL.PCPC_045
SET
  USUARIO_SYSTEXTIL = 'ANSELMO_SIS'
WHERE PCPC040_PERCONF=1725 AND PCPC040_ORDCONF=33 AND PCPC040_ESTCONF=48 AND SEQUENCIA=2
;

--

SELECT
  lo.ORDEM_CONFECCAO
FROM (
--
  SELECT
    max( os.NUMERO_ORDEM ) NUMERO_ORDEM
  , os.PERIODO_PRODUCAO
  , os.ORDEM_CONFECCAO
  FROM PCPC_040 os
  WHERE os.ORDEM_PRODUCAO = 23
  GROUP BY
    os.PERIODO_PRODUCAO
  , os.ORDEM_CONFECCAO
--  ORDER BY
--    1 DESC
--;
--
) lo
WHERE 1=1
  AND lo.NUMERO_ORDEM = 0
;

--

SELECT
  l.*
FROM PCPC_040 l
WHERE l.PERIODO_PRODUCAO = 1725
  AND l.ORDEM_CONFECCAO = 34
;

--

UPDATE PCPC_040 l
SET
  l.QTDE_PECAS_PROD =
    CASE WHEN l.SEQ_OPERACAO < 60
    THEN l.QTDE_PECAS_PROG
    ELSE 0
    END
, l.QTDE_EM_PRODUCAO_PACOTE =
    CASE WHEN l.SEQ_OPERACAO = 60
    THEN l.QTDE_PECAS_PROG
    ELSE 0
    END
, l.QTDE_A_PRODUZIR_PACOTE =
    CASE WHEN l.SEQ_OPERACAO >= 60
    THEN l.QTDE_PECAS_PROG
    ELSE 0
    END
, l.QTDE_DISPONIVEL_BAIXA =
    CASE WHEN l.SEQ_OPERACAO = 60
    THEN l.QTDE_PECAS_PROG
    ELSE 0
    END
WHERE l.PERIODO_PRODUCAO = 1725
  AND l.ORDEM_CONFECCAO = 34
;

--

UPDATE PCPC_040 l
SET
  l.QTDE_EM_PRODUCAO_PACOTE =
    CASE WHEN l.SEQ_OPERACAO = 60
    THEN l.QTDE_PECAS_PROG
    ELSE 0
    END
, l.QTDE_A_PRODUZIR_PACOTE =
    CASE WHEN l.SEQ_OPERACAO >= 60
    THEN l.QTDE_PECAS_PROG
    ELSE 0
    END
, l.QTDE_DISPONIVEL_BAIXA =
    CASE WHEN l.SEQ_OPERACAO = 60
    THEN l.QTDE_PECAS_PROG
    ELSE 0
    END
WHERE l.PERIODO_PRODUCAO = 1725
  AND l.ORDEM_CONFECCAO IN (
	SELECT
	  lo.ORDEM_CONFECCAO
	FROM (
	  SELECT
	    max( os.NUMERO_ORDEM ) NUMERO_ORDEM
	  , os.PERIODO_PRODUCAO
	  , os.ORDEM_CONFECCAO
	  FROM PCPC_040 os
	  WHERE os.ORDEM_PRODUCAO = 23
	  GROUP BY
	    os.PERIODO_PRODUCAO
	  , os.ORDEM_CONFECCAO
	) lo
	WHERE lo.NUMERO_ORDEM = 0
  )
;

-- !!! isso não foi o suficiente para voltar os estágios

--

SELECT
  coalesce(d.USUARIO_SYSTEXTIL, ' ') USU
, TO_CHAR(d.DATA_INSERCAO, 'DD/MM/YYYY HH24:MI') DT
, coalesce(d.PROCESSO_SYSTEXTIL || ' - ' || p.DESCRICAO, ' ') PRG
, d.*
FROM PCPC_045 d
LEFT JOIN HDOC_036 p
  ON p.CODIGO_PROGRAMA = d.PROCESSO_SYSTEXTIL
 AND p.LOCALE = 'pt_BR'
WHERE d.PCPC040_PERCONF = 1725
  AND d.PCPC040_ORDCONF = 33
ORDER BY
  d.DATA_INSERCAO
;

--

-- DEMOROU MUITO!!!!!!! DESISTI de simular uso do sistema
UPDATE SYSTEXTIL.HDOC_090
SET
  PROGRAMA='pcpc_f046'
WHERE USUARIO='ANSELMO_SIS'
;

-- vou apagar uso do sistema

SELECT
  d.*
--DELETE
FROM PCPC_045 d
WHERE d.PCPC040_PERCONF = 1725
  AND d.PCPC040_ESTCONF IN (51, 48, 45, 55, 24, 39, 21)
  AND d.PCPC040_ORDCONF IN (
	SELECT
	  lo.ORDEM_CONFECCAO
	FROM (
	  SELECT
	    max( os.NUMERO_ORDEM ) NUMERO_ORDEM
	  , os.PERIODO_PRODUCAO
	  , os.ORDEM_CONFECCAO
	  FROM PCPC_040 os
	  WHERE os.ORDEM_PRODUCAO = 23
	  GROUP BY
	    os.PERIODO_PRODUCAO
	  , os.ORDEM_CONFECCAO
	) lo
	WHERE lo.NUMERO_ORDEM = 0
  )
;
