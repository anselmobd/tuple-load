#!/bin/bash

if [ $1 ] ; then
  VERBOSE=$1
else
  VERBOSE=""
fi

# Order matters - Criation order
iniFiles=(
  "fornecedor"
  "produto_loteexpedicao_referencias"
  "insumo_nao_tecido_codigo_antigo"
  "insumo_nao_tecido_loteexpedicao_codigo_antigo"
  "insumo_nao_tecido_loteexpedicao_md_codigo_antigo"
  "insumo_nao_tecido_loteexpedicao_capa"
  "insumo_nao_tecido_loteexpedicao_tamanho"
  "insumo_nao_tecido_loteexpedicao_tamanho_cor"
  "insumo_tecido_codigo_antigo"
  "insumo_tecido_loteexpedicao_codigo_antigo"
  "insumo_tecido_loteexpedicao_md_codigo_antigo"
  "insumo_tecido_loteexpedicao_capa"
  "insumo_tecido_loteexpedicao_tamanho"
  "insumo_tecido_loteexpedicao_tamanho_cor"
  "insumo_tecido_loteexpedicao_tamanho_cor_col"
  "produto_colecao"
  "produto_fabric_pa_capa"
  "produto_fabric_md_capa"
  "produto_pa_capa"
  "produto_pa_tamanho"
  "produto_pa_tamanho_cor"
  "produto_pa_faixa_etaria"
  "produto_md_capa"
  "produto_md_tamanho"
  "produto_md_tamanho_cor"
  "componentes_tamanho_cor"
  "produto_pa_estrutura"
  "produto_md_estrutura"
  "produto_pa_estrutura_combinacao_cor_d"
  "produto_pa_estrutura_combinacao_cor_m"
  "produto_md_estrutura_combinacao_cor_d"
  "produto_md_estrutura_combinacao_cor_m"
  "produto_pa_estrutura_combinacao_tamanho_d"
  "produto_pa_estrutura_combinacao_tamanho_m"
  "produto_md_estrutura_combinacao_tamanho_d"
  "produto_md_estrutura_combinacao_tamanho_m"
)

# generate

echo
echo "====="
echo "Generate CSVs"
echo
read -p "Confirm executing 'Generate'? (c/n/a/g) " -n1 -s exec
echo

if [ $exec = 'g' ]; then
  INI=$(date)
fi

if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ]; then

  echo
  for iniFile in "${iniFiles[@]}"
  do
    echo
    echo "====="
    echo "./dbms2csv.py ${iniFile} $VERBOSE"
    echo
    if [ $exec != 'a' -a $exec != 'g' ]; then
      read -p "Execute this command? (y/n) " -n1 -s exec
      echo
    fi
    echo
    if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ]; then
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
  "faixa_etaria.fixo"
  "unidades_de_medida.fixo"
  "tamanho.fixo"
  "serie_tamanho.fixo"
  "serie_tamanho_tamanho.fixo"
  "cor.fixo"
  "conta_de_estoque"
  "tecido-linha_de_produto"
  "tecido-artigo_de_produto"
  "ncm.fixo"
  "produto-linha_de_produto"
  "produto-artigo_de_produto"
  "fornecedor"
  "_produto_colecao"
  "_insumo_nao_tecido_loteexpedicao_capa"
  "_insumo_nao_tecido_loteexpedicao_tamanho"
  "_insumo_nao_tecido_loteexpedicao_tamanho_cor"
  "_insumo_tecido_loteexpedicao_capa"
  "_insumo_tecido_loteexpedicao_tamanho"
  "_insumo_tecido_loteexpedicao_tamanho_cor"
  "_insumo_tecido_loteexpedicao_tamanho_cor_col"
  "_produto_md_capa"
  "_produto_md_tamanho"
  "_produto_md_tamanho_cor"
  "_produto_pa_capa"
  "_produto_pa_tamanho"
  "_produto_pa_tamanho_cor"
  "_produto_md_estrutura.pamd"
  "_produto_md_estrutura_combinacao_tamanho_m.1.2.3.4.5.6"
)

# delete

echo
echo "====="
echo "Delete tuples no longer useful"
echo
if [ $exec != 'g' ]; then
  read -p "Confirm executing 'Delete'? (c/n/a) " -n1 -s exec
  echo
fi

if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ]; then

  echo
  for (( idx=${#dataGroupFiles[@]}-1 ; idx>=0 ; idx-- )) ; do
    echo
    echo "====="
    echo "./csv2oracle.py ${dataGroupFiles[idx]} -d $VERBOSE"
    echo
    if [ $exec != 'a' -a $exec != 'g' ]; then
      read -p "Execute this command? (y/n) " -n1 -s exec
      echo
    fi
    echo
    if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ]; then
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
    echo "./csv2oracle.py ${dataGroupFile} -i $VERBOSE"
    echo
    if [ $exec != 'a' -a $exec != 'g' ]; then
      read -p "Execute this command? (y/n) " -n1 -s exec
      echo
    fi
    echo
    if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ]; then
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

if [ $exec = 'g' ]; then
  echo "Start at:"
  echo $INI
  echo
  echo "End at:"
  date
  echo
fi
