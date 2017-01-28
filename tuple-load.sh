#!/bin/bash

if [ $1 ] ; then
  VERBOSE=$1
else
  VERBOSE="-vvv"
fi

# generate

echo
echo "====="
echo "Generate CSVs"
echo
read -p "Confirm executing 'Generate'? (c/n) " -n1 -s exec
echo

if [ $exec = 'c' ]; then

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
    else
      echo "Junp ${iniFile}"
    fi
  done
  echo

fi

# delete

echo
echo "====="
echo "Delete tuples no longer useful"
echo
read -p "Confirm executing 'Delete'? (c/n) " -n1 -s exec
echo

if [ $exec = 'c' ]; then

  ./csv2oracle.py _insumo_nao_tecido_tamanho_cor -d $VERBOSE

  ./csv2oracle.py _insumo_nao_tecido_tamanho -d $VERBOSE

  ./csv2oracle.py _insumo_nao_tecido_capa -d $VERBOSE

  ./csv2oracle.py _insumo_tecido_tamanho_cor_col -d $VERBOSE

  ./csv2oracle.py _insumo_tecido_tamanho_cor -d $VERBOSE

  ./csv2oracle.py _insumo_tecido_tamanho -d $VERBOSE

  ./csv2oracle.py _insumo_tecido_capa -d $VERBOSE

  ./csv2oracle.py _produto_pa_tamanho_cor -d $VERBOSE

  ./csv2oracle.py _produto_pa_tamanho -d $VERBOSE

  ./csv2oracle.py _produto_pa_capa  -d $VERBOSE

  ./csv2oracle.py _produto_md_tamanho_cor -d $VERBOSE

  ./csv2oracle.py _produto_md_tamanho -d $VERBOSE

  ./csv2oracle.py _produto_md_capa  -d $VERBOSE

  ./csv2oracle.py _produto_colecao -d $VERBOSE

  ./csv2oracle.py ncm.fixo -d $VERBOSE

  ./csv2oracle.py produto-artigo_de_produto -d $VERBOSE

  ./csv2oracle.py tecido-artigo_de_produto -d $VERBOSE

  ./csv2oracle.py produto-linha_de_produto -d $VERBOSE

  ./csv2oracle.py tecido-linha_de_produto -d $VERBOSE

  ./csv2oracle.py conta_de_estoque.v161202 -d $VERBOSE

  ./csv2oracle.py cor.fixo -d $VERBOSE

  ./csv2oracle.py tamanho.fixo -d $VERBOSE

  ./csv2oracle.py unidades_de_medida.fixo -d $VERBOSE

fi

# insert/update

echo
echo "====="
echo "Insert/Update tuples"
echo
read -p "Confirm executing 'Insert/Update'? (c/n) " -n1 -s exec
echo

if [ $exec = 'c' ]; then

  ./csv2oracle.py unidades_de_medida.fixo -i $VERBOSE

  ./csv2oracle.py tamanho.fixo -i $VERBOSE

  ./csv2oracle.py cor.fixo -i $VERBOSE

  ./csv2oracle.py conta_de_estoque.v161202 -i $VERBOSE

  ./csv2oracle.py tecido-linha_de_produto -i $VERBOSE

  ./csv2oracle.py produto-linha_de_produto -i $VERBOSE

  ./csv2oracle.py tecido-artigo_de_produto -i $VERBOSE

  ./csv2oracle.py produto-artigo_de_produto -i $VERBOSE

  ./csv2oracle.py ncm.fixo -i $VERBOSE

  ./csv2oracle.py _produto_colecao -i $VERBOSE

  ./csv2oracle.py _produto_md_capa -i $VERBOSE

  ./csv2oracle.py _produto_md_tamanho -i $VERBOSE

  ./csv2oracle.py _produto_md_tamanho_cor -i $VERBOSE

  ./csv2oracle.py _produto_pa_capa -i $VERBOSE

  ./csv2oracle.py _produto_pa_tamanho -i $VERBOSE

  ./csv2oracle.py _produto_pa_tamanho_cor -i $VERBOSE

  ./csv2oracle.py _insumo_tecido_capa -i $VERBOSE

  ./csv2oracle.py _insumo_tecido_tamanho -i $VERBOSE

  ./csv2oracle.py _insumo_tecido_tamanho_cor -i $VERBOSE

  ./csv2oracle.py csv/_insumo_tecido_tamanho_cor_col -i $VERBOSE

  ./csv2oracle.py _insumo_nao_tecido_capa -i $VERBOSE

  ./csv2oracle.py _insumo_nao_tecido_tamanho -i $VERBOSE

  ./csv2oracle.py _insumo_nao_tecido_tamanho_cor -i $VERBOSE

fi
echo
