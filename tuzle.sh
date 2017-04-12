#!/bin/bash
# tuzle.sh subject_destination{.sh} [-verbose]

# rascunho
#./csv2oracle.py -b csv/regiao.csv yaml/regiao.PEDI_040.yaml -vvvvv --dbvar prod

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

if [[ $# -ne 1 ]]; then
  echo 'Sintax: tuzle.sh subject_destination{.sh} [-g][-v{1,4}]'
  exit 64
fi

if [ $1 ] ; then
  . $1
fi

if [ -z ${DBVAR+x} ] ; then
  echo "No var DBVAR in $1"
  exit 65
fi

if [ -z ${exec+x} ] ; then
  exec='#'
fi

if [ $exec = 'g' ] ; then
  if [ -z ${INI+x} ] ; then
    INI=$(date)
  fi
fi

echo '-- tuzle creation --'
for iniFile in "${iniFiles[@]}" ; do
  echo "dbms2csv.py - ${iniFile}"
done

echo '-- tuzle mantain --'
for dataGroupFiles in "${dataGroupFiles[@]}" ; do
  echo "dbms2csv.py - ${dataGroupFiles}"
done

echo '-- --'

if [ ${#iniFiles[@]} -eq 0 ] ; then
  if [ ${#dataGroupFiles[@]} -eq 0 ] ; then
     echo 'Nothing to do'
     exit 0
  fi
fi

if [ ${#iniFile[@]} -ne 0 ] ; then

  # generate

  echo
  echo "====="
  echo "Generate CSVs"
  echo

  if [ $exec != 'g' ] ; then
    read -p "Confirm executing 'Generate'? (c/n/a/g) " -n1 -s exec
    echo

    if [ $exec = 'g' ] ; then
      if [ -z ${INI+x} ] ; then
        INI=$(date)
      fi
    fi
  fi

  if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ] ; then

    echo
    for (( idx=1 ; idx<=${#iniFiles[@]}-2 ; idx++ )) ; do
      echo
      echo "====="
      echo "./dbms2csv.py ${iniFiles[idx]} $VERBOSE"
      echo
      if [ $exec != 'a' -a $exec != 'g' ] ; then
        read -p "Execute this command? (y/n) " -n1 -s exec
        echo
      fi
      echo
      if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ] ; then
        ./dbms2csv.py ${iniFiles[idx]} $VERBOSE
        if [ $? -eq 0 ] ; then
          echo
          echo "Generated data group ${iniFiles[idx]} - OK !!!"
        else
          echo
          echo "ERROR generating data group ${iniFiles[idx]} !!!"
          exit
        fi
      else
        echo "Jump ${iniFiles[idx]}"
      fi
    done
    echo

  fi

fi

if [ ${#dataGroupFiles[@]} -ne 0 ] ; then

  # delete

  echo
  echo "====="
  echo "Delete tuples no longer useful"
  echo
  if [ $exec != 'g' ] ; then
    read -p "Confirm executing 'Delete'? (c/n/a/g) " -n1 -s exec
    echo

    if [ $exec = 'g' ] ; then
      if [ -z ${INI+x} ] ; then
        INI=$(date)
      fi
    fi

  fi

  if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ] ; then

    echo
    for (( idx=${#dataGroupFiles[@]}-2 ; idx>=1 ; idx-- )) ; do
      echo
      echo "====="
      echo "./csv2oracle.py ${dataGroupFiles[idx]} -d $VERBOSE $DBVAR"
      echo
      if [ $exec != 'a' -a $exec != 'g' ] ; then
        read -p "Execute this command? (y/n) " -n1 -s exec
        echo
      fi
      echo
      if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ] ; then
        ./csv2oracle.py ${dataGroupFiles[idx]} -d $VERBOSE $DBVAR
        if [ $? -eq 0 ] ; then
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
  if [ $exec != 'g' ] ; then
    read -p "Confirm executing 'Insert/Update'? (c/n/a/g) " -n1 -s exec
    echo

    if [ $exec = 'g' ] ; then
      if [ -z ${INI+x} ] ; then
        INI=$(date)
      fi
    fi

  fi

  if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ] ; then

    echo
    for (( idx=1 ; idx<=${#dataGroupFiles[@]}-2 ; idx++ )) ; do
      echo
      echo "====="
      echo "./csv2oracle.py ${dataGroupFiles[idx]} -i $VERBOSE $DBVAR"
      echo
      if [ $exec != 'a' -a $exec != 'g' ] ; then
        read -p "Execute this command? (y/n) " -n1 -s exec
        echo
      fi
      echo
      if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ] ; then
        ./csv2oracle.py ${dataGroupFiles[idx]} -i $VERBOSE $DBVAR
        if [ $? -eq 0 ] ; then
          echo
          echo "Inserted/Updated data group ${dataGroupFiles[idx]} - OK !!!"
        else
          echo
          echo "ERROR Inserting/Updating data group ${dataGroupFiles[idx]} !!!"
          exit
        fi
      else
        echo "Jump ${dataGroupFiles[idx]}"
      fi
    done
    echo

  fi

fi

echo

if [ -z ${exec+x} ] ; then
  exec='#'
fi

if [ $exec = 'g' ] ; then
  echo "Start at:"
  echo $INI
  echo
  echo "End at:"
  date
  echo
fi
