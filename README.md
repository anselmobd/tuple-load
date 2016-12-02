# tuple-load
Loading CVS tuples into relational databases.

- cvs2oracle.py - Get data from a CSV and, according configuration files, write
to an Oracle database.

## Files for routine testing.

- tables.cfg - Configuration file, which for the moment is only used to link an intelegable table name to the table name in an RDB. The intelegable name is the name of the CSV file (with a .csv), which contains the tuples (the data). The table name in the RDB is the name of the JSON file (with a .json), which contains information about the columns of the table.

- tamanho.csv - First set of tuples.

- BASI_220.json - First file with information from a table.

## ./cvs2oracle.py --help

```
usage: cvs2oracle.py [-h] [-i] [-u] [-d] [-b] [-v] cvsFile configFile

Write CSV data to Oracle

positional arguments:
  cvsFile          data group CVS file name, in the format data_group_name[.version].csv
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
