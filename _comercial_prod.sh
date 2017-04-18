#!/bin/bash

DBVAR='--dbvar prod'

# To dbms2csv.py
# Order matters - Criation order
iniFiles=(
  "--inicio"
  "cliente"
  "--fim"
)

# To csv2oracle.py
# Order matters - Criation order
dataGroupFiles=(
  "--inicio"
  "_cliente"
  "periodo_de_comissao"
  "periodo_de_producao_por_area"
  "--fim"
)
