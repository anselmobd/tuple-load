#!/bin/bash

if [ $1 ] ; then
  VERBOSE=$1
else
  VERBOSE="-vvv"
fi

# generate

./dbms2csv.py insumo_nao_tecido_codigos.ini _insumo_nao_tecido_codigos.csv $VERBOSE

./dbms2csv.py insumo_nao_tecido_capa.ini _insumo_nao_tecido_capa.csv $VERBOSE

./dbms2csv.py insumo_nao_tecido_tamanho.ini _insumo_nao_tecido_tamanho.csv $VERBOSE

./dbms2csv.py insumo_nao_tecido_tamanho_cor.ini _insumo_nao_tecido_tamanho_cor.csv $VERBOSE

./dbms2csv.py insumo_tecido_codigos.ini _insumo_tecido_codigos.csv $VERBOSE

./dbms2csv.py insumo_tecido_capa.ini _insumo_tecido_capa.csv $VERBOSE

./dbms2csv.py insumo_tecido_tamanho.ini _insumo_tecido_tamanho.csv $VERBOSE

./dbms2csv.py insumo_tecido_tamanho_cor.ini _insumo_tecido_tamanho_cor.csv $VERBOSE

./dbms2csv.py insumo_tecido_tamanho_cor_col.ini _insumo_tecido_tamanho_cor_col.csv $VERBOSE

./dbms2csv.py produto_colecao.ini _produto_colecao.csv $VERBOSE

./dbms2csv.py produto_loteexpedicao_referencias.ini _produto_loteexpedicao_referencias.csv $VERBOSE

./dbms2csv.py produto_fabric_capa.ini _produto_fabric_capa.csv $VERBOSE

./dbms2csv.py produto_pa_capa.ini _produto_pa_capa.csv $VERBOSE

./dbms2csv.py produto_pa_tamanho.ini _produto_pa_tamanho.csv $VERBOSE

./dbms2csv.py produto_pa_tamanho_cor.ini _produto_pa_tamanho_cor.csv $VERBOSE

# delete

./csv2oracle.py csv/_insumo_tecido_tamanho_cor_col.csv yaml/basi_400.produtos_referencia_nivel_2_tamanho_cor_col.yaml -d $VERBOSE

./csv2oracle.py _insumo_nao_tecido_tamanho_cor.csv -d $VERBOSE

./csv2oracle.py _insumo_nao_tecido_tamanho.csv -d $VERBOSE

./csv2oracle.py _insumo_nao_tecido_capa.csv -d $VERBOSE

./csv2oracle.py _insumo_tecido_tamanho_cor.csv -d $VERBOSE

./csv2oracle.py _insumo_tecido_tamanho.csv -d $VERBOSE

./csv2oracle.py _insumo_tecido_capa.csv -d $VERBOSE

./csv2oracle.py _produto_colecao.csv -d $VERBOSE

./csv2oracle.py csv/_produto_pa_tamanho_cor.csv yaml/basi_010.produtos_pa_nivel_1_tamanho_cor.yaml -d $VERBOSE

./csv2oracle.py csv/_produto_pa_tamanho.csv yaml/basi_020.produtos_pa_nivel_1_tamanho.yaml -d $VERBOSE

./csv2oracle.py csv/_produto_pa_capa.csv  yaml/basi_030.produtos_pa_nivel_1.yaml -d $VERBOSE

./csv2oracle.py ncm.fixo.csv -d $VERBOSE

./csv2oracle.py produto-artigo_de_produto.csv -d $VERBOSE

./csv2oracle.py tecido-artigo_de_produto.csv -d $VERBOSE

./csv2oracle.py produto-linha_de_produto.csv -d $VERBOSE

./csv2oracle.py tecido-linha_de_produto.csv -d $VERBOSE

./csv2oracle.py conta_de_estoque.v161202.csv -d $VERBOSE

./csv2oracle.py cor.fixo.csv -d $VERBOSE

./csv2oracle.py tamanho.fixo.csv -d $VERBOSE

./csv2oracle.py unidades_de_medida.fixo.csv -d $VERBOSE

# insert/update

./csv2oracle.py unidades_de_medida.fixo.csv -i $VERBOSE

./csv2oracle.py tamanho.fixo.csv -i $VERBOSE

./csv2oracle.py cor.fixo.csv -i $VERBOSE

./csv2oracle.py conta_de_estoque.v161202.csv -i $VERBOSE

./csv2oracle.py tecido-linha_de_produto.csv -i $VERBOSE

./csv2oracle.py produto-linha_de_produto.csv -i $VERBOSE

./csv2oracle.py tecido-artigo_de_produto.csv -i $VERBOSE

./csv2oracle.py produto-artigo_de_produto.csv -i $VERBOSE

./csv2oracle.py ncm.fixo.csv -i $VERBOSE

./csv2oracle.py csv/_produto_pa_capa.csv yaml/basi_030.produtos_pa_nivel_1.yaml -i $VERBOSE

./csv2oracle.py csv/_produto_pa_tamanho.csv yaml/basi_020.produtos_pa_nivel_1_tamanho.yaml -i $VERBOSE

./csv2oracle.py csv/_produto_pa_tamanho_cor.csv yaml/basi_010.produtos_pa_nivel_1_tamanho_cor.yaml -d $VERBOSE

./csv2oracle.py _produto_colecao.csv -i $VERBOSE

./csv2oracle.py _insumo_tecido_capa.csv -i $VERBOSE

./csv2oracle.py _insumo_tecido_tamanho.csv -i $VERBOSE

./csv2oracle.py _insumo_tecido_tamanho_cor.csv -i $VERBOSE

./csv2oracle.py _insumo_nao_tecido_capa.csv -i $VERBOSE

./csv2oracle.py _insumo_nao_tecido_tamanho.csv -i $VERBOSE

./csv2oracle.py _insumo_nao_tecido_tamanho_cor.csv -i $VERBOSE

./csv2oracle.py csv/_insumo_tecido_tamanho_cor_col.csv yaml/basi_400.produtos_referencia_nivel_2_tamanho_cor_col.yaml -i $VERBOSE
