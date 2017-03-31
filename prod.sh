#!/bin/bash
# tuzle.sh subject_destination{.sh} [-verbose]

# To dbms2csv.py
# Order matters - Criation order
iniFiles=(
)

# To csv2oracle.py
# Order matters - Criation order
dataGroupFiles=(
)

if [ $1 ] ; then
  VERBOSE=$1
else
  VERBOSE=""
fi

echo "./tuzle.sh _user_prod.sh $VERBOSE"
./tuzle.sh _user_prod.sh $VERBOSE

echo "./tuzle.sh _basico_prod.sh $VERBOSE"
./tuzle.sh _basico_prod.sh $VERBOSE

echo "./tuzle.sh _contab_prod.sh $VERBOSE"
./tuzle.sh _contab_prod.sh $VERBOSE

echo "./tuzle.sh _produto_prod.sh $VERBOSE"
./tuzle.sh _produto_prod.sh $VERBOSE

echo "./tuzle.sh _comercial_prod.sh $VERBOSE"
./tuzle.sh _comercial_prod.sh $VERBOSE
