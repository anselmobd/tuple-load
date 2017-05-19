SELECT
  col
, colecao
, lin
, linha
, art
, artigo
, ces
, conta_estoque
, insumo
, narrativa
, lead
, decode(sign(saldo_antes),-1,atraso_antes,0)||' | '||
  decode(sign(saldo_agora),-1,atraso_agora,0)||' | '||
  decode(sign(saldo_depois),-1,atraso_depois,0) atraso
, estoque
, minimo
--
, reserva_antes
, areceber_antes
, decode(sign(saldo_antes-minimo), -1,saldo_antes - minimo, saldo_antes) saldo_antes
--
, reserva_agora
, areceber_agora
, decode(sign(saldo_agora-minimo), -1,saldo_agora - minimo, saldo_agora) saldo_agora
--
, reserva_depois
, areceber_depois
, decode(sign(saldo_depois-minimo), -1,saldo_depois - minimo, saldo_depois) saldo_depois
--
, to_char(to_date(:agora, 'dd/mm/yyyy')+0, 'dd') || ' a ' ||
  to_char(to_date(:agora, 'dd/mm/yyyy')+6, 'dd/mm') S1
, reserva_s1
, areceber_s1
, decode(sign(saldo_s1-minimo), -1, saldo_s1-minimo, saldo_s1) saldo_s1
--
, to_char(to_date(:agora, 'dd/mm/yyyy')+7, 'dd') || ' a ' ||
  to_char(to_date(:agora, 'dd/mm/yyyy')+13, 'dd/mm') S2
, reserva_s2
, areceber_s2
, decode(sign(saldo_s2-minimo), -1, saldo_s2-minimo, saldo_s2) saldo_s2
--
, to_char(to_date(:agora, 'dd/mm/yyyy')+14, 'dd') || ' a ' ||
  to_char(to_date(:agora, 'dd/mm/yyyy')+20, 'dd/mm') S3
, reserva_s3
, areceber_s3
, decode(sign(saldo_s3-minimo), -1, saldo_s3-minimo, saldo_s3) saldo_s3
--
, to_char(to_date(:agora, 'dd/mm/yyyy')+21, 'dd') || ' a ' ||
  to_char(to_date(:agora, 'dd/mm/yyyy')+27, 'dd/mm') S4
, reserva_s4
, areceber_s4
, decode(sign(saldo_s4-minimo), -1, saldo_s4-minimo, saldo_s4) saldo_s4
--
, to_char(to_date(:agora, 'dd/mm/yyyy')+28, 'dd') || ' a ' ||
  to_char(to_date(:agora, 'dd/mm/yyyy')+34, 'dd/mm') S5
, reserva_s5
, areceber_s5
, decode(sign(saldo_s5-minimo), -1, saldo_s5-minimo, saldo_s5) saldo_s5
--
, to_char(to_date(:agora, 'dd/mm/yyyy')+35, 'dd') || ' a ' ||
  to_char(to_date(:agora, 'dd/mm/yyyy')+41, 'dd/mm') S6
, reserva_s6
, areceber_s6
, decode(sign(saldo_s6-minimo), -1, saldo_s6-minimo, saldo_s6) saldo_s6
--
, to_char(to_date(:agora, 'dd/mm/yyyy')+42, 'dd') || ' a ' ||
  to_char(to_date(:agora, 'dd/mm/yyyy')+48, 'dd/mm') S7
, reserva_s7
, areceber_s7
, decode(sign(saldo_s7-minimo), -1, saldo_s7-minimo, saldo_s7) saldo_s7
--
, to_char(to_date(:agora, 'dd/mm/yyyy')+49, 'dd') || ' a ' ||
  to_char(to_date(:agora, 'dd/mm/yyyy')+55, 'dd/mm') S8
