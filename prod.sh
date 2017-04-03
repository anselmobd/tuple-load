#!/bin/bash
# tuzle.sh subject_destination{.sh} [-verbose]

getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I’m sorry, `getopt --test` failed in this environment."
    exit 1
fi
SHORT=gv
LONG=global,verbose
PARSED=$(getopt --options $SHORT --longoptions $LONG --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    exit 2
fi
eval set -- "$PARSED"
while true; do
    case "$1" in
        -g|--global)
            exec=g
            shift
            ;;
        -v|--verbose)
            VERBOSE="-${VERBOSE#-}v"
            shift
            ;;
        # -o|--output)
        #     outFile="$2"
        #     shift 2
        #     ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

# To dbms2csv.py
# Order matters - Criation order
iniFiles=(
)

# To csv2oracle.py
# Order matters - Criation order
dataGroupFiles=(
)

if [ -z ${exec+x} ] ; then
  exec='#'
fi

echo
if [ $exec != 'g' ] ; then
  read -p "Confirm executing 'prod' tuzle? (c/n/g) " -n1 -s exec
  echo
fi

if [ $exec = 'g' ] ; then
  if [ -z ${INIFULL+x} ] ; then
    INIFULL=$(date)
  fi
  EXECARG='-g'
fi

if [ $exec = 'c' -o $exec = 'g' ] ; then

  echo "./tuzle.sh _user_prod.sh $VERBOSE $EXECARG"
  ./tuzle.sh _user_prod.sh $VERBOSE $EXECARG

  echo "./tuzle.sh _basico_prod.sh $VERBOSE $EXECARG"
  ./tuzle.sh _basico_prod.sh $VERBOSE $EXECARG

  echo "./tuzle.sh _contab_prod.sh $VERBOSE $EXECARG"
  ./tuzle.sh _contab_prod.sh $VERBOSE $EXECARG

  echo "./tuzle.sh _produto_prod.sh $VERBOSE $EXECARG"
  ./tuzle.sh _produto_prod.sh $VERBOSE $EXECARG

  echo "./tuzle.sh _comercial_prod.sh $VERBOSE $EXECARG"
  ./tuzle.sh _comercial_prod.sh $VERBOSE $EXECARG

fi

if [ $exec = 'g' ] ; then
  echo "$0 started at:"
  echo $INIFULL
  echo
  echo "$0 ended at:"
  date
  echo
fi
