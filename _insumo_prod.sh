#!/bin/bash

DBVAR='--dbvar prod'

# To dbms2csv.py
# Order matters - Criation order
iniFiles=(
  "--inicio"
  "fornecedor"
  "produto_loteexpedicao_referencias"
  "insumo_nao_tecido_codigo_antigo"
  "insumo_nao_tecido_loteexpedicao_codigo_antigo"
  "insumo_nao_tecido_loteexpedicao_md_codigo_antigo"
  "insumo_nao_tecido_loteexpedicao_capa"
  "insumo_nao_tecido_loteexpedicao_tamanho"
  "insumo_nao_tecido_loteexpedicao_tamanho_cor"
  "insumo_nao_tecido_loteexpedicao_almox"
  "insumo_tecido_codigo_antigo"
  "insumo_tecido_loteexpedicao_codigo_antigo"
  "insumo_tecido_loteexpedicao_md_codigo_antigo"
  "insumo_tecido_loteexpedicao_capa"
  "insumo_tecido_loteexpedicao_tamanho"
  "insumo_tecido_loteexpedicao_tamanho_cor"
  "insumo_tecido_loteexpedicao_tamanho_cor_col"
  "--fim"
)

# To csv2oracle.py
# Order matters - Criation order
dataGroupFiles=(
  "--inicio"
  "conta_de_estoque"
  "faixa_etaria.fixo"
  "unidades_de_medida.fixo"
  "tamanho.fixo"
  "serie_tamanho.fixo"
  "serie_tamanho_tamanho.fixo"
  "cor.fixo"
  "ncm.fixo"
  "tecido-linha_de_produto"
  "tecido-artigo_de_produto"
  "produto-linha_de_produto"
  "produto-artigo_de_produto"
  "produto_colecao"
  "_fornecedor"
  "_insumo_nao_tecido_loteexpedicao_capa"
  "_insumo_nao_tecido_loteexpedicao_tamanho"
  "_insumo_nao_tecido_loteexpedicao_tamanho_cor"
  "_insumo_tecido_loteexpedicao_capa"
  "_insumo_tecido_loteexpedicao_tamanho"
  "_insumo_tecido_loteexpedicao_tamanho_cor"
  "_insumo_tecido_loteexpedicao_tamanho_cor_col"
  "--fim"
)