, reserva_s8
, areceber_s8
, decode(sign(saldo_s8-minimo), -1, saldo_s8-minimo, saldo_s8) saldo_s8
--
, reserva_futuro
, areceber_futuro
, decode(sign(saldo_futuro-minimo), -1, saldo_futuro-minimo, saldo_futuro) saldo_futuro
from ( -- Resume as informações por insumo
  select
    basi_010.col, basi_010.colecao,
    basi_010.lin, basi_010.linha,
    basi_010.art, basi_010.artigo,
    basi_010.ces, basi_010.conta_estoque,
    basi_010.insumo, basi_010.narrativa,
    reserva.lead lead,
    nvl(reserva.minimo,0) minimo,
    nvl(atraso_antes,0) atraso_antes,
    nvl(atraso_agora,0) atraso_agora,
    nvl(atraso_depois,0) atraso_depois,
    nvl(estoque,0) estoque,
    nvl(reserva_antes,0)  reserva_antes,  nvl(areceber_antes,0)  areceber_antes, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0))     saldo_antes ,
    nvl(reserva_agora,0)  reserva_agora,  nvl(areceber_agora,0)  areceber_agora, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_agora,0) + nvl(areceber_agora,0)) saldo_agora ,
    nvl(reserva_depois,0) reserva_depois, nvl(areceber_depois,0) areceber_depois,(nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_agora,0) + nvl(areceber_agora,0) - nvl(reserva_depois,0) + nvl(areceber_depois,0)) saldo_depois ,
    nvl(reserva_s1,0)  reserva_s1,  nvl(areceber_s1,0)  areceber_s1, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0))     saldo_s1 ,
    nvl(reserva_s2,0)  reserva_s2,  nvl(areceber_s2,0)  areceber_s2, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0) - nvl(reserva_s2,0) + nvl(areceber_s2,0)) saldo_s2 ,
    nvl(reserva_s3,0)  reserva_s3,  nvl(areceber_s3,0)  areceber_s3, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0) - nvl(reserva_s2,0) + nvl(areceber_s2,0) - nvl(reserva_s3,0) + nvl(areceber_s3,0)) saldo_s3 ,
    nvl(reserva_s4,0)  reserva_s4,  nvl(areceber_s4,0)  areceber_s4, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0) - nvl(reserva_s2,0) + nvl(areceber_s2,0) - nvl(reserva_s3,0) + nvl(areceber_s3,0) - nvl(reserva_s4,0) + nvl(areceber_s4,0)) saldo_s4 ,
    nvl(reserva_s5,0)  reserva_s5,  nvl(areceber_s5,0)  areceber_s5, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0) - nvl(reserva_s2,0) + nvl(areceber_s2,0) - nvl(reserva_s3,0) + nvl(areceber_s3,0) - nvl(reserva_s4,0) + nvl(areceber_s4,0)  - nvl(reserva_s5,0) + nvl(areceber_s5,0)) saldo_s5 ,
    nvl(reserva_s6,0)  reserva_s6,  nvl(areceber_s6,0)  areceber_s6, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0) - nvl(reserva_s2,0) + nvl(areceber_s2,0) - nvl(reserva_s3,0) + nvl(areceber_s3,0) - nvl(reserva_s4,0) + nvl(areceber_s4,0)  - nvl(reserva_s5,0) + nvl(areceber_s5,0) - nvl(reserva_s6,0) + nvl(areceber_s6,0)) saldo_s6 ,
    nvl(reserva_s7,0)  reserva_s7,  nvl(areceber_s7,0)  areceber_s7, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0) - nvl(reserva_s2,0) + nvl(areceber_s2,0) - nvl(reserva_s3,0) + nvl(areceber_s3,0) - nvl(reserva_s4,0) + nvl(areceber_s4,0)  - nvl(reserva_s5,0) + nvl(areceber_s5,0) - nvl(reserva_s6,0) + nvl(areceber_s6,0) - nvl(reserva_s7,0) + nvl(areceber_s7,0)) saldo_s7 ,
    nvl(reserva_s8,0)  reserva_s8,  nvl(areceber_s8,0)  areceber_s8, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0) - nvl(reserva_s2,0) + nvl(areceber_s2,0) - nvl(reserva_s3,0) + nvl(areceber_s3,0) - nvl(reserva_s4,0) + nvl(areceber_s4,0)  - nvl(reserva_s5,0) + nvl(areceber_s5,0) - nvl(reserva_s6,0) + nvl(areceber_s6,0) - nvl(reserva_s7,0) + nvl(areceber_s7,0) - nvl(reserva_s8,0) + nvl(areceber_s8,0)) saldo_s8 ,
    nvl(reserva_futuro,0)  reserva_futuro,  nvl(areceber_futuro,0)  areceber_futuro, (nvl(estoque,0) - nvl(reserva_antes,0) + nvl(areceber_antes,0) - nvl(reserva_s1,0) + nvl(areceber_s1,0) - nvl(reserva_s2,0) + nvl(areceber_s2,0) - nvl(reserva_s3,0) + nvl(areceber_s3,0) - nvl(reserva_s4,0) + nvl(areceber_s4,0)  - nvl(reserva_s5,0) + nvl(areceber_s5,0) - nvl(reserva_s6,0) + nvl(areceber_s6,0) - nvl(reserva_s7,0) + nvl(areceber_s7,0) - nvl(reserva_s8,0) + nvl(areceber_s8,0) - nvl(reserva_futuro,0) + nvl(areceber_futuro,0)) saldo_futuro
  from ( -- estoque
             select estq_040.cditem_nivel99||'.'||estq_040.cditem_grupo||'.'||estq_040.cditem_subgrupo||'.'||estq_040.cditem_item insumo,
                    sum(estq_040.qtde_estoque_atu) estoque
             from estq_040, basi_205
             where estq_040.deposito = basi_205.codigo_deposito
               and basi_205.considera_tmrp = 1
               and estq_040.cditem_nivel99 not in ('1')
             group by estq_040.cditem_nivel99, estq_040.cditem_grupo, estq_040.cditem_subgrupo, estq_040.cditem_item
           ) estoque,
           ( --------------------- Reservas das Ordens produç?o
              select insumo, lead, minimo,
                     nvl(min(case when decode(:opcaoData,0,dt_comprar,dt_chegar) < to_date(:agora,'dd/mm/yyyy')
                             then reserva.atraso end),0)                                 atraso_antes,
                     nvl(min(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy') and to_date(:agora,'dd/mm/yyyy') + (:semanasAgora*7)
                             then reserva.atraso end),0)                                 atraso_agora,
                     nvl(min(case when decode(:opcaoData,0,dt_comprar,dt_chegar) > to_date(:agora,'dd/mm/yyyy') + (:semanasAgora*7)
                             then reserva.atraso end),0)                                 atraso_depois,

                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) < to_date(:agora,'dd/mm/yyyy')
                             then reserva.reservada end),0)                              reserva_antes,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy') and to_date(:agora,'dd/mm/yyyy') + (:semanasAgora*7)
                             then reserva.reservada end),0)                              reserva_agora,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) > to_date(:agora,'dd/mm/yyyy') + (:semanasAgora*7)
                             then reserva.reservada end),0)                              reserva_depois,

                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy')   and to_date(:agora,'dd/mm/yyyy')+6
                             then reserva.reservada end),0)                              reserva_s1,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy')+7 and to_date(:agora,'dd/mm/yyyy')+13
                             then reserva.reservada end),0)                              reserva_s2,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy')+14 and to_date(:agora,'dd/mm/yyyy')+20
                             then reserva.reservada end),0)                              reserva_s3,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy')+21 and to_date(:agora,'dd/mm/yyyy')+27
                             then reserva.reservada end),0)                              reserva_s4,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy')+28 and to_date(:agora,'dd/mm/yyyy')+34
                             then reserva.reservada end),0)                              reserva_s5,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy')+35 and to_date(:agora,'dd/mm/yyyy')+41
                             then reserva.reservada end),0)                              reserva_s6,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy')+42 and to_date(:agora,'dd/mm/yyyy')+48
                             then reserva.reservada end),0)                              reserva_s7,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) between to_date(:agora,'dd/mm/yyyy')+49 and to_date(:agora,'dd/mm/yyyy')+55
                             then reserva.reservada end),0)                              reserva_s8,
                     nvl(sum(case when decode(:opcaoData,0,dt_comprar,dt_chegar) > to_date(:agora,'dd/mm/yyyy')+55
                             then reserva.reservada end),0)                              reserva_futuro

              from (select tmrp_041.nivel_estrutura||'.'||tmrp_041.grupo_estrutura||'.'||tmrp_041.subgru_estrutura||'.'||tmrp_041.item_estrutura insumo,
                           pcpc_020.ordem_producao                                                                           op,
                           pcpc_020.data_entrada_corte                                                                       dt_corte,
                           pcpc_020.data_entrada_corte - :diasSeguranca                                                      dt_chegar,
                           pcpc_020.data_entrada_corte - :diasSeguranca - nvl(basi_015.tempo_reposicao,100)                  dt_Comprar,
                           nvl(basi_015.tempo_reposicao,100)                                                                 lead,
                           nvl(basi_015.estoque_minimo,0)                                                                    minimo,
                           sum(tmrp_041.qtde_reservada)                                                                      reservada,
                           trunc(pcpc_020.data_entrada_corte - :diasSeguranca - nvl(basi_015.tempo_reposicao,100),'dd') - trunc(sysdate,'dd') Atraso
                    from tmrp_041, pcpc_020, basi_015
                    where tmrp_041.area_producao    = 1
                      and tmrp_041.nr_pedido_ordem  = pcpc_020.ordem_producao
                      and pcpc_020.cod_cancelamento = 0
                      and pcpc_020.data_entrada_corte is not null
                      and tmrp_041.nivel_estrutura not in ('1')
                      and tmrp_041.nivel_estrutura  = basi_015.nivel_estrutura  (+)
                      and tmrp_041.grupo_estrutura  = basi_015.grupo_estrutura  (+)
                      and tmrp_041.subgru_estrutura = basi_015.subgru_estrutura (+)
                      and tmrp_041.item_estrutura   = basi_015.item_estrutura   (+)
                    group by tmrp_041.nivel_estrutura, tmrp_041.grupo_estrutura, tmrp_041.subgru_estrutura, tmrp_041.item_estrutura,
                             pcpc_020.ordem_producao, pcpc_020.data_entrada_corte, basi_015.tempo_reposicao, basi_015.estoque_minimo
                    ) reserva
              group by reserva.insumo, reserva.lead,reserva.minimo
            ) reserva,
            ( ------------------------- Compras - Mostra o areceber
              select tmrp_041.NIVEL_ESTRUTURA||'.'||tmrp_041.GRUPO_ESTRUTURA||'.'||tmrp_041.SUBGRU_ESTRUTURA||'.'||tmrp_041.ITEM_ESTRUTURA insumo,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      < to_date(:agora,'dd/mm/yyyy')
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_antes,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy') and to_date(:agora,'dd/mm/yyyy') + (:semanasAgora*7)
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_agora,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      > to_date(:agora,'dd/mm/yyyy') + (:semanasAgora*7)
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_depois,

                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy')   and to_date(:agora,'dd/mm/yyyy')+6
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_s1,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy')+7 and to_date(:agora,'dd/mm/yyyy')+13
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_s2,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy')+14 and to_date(:agora,'dd/mm/yyyy')+20
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_s3,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy')+21 and to_date(:agora,'dd/mm/yyyy')+27
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_s4,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy')+28 and to_date(:agora,'dd/mm/yyyy')+34
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_s5,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy')+35 and to_date(:agora,'dd/mm/yyyy')+41
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_s6,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy')+42 and to_date(:agora,'dd/mm/yyyy')+48
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_s7,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      between to_date(:agora,'dd/mm/yyyy')+49 and to_date(:agora,'dd/mm/yyyy')+55
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_s8,
                     nvl(sum(case when decode(:opcaoData,0,supr_090.DT_EMIS_PED_COMP,supr_100.data_prev_entr)      > to_date(:agora,'dd/mm/yyyy')+55
                             then tmrp_041.QTDE_ARECEBER end),0)                                             areceber_futuro

              from tmrp_041, supr_090, supr_100
              where tmrp_041.AREA_PRODUCAO   = 9
                and supr_090.PEDIDO_COMPRA   = tmrp_041.NR_PEDIDO_ORDEM
                and supr_100.NUM_PED_COMPRA  = supr_090.PEDIDO_COMPRA
                and supr_100.SEQ_ITEM_PEDIDO = tmrp_041.SEQ_PEDIDO_ORDEM
              group by  tmrp_041.NIVEL_ESTRUTURA, tmrp_041.GRUPO_ESTRUTURA, tmrp_041.SUBGRU_ESTRUTURA, tmrp_041.ITEM_ESTRUTURA
            ) compras,
            ( ------------------------ produtos
               select basi_010.nivel_estrutura||'.'||basi_010.grupo_estrutura||'.'||basi_010.subgru_estrutura||'.'||basi_010.item_estrutura insumo,
                      basi_030.colecao          col, basi_140.descr_colecao    colecao,
                      basi_030.linha_produto    lin, basi_120.descricao_linha  linha,
                      basi_030.artigo           art, basi_290.descr_artigo     artigo,
                      basi_030.conta_estoque    ces, basi_150.descr_ct_estoque conta_estoque,
                      basi_010.nivel_estrutura  nivel,
                      basi_010.grupo_estrutura  grupo,
                      basi_010.subgru_estrutura tam,
                      basi_010.item_estrutura   cor,
                      basi_030.descr_referencia nome_grupo,
                      basi_010.descricao_15     nome_cor,
                      basi_010.narrativa
               from basi_010, basi_030, basi_140, basi_120, basi_290, basi_150
               where basi_010.nivel_estrutura = basi_030.nivel_estrutura
                 and basi_010.grupo_estrutura = basi_030.referencia
                 and basi_030.colecao         = basi_140.colecao
                 and basi_030.linha_produto   = basi_120.linha_produto
                 and basi_030.artigo          = basi_290.artigo
                 and basi_030.conta_estoque   = basi_150.conta_estoque
            ) basi_010
      where basi_010.insumo = reserva.insumo (+)
        and basi_010.insumo = estoque.insumo (+)
        and basi_010.insumo = compras.insumo (+)
        and (areceber_antes is not null or areceber_agora is not null or areceber_depois is not null or
             reserva_antes  is not null or reserva_agora  is not null or reserva_depois is not null or
             estoque is not null or minimo is not null
             )
      group by basi_010.col, basi_010.colecao,
               basi_010.lin, basi_010.linha,
               basi_010.art, basi_010.artigo,
               basi_010.ces, basi_010.conta_estoque,
               basi_010.insumo,basi_010.narrativa,reserva.lead, reserva.minimo, estoque.estoque,
               atraso_antes,   atraso_agora,   atraso_depois,
               reserva_antes,  reserva_agora,  reserva_depois,
               areceber_antes, areceber_agora, areceber_depois,
               reserva_s1, reserva_s2, reserva_s3,reserva_s4,reserva_s5,reserva_s6,reserva_s7,reserva_s8, reserva_futuro,
               areceber_s1, areceber_s2, areceber_s3, areceber_s4, areceber_s5, areceber_s6, areceber_s7, areceber_s8, areceber_futuro
)
