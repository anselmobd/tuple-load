--título 72653-1
--

SELECT
  cp.COMPL_HISTORICO
, cp.*
FROM CPAG_010 cp
WHERE 1=1
--  AND cp.DOCUMENTO = 72653
--  AND cp.COMPL_HISTORICO LIKE '%L%'
;

SELECT
  cp.COMPL_HISTORICO
, cp.*
FROM CPAG_010 cp
--WHERE cp.COMPL_HISTORICO LIKE '%L%'
;

-- Ops! Não é a pagar e a receber

SELECT
  bol.COMPL_HISTORICO
, bol.*
FROM FATU_070 bol
WHERE bol.COMPL_HISTORICO LIKE '%AL%'
;

select col.column_id,
       col.owner as schema_name,
       col.table_name,
       col.column_name,
       col.data_type,
       col.data_length,
       col.data_precision,
       col.data_scale,
       col.nullable
from sys.dba_tab_columns col
inner join sys.dba_tables t on col.owner = t.owner
                              and col.table_name = t.table_name
WHERE 1=1
  AND col.column_name like '%HIST_PGTO%'
--where col.owner = 'AP'
--and col.table_name = 'AP_INVOICES_ALL'
order by col.column_id
;

select col.column_id,
       col.owner as schema_name,
       col.table_name,
       col.column_name,
       col.data_type,
       col.data_length,
       col.data_precision,
       col.data_scale,
       col.nullable
from sys.dba_tab_columns col
inner join sys.dba_views v
  on col.owner = v.owner
 and col.table_name = v.view_name
WHERE 1=1
  AND col.column_name like '%DESCR_TIPO_INF%'
order by col.owner, col.table_name, col.column_id
;

-- salva view atual

select dbms_metadata.get_ddl('VIEW','STVIEW_TITULOS_RECEBER','SYSTEXTIL') from dual;

-- redefine view adicionando campo

