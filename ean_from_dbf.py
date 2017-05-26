#!/usr/bin/env python3
# -*- coding: utf8 -*-

import sys
import csv
from pprint import pprint
from dbfread import DBF


class GTIN(object):
    '''
    from http://stackoverflow.com/questions/35552374/
    by Andronaute
    '''

    def __init__(self, barcode=''):
        self.barcode = barcode

    def __checkDigit(self, digits):
        total = sum(digits) + sum([d*2 for d in digits[-1::-2]])
        return (10 - (total % 10)) % 10

    def validateCheckDigit(self, barcode=''):
        barcode = (barcode if barcode else self.barcode)
        if len(barcode) in (8, 12, 13, 14) and barcode.isdigit():
            digits = [int(s) for s in barcode]
            checkDigit = self.__checkDigit(digits[0:-1])
            return checkDigit == digits[-1]
        return False

    def addCheckDigit(self, barcode=''):
        barcode = (barcode if barcode else self.barcode)
        if len(barcode) in (7, 11, 12, 13) and barcode.isdigit():
            digits = [int(s) for s in barcode]
            return barcode + str(self.__checkDigit(digits))
        return ''


range = {'1': '78968962', '2': '78996188'}

# f = open('DIS_BAT.DBF', 'r')

table = DBF('./scripts/DIS_BAT.DBF')
# pprint(table)

# writer = csv.writer(sys.stdout)
# writer.writerow(table.field_names)
for record in table:
    # pass
    # if record['B_PROD'] == '640':
    if record['B_ATIV'] == 'S':
        # pprint(record)
        # print(range[record['B_RANGE']])
        ean13_ = range[record['B_RANGE']] + record['B_CODBAR']
        ean13 = GTIN(ean13_).addCheckDigit()
        prod = record['B_PROD']
        cor = record['B_COR']
        tam = record['B_TAM']
        print('--{}.{}.{}: {}'.format(prod, tam, cor, ean13))
        print("UPDATE basi_010 c SET c.CODIGO_BARRAS = '{}' "
              "WHERE c.CODIGO_VELHO = 'PA{}.{}.{}' "
              "AND c.NIVEL_ESTRUTURA = 1 AND c.GRUPO_ESTRUTURA < '99999' "
              "AND c.CODIGO_BARRAS IS NULL;".format(ean13, prod, tam, cor))
        # sys.exit(9)
    # pprint(record)
    # sys.exit(9)
