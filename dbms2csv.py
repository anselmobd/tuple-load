#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys
import os.path
import locale
import contextlib
from pprint import pprint
import operator
import subprocess
import re
import hashlib

import configparser
import json
import yaml
import csv

import gettext

from oxy.arg import parse as argparse
from oxy.mssql import Mssql
from oxy.firebird import Firebird
import oxy.usual as oxyu
from oxy.usual import VerboseOutput


def count_field(valIni, valStep, fieldBreak):
    ''' Closure to "count" function variable '''
    ini = int(valIni)
    step = int(valStep)
    breakVal = None

    def inner_func(dictRow):
        nonlocal ini, breakVal, step
        if fieldBreak:
            if (not breakVal) or breakVal != dictRow[fieldBreak]:
                breakVal = dictRow[fieldBreak]
                ini = int(valIni)
        result = ini
        ini += step
        return result
    return inner_func


def translate_field(queryDict):
    ''' Closure to "translate" function variable '''
    query = queryDict

    with open(query['from']) as transFile:
        readCsv = csv.reader(transFile, delimiter=';')
        columns = None
        rows = []
        for row in readCsv:
            if columns:
                rows.append(row)
            else:
                columns = row

    def inner_func(dictRow):
        nonlocal query, columns, rows
        result = None
        for row in rows:
            csvRow = dict(zip(columns, row))
            bOk = True
            for cond in query['where']:
                if len(cond) > 2:
                    # "#" meeans "=" only if dictRow[cond[-1]] is not
                    # empty or null
                    if cond[1] == '#':
                        if dictRow[cond[-1]]:
                            bOk = bOk and csvRow[cond[0]] == \
                                dictRow[cond[-1]]
                else:
                    bOk = bOk and csvRow[cond[0]] == dictRow[cond[-1]]
                if not bOk:
                    break
            if bOk:
                result = csvRow[query['select']]
                if 'other_fields' in query:
                    result = [result]
                    for other_field in query['other_fields']:
                        result.append(csvRow[other_field[1]])
                break
        if (not result):
            if ('default' in query):
                result = query['default']
            elif ('field_default' in query):
                result = dictRow[query['field_default']]
        if ('type' in query) and (query['type'] == 'n'):
            result = float(result)
        return result
    return inner_func


def trim_field(fieldName):
    ''' Closure to "trim" function variable '''
    field = fieldName

    def inner_func(dictRow):
        nonlocal field
        if isinstance(dictRow[field], str):
            result = dictRow[field].strip()
        else:
            result = ''
        return result
    return inner_func


def str_field(methodDict, variable):
    ''' Closure to str methods variable '''
    method = methodDict
    fieldName = variable

    def inner_func(dictRow):
        nonlocal method
        result = ''

        if 'field' in method:
            field = method['field']
        else:
            field = fieldName

        if isinstance(dictRow[field], str):
            if method['method'] == 'rjust':
                size = int(method['args'][0])
                fill = method['args'][1]
                result = dictRow[field].rjust(size, fill)
            elif method['method'] == 'strip':
                result = dictRow[field].strip()
            elif method['method'] == 'char':
                pos = int(method['args'][0])
                result = dictRow[field][pos]
            elif method['method'] == 'slice':
                if method['args'][0] != '':
                    ini = int(method['args'][0])
                else:
                    ini = None
                if len(method['args']) > 1 and method['args'][1] != '':
                    end = int(method['args'][1])
                else:
                    end = None
                if len(method['args']) > 2 and method['args'][2] != '':
                    step = int(method['args'][2])
                else:
                    step = None
                result = dictRow[field][ini:end:step]
            elif method['method'] == 're.group':
                regex = method['args'][0]
                reResult = re.search(regex, dictRow[field])
                if reResult:
                    result = reResult.group(1)
            elif method['method'] == 're.sub':
                pattern = method['args'][0]
                repl = method['args'][1]
                result = re.sub(pattern, repl, dictRow[field])
            elif method['method'] == 'format':
                args = [field] + method['other_fields']
                values = [dictRow[a] for a in args]
                result = method['format'].format(*values)
            elif method['method'] == 'cnpj_digits':
                result = oxyu.Cnpj().digits(dictRow[field])
            elif method['method'] == 'only_digits':
                result = re.sub("[^0-9]", "", dictRow[field])
            elif method['method'] == 'int':
                try:
                    result = int(dictRow[field])
                except Exception as e:
                    result = 0
        return result
    return inner_func


def if_not_null_field(methodDict):
    ''' Closure to if_not_null variable '''
    method = methodDict

    def inner_func(dictRow):
        nonlocal method
        if dictRow[method['test_field']] is None:
            result = method['else_value']
        else:
            result = dictRow[method['field']]
        return result
    return inner_func


