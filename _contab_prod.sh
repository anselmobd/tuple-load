#!/bin/bash

DBVAR='--dbvar prod'

# To dbms2csv.py
# Order matters - Criation order
iniFiles=(
  "--inicio"
  "centrodecusto --iniyaml"
  "--fim"
)

# To csv2oracle.py
# Order matters - Criation order
dataGroupFiles=(
  "--inicio"
  "plano_referencial"
  "_centrodecusto"
  "deposito"
  "--fim"
)
