#!/bin/bash

# rascunho
#./csv2oracle.py -b csv/regiao.csv yaml/regiao.PEDI_040.yaml -vvvvv --dbvar prod


if [ $1 ] ; then
  VERBOSE=$1
else
  VERBOSE=""
fi

# Order matters - Criation order
dataGroupFiles=(
  "_centrodecusto"
  "conta_de_estoque"
  "plano_referencial"
  "periodo_de_comissao"
  "regiao"
  "subregiao"
  "funcionario_cargo"
  "funcionario_setor"
  "funcionario"
  "usuario"
)

# delete

echo
echo "====="
echo "Delete tuples no longer useful"
echo
read -p "Confirm executing 'Delete'? (c/n/a) " -n1 -s exec
echo

if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ]; then

  echo
  for (( idx=${#dataGroupFiles[@]}-1 ; idx>=0 ; idx-- )) ; do
    echo
    echo "====="
    echo "./csv2oracle.py ${dataGroupFiles[idx]} -d $VERBOSE --dbvar prod"
    echo
    if [ $exec != 'a' -a $exec != 'g' ]; then
      read -p "Execute this command? (y/n) " -n1 -s exec
      echo
    fi
    echo
    if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ]; then
      ./csv2oracle.py ${dataGroupFiles[idx]} -d $VERBOSE --dbvar prod
      if [ $? -eq 0 ]; then
        echo
        echo "Deleted data group ${dataGroupFiles[idx]} - OK !!!"
      else
        echo
        echo "ERROR deleting data group ${dataGroupFiles[idx]} !!!"
        exit
      fi
    else
      echo "Jump ${dataGroupFiles[idx]}"
    fi
  done
  echo

fi

# insert/update

echo
echo "====="
echo "Insert/Update tuples"
echo
if [ $exec != 'g' ]; then
  read -p "Confirm executing 'Insert/Update'? (c/n/a) " -n1 -s exec
  echo
fi

if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ]; then

  echo
  for dataGroupFile in "${dataGroupFiles[@]}"
  do
    echo
    echo "====="
    echo "./csv2oracle.py ${dataGroupFile} -i $VERBOSE --dbvar prod"
    echo
    if [ $exec != 'a' -a $exec != 'g' ]; then
      read -p "Execute this command? (y/n) " -n1 -s exec
      echo
    fi
    echo
    if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ]; then
      ./csv2oracle.py ${dataGroupFile} -i $VERBOSE --dbvar prod
      if [ $? -eq 0 ]; then
        echo
        echo "Inserted/Updated data group ${dataGroupFile} - OK !!!"
      else
        echo
        echo "ERROR Inserting/Updating data group ${dataGroupFile} !!!"
        exit
      fi
    else
      echo "Jump ${dataGroupFile}"
    fi
  done
  echo

fi
echo

if [ $exec = 'g' ]; then
  echo "Start at:"
  echo $INI
  echo
  echo "End at:"
  date
  echo
fi
