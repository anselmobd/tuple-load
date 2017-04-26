
# 2017-04-25

./csv2oracle.py csv/corrigindo_codigos.csv yaml/corrigindo_codigos.yaml -vvvv --dbvar simula
./csv2oracle.py csv/corrigindo_codigos.csv yaml/corrigindo_codigos.yaml -vvvv --dbvar prod

./csv2oracle.py csv/m_to_c.csv yaml/copiando_produto_capa.yaml -vvvv --dbvar simula
./csv2oracle.py csv/m_to_c.csv yaml/copiando_produto_capa.yaml -vvvv --dbvar prod

./csv2oracle.py csv/m_to_r.csv yaml/copiando_produto_capa.yaml -vvvv --dbvar simula
./csv2oracle.py csv/m_to_r.csv yaml/copiando_produto_capa.yaml -vvvv --dbvar prod

./csv2oracle.py csv/estru_pa_individual_to_md.csv yaml/copiando_estru_pa_individual_to_md.yaml -vvvv --dbvar simula
./csv2oracle.py csv/estru_pa_individual_to_md.csv yaml/copiando_estru_pa_individual_to_md.yaml -vvvv --dbvar prod

./csv2oracle.py csv/estru_md_individual_to_pa_2_3.csv yaml/copiando_estru_md_individual_to_pa_2_3.yaml -vvvv --dbvar simula
./csv2oracle.py csv/estru_md_individual_to_pa_2_3.csv yaml/copiando_estru_md_individual_to_pa_2_3.yaml -vvvv --dbvar prod

./csv2oracle.py csv/md_pa.csv yaml/copiando_estru_pa_kit_to_pa_1_2_3_inc300_del.yaml -vvvv --dbvar simula
./csv2oracle.py csv/md_pa.csv yaml/copiando_estru_pa_kit_to_pa_1_2_3_inc300_del.yaml -vvvv --dbvar prod

./csv2oracle.py csv/md_pa.csv yaml/copiando_estru_md_kit_to_pa_1_2_3.yaml -vvvv --dbvar simula
./csv2oracle.py csv/md_pa.csv yaml/copiando_estru_md_kit_to_pa_1_2_3.yaml -vvvv --dbvar prod
