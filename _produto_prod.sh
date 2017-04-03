#!/bin/bash

DBVAR='--dbvar prod'

# To dbms2csv.py
# Order matters - Criation order
iniFiles=(
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
  "--fim"
)
