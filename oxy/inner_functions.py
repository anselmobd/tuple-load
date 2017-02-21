#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import re
import unicodedata

import csv


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
                args = [None] * 3
                for iArg in range(3):
                    if len(method['args']) > iArg \
                                and method['args'][iArg] != '':
                        args[iArg] = int(method['args'][iArg])
                result = dictRow[field][args[0]:args[1]:args[2]]
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
            elif method['method'] == 'unaccent':
                result = ''.join(
                    (c for c
                     in unicodedata.normalize('NFD', dictRow[field])
                     if unicodedata.category(c) != 'Mn'))
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
