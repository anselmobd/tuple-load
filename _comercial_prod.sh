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
  "periodo_de_comissao"
  "periodo_de_producao_por_area"
  "--fim"
)
