#!/usr/bin/env python3
# -*- coding: utf8 -*-

import sys
import os.path
import locale
import contextlib
from pprint import pprint
import operator
import subprocess
import hashlib

import configparser
import json
import csv

import gettext

from oxy.arg import parse as argparse
from oxy.mssql import Mssql
from oxy.firebird import Firebird
import oxy.usual as oxyu
from oxy.usual import VerboseOutput
import oxy.inner_functions as oxyin


class Main:

    def checkFile(self, fileName, description, exitError):
        self.vOut.prnt(description + ' file: {}'.format(fileName))
        if not os.path.exists(fileName):
            print('"{}" file "{}" does not exist'.format(
                description, fileName), file=sys.stderr)
            sys.exit(exitError)

    def connectDataBase(self):
        self.vOut.prnt('->connectDataBase', 4)
        dbfrom = 'db.from.{}'.format(self.ini.get('read', 'db'))
        dbms = self.config.get(dbfrom, 'dbms')

        if dbms == 'mssql':
            self.db = Mssql(
                self.config.get(dbfrom, 'username'),
                self.config.get(dbfrom, 'password'),
                self.config.get(dbfrom, 'hostname'),
                self.config.get(dbfrom, 'port'),
                self.config.get(dbfrom, 'database'),
                self.config.get(dbfrom, 'schema'))

        elif dbms == 'firebird':
            self.db = Firebird(
                self.config.get(dbfrom, 'username'),
                self.config.get(dbfrom, 'password'),
                self.config.get(dbfrom, 'hostname'),
                self.config.get(dbfrom, 'port'),
                self.config.get(dbfrom, 'database'),
                self.config.get(dbfrom, 'charset'))

        elif dbms == 'oracle':
            self.oracle = Oracle(
                self.config.get(dbTo, 'username'),
                self.config.get(dbTo, 'password'),
                self.config.get(dbTo, 'hostname'),
                self.config.get(dbTo, 'port'),
                self.config.get(dbTo, 'servicename'),
                self.config.get(dbTo, 'schema'))
        else:
            raise NameError(
                'For now, script is not prepared for "'+dbms+'".')

        self.db.connect()

    def closeDataBase(self):
        self.db.disconnect()

    def __init__(self):
        self.main()

    def parseArgs(self):
        parser = argparse.ArgumentParser(
            description=_('Write CSV from Mssql database'),
            epilog="(c) Tussor & Oxigenai",
            formatter_class=argparse.RawTextHelpFormatter)
        parser.add_argument(
            "iniFile",
            help='data group INI file name, in the format '
            '[dir/]data_group_name[.version][.ini|.yaml]')
        parser.add_argument(
            "csvFile",
            nargs='?',
            default='',
            help='CSV file to be created, '
            'in the format [dir/]_file_name[.csv] '
            'By default the data group name is underscored and used: '
            '_data_group_name')
        parser.add_argument(
            "--iniyaml",
            action="store_true",
            help='INI file is in YAML format')
        parser.add_argument(
            "--cfg", "--cfgfile",
            type=str,
            default='tuple-load.cfg',
            help='config file of data access and groups')
        parser.add_argument(
            "--ini", "--inidir",
            type=str,
            default='ini',
            help='default directory for ini files')
        parser.add_argument(
            "--csv", "--csvdir",
            type=str,
            default='csv',
            help='default directory for csv files')
        parser.add_argument(
            "--json", "--jsondir",
            type=str,
            default='json',
            help='default directory for json files')
        parser.add_argument(
            "-v", "--verbosity", action="count", default=0,
            help="increase output verbosity")
        self.args = parser.parse_args()

    def configProcess(self):
        self.vOut.prnt('->configProcess', 2)

        if self.args.iniyaml:
            self.args.iniFile = \
                oxyu.fileWithRequiredExtension(self.args.iniFile, 'yaml')
        else:
            self.args.iniFile = \
                oxyu.fileWithRequiredExtension(self.args.iniFile, 'ini')

        self.args.iniFile = \
            oxyu.fileWithDefaultDir(self.args.ini, self.args.iniFile)

        if not self.args.csvFile:
            self.args.csvFile, sAux = os.path.splitext(self.args.iniFile)
            sAux, self.args.csvFile = os.path.split(self.args.csvFile)
            self.args.csvFile = '_'+self.args.csvFile

        self.args.csvFile = \
            oxyu.fileWithRequiredExtension(self.args.csvFile, 'csv')

        self.args.csvFile = \
            oxyu.fileWithDefaultDir(self.args.csv, self.args.csvFile)

        self.checkFile(self.args.iniFile, 'INI', 11)

        self.checkFile(self.args.cfg, 'Config', 12)

        self.ini = oxyu.IniParser(self.args.iniFile)

        self.vOut.ppr(4, self.ini)

        if self.ini.has('inactive'):
            print('Inactive INI file', file=sys.stderr)
            sys.exit(21)

        self.config = configparser.RawConfigParser()
        self.config.read(self.args.cfg)

        with contextlib.suppress(FileNotFoundError):
            os.remove(self.args.csvFile)

        if os.path.exists('secret.py'):
            from secret import DBSECRET
            for dbkey in DBSECRET:
                self.config[dbkey].update(DBSECRET[dbkey])

    def run(self):
        self.vOut.prnt('->run', 2)
        locale.setlocale(locale.LC_ALL, 'pt_BR.utf8')

        try:
            self.connectDataBase()

            with open(self.args.csvFile, 'w') as self.csvNew:
                self.executeMaster()

        finally:
            self.closeDataBase()

        self.doPostProcess()

    def getElementDef(self, aList, aKey, default):
        return default if aKey not in aList else aList[aKey]

    def loadFunctionVariables(self):
        self.vOut.prnt('->loadFunctionVariables', 3)

        dictRowFunctions = []
        if self.ini.has('functions'):
            for variable, value in self.ini.iter('functions'):
                variable = variable.lower()
                self.vOut.prnt('function variable: {}'.format(variable), 4)
                if self.args.iniyaml:
                    varParams = value
                else:
                    varParams = json.loads(value)
                if 'count' in varParams:
                    funcParams = varParams['count']
                    dictRowFunctions.append([variable, oxyin.count_field(
                        self.getElementDef(funcParams, 'start', '1'),
                        self.getElementDef(funcParams, 'step', '1'),
                        self.getElementDef(funcParams, 'break', None))
                        ])
                elif 'translate' in varParams:
                    funcParams = varParams['translate']
                    funcParams['from'] = oxyu.fileWithDefaultDir(
                            self.args.csv, funcParams['from'])
                    if 'other_fields' in funcParams:
                        variable = [variable]
                        for other_field in funcParams['other_fields']:
                            variable.append(other_field[0])
                    dictRowFunctions.append(
                        [variable, oxyin.translate_field(funcParams)])
                elif 'trim' in varParams:
                    funcParams = varParams['trim']
                    dictRowFunctions.append(
                        [variable, oxyin.trim_field(funcParams['field'])])
                elif 'str' in varParams:
                    funcParams = varParams['str']
                    dictRowFunctions.append(
                        [variable, oxyin.str_field(funcParams, variable)])
                elif 'if_not_null' in varParams:
                    funcParams = varParams['if_not_null']
                    dictRowFunctions.append(
                        [variable, oxyin.if_not_null_field(funcParams)])
        return dictRowFunctions

    def addVariablesToRow(self, dictRow):
        if self.ini.has('variables'):
            for variable, value in self.ini.iter('variables'):
                varParams = json.loads(value)
                if 'value' in varParams.keys():
                    if 'type' in varParams.keys():
                        varType = varParams['type']
                    else:
                        varType = 't'
                    if varType == 'n':
                        dictRow[variable] = float(varParams['value'])
                    else:
                        dictRow[variable] = varParams['value']

    def execFunctionsToRow(self, dictRowFunctions, dictRow):
        self.vOut.prnt('->execFunctionsToRow', 4)
        for function in dictRowFunctions:
            self.vOut.prnt('column: {}'.format(function[0]), 4)
            result = function[1](dictRow)
            if isinstance(function[0], str):
                dictRow[function[0]] = result
            else:
                for idx, val in enumerate(function[0]):
                    dictRow[val] = result[idx]

    def executeMaster(self):
        self.vOut.prnt('->executeMaster', 4)
        self.doHeader = True
        if not self.ini.has('read', 'master.db'):
            self.queryParam = None
            self.executeQueries()
        else:
            if self.ini.get('read', 'master.db') == 'csv':
                paramsFile = self.ini.get('read', 'master.filename')
                paramsFile = oxyu.fileWithDefaultDir(self.args.csv, paramsFile)
                self.vOut.prnt('paramsFile: {}'.format(paramsFile), 3)
                self.vOut.prnt(
                    'master.select: {}'.format(
                        self.ini.get('read', 'master.select')), 3)
                masterSelect = json.loads(
                    self.ini.get('read', 'master.select'))
                self.vOut.prnt('masterSelect: {}'.format(masterSelect, 3))
                keys = masterSelect['keys']
                self.vOut.prnt('keys: {}'.format(keys, 3))
                reader = csv.reader(open(paramsFile), delimiter=';')
                columns = next(reader)
                countRows = 0
                firstRows = -1
                if self.ini.has('read', 'master.first'):
                    firstRows = int(self.ini.get('read', 'master.first'))
                skipRows = 0
                if self.ini.has('read', 'master.skip'):
                    skipRows = int(self.ini.get('read', 'master.skip'))
                for row in reader:
                    if skipRows > 0:
                        skipRows -= 1
                        continue
                    dictRow = dict(zip(columns, row))
                    for key in keys:
                        self.vOut.prnt('key: {}'.format(key, 4))
                        self.vOut.prnt(
                            'dictRow["{}"]: {}'.format(key, dictRow[key], 3))

                    self.queryParam = [dictRow[key] for key in keys]
                    self.vOut.pprnt(self.queryParam, 4)
                    self.executeQueries()
                    countRows += 1
                    if countRows == firstRows:
                        break

    def executeQueries(self):
        self.vOut.prnt('->executeQueries', 2)
        for i in range(10):
            if i == 0:
                sqlVar = 'sql'
            else:
                sqlVar = 'sql{}'.format(i)
            if self.ini.has('read', sqlVar):
                self.vOut.prnt('sql = {}'.format(sqlVar), 3)
                sqlF = self.ini.get('read', sqlVar)
                self.executeQuery(sqlF)

    def executeQuery(self, sqlF):
        self.vOut.prnt('->executeQuery', 3)

        curF = self.db.cursorExecute(sqlF, self.queryParam)

        columns = [column[0].lower() for column in curF.description]

        dictRowFunctions = self.loadFunctionVariables()

        headerLine = ''

        while True:
            row = curF.fetchone()
            if not row:
                break

            dictRow = dict(zip(columns, row))

            self.addVariablesToRow(dictRow)

            self.execFunctionsToRow(dictRowFunctions, dictRow)

            dataLine = ''
            separator = ''
            for column, spec in self.ini.iter('columns'):
                column = column.lower()
                if self.args.iniyaml:
                    if isinstance(spec, str):
                        colType = spec[0]
                        colParams = {}
                    else:
                        colType = spec['type']
                        colParams = spec['args']
                else:
                    colType = spec[0]
                    colParams = {}
                    if len(spec) > 2:
                        colParams = json.loads(spec[2:])

                colValue = None

                # A column can be made by processing others; if so it can not
                # exist in dictRow
                if column in dictRow.keys():
                    colValue = dictRow[column]

                if colType == 't':
                    if not colValue:
                        colValue = ''
                    if 'format' in colParams:
                        if 'fields' in colParams:
                            colFieldValues = \
                                tuple((dictRow[c]
                                      for c in colParams['fields']))
                        else:
                            colFieldValues = tuple(colValue,)
                        colValue = \
                            colParams['format'] % tuple(colFieldValues)
                    colValue = \
                        '"{}"'.format(colValue.replace('"', '""'))

                elif colType == 'n':
                    if not colValue:
                        colValue = 0
                    if 'sqlformat' in colParams:
                        colFormat = colParams['sqlformat']
                        colValue = colFormat % colValue
                    else:
                        if 'format' in colParams:
                            colFormat = colParams['format']
                        else:
                            colFormat = '%d'
                        colValue = locale.format(colFormat, colValue)

                elif colType == 'd':
                    if not colValue:
                        colValue = ''
                    else:
                        colValue = colValue.strftime(colParams['format'])

                dataLine += '{}{}'.format(separator, colValue)

                if self.doHeader:
                    headerLine += '{}"{}"'.format(separator, column.upper())

                separator = ';'

            if self.doHeader:
                self.csvNew.write('{}\n'.format(headerLine))
                self.doHeader = False

            self.csvNew.write('{}\n'.format(dataLine))

    def sortCsv(self, varParams, fromCsv, toCsv):
        self.vOut.prnt('->sortCsv', 3)
        self.vOut.pprnt(varParams, 3)
        reader = csv.reader(open(fromCsv), delimiter=';')
        cab = next(reader)
        keyFieldIndex = cab.index(varParams['field'].upper())
        sortedlist = sorted(reader, key=operator.itemgetter(keyFieldIndex))

        writer = csv.writer(
            open(toCsv, 'w', newline=''),
            delimiter=';',
            quoting=csv.QUOTE_NONNUMERIC)
        writer.writerow(cab)
        unique = False
        if 'options' in varParams:
            unique = 'unique' in varParams['options']
        hashRows = []
        for row in sortedlist:
            write = True
            if unique:
                hashValue = hashlib.md5(str(row).encode()).digest()
                write = hashValue not in hashRows
                if write:
                    hashRows.append(hashValue)
            if write:
                writer.writerow(row)

    def external(self, varParams, fromCsv, toCsv):
        self.vOut.prnt('->external', 3)
        self.vOut.pprnt(varParams, 3)
        params = [fromCsv]
        if 'args' in varParams:
            for arg in varParams['args']:
                params.append(arg)
        params.append(toCsv)
        try:
            retcode = subprocess.call(
                ('./{}'+(' {}'*len(params))).format(
                    varParams['script'], *params),
                shell=True)
            if retcode < 0:
                print("Child was terminated by signal",
                      -retcode, file=sys.stderr)
            else:
                print("Child returned", retcode, file=sys.stderr)
        except OSError as e:
            print("Execution failed:", e, file=sys.stderr)

    def doPostProcess(self):
        self.vOut.prnt('->doPostProcess', 3)

        if self.ini.has('post_process'):
            self.vOut.pprnt(self.ini.get('post_process'), 4)
            for variable, value in self.ini.iter('post_process'):
                self.vOut.pprnt(variable, 4)
                varParams = json.loads(value)
                if 'id' in varParams:
                    postProcId = varParams['id']
                else:
                    postProcId = variable

                file_name, file_ext = os.path.splitext(self.args.csvFile)
                newCsv = '{}.{}{}'.format(file_name, postProcId, file_ext)

                if variable == 'sort':
                    self.sortCsv(varParams, self.args.csvFile, newCsv)
                if variable.startswith('external'):
                    self.external(varParams, self.args.csvFile, newCsv)
                self.args.csvFile = newCsv

    def main(self):
        self.parseArgs()
        self.vOut = VerboseOutput(self.args.verbosity)
        self.configProcess()
        self.run()


if __name__ == '__main__':
    tupleLoadGT = gettext.translation('tuple-load', 'po', fallback=True)
    tupleLoadGT.install()
    Main()
