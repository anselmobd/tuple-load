# tuple-load
Loading CSV tuples into relational databases.

- csv2oracle.py - Get data from a CSV and, according configuration files, write to an Oracle database.

- dbms2csv.py - Get data from MS-SQL database and, according configuration files, write to a CSV file.
  (Yet in early stages of development.)

## Files

- data_load.cfg - Configuration file, which for the moment is only used to link an intelegable table name to the table name in an RDB. The intelegable name is the name of the CSV file (with a .csv), which contains the tuples (the data). The table name in the RDB is the name of the JSON file (with a .json), which contains information about the columns of the table.

- insumos.ini - Sample configuration file to "dbms2csv.py" script.

## Directories

- csv (/\*.csv) One file per data group.

- json (/\*.json) One file per database table, with SQL commands required to load.

### ./csv2oracle.py --help

```
usage: csv2oracle.py [-h] [-i] [-u] [-d] [-b] [-v] csvFile configFile

Write CSV data to Oracle

positional arguments:
  csvFile          data group CSV file name, in the format data_group_name[.version].csv
  configFile       config file of data groups

optional arguments:
  -h, --help       show this help message and exit
  -i, --insert     insert or update in Oracle rows in CSV
                   (default if none action defined)
  -u, --update     same as -i
  -d, --delete     delete in Oracle rows not in CSV
  -b, --both       force -i and -d
  -v, --verbosity  increase output verbosity

(c) Tussor & Oxigenai
```
