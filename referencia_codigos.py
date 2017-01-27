#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys
import re
from pprint import pprint

import csv


refs = []

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
refFile = sys.argv[2]
if len(sys.argv) > 3:
    verbose = sys.argv[3] == 'v'

if verbose:
    pprint(sys.argv)
    print(csvFile)

reader = csv.reader(open(csvFile), delimiter=';')
cab = next(reader)

for row in reader:
    pCod = row[0]
    if verbose:
        print('codigo {}'.format(pCod))

    regexNum = "^[^\d]*(\d+?)[^\d]*$"
    reResult = re.search(regexNum, pCod)
    if reResult:
        refMaster = reResult.group(1)
    else:
        refMaster = ''

    refPa = row[1]
    ref4 = refPa[1:]
    altM = ['N', 'P', 'Q', 'W', 'Y']
    altC = ['D', 'E', 'F', 'G', 'H']
    altR = ['S', 'T', 'U', 'V', 'X']

    if len(pCod) < 5:
        refMd = 'M'+ref4
        refCo = 'C'+ref4
        refRi = 'R'+ref4
    else:
        contRef4 = conta(ref4)
        refMd = altM[contRef4]+ref4
        refCo = altC[contRef4]+ref4
        refRi = altR[contRef4]+ref4

    refs.append([ref4, pCod, refPa, refMd, refCo, refRi, refMaster])
    if verbose:
        print('refs = ')
        pprint(refs)

writer = csv.writer(
    open(refFile, 'w', newline=''),
    delimiter=';',
    quoting=csv.QUOTE_NONNUMERIC)
cab = ['REFERENCIA', 'PA', 'MD', 'CO', 'RI', 'REFMASTER']
writer.writerow(cab)
for row in refs:
    pprint(row)
    writer.writerow(row[1:])
