-- INCLUSÃO DE NOTAS DE SAIDA PARA REFERENCIAR DEVOLUÇÕES
-- ======================================================

insert into fatu_050
  (codigo_empresa, num_nota_fiscal, serie_nota_fisc, especie_docto, data_base_fatur, data_saida, data_emissao, cgc_9, cgc_4, cgc_2, cliente_fornec,
  cod_rep_cliente, portador, natop_nf_nat_oper, natop_nf_est_oper, classif_contabil, cond_pgto_venda, cod_canc_nfisc, pedido_venda, nr_solicitacao,
  qtde_itens, quantidade, peso_liquido, peso_bruto, desconto1, desconto2, desconto3, encargos, valor_itens_nfis, valor_seguro, valor_encar_nota,
  valor_desc_nota, valor_desconto, valor_despesas, valor_ipi, base_icms, valor_icms, valor_icms_frete, valor_frete_nfis, tipo_frete, tipo_frete_redes,
  via_transporte, transpor_forne9, transpor_forne4, transpor_forne2, observacao_01, observacao_02, nr_volume, marca_volumes, especie_volume, codigo_embalagem,
  qtde_embalagens, terceiros, situacao_nfisc, msg_corpo1, msg_corpo2, seq_end_entr, seq_end_cobr, base_icms_sub, valor_icms_sub, historico_cont, valor_suframa,
  nota_fatura, nota_entrega, flag_devolucao, flag_contabil, col_tabela, mes_tabela, seq_tabela, serie_fatura, perc_iva_1, perc_iva_2, valor_iva_1, valor_iva_2,
  cod_vendedor, perc_repres, perc_vendedor, tipo_desconto, vlr_desc_especial, num_contabil, transp_redespacho9, transp_redespacho4, transp_redespacho2,
  origem_nota, nr_cupom, placa_veiculo, cli9resptit, cli4resptit, cli2resptit, origem_pedido, selo_inicial, selo_final, tipo_comissao, hora_saida,
  metros_cubicos_nota, tarifa_frete, situacao_edi, status_frete, perc_iss, numero_re, numero_di, num_serie_ecf, num_intervencao, forma_pgto,
  numero_consignacao, flag_nota_loja, valor_iss, gerou_retorno_servico, nr_processo_export, num_container_exp, num_lacre_exp, numero_formulario,
  moeda_nota, nsu, data_nsu, hora_nsu, codigo_cai, dt_valida_cai, cod_carta_credito, num_form_inicial, num_form_final, ntermo_venda, nlocal_embarque,
  codigo_condutor, vr_indice_moeda, origem, processado_drawback, cod_impressora_fiscal, tipo_valor_nf, numero_danf_nfe,
   nr_declaracao_exp_sped, data_exp_sped, tipo_exp_sped, data_registro_exp_sped, conhecimento_emb_sped, data_conhecimento_emb_sped,
   tipo_inform_conhecimento_sped, codigo_pais_siscomex_sped, data_averbacao_sped, tipo_valores_fiscal, nr_recibo, nr_protocolo, justificativa,
   ano_inutilizacao, nr_final_inut, cod_status, msg_status, cod_solicitacao_nfe, status_impressao_danfe, nr_romaneio_kg, nfe_contigencia,
   tipo_nat_exp_sped, cod_justificativa, tipo_nf_referenciada, xml_nprot, versao_systextilnfe, cod_moeda_exp, local_impressao, integrado_decisor,
   cnpj9_fatura, cnpj4_fatura, cnpj2_fatura, chave_contingencia, considera_inventario, data_autorizacao_nfe, cod_local, etiq_impressa, nr_solicitacao_dav,
   st_flag_cce, exportada, nota_estorno, justificativa_cont, data_hora_contigencia, percentual_negociado)
select
--   vvvvv -- nota do sistema antigo - devolvida
  1, 55612, '1', especie_docto, '01-jan-17', '01-jan-17', '01-jan-17',
