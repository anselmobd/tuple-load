#!/bin/bash

# generate

./dbms2csv.py insumo_nao_tecido_capa.ini > csv/_insumo_nao_tecido_capa.csv

./dbms2csv.py insumo_nao_tecido_tamanho.ini > csv/_insumo_nao_tecido_tamanho.csv

# delete

./csv2oracle.py _insumo_nao_tecido_capa.csv -d -vvv

./csv2oracle.py conta_de_estoque.v161202.csv -d -vvv

./csv2oracle.py tamanho.fixo.csv -d -vvv

./csv2oracle.py unidades_de_medida.fixo.csv -d -vvv

# insert/update

./csv2oracle.py unidades_de_medida.fixo.csv -i -vvv

./csv2oracle.py tamanho.fixo.csv -i -vvv

./csv2oracle.py conta_de_estoque.v161202.csv -i -vvv

./csv2oracle.py _insumo_nao_tecido_capa.csv -i -vvv