CREATE OR REPLACE
VIEW SYSTEXTIL.STVIEW_TITULOS_RECEBER (
EMPRESA,
NOME_EMPRESA,
DUPLICATA,
SEQ_DUPLICATA,
SEQ_PGTO,
NOTA_FISCAL,
PEDIDO_VENDA,
SITUACAO_DUPL,
DESCR_SIT_DUPL,
TIPO_TITULO,
DESCR_TIPO_TIT,
CNPJ9,
CNPJ4,
CNPJ2,
NOME_CLIENTE,
FANTASIA_CLIENTE,
DDD,
TELEFONE_CLIENTE,
CELULAR_CLIENTE,
CDREPRES_CLIENTE,
NOME_REP_CLIENTE,
BANCO,
NOME_BANCO,
COD_CARTEIRA,
POSICAO,
DESCR_POSICAO,
DATA_EMISSAO,
DATA_VENCIMENTO,
DATA_PRORROGACAO,
CONTA_CORRENTE,
VALOR_DUPLICATA,
SALDO_DUPLICATA,
SALDO_COM_CHEQUE,
PREVISAO,
ORIGEM,
DESCR_ORIGEM,
COD_CANC,
DESCR_CANC,
DATA_PAGAMENTO,
DATA_CREDITO,
VALOR_PAGO,
VALOR_DESCONTOS,
VALOR_JUROS,
HISTORICO,
DESCR_HIST,
TIPO_HIST,
SEQ_INFORMACAO,
DATA_INFORMACAO,
HORA_INFORMACAO,
TIPO_INFORMACAO,
DESCR_TIPO_INF,
INFORMANTE,
DATA_COMPL,
INFORMACAO,
COMPL_HISTORICO
) AS
SELECT
  a.codigo_empresa EMPRESA,
  b.nome_empresa NOME_EMPRESA,
  a.num_duplicata DUPLICATA,
  a.seq_duplicatas SEQ_DUPLICATA,
  j.seq_pagamento SEQ_PGTO,
  a.num_nota_fiscal NOTA_FISCAL,
  a.pedido_venda PEDIDO_VENDA,
  a.situacao_duplic SITUACAO_DUPL,
  DECODE(a.situacao_duplic, 0, 'ABERTO', 1, 'PAGO TOTAL', 2, 'CANCELADO', 3, 'PAGO A MENOR', 'PAGO A MAIOR') DESCR_SIT_DUPL,
  a.tipo_titulo,
  c.descricao DESCR_TIPO_TIT,
  a.cli_dup_cgc_cli9 CNPJ9,
  a.cli_dup_cgc_cli4 CNPJ4,
  a.cli_dup_cgc_cli2 CNPJ2,
  d.nome_cliente,
  d.fantasia_cliente,
  o.ddd,
  d.telefone_cliente,
  d.celular_cliente,
  d.cdrepres_cliente,
  n.nome_rep_cliente,
  a.portador_duplic BANCO,
  e.nome_banco,
  a.cod_carteira,
  a.posicao_duplic POSICAO,
  f.descricao DESCR_POSICAO,
  a.data_emissao,
  a.data_venc_duplic DATA_VENCIMENTO,
  a.data_prorrogacao,
  a.conta_corrente,
  a.valor_duplicata,
  a.saldo_duplicata,
  NVL((a.saldo_duplicata - DECODE((SELECT SUM(i.valor_usado) FROM crec_180 i WHERE i.empresa = a.codigo_empresa AND ((i.cgc9_cli = a.cli9resptit AND i.cgc4_cli = a.cli4resptit AND i.cgc2_cli = a.cli2resptit AND i.chq_resp = 1 AND (i.cgc9_cli <> a.cli_dup_cgc_cli9 OR i.cgc4_cli <> a.cli_dup_cgc_cli4 OR i.cgc2_cli <> a.cli_dup_cgc_cli2)) OR (i.cgc9_cli = a.cli_dup_cgc_cli9 AND i.cgc4_cli = a.cli_dup_cgc_cli4 AND i.cgc2_cli = a.cli_dup_cgc_cli2 AND i.chq_resp = 0)) AND i.tipo_titulo = a.tipo_titulo AND i.numero_titulo = a.num_duplicata AND i.parcela_titulo = a.seq_duplicatas AND i.flag_reg = 0), NULL, 0, (SELECT SUM(i.valor_usado) FROM crec_180 i WHERE i.empresa = a.codigo_empresa AND ((i.cgc9_cli = a.cli9resptit AND i.cgc4_cli = a.cli4resptit AND i.cgc2_cli = a.cli2resptit AND i.chq_resp = 1 AND (i.cgc9_cli <> a.cli_dup_cgc_cli9 OR i.cgc4_cli <> a.cli_dup_cgc_cli4 OR i.cgc2_cli <> a.cli_dup_cgc_cli2)) OR (i.cgc9_cli = a.cli_dup_cgc_cli9 AND i.cgc4_cli = a.cli_dup_cgc_cli4 AND i.cgc2_cli = a.cli_dup_cgc_cli2 AND i.chq_resp = 0)) AND i.tipo_titulo = a.tipo_titulo AND i.numero_titulo = a.num_duplicata AND i.parcela_titulo = a.seq_duplicatas AND i.flag_reg = 0)) ), 0.00) SALDO_COM_CHEQUE,
  DECODE(a.previsao, 0, 'CONFIRMADO', 'PREVISTO') PREVISAO,
  a.origem_pedido ORIGEM,
  g.descr_origem DESCR_ORIGEM,
  a.cod_canc_duplic COD_CANC,
  h.des_canc_nfiscal DESCR_CANC,
  j.data_pagamento,
  j.data_credito,
  j.valor_pago,
  j.valor_descontos,
  j.valor_juros,
  j.historico_pgto HISTORICO,
  k.historico_contab DESCR_HIST,
  DECODE(k.sinal_titulo, 0, 'NEUTRO', 1, 'BAIXA', 2, 'ESTORNO', '') TIPO_HIST,
  l.seq_informacao,
  l.data_informacao,
  TO_CHAR(l.hora_informacao, 'HH:MI:SS') HORA_INFORMACAO,
  l.tipo_informacao,
  m.descricao DESCR_TIPO_INF,
  l.informante,
  l.data_complemento DATA_COMPL,
  l.descricao INFORMACAO,
  a.COMPL_HISTORICO
