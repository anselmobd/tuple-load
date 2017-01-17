#!/usr/bin/python3
# -*- coding: utf8 -*-

import sys
import os.path
from pprint import pprint

import argparse
import configparser
import json
import csv
import yaml

import cx_Oracle

import myOracle
from oxy.usual import VerboseOutput


class Main:

    def checkFile(self, fileName, description, exitError):
        self.vOut.prnt(description + ' file: {}'.format(fileName))
        if not os.path.exists(fileName):
            print('"{}" file "{}" does not exist'.format(
                description, fileName))
            sys.exit(exitError)

    def fileWithDefaultDir(self, dire, fileName):
        path, name = os.path.split(fileName)
        if not path:
            path = dire
        return os.path.join(path, name)

    def connectDataBase(self):
        dbTo = 'db.to.{}'.format(self.rules['sql']['db'])
        if self.config.get(dbTo, 'dbms') != 'oracle':
            raise NameError('For now, script prepared only for Oracle.')

        self.oracle = myOracle.Oracle(
            self.config.get(dbTo, 'username'),
            self.config.get(dbTo, 'password'),
            self.config.get(dbTo, 'hostname'),
            self.config.get(dbTo, 'port'),
            self.config.get(dbTo, 'servicename'),
            self.config.get(dbTo, 'schema'))
        self.oracle.verbosity = self.args.verbosity

        self.oracle.connect()
        self.vOut.prnt(
            'Banco de dados conectado. (versão do Oracle: {})'.format(
                self.oracle.con.version))

    def closeDataBase(self):
        self.oracle.commit()
        self.oracle.disconnect()

    def __init__(self):
        self.main()

    def parseArgs(self):
        parser = argparse.ArgumentParser(
            description='Write CSV data to Oracle',
            epilog="(c) Tussor & Oxigenai",
            formatter_class=argparse.RawTextHelpFormatter)
        parser.add_argument(
            "csvFile",
            help='data group CSV file name, in the format '
            'data_group_name[.version].csv')
        parser.add_argument(
            "--cfg", "--cfgfile",
            type=str,
            default='tuple-load.cfg',
            help='config file of data groups')
        parser.add_argument(
            "--ini", "--inidir",
            type=str,
            default='ini',
            help='default directory for INI files')
        parser.add_argument(
            "--csv", "--csvdir",
            type=str,
            default='csv',
            help='default directory for CSV files')
        parser.add_argument(
            "--json", "--jsondir",
            type=str,
            default='json',
            help='default directory for JSON files')
        parser.add_argument(
            "--yaml", "--yamldir",
            type=str,
            default='yaml',
            help='default directory for YAML files')
        parser.add_argument(
            "--yc", "--yamlcfg",
            action="store_true",
            help='use YAML format config file')
        parser.add_argument(
            "-i", "--insert",
            action="store_true",
            help="insert or update in Oracle rows in CSV\n"
                 "(default if none action defined)")
        parser.add_argument(
            "-u", "--update",
            action="store_true",
            help="same as -i")
        parser.add_argument(
            "-d", "--delete", action="store_true",
            help="delete in Oracle rows not in CSV")
        parser.add_argument(
            "-b", "--both", action="store_true",
            help="force -i and -d")
        parser.add_argument(
            "-v", "--verbosity", action="count", default=0,
            help="increase output verbosity")
        self.args = parser.parse_args()

        self.args.insert = self.args.insert \
            or self.args.update or self.args.both
        self.args.delete = self.args.delete or self.args.both
        if self.args.insert == self.args.delete:
            self.args.insert = True

        self.args.csvFile = \
            self.fileWithDefaultDir(self.args.csv, self.args.csvFile)

    def configProcess(self):
        self.vOut.prnt('->configProcess', 2)

        if self.args.insert:
            self.vOut.prnt('--insert', 2)
        if self.args.delete:
            self.vOut.prnt('--delete', 2)
        if self.args.update:
            self.vOut.prnt('--update', 2)
        if self.args.both:
            self.vOut.prnt('--both', 2)

        self.checkFile(self.args.csvFile, 'CSV', 11)

        self.checkFile(self.args.cfg, 'Config', 12)

        self.config = configparser.RawConfigParser()
        self.config.read(self.args.cfg)

        if os.path.exists('secret.py'):
            from secret import DBSECRET
            for dbkey in DBSECRET:
                self.config[dbkey].update(DBSECRET[dbkey])

        dataGroup = os.path.basename(self.args.csvFile)
        dataGroup = os.path.splitext(dataGroup)[0]
        dataGroup = dataGroup.split('.')[0]
        self.vOut.prnt('Data group name: %s' % (dataGroup))

        sqlTable = self.config.get('data_groups', dataGroup)
        self.vOut.prnt('SQL Table name: %s' % (sqlTable))

        if self.args.yc:
            self.jsonFileName = ''.join((sqlTable, '.yaml'))
            self.jsonFileName = \
                self.fileWithDefaultDir(self.args.yaml, self.jsonFileName)
        else:
            self.jsonFileName = ''.join((sqlTable, '.json'))
            self.jsonFileName = \
                self.fileWithDefaultDir(self.args.json, self.jsonFileName)
        self.vOut.prnt('JSON file name: %s' % (self.jsonFileName))

    def run(self):
        self.vOut.prnt('->run', 2)

        if self.args.yc:
            self.readYaml()
        else:
            self.readJson()

        try:
            self.connectDataBase()

            if self.args.insert:
                for dataRow in self.readCsvGenerator():
                    self.insertUpdateRow(dataRow)

            if self.args.delete:
                self.readCsvKeys()
                self.deleteRows()
        finally:
            if self.oracle.connected:
                self.closeDataBase()

    def readJson(self):
        self.vOut.prnt('->readJson', 2)
        with open(self.jsonFileName) as json_data:
            self.rules = json.load(json_data)
        self.vOut.pprnt(self.rules, 3)

    def readYaml(self):
        self.vOut.prnt('->readYaml', 2)
        with open(self.jsonFileName) as yaml_data:
            self.rules = yaml.load(yaml_data)
        self.vOut.pprnt(self.rules, 3)

    def readCsvGenerator(self):
        self.vOut.prnt('->readCsvGenerator', 2)
        with open(self.args.csvFile) as csvfile:
            readCsv = csv.reader(csvfile, delimiter=';')
            columns = None
            for row in readCsv:
                if columns:
                    dictRow = dict(zip(columns, row))
                    self.vOut.pprnt(dictRow, 3)
                    self.vOut.pprnt(
                        list(
                            (dictRow[f] for f in self.rules['csv']['keys'])
                            ), 3)
                    yield dictRow
                    # break
                else:
                    columns = row

    def insertUpdateRow(self, dictRow):
        self.vOut.prnt('->insertUpdate', 2)
        self.vOut.pprnt(dictRow, 3)

        keyRow = dict(((k, dictRow[k]) for k in self.rules['csv']['keys']))
        self.vOut.pprnt(keyRow)

        # counting rows

        rulesql = self.rules['sql']['key_count']
        if isinstance(rulesql, list):
            sql = '\n'.join(rulesql)
        else:
            sql = rulesql
        self.vOut.prnt(sql, 3, sep='---')

        cursor = self.oracle.cursorExecute(sql, keyRow)
        countRows = cursor.fetchall()[0][0]
        self.vOut.prnt('count = %s' % (countRows), 2)

        if countRows == 1:
            sql = '\n'.join(self.rules['sql']['update'])
            self.vOut.prnt(sql, 3, sep='---')

            cursor = self.oracle.cursorExecute(sql, dictRow)
            self.vOut.prnt('updated: %s' % (cursor.rowcount), 2)
        else:
            sql = '\n'.join(self.rules['sql']['insert'])
            self.vOut.prnt(sql, 3, sep='---')

            cursor = self.oracle.cursorExecute(sql, dictRow)
            self.vOut.prnt('inserted: %s' % (cursor.rowcount), 2)

    def readCsvKeys(self):
        self.vOut.prnt('->readCsvKeys', 2)
        self.keys = []
        for dataRow in self.readCsvGenerator():
            completeKey = ()
            for keyName in self.rules['csv']['keys']:
                key = dataRow[keyName]
                if ('fields' in self.rules['csv'] and
                        keyName in self.rules['csv']['fields']):
                    fieldType = self.rules['csv']['fields'][keyName]['type']
                    if fieldType == 'integer':
                        key = int(key)
                completeKey += (key,)
            self.keys.append(completeKey)
        self.vOut.prnt('self.keys', 3)
        self.vOut.pprnt(self.keys, 3)

    def deleteRows(self):
        self.vOut.prnt('->deleteRows', 2)

        sql = '\n'.join(self.rules['sql']['key_list'])
        self.vOut.prnt(sql, 3, sep='---')

        cursor = self.oracle.cursorExecute(sql)

        toDelete = []
        for row in cursor:
            self.vOut.prnt('row', 4)
            self.vOut.pprnt(row, 4)
            if row in self.keys:
                self.vOut.prnt('remove', 3)
                self.keys.remove(row)
            else:
                self.vOut.prnt('append', 3)
                toDelete.append(
                    {self.rules['csv']['keys'][i]: row[i]
                        for i in range(0, len(row))})

        self.vOut.pprnt(toDelete, 3)

        if len(toDelete) > 0:
            sql = '\n'.join(self.rules['sql']['delete'])
            self.vOut.prnt(sql, 2, sep='---')

            for deleteKey in toDelete:
                self.vOut.prnt('Delete: "{}"'.format(deleteKey))
                cursor = self.oracle.cursorExecute(
                    sql, deleteKey, self.oracle.CONTINUE_ON_ERROR)
                self.vOut.prnt('deleted: %s' % (cursor.rowcount), 2)

    def main(self):
        self.parseArgs()
        self.vOut = VerboseOutput(self.args.verbosity)
        self.configProcess()
        self.run()


if __name__ == '__main__':
    Main()
