#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys
import re
from pprint import pprint

import csv


verbose = False


def conta(ref4):
    global refs, verbose
    conta = 0
    if verbose:
        print('conta refs')
    for row in refs:
        if row[0] == ref4:
            conta += 1
    if verbose:
        print('conta = {}'.format(conta))
    return conta


csvFile = sys.argv[1]
nivel = sys.argv[2]
refFile = sys.argv[3]
if len(sys.argv) > 4:
    verbose = sys.argv[4] == 'v'

if verbose:
    pprint(sys.argv)
    print(csvFile)

reader = csv.reader(open(csvFile), delimiter=';')
cab = next(reader)

writer = csv.writer(
    open(refFile, 'w', newline=''),
    delimiter=';',
    quoting=csv.QUOTE_NONNUMERIC)
cab = ['NIVEL_ESTRUTURA', 'REFERENCIA', 'VERSAOORDER', 'CODITEMPROD']
writer.writerow(cab)

valIni = 1
step = 1
breakVal = None

for row in reader:
    codini = row[0][:2]

    if (not breakVal) or breakVal != codini:
        breakVal = codini
        ini = valIni
    else:
        ini += step

    row.insert(0, '%s%03d' % (codini, ini))
    row.insert(0, nivel)

    if verbose:
        pprint(row)

    writer.writerow(row)
