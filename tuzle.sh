#!/bin/bash
# tuzle.sh subject_destination{.sh} [-verbose]

# rascunho
#./csv2oracle.py -b csv/regiao.csv yaml/regiao.PEDI_040.yaml -vvvvv --dbvar prod

if [ $1 ] ; then
  . $1
else
  echo 'Sintax: tuzle.sh _subject_destination.sh [-verbose]'
  exit 64
fi

if [ -z ${DBVAR+x} ] ; then
  echo "No var DBVAR in $1"
  exit 65
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

if [ $2 ] ; then
  VERBOSE=$2
else
  VERBOSE=""
fi

if [ ${#iniFile[@]} -ne 0 ] ; then

  # generate

  echo
  echo "====="
  echo "Generate CSVs"
  echo
  read -p "Confirm executing 'Generate'? (c/n/a/g) " -n1 -s exec
  echo

  if [ $exec = 'g' ] ; then
    INI=$(date)
  fi

  if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ] ; then

    echo
    for iniFile in "${iniFiles[@]}"
    do
      echo
      echo "====="
      echo "./dbms2csv.py ${iniFile} $VERBOSE"
      echo
      if [ $exec != 'a' -a $exec != 'g' ] ; then
        read -p "Execute this command? (y/n) " -n1 -s exec
        echo
      fi
      echo
      if [ $exec = 'y' -o $exec = 'a' -o $exec = 'g' ] ; then
        ./dbms2csv.py ${iniFile} $VERBOSE
        if [ $? -eq 0 ] ; then
          echo
          echo "Generated data group ${iniFile} - OK !!!"
        else
          echo
          echo "ERROR generating data group ${iniFile} !!!"
          exit
        fi
      else
        echo "Jump ${iniFile}"
      fi
    done
    echo

  fi

fi

if [ ${#dataGroupFiles[@]} -ne 0 ] ; then

  if [ -z ${exec+x} ] ; then
    exec='#'
  fi

  # delete

  echo
  echo "====="
  echo "Delete tuples no longer useful"
  echo
  if [ $exec != 'g' ] ; then
    read -p "Confirm executing 'Delete'? (c/n/a/g) " -n1 -s exec
    echo

    if [ $exec = 'g' ] ; then
      INI=$(date)
    fi

  fi

  if [ $exec = 'c' -o $exec = 'a' -o $exec = 'g' ] ; then

    echo
    for (( idx=${#dataGroupFiles[@]}-2 ; idx>=1 ; idx-- )) ; do
      echo
      echo "====="
      echo "idx = $idx"
      echo "{dataGroupFiles[idx]} = ${dataGroupFiles[$idx]}"
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
      INI=$(date)
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