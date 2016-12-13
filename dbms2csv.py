#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys
import locale

from pprint import pprint
import json
import configparser

import pyodbc
import csv


def count_field(valIni, fieldBreak):
    ''' Closure to "count" function variable '''
    ini = valIni
    breakVal = None

    def inner_func(dictRow):
        nonlocal ini, breakVal
        if fieldBreak:
            if (not breakVal) or breakVal != dictRow[fieldBreak]:
                breakVal = dictRow[fieldBreak]
                ini = valIni
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


iniConfig = configparser.RawConfigParser()
iniConfig.read('insumo_nao_tecido_capa.ini')

cfgConfig = configparser.RawConfigParser()
cfgConfig.read('data_load.cfg')

locale.setlocale(locale.LC_ALL, 'pt_BR.utf8')

conFabric = pyodbc.connect(
            'DRIVER={FreeTDS};'
            'SERVER='+cfgConfig.get('dbread', 'hostname')+';'
            'PORT='+cfgConfig.get('dbread', 'port')+';'
            'DATABASE='+cfgConfig.get('dbread', 'database')+';'
            'SCHEMA='+cfgConfig.get('dbread', 'schema')+';'
            'UID='+cfgConfig.get('dbread', 'username')+';'
            'PWD='+cfgConfig.get('dbread', 'password')+';'
            'TDS_Version=7.0;'
            )

curF = conFabric.cursor()

sqlF = iniConfig.get('read', 'sql')
curF.execute(sqlF)

columns = [column[0].lower() for column in curF.description]

# load function variables
dictRowFunctions = {}
for variable, value in iniConfig.items("functions"):
    varParams = json.loads(value)
    if list(varParams.keys())[0] == 'count':
        funcParams = varParams['count']
        dictRowFunctions[variable] = count_field(
            1, None if 'break' not in funcParams else funcParams['break'])
    elif list(varParams.keys())[0] == 'translate':
        funcParams = varParams['translate']
        dictRowFunctions[variable] = translate_field(funcParams)


doHeader = True
headerLine = ''

row = curF.fetchone()
while row:
    dictRow = dict(zip(columns, row))

    for variable, value in iniConfig.items("variables"):
        varParams = json.loads(value)
        if 'value' in varParams.keys():
            dictRow[variable] = varParams['value']

    for column in dictRowFunctions.keys():
        dictRow[column] = dictRowFunctions[column](dictRow)

    dataLine = ''
    separator = ''
    for column, spec in iniConfig.items("columns"):
        # print(column, spec)
        colType = spec[0]
        colParams = {}
        if len(spec) > 2:
            colParams = json.loads(spec[2:])

        colValue = None

        if column in dictRow.keys():
            colValue = dictRow[column]

        if colType == 't':
            if not colValue:
                colValue = ''
            if 'format' in colParams:
                if 'fields' in colParams:
                    colFieldValues = \
                        tuple((dictRow[c] for c in colParams['fields']))
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
    row = curF.fetchone()

curF.close()
conFabric.close()
