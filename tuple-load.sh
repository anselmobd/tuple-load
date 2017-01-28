#!/bin/bash

if [ $1 ] ; then
  VERBOSE=$1
else
  VERBOSE="-vvv"
fi

# Order matters - Criation order
iniFiles=(
  "insumo_nao_tecido_codigos"
  "insumo_nao_tecido_capa"
  "insumo_nao_tecido_tamanho"
  "insumo_nao_tecido_tamanho_cor"
  "insumo_tecido_codigos"
  "insumo_tecido_capa"
  "insumo_tecido_tamanho"
  "insumo_tecido_tamanho_cor"
  "insumo_tecido_tamanho_cor_col"
  "produto_colecao"
  "produto_loteexpedicao_referencias"
  "produto_fabric_pa_capa"
  "produto_fabric_md_capa"
  "produto_pa_capa"
  "produto_pa_tamanho"
  "produto_pa_tamanho_cor"
  "produto_md_capa"
  "produto_md_tamanho"
  "produto_md_tamanho_cor"
  "produto_pa_estrutura"
)

# generate

echo
echo "====="
echo "Generate CSVs"
echo
read -p "Confirm executing 'Generate'? (c/n) " -n1 -s exec
echo

if [ $exec = 'c' ]; then

  echo
  for iniFile in "${iniFiles[@]}"
  do
    echo
    echo "====="
    echo "./dbms2csv.py ${iniFile} $VERBOSE"
    echo
    read -p "Execute this command? (y/n) " -n1 -s exec
    echo
    echo
    if [ $exec = 'y' ]; then
      ./dbms2csv.py "${iniFile}" $VERBOSE
      if [ $? -eq 0 ]; then
        echo
        echo "Generated data group ${iniFile} - OK !!!"
      else
        echo
        echo "ERROR generating data group ${iniFile} !!!"
        exit
      fi
    else
      echo "Jump ${iniFile}"
    fi
  done
  echo

fi

# Order matters - Criation order
dataGroupFiles=(
  "unidades_de_medida.fixo"
  "tamanho.fixo"
  "cor.fixo"
  "conta_de_estoque.v161202"
  "tecido-linha_de_produto"
  "tecido-artigo_de_produto"
  "ncm.fixo"
  "produto-linha_de_produto"
  "produto-artigo_de_produto"
  "_produto_colecao"
  "_insumo_nao_tecido_capa"
  "_insumo_nao_tecido_tamanho"
  "_insumo_nao_tecido_tamanho_cor"
  "_insumo_tecido_capa"
  "_insumo_tecido_tamanho"
  "_insumo_tecido_tamanho_cor"
  "_insumo_tecido_tamanho_cor_col"
  "_produto_md_capa"
  "_produto_md_tamanho"
  "_produto_md_tamanho_cor"
  "_produto_pa_capa"
  "_produto_pa_tamanho"
  "_produto_pa_tamanho_cor"
)

# delete

echo
echo "====="
echo "Delete tuples no longer useful"
echo
read -p "Confirm executing 'Delete'? (c/n) " -n1 -s exec
echo

if [ $exec = 'c' ]; then

  echo
  for (( idx=${#dataGroupFiles[@]}-1 ; idx>=0 ; idx-- )) ; do
    echo
    echo "====="
    echo "./csv2oracle.py ${dataGroupFiles[idx]} -d $VERBOSE"
    echo
    read -p "Execute this command? (y/n) " -n1 -s exec
    echo
    echo
    if [ $exec = 'y' ]; then
      ./csv2oracle.py ${dataGroupFiles[idx]} -d $VERBOSE
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
read -p "Confirm executing 'Insert/Update'? (c/n) " -n1 -s exec
echo

if [ $exec = 'c' ]; then

  echo
  for dataGroupFile in "${dataGroupFiles[@]}"
  do
    echo
    echo "====="
    echo "./csv2oracle.py ${dataGroupFile} -i $VERBOSE"
    echo
    read -p "Execute this command? (y/n) " -n1 -s exec
    echo
    echo
    if [ $exec = 'y' ]; then
      ./csv2oracle.py ${dataGroupFile} -i $VERBOSE
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
