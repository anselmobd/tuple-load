#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys
import os.path
from pprint import pprint
import locale

import argparse
import configparser
import json
import csv

import pyodbc


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


class VerboseOutput:

    def __init__(self, verbosity):
        self.verbosity = verbosity

    def prnt(self, message, verbosity=1, **args):
        ''' Print message if verbosity x '''
        try:
            message = '{0}\n{1}\n{0}'.format(args['sep'], message)
        except:
            pass
        if self.verbosity >= verbosity:
            print(message)

    def pprnt(self, obj, verbosity=1):
        ''' PPrint object if verbosity x '''
        if self.verbosity >= verbosity:
            pprint(obj)


class Mssql:

    def __init__(self, username, password,
                 hostname, port, database, schema):
        # self.CONTINUE_ON_ERROR = False
        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.database = database
        self.schema = schema

    def connect(self):
        """ Connect to the database. if this fails, raise. """
        try:
            self.con = pyodbc.connect(
                'DRIVER={FreeTDS};'
                'SERVER='+self.hostname+';'
                'PORT='+self.port+';'
                'DATABASE='+self.database+';'
                'SCHEMA='+self.schema+';'
                'UID='+self.username+';'
                'PWD='+self.password+';'
                'TDS_Version=7.0;'
                )

        except pyodbc.DatabaseError as e:
            print('Database connection error: {}'.format(e))
            raise

        self.cursor = self.con.cursor()

    def disconnect(self):
        """ Disconnect from the database. If this fails, don't care. """
        try:
            self.cursor.close()
            self.con.close()
        except pyodbc.DatabaseError:
            pass

    def cursorExecute(self, statement, data=None, halt=True):
        """ Execute statement using data and return cursor. """
        try:
            if data:
                self.cursor.execute(statement, data)
            else:
                self.cursor.execute(statement)
        except puodbc.DatabaseError as e:
            print('Error: {}'.format(e))
            if halt:
                raise
        return self.cursor


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
        if self.cfgConfig.get('dbread', 'dbms') != 'mssql':
            raise NameError('For now, script prepared only for Mssql.')

        self.db = Mssql(self.cfgConfig.get('dbread', 'username'),
                        self.cfgConfig.get('dbread', 'password'),
                        self.cfgConfig.get('dbread', 'hostname'),
                        self.cfgConfig.get('dbread', 'port'),
                        self.cfgConfig.get('dbread', 'database'),
                        self.cfgConfig.get('dbread', 'schema'))

        self.db.connect()

    def closeDataBase(self):
        self.db.disconnect()

    def __init__(self):
        self.main()

    def parseArgs(self):
        parser = argparse.ArgumentParser(
            description='Write CSV from Mssql database',
            epilog="(c) Tussor & Oxigenai",
            formatter_class=argparse.RawTextHelpFormatter)
        parser.add_argument(
            "iniFile",
            help='data group INI file name, in the format '
            '[dir/]data_group_name[.version].ini')
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

    def configProcess(self):
        self.vOut.prnt('->configProcess', 2)
        self.checkFile(self.args.iniFile, 'INI', 11)

        self.checkFile(self.args.cfg, 'Config', 12)

        self.iniConfig = configparser.RawConfigParser()
        self.iniConfig.read(self.args.iniFile)

        self.cfgConfig = configparser.RawConfigParser()
        self.cfgConfig.read(self.args.cfg)

        # dataGroup = os.path.basename(self.args.csvFile)
        # dataGroup = os.path.splitext(dataGroup)[0]
        # dataGroup = dataGroup.split('.')[0]
        # self.vOut.prnt('Data group name: %s' % (dataGroup))
        #
        # sqlTable = self.config.get('data_groups', dataGroup)
        # self.vOut.prnt('SQL Table name: %s' % (sqlTable))
        #
        # self.jsonFileName = ''.join((sqlTable, '.json'))
        # self.vOut.prnt('JSON file name: %s' % (self.jsonFileName))

    def run(self):
        self.vOut.prnt('->run', 2)
        locale.setlocale(locale.LC_ALL, 'pt_BR.utf8')

        try:
            self.connectDataBase()

            self.executeQuery()
        finally:
            self.closeDataBase()

    def loadFunctionVariables(self):
        dictRowFunctions = {}
        for variable, value in self.iniConfig.items("functions"):
            varParams = json.loads(value)
            if list(varParams.keys())[0] == 'count':
                funcParams = varParams['count']
                dictRowFunctions[variable] = count_field(
                    '1' if 'start' not in funcParams else funcParams['start'],
                    None if 'break' not in funcParams else funcParams['break'])
            elif list(varParams.keys())[0] == 'translate':
                funcParams = varParams['translate']
                dictRowFunctions[variable] = translate_field(funcParams)
        return dictRowFunctions

    def addVariablesToRow(self, dictRow):
        for variable, value in self.iniConfig.items("variables"):
            varParams = json.loads(value)
            if 'value' in varParams.keys():
                dictRow[variable] = varParams['value']

    def execFunctionsToRow(self, dictRowFunctions, dictRow):
        for column in dictRowFunctions.keys():
            dictRow[column] = dictRowFunctions[column](dictRow)

    def executeQuery(self):
        sqlF = self.iniConfig.get('read', 'sql')
        curF = self.db.cursorExecute(sqlF)

        columns = [column[0].lower() for column in curF.description]

        dictRowFunctions = self.loadFunctionVariables()

        doHeader = True
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

                if doHeader:
                    headerLine += '{}"{}"'.format(separator, column.upper())

                separator = ';'

            if doHeader:
                print(headerLine)
                doHeader = False

            print(dataLine)

            # sys.exit(2)

    def main(self):
        self.parseArgs()
        self.vOut = VerboseOutput(self.args.verbosity)
        self.configProcess()
        self.run()

if __name__ == '__main__':
    Main()
