#!/usr/bin/env python3
# -*- coding: utf8 -*-

import sys
import os.path
from pprint import pprint

import configparser
import json
import csv
import yaml

import gettext

from oxy.arg import parse as argparse
from oxy.oracle import Oracle
import oxy.usual as oxyu
from oxy.usual import VerboseOutput


class Main:

    def checkFile(self, fileName, description, exitError):
        self.vOut.prnt(_('{} file: {}').format(description, fileName))
        if not os.path.exists(fileName):
            print(_('file does not exist'))
            sys.exit(exitError)

    def hasRule(self, *path):
        branch = self.rules
        for level in path:
            if level not in branch:
                return False
            branch = branch[level]
        return True

    def getDefRule(self, default, *path):
        result = self.getRule(*path)
        if result is None:
            result = default
        return result

    def getRule(self, *path):
        branch = self.rules
        for level in path:
            if level not in branch:
                return None
            branch = branch[level]
        return branch

    def getStrDefRule(self, default, *path):
        result = self.getStrRule(*path)
        if result is None:
            result = default
        return result

    def getStrRule(self, *path):
        ruleData = self.getRule(*path)
        if isinstance(ruleData, list):
            rule = '\n'.join(ruleData)
        else:
            rule = ruleData
        self.vOut.prnt(rule, 3, sep='---')
        return rule

    def connectDataBase(self):
        self.vOut.prnt('->connectDataBase', 4)
        dbTo = 'db.to.{}{}'.format(self.getRule('sql', 'db'), self.args.dbvar)
        dbms = self.config.get(dbTo, 'dbms')
        self.vOut.prnt('dbTo = {}'.format(dbTo), 3)

        if dbms == 'oracle':
            self.db = Oracle(
                self.config.get(dbTo, 'username'),
                self.config.get(dbTo, 'password'),
                self.config.get(dbTo, 'hostname'),
                self.config.get(dbTo, 'port'),
                self.config.get(dbTo, 'servicename'),
                self.config.get(dbTo, 'schema'))
        else:
            raise NameError(
                'For now, script is not prepared for "'+dbms+'".')

        self.db.verbosity = self.args.verbosity

        self.db.connect()
        self.vOut.prnt(
            _('Database connected. (Oracle version: {})').format(
                self.db.con.version))

    def closeDataBase(self):
        self.db.commit()
        self.db.disconnect()

    def __init__(self):
        self.main()

    def parseArgs(self):
        parser = argparse.ArgumentParser(
            description=_('Write CSV data to Oracle table'),
            epilog="(c) Tussor & Oxigenai",
            formatter_class=argparse.RawTextHelpFormatter)
        parser.add_argument(
            "csvFile",
            help=_('data group CSV file name, in the format '
                   'data_group_name[.version][.csv]'))
        parser.add_argument(
            "rulesFile",
            nargs='?',
            default='',
            help=_('table access definitions (TAD) file name, in the format '
                   'tad_name.{yaml|json}'))
        parser.add_argument(
            "--cfg", "--cfgfile",
            type=str,
            default='tuple-load.cfg',
            help=_('config file of data groups and database access'))
        parser.add_argument(
            "--csv", "--csvdir",
            type=str,
            default='csv',
            help=_('default directory for CSV files'))
        parser.add_argument(
            "--json", "--jsondir",
            type=str,
            default='json',
            help=_('default directory for table access definitions '
                   'in JOSN format'))
        parser.add_argument(
            "--yaml", "--yamldir",
            type=str,
            default='yaml',
            help=_('default directory for table access definitions '
                   'in YAML format'))

        group = parser.add_mutually_exclusive_group()
        group.add_argument(
            "--yamltad", "--yt",
            action="store_true",
            default=True,
            help=_('use YAML format file for table access definitions '
                   '(default)'))
        group.add_argument(
            "--jsontad", "--jt",
            action="store_true",
            help=_('use JOSN format file for table access definitions'))

        parser.add_argument(
            "-i", "--insert",
            action="store_true",
            help=_("insert or update in Oracle rows in CSV\n"
                   "(default if none action defined)"))
        parser.add_argument(
            "-u", "--update",
            action="store_true",
            help=_("(same as -i)"))
        parser.add_argument(
            "-d", "--delete", action="store_true",
            help=_("delete in Oracle rows not in CSV"))
        parser.add_argument(
            "-b", "--both", action="store_true",
            help=_("force -i and -d"))
        parser.add_argument(
            "-v", "--verbosity", action="count", default=0,
            help=_("increase output verbosity"))
        parser.add_argument(
            "--dbvar",
            type=str,
            default='',
            help=_('Variation of the database. '
                   'Suffix of the database identifier. '
                   '(".variation" is added to the identifier used in table '
                   'access definitions)'))
        self.args = parser.parse_args()

        self.args.insert = self.args.insert \
            or self.args.update or self.args.both
        self.args.delete = self.args.delete or self.args.both
        if self.args.jsontad:
            self.args.yamltad = False
        if self.args.insert == self.args.delete:
            self.args.insert = True

        if self.args.dbvar:
            self.args.dbvar = '.'+self.args.dbvar

        self.args.csvFile = \
            oxyu.fileWithRequiredExtension(self.args.csvFile, 'csv')

        self.args.csvFile = \
            oxyu.fileWithDefaultDir(self.args.csv, self.args.csvFile)

    def configProcess(self):
        self.vOut.prnt('->configProcess', 2)

        self.tadTypeScript = False

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
        self.vOut.prnt(_('Data group name: %s') % (dataGroup))

        if self.args.rulesFile == '':
            sqlTable = self.config.get('data_groups', dataGroup)
            self.vOut.prnt(_('SQL Table name: %s') % (sqlTable))

            if self.args.yamltad:
                self.tableADFileName = ''.join((sqlTable, '.yaml'))
                self.tableADFileName = \
                    oxyu.fileWithDefaultDir(self.args.yaml,
                                            self.tableADFileName)
            else:
                self.tableADFileName = ''.join((sqlTable, '.json'))
                self.tableADFileName = \
                    oxyu.fileWithDefaultDir(self.args.json,
                                            self.tableADFileName)
        else:
            self.tableADFileName = self.args.rulesFile

        self.vOut.prnt(_('Table access definitions '
                         'file name: %s') % (self.tableADFileName))

    def countersInit(self):
        self.countInsert = 0
        self.countUpdate = 0
        self.countCommands = 0
        self.countDelete = 0
        self.countFaultDelete = 0

    def countersPrint(self):
        self.vOut.prnt('- Counters')
        if self.tadTypeScript:
            self.vOut.prnt('Script commands: {}'.format(self.countCommands))
        else:
            if self.args.insert:
                self.vOut.prnt('Inserted: {}'.format(self.countInsert))
                self.vOut.prnt('Updated: {}'.format(self.countUpdate))
                self.vOut.prnt(
                    'After Insert Update: {}'.format(self.countCommands))
            if self.args.delete:
                self.vOut.prnt('Deleted: {}'.format(self.countDelete))
                self.vOut.prnt(
                    'Fault Deleted: {}'.format(self.countFaultDelete))

    def run(self):
        self.vOut.prnt('->run', 2)

        if self.args.yamltad:
            self.readYaml()
        else:
            self.readJson()

        self.countersInit()
        try:
            self.connectDataBase()

            self.tadTypeScript =\
                self.getDefRule('iud', 'sql', 'type') == 'script'

            if self.tadTypeScript:

                path = ('sql', 'script')
                for dataRow in self.readCsvGenerator():
                    self.scriptRow(dataRow, *path)

            else:
                if self.args.insert:
                    for dataRow in self.readCsvGenerator():
                        self.insertUpdateRow(dataRow)

                if self.args.delete:
                    self.readCsvKeys()
                    self.deleteRows()
        finally:
            if self.db.connected:
                self.closeDataBase()

        self.countersPrint()

    def readJson(self):
        self.vOut.prnt('->readJson', 2)
        with open(self.tableADFileName) as json_data:
            self.rules = json.load(json_data)
        self.vOut.pprnt(self.rules, 3)

    def readYaml(self):
        self.vOut.prnt('->readYaml', 2)
        with open(self.tableADFileName) as yaml_data:
            self.rules = yaml.load(yaml_data)
        self.vOut.pprnt(self.rules, 3)

    def readCsvGenerator(self):
        self.vOut.prnt('->readCsvGenerator', 2)
        with open(self.args.csvFile) as csvfile:
            readCsv = csv.reader(csvfile, delimiter=';')

            countRows = 0
            firstRows = -1
            if self.hasRule('csv', 'first'):
                firstRows = self.getRule('csv', 'first')
            skipRows = 0
            if self.hasRule('csv', 'skip'):
                skipRows = self.getRule('csv', 'skip')

            columns = None
            for row in readCsv:
                if columns:
                    if skipRows > 0:
                        skipRows -= 1
                        continue

                    rowByColumns = [row[originalColumns.index(col)]
                                    for col in columns]
                    dictRow = dict(zip(columns, rowByColumns))

                    self.vOut.pprnt(dictRow, 3)
                    keys = self.getRule('csv', 'keys')
                    if keys is not None:
                        self.vOut.pprnt(
                            list(
                                (dictRow[f]
                                 for f in self.getRule('csv', 'keys'))
                                ), 3)
                    yield dictRow

                    countRows += 1
                    if countRows == firstRows:
                        break
                else:
                    originalColumns = row
                    columns_tuple = ('csv', 'columns')
                    if self.hasRule(*columns_tuple):
                        columns = self.getRule(*columns_tuple)
                    else:
                        columns = originalColumns

    def insertUpdateRow(self, dictRow):
        self.vOut.prnt('->insertUpdate', 2)
        self.vOut.pprnt(dictRow, 3)

        keyRow = dict(((k, dictRow[k]) for k in self.getRule('csv', 'keys')))
        self.vOut.pprnt(keyRow)

        # counting rows

        sql = self.getStrRule('sql', 'key_count')
        cursor = self.db.cursorExecute(sql, keyRow)
        countRows = cursor.fetchall()[0][0]
        self.vOut.prnt(_('count = %s') % (countRows), 2)

        if countRows >= 1:
            if self.hasRule('sql', 'update'):
                sql = self.getStrRule('sql', 'update')
                cursor = self.db.cursorExecute(sql, dictRow)
                self.vOut.prnt(_('updated: %s') % (cursor.rowcount), 2)
                self.countUpdate += cursor.rowcount
        else:
            if self.hasRule('sql', 'insert'):
                sql = self.getStrRule('sql', 'insert')
                cursor = self.db.cursorExecute(sql, dictRow)
                self.vOut.prnt(_('inserted: %s') % (cursor.rowcount), 2)
                self.countInsert += cursor.rowcount

        path = ('sql', 'after_insert_update')
        if cursor.rowcount != 0 and self.hasRule(*path):
            self.scriptRow(dictRow, *path)

    def scriptRow(self, dictRow, *path):
        self.vOut.prnt('->scriptRow', 2)
        hasSubSql = False
        for sqlOrderInt in range(100):
            strOrderInt = '' if sqlOrderInt == 0 else str(sqlOrderInt)
            sqlOrder = 'command{}'.format(strOrderInt)
            if self.hasRule(*path, sqlOrder):
                hasSubSql = True
                sql = self.getStrRule(*path, sqlOrder)

                columnsPath = None
                colOrder = 'columns{}'.format(strOrderInt)
                if self.hasRule(*path, colOrder):
                    columnsPath = (*path, colOrder)
                elif sqlOrderInt != 0 and self.hasRule(*path, 'columns'):
                    columnsPath = (*path, 'columns')
                if columnsPath is not None:
                    columnsDef = self.getRule(*columnsPath)
                    dictRow = {key: dictRow[key] for key in columnsDef}

                cursor = self.db.cursorExecute(sql, dictRow)
                self.vOut.prnt(_('%s (command: %s): %s') % (
                    path[1], sqlOrderInt, cursor.rowcount), 2)
                self.countCommands += cursor.rowcount
        if not hasSubSql:
            sql = self.getStrRule(*path)
            cursor = self.db.cursorExecute(sql, dictRow)
            self.vOut.prnt(
                _('%s: %s') % (path[1], cursor.rowcount), 2)
            self.countCommands += cursor.rowcount

    def readCsvKeys(self):
        self.vOut.prnt('->readCsvKeys', 2)
        self.keys = []
        for dataRow in self.readCsvGenerator():
            completeKey = ()
            for keyName in self.getRule('csv', 'keys'):
                key = dataRow[keyName]
                if ('fields' in self.rules['csv'] and
                        keyName in self.getRule('csv', 'fields')):
                    fieldType = self.rules['csv']['fields'][keyName]['type']
                    if fieldType == 'integer':
                        key = int(key)
                completeKey += (key,)
            self.keys.append(completeKey)
        self.vOut.prnt('self.keys', 3)
        self.vOut.pprnt(self.keys, 3)

    def deleteRows(self):
        self.vOut.prnt('->deleteRows', 2)

        sql = self.getStrRule('sql', 'key_list')
        cursor = self.db.cursorExecute(sql)

        toDelete = []
        for row in cursor:
            self.vOut.prnt('row', 4)
            self.vOut.pprnt(row, 4)
            if row in self.keys:
                self.vOut.prnt('remove from key list to delete', 4)
                self.keys.remove(row)
            else:
                self.vOut.prnt('key appended to remove', 4)
                toDelete.append(
                    {self.getRule('csv', 'keys')[i]: row[i]
                        for i in range(0, len(row))})

        if len(toDelete) == 0:
            self.vOut.prnt('there is nothing to remove', 4)
        else:
            sql = self.getStrRule('sql', 'delete')
            for deleteKey in toDelete:
                self.vOut.pprnt(deleteKey, 3)
                cursor = self.db.cursorExecute(
                    sql, deleteKey, self.db.CONTINUE_ON_ERROR)
                self.vOut.prnt(_('deleted: %s') % (cursor.rowcount), 2)
                self.countDelete += cursor.rowcount
                if cursor.rowcount == 0:
                    if 'fault_delete' in self.rules['sql']:
                        sql = self.getRule('sql', 'fault_delete')
                        cursor = self.db.cursorExecute(sql, deleteKey)
                        self.vOut.prnt(
                            _('fault deleted: %s') % (cursor.rowcount), 2)
                        self.countFaultDelete += cursor.rowcount

    def main(self):
        self.parseArgs()
        self.vOut = VerboseOutput(self.args.verbosity)
        self.configProcess()
        self.run()


if __name__ == '__main__':
    tupleLoadGT = gettext.translation('tuple-load', 'po', fallback=True)
    tupleLoadGT.install()
    Main()
