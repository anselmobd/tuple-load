#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys
import os.path
import locale
import contextlib
from pprint import pprint

import argparse
import configparser
import json
import csv

import gettext

from oxy.arg import parse as argparse
from oxy.mssql import Mssql
from oxy.firebird import Firebird
from oxy.usual import VerboseOutput


def count_field(valIni, fieldBreak):
    ''' Closure to "count" function variable '''
    ini = int(valIni)
    breakVal = None

    def inner_func(dictRow):
        nonlocal ini, breakVal
        if fieldBreak:
            if (not breakVal) or breakVal != dictRow[fieldBreak]:
                breakVal = dictRow[fieldBreak]
                ini = int(valIni)
        result = ini
        ini += 1
        return result
    return inner_func


def translate_field(queryDict):
    ''' Closure to "translate" function variable '''
    query = queryDict

    def inner_func(dictRow):
        nonlocal query
        result = None
        with open(query['from']) as transFile:
            readCsv = csv.reader(transFile, delimiter=';')
            columns = None
            for row in readCsv:
                if columns:
                    csvRow = dict(zip(columns, row))
                    bOk = True
                    for cond in query['where']:
                        bOk = bOk and csvRow[cond[0]] == dictRow[cond[-1]]
                    if bOk:
                        result = csvRow[query['select']]
                        break
                else:
                    columns = row
            if (not result) and ('default' in query):
                result = query['default']
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
                ini = int(method['args'][0])
                if len(method['args']) > 1 and method['args'][1] != '':
                    end = int(method['args'][1])
                else:
                    end = None
                if len(method['args']) > 2 and method['args'][2] != '':
                    step = int(method['args'][2])
                else:
                    step = None
                result = dictRow[field][ini:end:step]
        return result
    return inner_func


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
        dbfrom = 'db.from.{}'.format(self.iniConfig.get('read', 'db'))
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
            '[dir/]data_group_name[.version].ini')
        parser.add_argument(
            "csvFile",
            help='CSV file to be created '
            '[dir/]_file_name.csv')
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

        self.args.iniFile = \
            self.fileWithDefaultDir(self.args.ini, self.args.iniFile)

        self.args.csvFile = \
            self.fileWithDefaultDir(self.args.csv, self.args.csvFile)

    def configProcess(self):
        self.vOut.prnt('->configProcess', 2)
        self.checkFile(self.args.iniFile, 'INI', 11)

        self.checkFile(self.args.cfg, 'Config', 12)

        self.iniConfig = configparser.RawConfigParser()
        self.iniConfig.read(self.args.iniFile)

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
                self.executeQueries()

        finally:
            self.closeDataBase()

    def loadFunctionVariables(self):
        self.vOut.prnt('->loadFunctionVariables', 3)
        self.vOut.pprnt(self.iniConfig.items("functions"), 4)

        dictRowFunctions = []
        for variable, value in self.iniConfig.items("functions"):
            self.vOut.prnt('variable: {}'.format(variable), 4)
            varParams = json.loads(value)
            if 'count' in varParams:
                funcParams = varParams['count']
                dictRowFunctions.append([variable, count_field(
                    '1' if 'start' not in funcParams else funcParams['start'],
                    None if 'break' not in funcParams else funcParams['break'])
                    ])
            elif 'translate' in varParams:
                funcParams = varParams['translate']
                funcParams['from'] = self.fileWithDefaultDir(
                        self.args.csv, funcParams['from'])
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
        return dictRowFunctions

    def addVariablesToRow(self, dictRow):
        for variable, value in self.iniConfig.items("variables"):
            varParams = json.loads(value)
            if 'value' in varParams.keys():
                dictRow[variable] = varParams['value']

    def execFunctionsToRow(self, dictRowFunctions, dictRow):
        self.vOut.prnt('->execFunctionsToRow', 4)
        for function in dictRowFunctions:
            self.vOut.prnt('column: {}'.format(function[0]), 4)
            dictRow[function[0]] = function[1](dictRow)

    def executeQueries(self):
        self.vOut.prnt('->executeQueries', 2)
        self.doHeader = True
        for i in range(10):
            if i == 0:
                sqlVar = 'sql'
            else:
                sqlVar = 'sql{}'.format(i)
            if sqlVar in list(self.iniConfig['read']):
                self.vOut.prnt('sql = {}'.format(sqlVar), 3)
                sqlF = self.iniConfig.get('read', sqlVar)
                self.executeQuery(sqlF)

    def executeQuery(self, sqlF):
        curF = self.db.cursorExecute(sqlF)

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
                    colValue = \
                        locale.format(colParams['format'], colValue)

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

    def main(self):
        self.parseArgs()
        self.vOut = VerboseOutput(self.args.verbosity)
        self.configProcess()
        self.run()

if __name__ == '__main__':
    tupleLoadGT = gettext.translation('tuple-load', 'po', fallback=True)
    tupleLoadGT.install()
    Main()
