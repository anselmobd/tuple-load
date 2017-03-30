#!/bin/bash

DBVAR='--dbvar prod'

# To dbms2csv.py
# Order matters - Criation order
iniFiles=(
  "centrodecusto --iniyaml"
)

# To csv2oracle.py
# Order matters - Criation order
dataGroupFiles=(
  "funcionario_cargo"
  "funcionario_setor"
  "funcionario"
  "usuario"
)
