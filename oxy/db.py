#!/usr/bin/python3
# -*- coding: utf8 -*-

import sys

import cx_Oracle


class Db:

    def __init__(self):

        # Vebosity level to show all
        self._VERBOSITY = 4

        self.CONTINUE_ON_ERROR = False
        self.connected = False
        self.verbosity = 0

        self.className = self.__class__.__name__

        self.dbModule = None
        self.nonRaiserErrors = {}

        self.STRING = None
        self.NUMBER = None

    def custonConnect(self):
        pass

    def connect(self):
        """ Connect to the database. if this fails, raise. """
        if self.verbosity >= self._VERBOSITY:
            print(self.className, '-> connect start')

        try:
            self.custonConnect()
            self.connected = True

        except self.dbModule.DatabaseError as e:
            error, *args = e.args
            msgPrefix = 'Database connection error:'
            if error.code in self.nonRaiserErrors.keys():
                reraise = False
                msg = self.nonRaiserErrors[error.code]
            else:
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
            print(self.className, '-> connect end')

    def commit(self):
        """ Commit data to the database. If this fails, don't care. """
        if self.verbosity >= self._VERBOSITY:
            print(self.className, '-> commit start')
        try:
            self.con.commit()
        except cx_Oracle.DatabaseError:
            pass
        if self.verbosity >= self._VERBOSITY:
            print(self.className, '-> commit end')

    def disconnect(self):
        """ Disconnect from the database. If this fails, don't care. """
        if self.verbosity >= self._VERBOSITY:
            print(self.className, '-> disconnect start')
        try:
            self.cursor.close()
            self.con.close()
            self.connected = False
        except cx_Oracle.DatabaseError:
            pass
        if self.verbosity >= self._VERBOSITY:
            print(self.className, '-> disconnect end')

    def cursorExecute(self, statement, data=None, halt=True):
        """ Execute statement using data and return cursor. """
        if self.verbosity >= self._VERBOSITY:
            print(self.className, '-> cursorExecute start')
        try:
            if data:
                self.cursor.execute(statement, data)
            else:
                self.cursor.execute(statement)
        except cx_Oracle.DatabaseError as e:
            error, = e.args
            if self.verbosity >= 1:
                print('Error: {}'.format(e))
            if halt:
                raise
        if self.verbosity >= self._VERBOSITY:
            print(self.className, '-> cursorExecute end')
        return self.cursor


if __name__ == '__main__':
    pass
