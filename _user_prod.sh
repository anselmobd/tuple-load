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
  "funcionario_cargo"
  "funcionario_setor"
  "funcionario"
  "usuario"
  "--fim"
)

# for (( idx=${#dataGroupFiles[@]}-2 ; idx>=1 ; idx-- )) ; do
#   echo "./csv2oracle.py ${dataGroupFiles[idx]} -d $DBVAR"
# done
#
# for (( idx=1 ; idx<=${#dataGroupFiles[@]}-2 ; idx++ )) ; do
#   echo "./csv2oracle.py ${dataGroupFiles[idx]} -i $DBVAR"
# done
