#!/bin/bash

if [ $1 ] ; then
  VERBOSE=$1
else
  VERBOSE="-vvv"
fi

# generate

./dbms2csv.py insumo_nao_tecido_codigos $VERBOSE

./dbms2csv.py insumo_nao_tecido_capa $VERBOSE

./dbms2csv.py insumo_nao_tecido_tamanho $VERBOSE

./dbms2csv.py insumo_nao_tecido_tamanho_cor $VERBOSE

./dbms2csv.py insumo_tecido_codigos $VERBOSE

./dbms2csv.py insumo_tecido_capa $VERBOSE

./dbms2csv.py insumo_tecido_tamanho $VERBOSE

./dbms2csv.py insumo_tecido_tamanho_cor $VERBOSE

./dbms2csv.py insumo_tecido_tamanho_cor_col $VERBOSE

./dbms2csv.py produto_colecao $VERBOSE

./dbms2csv.py produto_loteexpedicao_referencias $VERBOSE

./dbms2csv.py produto_fabric_pa_capa $VERBOSE

./dbms2csv.py produto_fabric_md_capa $VERBOSE

./dbms2csv.py produto_pa_capa $VERBOSE

./dbms2csv.py produto_pa_tamanho $VERBOSE

./dbms2csv.py produto_pa_tamanho_cor $VERBOSE

./dbms2csv.py produto_md_capa $VERBOSE

./dbms2csv.py produto_md_tamanho $VERBOSE

./dbms2csv.py produto_md_tamanho_cor $VERBOSE

./dbms2csv.py produto_pa_estrutura $VERBOSE

# delete

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

# insert/update

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
