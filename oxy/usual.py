#!/usr/bin/python3
# -*- coding: utf8 -*-

import os
import re
import configparser
import yaml

from pprint import pprint


def fileWithRequiredExtension(fileName, requiredExtension):
    name, extension = os.path.splitext(fileName)
    if extension == '.'+requiredExtension:
        return fileName
    else:
        return '{}.{}'.format(fileName, requiredExtension)


def fileWithDefaultDir(dire, fileName):
    path, name = os.path.split(fileName)
    if not path:
        path = dire
    return os.path.join(path, name)


class IniParser:

    AUTO = 0
    INI = 1
    YAML = 2

    type = None
    iniCfg = None

    def __init__(self, fileName, type=AUTO):
        self.type = type
        if self.type == IniParser.AUTO:
            name, extention = os.path.splitext(fileName)
            if extention.lower() == '.ini':
                self.type = IniParser.INI
            else:
                self.type = IniParser.YAML

        if self.type == IniParser.INI:
            self.iniCfg = configparser.RawConfigParser()
            self.iniCfg.read(fileName)
        elif self.type == IniParser.YAML:
            with open(fileName) as yaml_data:
                self.iniCfg = yaml.load(yaml_data)

    def has(self, *levels):
        '''
        Test if has N levels of keys
        [key1][key...][keyN]
        '''
        if len(levels) == 1:
            if self.type == self.YAML:
                result = levels[0] in self.iniCfg
            else:
                result = levels[0] in self.iniCfg.sections()
        else:
            try:
                stru = self.get(*levels[:-1])
                if self.type == self.YAML:
                    result = levels[-1] in stru
                else:
                    result = levels[-1] in [pair[0] for pair in stru]
            except Exception:
                result = False
        return result

    def get(self, *levels):
        '''
        Get value of N levels of keys
        [key1][key...][keyN]
        '''
        if self.type == self.YAML:
            result = self.iniCfg[levels[0]]
        else:
            result = self.iniCfg.items(levels[0])
        for i in range(1, len(levels)):
            if self.type == self.YAML:
                result = result[levels[i]]
            else:
                keys = [pair[0] for pair in result]
                result = result[keys.index(levels[i])][1]

        return result

    def iter(self, *levels):
        '''
        Iter through the value of N levels of keys
        [key1][key...][keyN]
        returning tuple (key, value)
        '''
        stru = self.get(*levels)
        if self.type == self.YAML:
            for variable in stru:
                yield list(variable.keys())[0], \
                    variable[list(variable.keys())[0]]
        else:
            for variable, value in stru:
                yield variable, value


class VerboseOutput:

    def __init__(self, verbosity):
        self.verbosity = verbosity

    def prnt(self, message, verbosity=1, **args):
        ''' Print message if verbosity x '''
        try:
            message = '{0}\n{1}\n{0}'.format(args['sep'], message)
        except:
            pass
        if self.verbosity >= verbosity:
            print(message)

    def pprnt(self, obj, verbosity=1):
        ''' PPrint object if verbosity x '''
        if self.verbosity >= verbosity:
            pprint(obj)

    def ppr(self, verbosity, *obj):
        ''' PPrint 1 or more objects if verbosity >= x '''
        if not isinstance(verbosity, int):
            obj = (verbosity,) + obj
            verbosity = 1
        for o in obj:
            self.pprnt(o, verbosity)


class Cnpj:
    """
    Initially inspired by Murtog from http://wiki.python.org.br/Cnpj
    Adapted and tested under Python3.4 in 2017-02-04 by Anselmo B. D.
    """
    def __init__(self):
        """
        Class to interact with CNPJ brazilian numbers
        """
        # assert(self.validate('61882613000194'))
        # assert(self.validate('061882613000190'))
        # assert(not self.validate('61882613000195'))
        pass

    def validate(self, cnpj):
        """
        Method to validate brazilian CNPJs.
        Argument cnpj must contain 14 or 15 digits.
        Other characters wil be ignored.
        Sample tests:
            print(Cnpj().validate('61882613000194'))  # True
            print(Cnpj().validate('061882613000194'))  # True
            print(Cnpj().validate('61882613000195'))  # False
            print(Cnpj().validate('53.612.734/0001-98'))  # True
            print(Cnpj().validate('69.435.154/0001-02'))  # True
            print(Cnpj().validate('69.435.154/0001-01'))  # False
        """
        return bool(cnpj[-2:] == self.digits(cnpj))

    def factors_gen(self, size):
        for position in range(size, 0, -1):
            factor = (position - 1) % 8 + 2
            yield factor

    def digits(self, cnpj):
        """
        Method to calculate the last two digits from brazilian CNPJs.
        Argument cnpj must contain from 12 to 15 digits.
        "cnpj" argument with less than 14 digits will be considered without
        check digits. With 14 or more will be considered with the digits and
        these will be ignored.
        Tests:
            print(Cnpj().digits('61882613000194'))  # 94
            print(Cnpj().digits('618826130001'))  # 94
            print(Cnpj().digits('061882613000194'))  # 49
            print(Cnpj().digits('61882613000195'))  # 94
            print(Cnpj().digits('53.612.734/0001-98'))  # 98
            print(Cnpj().digits('69.435.154/0001-02'))  # 02
            print(Cnpj().digits('69.435.154/0001-01'))  # 02
        """

        # cleaning the cnpj
        cnpj = re.sub("[^0-9]", "", cnpj)

        # verifying the lenght of the cnpj
        if len(cnpj) < 12 or len(cnpj) > 15:
            raise ValueError(
                'Argument cnpj "{}" must contain from 12 to 15 digits '
                'and contain {}'.format(cnpj, len(cnpj)))

        # Removing digits
        if len(cnpj) >= 14:
            cnpj = cnpj[:-2]

        for i in range(2):

            # calculating a digit
            soma = 0
            for number, factor in zip(cnpj, self.factors_gen(len(cnpj))):
                soma += int(number) * factor

            soma = soma % 11
            digito = 0 if soma < 2 else 11 - soma

            cnpj = '{}{}'.format(cnpj, digito)

        return cnpj[-2:]


if __name__ == '__main__':
    pass