FROM
  fatu_070 a,
  fatu_500 b,
  cpag_040 c,
  pedi_010 d,
  pedi_050 e,
  crec_010 f,
  pedi_115 g,
  fatu_010 h,
  fatu_075 j,
  cont_010 k,
  crec_450 l,
  pedi_247 m,
  pedi_020 n,
  basi_160 o
WHERE
  a.codigo_empresa = b.codigo_empresa
  AND a.tipo_titulo = c.tipo_titulo
  AND a.cli_dup_cgc_cli9 = d.cgc_9
  AND a.cli_dup_cgc_cli4 = d.cgc_4
  AND a.cli_dup_cgc_cli2 = d.cgc_2
  AND d.cdrepres_cliente = n.cod_rep_cliente
  AND d.cod_cidade = o.cod_cidade
  AND a.portador_duplic = e.cod_portador (+)
  AND a.posicao_duplic = f.posicao_duplic (+)
  AND a.origem_pedido = g.origem (+)
  AND a.cod_canc_duplic = h.cod_canc_nfiscal (+)
  AND a.codigo_empresa = j.nr_titul_codempr (+)
  AND a.cli_dup_cgc_cli9 = j.nr_titul_cli_dup_cgc_cli9 (+)
  AND a.cli_dup_cgc_cli4 = j.nr_titul_cli_dup_cgc_cli4 (+)
  AND a.cli_dup_cgc_cli2 = j.nr_titul_cli_dup_cgc_cli2 (+)
  AND a.tipo_titulo = j.nr_titul_cod_tit (+)
  AND a.num_duplicata = j.nr_titul_num_dup (+)
  AND a.seq_duplicatas = j.nr_titul_seq_dup (+)
  AND j.historico_pgto = k.codigo_historico (+)
  AND a.codigo_empresa = l.codigo_empresa (+)
  AND a.cli_dup_cgc_cli9 = l.cnpj_cli9 (+)
  AND a.cli_dup_cgc_cli4 = l.cnpj_cli4 (+)
  AND a.cli_dup_cgc_cli2 = l.cnpj_cli2 (+)
  AND a.tipo_titulo = l.tipo_titulo (+)
  AND a.num_duplicata = l.num_duplicata (+)
  AND a.seq_duplicatas = l.seq_duplicatas (+)
  AND l.tipo_informacao = m.tipo_informacao (+)
ORDER BY
  a.codigo_empresa,
  a.cli_dup_cgc_cli9,
  a.cli_dup_cgc_cli4,
  a.cli_dup_cgc_cli2,
  a.tipo_titulo,
  a.num_duplicata,
  a.seq_duplicatas,
  j.data_pagamento,
  l.seq_informacao
;

-- registra o campo

SELECT
  f.*
FROM RGEN_QUERY_FIELD f
WHERE 1=1
  AND f.NAME = 'DESCR_TIPO_INF'
;

SELECT
  q.*
FROM RGEN_QUERY q
WHERE 1=1
  AND q.ID = 1074
;

-- obs: ID tem que ser forçado, não é autoincrementado
-- utilizei como ID o que seria o número do próximo ID somado a 100.000

INSERT INTO SYSTEXTIL.RGEN_QUERY_FIELD
(ID, NAME, "TYPE", QUERY_ID)
VALUES(101535, 'COMPL_HISTORICO', 'text', 1074);

SELECT
  f.*
FROM RGEN_QUERY_FIELD f
WHERE 1=1
  AND f.QUERY_ID = 1074
;
