#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import pyodbc

from oxy.db import Db


class Mssql(Db):

    def __init__(self, username, password,
                 hostname, port, database, schema):

        super(Mssql, self).__init__()

        self.className = self.__class__.__name__

        self.dbModule = pyodbc
        self.nonRaiserErrors = {}

        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.database = database
        self.schema = schema

    def custonConnect(self):
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


if __name__ == '__main__':
    pass
