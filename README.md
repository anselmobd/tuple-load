# tuple-load

Loading CSV tuples into relational databases.

## Scripts

- csv2oracle.py - Get data from a CSV and, according configuration files, write to an Oracle database.

- dbms2csv.py - Get data from MS-SQL database and, according configuration files, write to a CSV file.

## Other files

- tuple-load.cfg - Configuration file, used to:
. Link an intelligible name of data group a to the table name in an RDB. The intelligible name is the name of the CSV file (with a .csv), which contains the tuples (the data). The table name in the RDB is the name of the JSON file (with a .json), which contains information about how to work with that table in the RDB.
. Indicate informations necessaire to connect to RDB.

## Directories

- csv (/\*.csv) One file per data group.

- json (/\*.json) One file per database table, with SQL commands required to load.

- ini (/\*.ini) One file per data groups to be created.

### ./csv2oracle.py --help

```
usage: csv2oracle.py [-h] [--cfg CFG] [--ini INI] [--csv CSV] [--json JSON]
                     [-i] [-u] [-d] [-b] [-v]
                     csvFile

Write CSV data to Oracle

positional arguments:
  csvFile               data group CSV file name, in the format data_group_name[.version].csv

optional arguments:
  -h, --help            show this help message and exit
  --cfg CFG, --cfgfile CFG
                        config file of data groups
  --ini INI, --inidir INI
                        default directory for ini files
  --csv CSV, --csvdir CSV
                        default directory for csv files
  --json JSON, --jsondir JSON
                        default directory for json files
  -i, --insert          insert or update in Oracle rows in CSV
                        (default if none action defined)
  -u, --update          same as -i
  -d, --delete          delete in Oracle rows not in CSV
  -b, --both            force -i and -d
  -v, --verbosity       increase output verbosity

(c) Tussor & Oxigenai
```

### ./dbms2csv.py --help

```
usage: dbms2csv.py [-h] [--cfg CFG] [--ini INI] [--csv CSV] [--json JSON] [-v]
                   iniFile csvFile

Write CSV from Mssql database

positional arguments:
  iniFile               data group INI file name, in the format [dir/]data_group_name[.version].ini
  csvFile               CSV file to be created [dir/]_file_name.csv

optional arguments:
  -h, --help            show this help message and exit
  --cfg CFG, --cfgfile CFG
                        config file of data access and groups
  --ini INI, --inidir INI
                        default directory for ini files
  --csv CSV, --csvdir CSV
                        default directory for csv files
  --json JSON, --jsondir JSON
                        default directory for json files
  -v, --verbosity       increase output verbosity

(c) Tussor & Oxigenai
```
