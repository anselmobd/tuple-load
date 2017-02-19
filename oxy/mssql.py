#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys

import pyodbc


class Mssql:

    def __init__(self, username, password,
                 hostname, port, database, schema):

        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.database = database
        self.schema = schema

        # Vebosity to show all
        self._VERBOSITY = 4

        self.CONTINUE_ON_ERROR = False
        self.connected = False
        self.verbosity = 0

    def connect(self):
        """ Connect to the database. if this fails, raise. """
        if self.verbosity >= self._VERBOSITY:
            print(self.__class__.__name__, '-> connect start')

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
            self.connected = True

        except pyodbc.DatabaseError as e:
            error, *args = e.args
            reraise = False

            msgPrefix = 'Database connection error:'
            # raise "unknown" errors
            reraise = True
            msg = '(Code={}) {}'.format(error.code, e)

            if self.verbosity >= 1:
                print('{} {}'.format(msgPrefix, msg))
            if reraise:
                raise
            else:
                if self.verbosity >= self._VERBOSITY:
                    print('Exiting.')
                sys.exit(10)

        if self.connected:
            if self.verbosity >= self._VERBOSITY:
                print('Connected!')
            self.cursor = self.con.cursor()
        else:
            if self.verbosity >= self._VERBOSITY:
                print('Not connected!')

        if self.verbosity >= self._VERBOSITY:
            print(self.__class__.__name__, '-> connect end')

    def commit(self):
        """ Commit data to the database. If this fails, don't care. """
        if self.verbosity >= self._VERBOSITY:
            print(self.__class__.__name__, '-> commit start')
        try:
            self.con.commit()
        except pyodbc.DatabaseError:
            pass
        if self.verbosity >= self._VERBOSITY:
            print(self.__class__.__name__, '-> commit end')

    def disconnect(self):
        """ Disconnect from the database. If this fails, don't care. """
        if self.verbosity >= self._VERBOSITY:
            print(self.__class__.__name__, '-> disconnect start')
        try:
            self.cursor.close()
            self.con.close()
            self.connected = False
        except pyodbc.DatabaseError:
            pass
        if self.verbosity >= self._VERBOSITY:
            print(self.__class__.__name__, '-> disconnect end')

    def cursorExecute(self, statement, data=None, halt=True):
        """ Execute statement using data and return cursor. """
        if self.verbosity >= self._VERBOSITY:
            print(self.__class__.__name__, '-> cursorExecute start')
        try:
            if data:
                self.cursor.execute(statement, data)
            else:
                self.cursor.execute(statement)
        except pyodbc.DatabaseError as e:
            error, = e.args
            if self.verbosity >= 1:
                print('Error: {}'.format(e))
            if halt:
                raise
        if self.verbosity >= self._VERBOSITY:
            print(self.__class__.__name__, '-> cursorExecute end')
        return self.cursor


if __name__ == '__main__':
    pass
