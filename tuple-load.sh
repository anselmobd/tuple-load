#!/bin/bash

./csv2oracle.py csv/unidades_de_medida.fixo.csv -d -vvv

./csv2oracle.py csv/tamanho.fixo.csv -d -vvv

./csv2oracle.py csv/conta_de_estoque.v161202.csv -d -vvv

./dbms2csv.py ini/insumo_nao_tecido_capa.ini > csv/insumos_nao_tecido_capa.csv

./csv2oracle.py csv/insumos_nao_tecido_capa.csv -d -vvv
