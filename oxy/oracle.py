#!/usr/bin/python3
# -*- coding: utf8 -*-

import cx_Oracle

from oxy.db import Db


class Oracle(Db):

    def __init__(self, username, password,
                 hostname, port, servicename, schema):

        super(Oracle, self).__init__()

        self.className = self.__class__.__name__

        self.dbModule = cx_Oracle
        self.nonRaiserErrors = {
            1017: 'Please check your credentials.',
            12541: 'Can''t connect.'
            }

        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.servicename = servicename
        self.schema = schema

    def custonConnect(self):
        self.con = cx_Oracle.connect(
            self.username, self.password,
            '{}:{}/{}'.format(self.hostname, self.port, self.servicename))
        self.con.current_schema = self.schema


if __name__ == '__main__':
    pass
