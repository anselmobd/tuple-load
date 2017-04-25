
# 2017-04-25

./csv2oracle.py csv/corrigindo_codigos.csv yaml/corrigindo_codigos.yaml -vvvv --dbvar simula
./csv2oracle.py csv/corrigindo_codigos.csv yaml/corrigindo_codigos.yaml -vvvv --dbvar prod

./csv2oracle.py csv/m_to_c.csv yaml/copiando_produto_capa.yaml -vvvv --dbvar simula
./csv2oracle.py csv/m_to_c.csv yaml/copiando_produto_capa.yaml -vvvv --dbvar prod

./csv2oracle.py csv/m_to_r.csv yaml/copiando_produto_capa.yaml -vvvv --dbvar simula
./csv2oracle.py csv/m_to_r.csv yaml/copiando_produto_capa.yaml -vvvv --dbvar prod

