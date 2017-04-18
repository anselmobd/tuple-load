#!/bin/bash

DBVAR='--dbvar prod'

# To dbms2csv.py
# Order matters - Criation order
iniFiles=(
  "--inicio"
  "produto_fabric_pa_capa"
  "produto_fabric_md_capa"
  "produto_pa_capa"
  "produto_pa_tamanho"
  "produto_pa_tamanho_cor"
  "produto_pa_faixa_etaria"
  "produto_md_capa"
  "produto_md_tamanho"
  "produto_md_tamanho_cor"
  "componentes_tamanho_cor"
  "produto_pa_estrutura"
  "produto_md_estrutura"
  "produto_pa_estrutura_combinacao_cor_d"
  "produto_pa_estrutura_combinacao_cor_m"
  "produto_md_estrutura_combinacao_cor_d"
  "produto_md_estrutura_combinacao_cor_m"
  "produto_pa_estrutura_combinacao_tamanho_d"
  "produto_pa_estrutura_combinacao_tamanho_m"
  "produto_md_estrutura_combinacao_tamanho_d"
  "produto_md_estrutura_combinacao_tamanho_m"
  "--fim"
)

# To csv2oracle.py
# Order matters - Criation order
dataGroupFiles=(
  "--inicio"
  "area_producao"
  "estagios"
  "_produto_md_capa"
  "_produto_md_tamanho"
  "_produto_md_tamanho_cor"
  "_produto_pa_capa"
  "_produto_pa_tamanho"
  "_produto_pa_tamanho_cor"
  "_produto_md_estrutura.pamd"
  "_produto_md_estrutura_combinacao_tamanho_m.1.2.3.4.5.6"
  "--fim"
)
