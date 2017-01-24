#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import pyodbc


class Mssql:

    def __init__(self, username, password,
                 hostname, port, database, schema):
        # self.CONTINUE_ON_ERROR = False
        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.database = database
        self.schema = schema

    def connect(self):
        """ Connect to the database. if this fails, raise. """
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

        except pyodbc.DatabaseError as e:
            print('Database connection error: {}'.format(e))
            raise

        self.cursor = self.con.cursor()

    def disconnect(self):
        """ Disconnect from the database. If this fails, don't care. """
        try:
            self.cursor.close()
            self.con.close()
        except pyodbc.DatabaseError:
            pass

    def cursorExecute(self, statement, data=None, halt=True):
        """ Execute statement using data and return cursor. """
        try:
            if data:
                self.cursor.execute(statement, data)
            else:
                self.cursor.execute(statement)
        except pyodbc.DatabaseError as e:
            print('Error: {}'.format(e))
            if halt:
                raise
        return self.cursor


if __name__ == '__main__':
    pass