--vvvvvvvv  vvvv  vv -- CNPJ do cliente da nota devolvida
  48076228, 0023, 05, cliente_fornec, cod_rep_cliente, portador, natop_nf_nat_oper, natop_nf_est_oper, classif_contabil, cond_pgto_venda, cod_canc_nfisc, pedido_venda, nr_solicitacao, qtde_itens, quantidade, peso_liquido, peso_bruto, desconto1, desconto2, desconto3, encargos, valor_itens_nfis, valor_seguro, valor_encar_nota, valor_desc_nota, valor_desconto, valor_despesas, valor_ipi, base_icms, valor_icms, valor_icms_frete, valor_frete_nfis, tipo_frete, tipo_frete_redes, via_transporte, transpor_forne9, transpor_forne4, transpor_forne2, observacao_01, observacao_02, nr_volume, marca_volumes, especie_volume, codigo_embalagem, qtde_embalagens, terceiros, situacao_nfisc, msg_corpo1, msg_corpo2, seq_end_entr, seq_end_cobr, base_icms_sub, valor_icms_sub, historico_cont, valor_suframa, nota_fatura, nota_entrega, flag_devolucao, flag_contabil, col_tabela, mes_tabela, seq_tabela, serie_fatura, perc_iva_1, perc_iva_2, valor_iva_1, valor_iva_2, cod_vendedor, perc_repres, perc_vendedor, tipo_desconto, vlr_desc_especial, num_contabil, transp_redespacho9, transp_redespacho4, transp_redespacho2, origem_nota, nr_cupom, placa_veiculo, cli9resptit, cli4resptit, cli2resptit, origem_pedido, selo_inicial, selo_final, tipo_comissao, hora_saida, metros_cubicos_nota, tarifa_frete, situacao_edi, status_frete, perc_iss, numero_re, numero_di, num_serie_ecf, num_intervencao, forma_pgto, numero_consignacao, flag_nota_loja, valor_iss, gerou_retorno_servico, nr_processo_export, num_container_exp, num_lacre_exp, numero_formulario, moeda_nota, nsu, data_nsu, hora_nsu, codigo_cai, dt_valida_cai, cod_carta_credito, num_form_inicial, num_form_final, ntermo_venda, nlocal_embarque, codigo_condutor, vr_indice_moeda, origem, processado_drawback, cod_impressora_fiscal, tipo_valor_nf,
-- vvvvvvvvvvvvvvvvvvv... -- chave da nota devolvida
  '33170407681643000197550010000556121468040532', nr_declaracao_exp_sped, data_exp_sped, tipo_exp_sped, data_registro_exp_sped, conhecimento_emb_sped, data_conhecimento_emb_sped, tipo_inform_conhecimento_sped, codigo_pais_siscomex_sped, data_averbacao_sped, tipo_valores_fiscal, nr_recibo, nr_protocolo, justificativa, ano_inutilizacao, nr_final_inut, cod_status, msg_status, cod_solicitacao_nfe, status_impressao_danfe, nr_romaneio_kg, nfe_contigencia, tipo_nat_exp_sped, cod_justificativa, tipo_nf_referenciada, xml_nprot, versao_systextilnfe, cod_moeda_exp, local_impressao, integrado_decisor, cnpj9_fatura, cnpj4_fatura, cnpj2_fatura, chave_contingencia, considera_inventario, data_autorizacao_nfe, cod_local, etiq_impressa, nr_solicitacao_dav, st_flag_cce, exportada, nota_estorno, justificativa_cont, data_hora_contigencia, percentual_negociado
from fatu_050
where codigo_empresa  = 1
and   num_nota_fiscal = 55897 -- uma nota qq do sistema atual
and   serie_nota_fisc = '1'
;

--------------------------------

--- Ajusta itens da nota de entrada

update obrf_015 o
set o.num_nota_orig    = 55612,  --<<<<< nota do sistema antigo - devolvida
    o.serie_nota_orig  = '1',
    o.motivo_devolucao = 1
where o.capa_ent_nrdoc = 56051  --<<<<< nota de entrada (devolução) nova
and   o.capa_ent_serie = '1'
;

--- "Des-Ajusta" itens da nota de entrada

update obrf_015 o
set o.num_nota_orig    = 0,  --<<<<< nota do sistema antigo - devolvida
    o.serie_nota_orig  = NULL,
    o.motivo_devolucao = 0
where o.capa_ent_nrdoc = 56051  --<<<<< nota de entrada (devolução) nova
and   o.capa_ent_serie = '1'
;

-- pesquisa

SELECT
  o.num_nota_orig
, o.serie_nota_orig
, o.motivo_devolucao
, o.capa_ent_nrdoc
, o.capa_ent_serie
FROM obrf_015 o
;

-- Conferencia e ajuste abaixo podem não ser necessários

-------------------------------

select sum(o.rateio_despesas), sum(o.rateio_descontos_ipi), sum(o.desconto_item)
from obrf_015 o
where o.capa_ent_nrdoc = 56038
and   o.capa_ent_serie = '1'

--------------------------------

update obrf_015 o
set o.rateio_descontos_ipi = abs(o.rateio_despesas)
where o.capa_ent_nrdoc = 56055
and   o.capa_ent_serie = '1'

--------------------------------
[10:15:16] Intersys - Claudio Renato Antonius: O insert é para pegar uma nota fiscal qualquer e copiar a capa para a nota a ser devolvida.
[10:15:38] Intersys - Claudio Renato Antonius: Deve ser trocado o número da nota nova e o número do DANFE.
[10:15:56] Intersys - Claudio Renato Antonius: O segundo ... liga a nota fiscal de saída (nova) com a nota de devolução.
[10:16:31] Intersys - Claudio Renato Antonius: O terceiro e quarto é para corrigir o problema de arredondamento do desconto
[10:16:42] Intersys - Claudio Renato Antonius: O insert é para cadastrar a NF nova.


--

Júlio César Oeschler

47 3081-9500

julio@systextil.com.br

Júlio César Oeschler <julio@systextil.com.br>
Systextil
