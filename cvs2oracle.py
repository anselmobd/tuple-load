#!/usr/bin/python3

import sys
import os.path
from pprint import pprint

import argparse
import configparser
import csv
import json
import cx_Oracle


class Oracle:

    def __init__(self, username, password,
                 hostname, port, servicename, schema):
        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.servicename = servicename
        self.schema = schema

    def connect(self):
        """ Connect to the database. if this fails, raise. """
        try:
            self.con = cx_Oracle.connect(
                self.username, self.password,
                '{}:{}/{}'.format(self.hostname, self.port, self.servicename))
            self.con.current_schema = self.schema

        except cx_Oracle.DatabaseError as e:
            error, = e.args
            if error.code == 1017:
                print('Please check your credentials.')
            else:
                print('Database connection error: {}'.format(e))
            raise

        self.cursor = self.con.cursor()

    def commit(self):
        self.con.commit()

    def disconnect(self):
        """ Disconnect from the database. If this fails, don't care. """
        try:
            self.cursor.close()
            self.con.close()
        except cx_Oracle.DatabaseError:
            pass


class Main:

    def printV(self, message, level=1, **args):
        ''' Print message if visibility x '''
        try:
            message = '{0}\n{1}\n{0}'.format(args['sep'], message)
        except:
            pass
        if self.args.verbosity >= level:
            print(message)

    def pprintV(self, obj, level=1):
        ''' PPrint object if visibility x '''
        if self.args.verbosity >= level:
            pprint(obj)

    def checkFile(self, fileName, description, exitError):
        self.printV(description + ' file: {}'.format(fileName))
        if not os.path.exists(fileName):
            print('"{}" file "{}" does not exist'.format(
                description, fileName))
            sys.exit(exitError)

    def connectDataBase(self):
        self.oracle = Oracle(self.config.get('db', 'username'),
                             self.config.get('db', 'password'),
                             self.config.get('db', 'hostname'),
                             self.config.get('db', 'port'),
                             self.config.get('db', 'servicename'),
                             self.config.get('db', 'schema'))
        self.oracle.connect()
        self.printV(
            'Banco de dados conectado. ' +
            '(versão do Oracle:' + self.oracle.con.version + ')')
        self.cursor = self.oracle.cursor

    def closeDataBase(self):
        self.oracle.commit()
        self.oracle.disconnect()

    def __init__(self):
        self.main()

    def parseArgs(self):
        parser = argparse.ArgumentParser(
            description='Write CSV data to Oracle',
            epilog="(c) Tussor & Oxigenai",
            formatter_class=argparse.RawTextHelpFormatter)
        parser.add_argument(
            "cvsFile",
            help='data group CVS file name, in the format '
            'data_group_name[.version].csv')
        parser.add_argument(
            "configFile",
            help='config file of data groups')
        parser.add_argument(
            "-i", "--insert",
            action="store_true",
            help="insert or update in Oracle rows in CSV\n"
                 "(default if none action defined)")
        parser.add_argument(
            "-u", "--update",
            action="store_true",
            help="same as -i")
        parser.add_argument(
            "-d", "--delete", action="store_true",
            help="delete in Oracle rows not in CSV")
        parser.add_argument(
            "-b", "--both", action="store_true",
            help="force -i and -d")
        parser.add_argument(
            "-v", "--verbosity", action="count", default=0,
            help="increase output verbosity")
        self.args = parser.parse_args()
        self.args.insert = self.args.insert \
            or self.args.update or self.args.both
        self.args.delete = self.args.delete or self.args.both
        if self.args.insert == self.args.delete:
            self.args.insert = True

    def configProcess(self):
        self.printV('->configProcess', 2)
        self.checkFile(self.args.cvsFile, 'CSV', 11)

        self.checkFile(self.args.configFile, 'Config', 12)

        self.config = configparser.RawConfigParser()
        self.config.read(self.args.configFile)

        dataGroup = os.path.basename(self.args.cvsFile)
        dataGroup = os.path.splitext(dataGroup)[0]
        dataGroup = dataGroup.split('.')[0]
        self.printV('Data group name: %s' % (dataGroup))

        sqlTable = self.config.get('data_groups', dataGroup)
        self.printV('SQL Table name: %s' % (sqlTable))

        self.jsonFileName = ''.join((sqlTable, '.json'))
        self.printV('JSON file name: %s' % (self.jsonFileName))

    def run(self):
        self.printV('->run', 2)
        self.readJson()
        try:
            self.connectDataBase()

            if self.args.insert:
                for dataRow in self.readCsvGenerator():
                    self.insertUpdateRow(dataRow)

            if self.args.delete:
                self.readCsvKeys()
                self.deleteRows()
        finally:
            self.closeDataBase()

    def readJson(self):
        self.printV('->readJson', 2)
        with open(self.jsonFileName) as json_data:
            self.rules = json.load(json_data)
        self.pprintV(self.rules, 3)

    def readCsvGenerator(self):
        self.printV('->readCsvGenerator', 2)
        with open(self.args.cvsFile) as csvfile:
            readCsv = csv.reader(csvfile, delimiter=';')
            columns = None
            for row in readCsv:
                if columns:
                    dictRow = dict(zip(columns, row))
                    self.pprintV(dictRow, 3)
                    self.pprintV(
                        list(
                            (dictRow[f] for f in self.rules['csv']['keys'])
                            ), 3)
                    yield dictRow
                    # break
                else:
                    columns = row

    def insertUpdateRow(self, dictRow):
        self.printV('->insertUpdate', 2)
        self.pprintV(dictRow, 3)

        keyRow = dict(((k, dictRow[k]) for k in self.rules['csv']['keys']))
        self.pprintV(keyRow)

        # counting rows

        sql = '\n'.join(self.rules['sql']['key_count'])
        self.printV(sql, 2, sep='---')

        self.cursor.execute(sql, keyRow)
        countRows = self.cursor.fetchall()[0][0]
        self.printV('count = %s' % (countRows), 2)

        if countRows == 1:
            sql = '\n'.join(self.rules['sql']['update'])
            self.printV(sql, 2, sep='---')

            self.cursor.execute(sql, dictRow)
            self.printV('updated: %s' % (self.cursor.rowcount), 2)
        else:
            sql = '\n'.join(self.rules['sql']['insert'])
            self.printV(sql, 2, sep='---')

            self.cursor.execute(sql, dictRow)
            self.printV('inserted: %s' % (self.cursor.rowcount), 2)

    def readCsvKeys(self):
        self.printV('->readCsvKeys', 2)
        self.keys = []
        for dataRow in self.readCsvGenerator():
            completeKey = ()
            for keyName in self.rules['csv']['keys']:
                key = dataRow[keyName]
                if ('fields' in self.rules['csv'] and
                        keyName in self.rules['csv']['fields']):
                    fieldType = self.rules['csv']['fields'][keyName]['type']
                    if fieldType == 'integer':
                        key = int(key)
                completeKey += (key,)
            self.keys.append(completeKey)

            # self.keys.append(
            #     tuple((dataRow[k] for k in self.rules['csv']['keys'])))
        self.pprintV(self.keys, 3)

    def deleteRows(self):
        self.printV('->deleteRows', 2)

        sql = '\n'.join(self.rules['sql']['key_list'])
        self.printV(sql, 2, sep='---')

        self.cursor.execute(sql)

        toDelete = []
        for row in self.cursor:
            self.printV('row', 4)
            self.pprintV(row, 4)
            if row in self.keys:
                self.keys.remove(row)
            else:
                toDelete.append(
                    {self.rules['csv']['keys'][i]: row[i]
                        for i in range(0, len(row))})

        self.pprintV(toDelete, 3)

        if len(toDelete) > 0:
            sql = '\n'.join(self.rules['sql']['delete'])
            self.printV(sql, 2, sep='---')

            for deleteKey in toDelete:
                self.printV('Delete: "{}"'.format(deleteKey))
                try:
                    self.cursor.execute(sql, deleteKey)
                except cx_Oracle.DatabaseError as e:
                    print('ERROR: "{}"'.format(type(e)))
                    print('Deleting: "{}"'.format(deleteKey))
                    error,  = e.args
                    print('code: "{}"'.format(error.code))
                    print('message: "{}"'.format(error.message.strip()))
                    print('context: "{}"'.format(error.context))
                else:
                    self.printV('"{}" deleted'.format(deleteKey))

                self.printV('deleted: %s' % (self.cursor.rowcount), 2)

    def main(self):
        self.parseArgs()
        # self.printV('sql1', 2, sep='---')
        # self.printV('sql2', 2)
        # print('insert {}'.format(self.args.insert or self.args.both))
        # print('delete {}'.format(self.args.delete or self.args.both))
        # sys.exit(1)
        self.configProcess()
        self.run()


if __name__ == '__main__':
    Main()
