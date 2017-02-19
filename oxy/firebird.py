#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import sys

import fdb


class Firebird:

    def __init__(self, username, password,
                 hostname, port, database, charset):

        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.database = database
        self.charset = charset

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
            self.con = fdb.connect(
                dsn='{}/{}:{}'.format(self.hostname, self.port, self.database),
                user=self.username,
                password=self.password,
                charset=self.charset
                )
            self.connected = True

        except fdb.DatabaseError as e:
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
        except fdb.DatabaseError:
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
        except fdb.DatabaseError:
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
        except fdb.DatabaseError as e:
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
