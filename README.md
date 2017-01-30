# tuzle

Creating CSV tuples from relational databases, loading CSV tuples into relational databases.

## Scripts

- csv2oracle.py - Get data from a CSV and, according configuration files, write to an Oracle database.

- dbms2csv.py - Get data from MS-SQL database and, according configuration files, write to a CSV file.

- uniqtuples.py - Join 2 CSV files with compatible headers (all columns in first CSV must exist in second one) avoiding duplication

## Other files

- tuple-load.cfg - Configuration file, used to:
. Link an intelligible name of data group a to a table name in an RDB.
  . The intelligible name is the start of the name of a CSV file (.csv), which contains the tuples (the data).
  . The table name in an RDB is the start of the name of a JSON (or YAML) file (.json or .yaml), which contains information about how to work with that table in the RDB.
. Indicate informations necessaire to connect to RDB.

## Directories

- csv (/\*.csv) : One file per data group.

- json (/\*.json) : One file per database table, with SQL commands required to load.

- yaml (/\*.yaml) : One file per database table, with SQL commands required to load. (better readability)

- ini (/\*.ini) : One file per data groups to be created.

- oxy : Package with generic (Oxigenai) modules

(c) Tussor & Oxigenai
