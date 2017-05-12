#!/bin/bash

./csv2oracle.py ean_havan_tam -vvvv --dbvar prod
./csv2oracle.py ean_havan_cor_tam -vvvv --dbvar prod

./csv2oracle.py ean_nao_havan -vvvv --dbvar prod
./csv2oracle.py ean_nao_havan_tam -vvvv --dbvar prod
./csv2oracle.py ean_nao_havan_cor_tam -vvvv --dbvar prod

./csv2oracle.py ean_0706B_0717B_05156_cor_tam -vvvv --dbvar prod
