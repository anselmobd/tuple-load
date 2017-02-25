#!/usr/bin/env python3.4
# -*- coding: utf8 -*-

import fdb

from oxy.db import Db


class Firebird(Db):

    def __init__(self, username, password,
                 hostname, port, database, charset):

        super(Firebird, self).__init__()

        self.className = self.__class__.__name__

        self.dbModule = fdb
        self.nonRaiserErrors = {}

        self.username = username
        self.password = password
        self.hostname = hostname
        self.port = port
        self.database = database
        self.charset = charset

    def custonConnect(self):
        self.con = fdb.connect(
            dsn='{}/{}:{}'.format(self.hostname, self.port, self.database),
            user=self.username,
            password=self.password,
            charset=self.charset
            )


if __name__ == '__main__':
    pass
