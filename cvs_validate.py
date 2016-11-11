#!/usr/bin/python3

import sys
import os.path
from pprint import pprint

import argparse
import configparser
import csv
import json


class Main:

    def printV(self, message, level=1):
        if self.args.verbosity >= level:
            print(message)

    def checkFile(self, fileName, description, exitError):
        self.printV((description + ' file: %s') % (fileName))
        if not os.path.exists(fileName):
            print(
                '"' + description + '" file "' + fileName +
                '" does not exist')
            sys.exit(exitError)

    def __init__(self):
        # self.args = None
        # self.jsonFileName = None
        self.main()

    def parseArgs(self):
        parser = argparse.ArgumentParser(
            description='Verify CSV files against structure in JSON file',
            epilog="(c) Tussor & Oxigenai")
        parser.add_argument("cvsFile", help='CVS file')
        parser.add_argument(
            "configFile",
            help='Config file with dictionary of table names')
        parser.add_argument(
            "-v", "--verbosity", action="count", default=0,
            help="increase output verbosity")
        self.args = parser.parse_args()

    def config(self):
        self.checkFile(self.args.cvsFile, 'CSV', 11)

        self.checkFile(self.args.configFile, 'Config', 12)

        config = configparser.RawConfigParser()
        config.read(self.args.configFile)

        tableName = os.path.splitext(self.args.cvsFile)[0]
        self.printV('Table name: %s' % (tableName))

        sqlTable = config.get('tables', tableName)
        self.printV('SQL Table name: %s' % (sqlTable))

        self.jsonFileName = ''.join((sqlTable, '.json'))
        self.printV('JSON file name: %s' % (self.jsonFileName))

    def validateCvs(self):
        with open(self.jsonFileName) as json_data:
            fields = json.load(json_data)
            pprint([field['name'] for field in fields
                    if 'default' not in field.keys()])

        with open(self.args.cvsFile) as csvfile:
            readCsv = csv.reader(csvfile, delimiter=',')
            for row in readCsv:
                print(row[0])

    def main(self):
        self.parseArgs()
        self.config()
        self.validateCvs()

if __name__ == '__main__':
    Main()
