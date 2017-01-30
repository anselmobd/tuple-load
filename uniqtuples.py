#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys
import os.path
import contextlib
import hashlib
import csv
import gettext

from oxy.arg import parse as argparse
import oxy.usual as oxyu
from oxy.usual import VerboseOutput


class Main:

    def checkFile(self, fileName, description, exitError):
        self.vOut.prnt(description + ' file: {}'.format(fileName))
        if not os.path.exists(fileName):
            print('"{}" file "{}" does not exist'.format(
                description, fileName))
            sys.exit(exitError)

    def __init__(self):
        self.main()

    def parseArgs(self):
        parser = argparse.ArgumentParser(
            description=_('Join 2 CSV files with compatible headers '
                          '(all columns in first CSV must exist in '
                          'second one) avoiding duplication'),
            epilog="(c) Tussor & Oxigenai",
            formatter_class=argparse.RawTextHelpFormatter)
        parser.add_argument(
            "oneCsvFile",
            help='First CSV file to be readed, '
            'in the format [dir/]one_csv[.csv]')
        parser.add_argument(
            "otherCsvFile",
            help='Second CSV file to be readed, '
            'in the format [dir/]other_csv[.csv]')
        parser.add_argument(
            "outputCsvFile",
            nargs='?',
            default='',
            help='CSV file to be created, '
            'in the format [dir/]output_csv[.csv] '
            'By default the fisrt CSV name is used with _uniq sufix: '
            'one_csv_uniq')
        parser.add_argument(
            "--csv", "--csvdir",
            type=str,
            default='csv',
            help='default directory for csv files')
        parser.add_argument(
            "-v", "--verbosity", action="count", default=0,
            help="increase output verbosity")
        self.args = parser.parse_args()

        self.args.oneCsvFile = \
            oxyu.fileWithRequiredExtension(self.args.oneCsvFile, 'csv')
        self.args.oneCsvFile = \
            oxyu.fileWithDefaultDir(self.args.csv, self.args.oneCsvFile)

        self.args.otherCsvFile = \
            oxyu.fileWithRequiredExtension(self.args.otherCsvFile, 'csv')
        self.args.otherCsvFile = \
            oxyu.fileWithDefaultDir(self.args.csv, self.args.otherCsvFile)

        if self.args.oneCsvFile == self.args.otherCsvFile:
            raise 'The two CSVs files are the same.'

        if not self.args.outputCsvFile:
            self.args.outputCsvFile, sAux = \
                os.path.splitext(self.args.oneCsvFile)
            sAux, self.args.outputCsvFile = \
                os.path.split(self.args.outputCsvFile)
            self.args.outputCsvFile += '_uniq'

        self.args.outputCsvFile = \
            oxyu.fileWithRequiredExtension(self.args.outputCsvFile, 'csv')
        self.args.outputCsvFile = \
            oxyu.fileWithDefaultDir(self.args.csv, self.args.outputCsvFile)

        if (self.args.outputCsvFile in
                [self.args.oneCsvFile, self.args.otherCsvFile]):
            raise 'The output CSV file is the same of one input.'

    def configProcess(self):
        self.vOut.prnt('->configProcess', 2)
        self.checkFile(self.args.oneCsvFile, 'One CSV', 11)
        self.checkFile(self.args.otherCsvFile, 'Other CSV', 11)

        with contextlib.suppress(FileNotFoundError):
            os.remove(self.args.outputCsvFile)

    def writeRowByCab(self, row, rowCab, byCab):
        self.vOut.pprnt(row, 4)
        rowByCab = [row[rowCab.index(col)] for col in byCab]

        hashValue = hashlib.md5(str(rowByCab).encode()).digest()
        if hashValue not in self.hashRows:
            self.hashRows.append(hashValue)
            self.writer.writerow(rowByCab)

    def run(self):
        self.vOut.prnt('->run', 2)

        csvOne = csv.reader(open(self.args.oneCsvFile), delimiter=';')
        cabOne = next(csvOne)

        csvTwo = csv.reader(open(self.args.otherCsvFile), delimiter=';')
        cabTwo = next(csvTwo)

        for column in cabOne:
            if column not in cabTwo:
                raise 'The two CSVs files have not the same header.'

        self.writer = csv.writer(
            open(self.args.outputCsvFile, 'w', newline=''),
            delimiter=';',
            quoting=csv.QUOTE_NONNUMERIC)
        self.writer.writerow(cabOne)

        self.hashRows = []
        for row in csvOne:
            self.writeRowByCab(row, cabOne, cabOne)
        for row in csvTwo:
            self.writeRowByCab(row, cabTwo, cabOne)

    def main(self):
        self.parseArgs()
        self.vOut = VerboseOutput(self.args.verbosity)
        self.configProcess()
        self.run()


if __name__ == '__main__':
    tupleLoadGT = gettext.translation('uniqtuples', 'po', fallback=True)
    tupleLoadGT.install()
    Main()
