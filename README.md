# tuple-load
Loading CVS tuples into relational databases.

- cvs2oracle.py - Get data from a CSV and, according configuration files, write
to an Oracle database.

## Files for routine testing.

- tables.cfg - Configuration file, which for the moment is only used to link an intelegable table name to the table name in an RDB. The intelegable name is the name of the CSV file (with a .csv), which contains the tuples (the data). The table name in the RDB is the name of the JSON file (with a .json), which contains information about the columns of the table.

- tamanho.csv - First set of tuples.

- BASI_220.json - First file with information from a table.

## ./cvs2oracle.py --help
