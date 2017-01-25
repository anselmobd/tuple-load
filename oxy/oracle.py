#!/usr/bin/python3
# -*- coding: utf8 -*-

import sys

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

        # Vebosity to show all
        self._VERBOSITY = 4

        self.CONTINUE_ON_ERROR = False
        self.connected = False
        self.verbosity = 0

    def connect(self):
        """ Connect to the database. if this fails, raise. """
        if self.verbosity >= self._VERBOSITY:
            print('Oracle->connect start')
        try:
            self.con = cx_Oracle.connect(
                self.username, self.password,
                '{}:{}/{}'.format(self.hostname, self.port, self.servicename))
            self.connected = True
            self.con.current_schema = self.schema

        except cx_Oracle.DatabaseError as e:
            error, = e.args
            reraise = False
            msgPrefix = 'Database connection error:'
            if error.code == 1017:
                msg = 'Please check your credentials.'
            elif error.code == 12541:
                msg = 'Can''t connect.'
            else:
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
            print('Oracle->connect end')

    def commit(self):
        """ Commit data to the database. If this fails, don't care. """
        if self.verbosity >= self._VERBOSITY:
            print('Oracle->commit start')
        try:
            self.con.commit()
        except cx_Oracle.DatabaseError:
            pass
        if self.verbosity >= self._VERBOSITY:
            print('Oracle->commit end')

    def disconnect(self):
        """ Disconnect from the database. If this fails, don't care. """
        if self.verbosity >= self._VERBOSITY:
            print('Oracle->disconnect start')
        try:
            self.cursor.close()
            self.con.close()
            self.connected = False
        except cx_Oracle.DatabaseError:
            pass
        if self.verbosity >= self._VERBOSITY:
            print('Oracle->disconnect end')

    def cursorExecute(self, statement, data=None, halt=True):
        """ Execute statement using data and return cursor. """
        if self.verbosity >= self._VERBOSITY:
            print('Oracle->cursorExecute start')
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
            print('Oracle->cursorExecute end')
        return self.cursor


if __name__ == '__main__':
    pass
