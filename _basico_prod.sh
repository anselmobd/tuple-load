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
  "regiao"
  "subregiao"
  "--fim"
)