class Main:

    def checkFile(self, fileName, description, exitError):
        self.vOut.prnt(description + ' file: {}'.format(fileName))
        if not os.path.exists(fileName):
            print('"{}" file "{}" does not exist'.format(
                description, fileName))
            sys.exit(exitError)

    def iniIn(self, detail, master=None):
        if self.args.iniyaml:
            if master:
                result = detail in self.iniConfig[master]
            else:
                result = detail in self.iniConfig
        else:
            if master:
                result = detail in list(self.iniConfig[master])
            else:
                result = detail in self.iniConfig.sections()
        return result

    def connectDataBase(self):
        self.vOut.prnt('->connectDataBase', 4)
        dbfrom = 'db.from.{}'.format(self.iniConfig['read']['db'])
        dbms = self.config.get(dbfrom, 'dbms')

        if dbms == 'mssql':
            self.db = Mssql(self.config.get(dbfrom, 'username'),
                            self.config.get(dbfrom, 'password'),
                            self.config.get(dbfrom, 'hostname'),
                            self.config.get(dbfrom, 'port'),
                            self.config.get(dbfrom, 'database'),
                            self.config.get(dbfrom, 'schema'))

        elif dbms == 'firebird':
            self.db = Firebird(self.config.get(dbfrom, 'username'),
                               self.config.get(dbfrom, 'password'),
                               self.config.get(dbfrom, 'hostname'),
                               self.config.get(dbfrom, 'port'),
                               self.config.get(dbfrom, 'database'),
                               self.config.get(dbfrom, 'charset'))

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

    def configProcess(self):
        self.vOut.prnt('->configProcess', 2)
        self.checkFile(self.args.iniFile, 'INI', 11)

        self.checkFile(self.args.cfg, 'Config', 12)

        if self.args.iniyaml:
            with open(self.args.iniFile) as yaml_data:
                self.iniConfig = yaml.load(yaml_data)
        else:
            self.iniConfig = configparser.RawConfigParser()
            self.iniConfig.read(self.args.iniFile)

        if self.iniIn('inactive'):
            self.vOut.prnt('Inactive INI file')
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
        if self.iniIn('functions'):
            self.vOut.pprnt(self.iniConfig['functions'], 4)
            # self.vOut.pprnt(self.iniConfig.items("functions"), 4)
            # for variable, value in self.iniConfig.items('functions'):
            pprint(self.iniConfig['functions'])
            for variable in self.iniConfig['functions']:
                pprint(variable)
                value = self.iniConfig['functions'][variable]
                pprint(value)
                self.vOut.prnt('function variable: {}'.format(variable), 4)
                if self.args.iniyaml:
                    varParams = value
                else:
                    varParams = json.loads(value)
                if 'count' in varParams:
                    funcParams = varParams['count']
                    dictRowFunctions.append([variable, count_field(
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
                        [variable, translate_field(funcParams)])
                elif 'trim' in varParams:
                    funcParams = varParams['trim']
                    dictRowFunctions.append(
                        [variable, trim_field(funcParams['field'])])
                elif 'str' in varParams:
                    funcParams = varParams['str']
                    dictRowFunctions.append(
                        [variable, str_field(funcParams, variable)])
                elif 'if_not_null' in varParams:
                    funcParams = varParams['if_not_null']
                    dictRowFunctions.append(
                        [variable, if_not_null_field(funcParams)])
        return dictRowFunctions

    def addVariablesToRow(self, dictRow):
        if self.iniIn('variables'):
            for variable, value in self.iniConfig.items('variables'):
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
        self.doHeader = True
        if not self.iniIn('master.db', 'read'):
            self.queryParam = None
            self.executeQueries()
        else:
            if self.iniConfig['read']['master.db'] == 'csv':
                paramsFile = self.iniConfig['read']['master.filename']
                paramsFile = oxyu.fileWithDefaultDir(self.args.csv, paramsFile)
                self.vOut.prnt('paramsFile: {}'.format(paramsFile), 3)
                self.vOut.prnt(
                    'master.select: {}'.format(
                        self.iniConfig['read']['master.select']), 3)
                masterSelect = json.loads(
                    self.iniConfig['read']['master.select'])
                self.vOut.prnt('masterSelect: {}'.format(masterSelect, 3))
                keys = masterSelect['keys']
                self.vOut.prnt('keys: {}'.format(keys, 3))
                reader = csv.reader(open(paramsFile), delimiter=';')
                columns = next(reader)
                countRows = 0
                firstRows = -1
                if self.iniIn('master.first', 'read'):
                    firstRows = int(self.iniConfig['read']['master.first'])
                skipRows = 0
                if self.iniIn('master.skip', 'read'):
                    skipRows = int(self.iniConfig['read']['master.skip'])
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
            if self.iniIn(sqlVar, 'read'):
                self.vOut.prnt('sql = {}'.format(sqlVar), 3)
                sqlF = self.iniConfig['read'][sqlVar]
                self.executeQuery(sqlF)

    def executeQuery(self, sqlF):
        self.vOut.prnt('->executeQuery', 3)

        curF = self.db.cursorExecute(sqlF, self.queryParam)
        # curF = self.db.cursorExecute(sqlF, data=[('302')])

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
            for column, spec in self.iniConfig.items("columns"):
                # print(column, spec)
                colType = spec[0]
                colParams = {}
                if len(spec) > 2:
                    colParams = json.loads(spec[2:])

                colValue = None

                # A column can be made by processing others, so it can not
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
                        # print(type(dictRow[column]))
                        colValue = colValue.strftime(colParams['format'])

                dataLine += '{}{}'.format(separator, colValue)

                if self.doHeader:
                    headerLine += '{}"{}"'.format(separator, column.upper())

                separator = ';'

            if self.doHeader:
                # print(headerLine)
                self.csvNew.write('{}\n'.format(headerLine))
                self.doHeader = False

            # print(dataLine)
            self.csvNew.write('{}\n'.format(dataLine))

            # sys.exit(2)

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

        if self.iniIn('post_process'):
            self.vOut.pprnt(self.iniConfig.items('post_process'), 4)
            for variable, value in self.iniConfig.items('post_process'):
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
