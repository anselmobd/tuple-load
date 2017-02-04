#!/usr/bin/python3
# -*- coding: utf8 -*-

import os
import re
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


class Cnpj:
    """
    Initially inspired by Murtog from http://wiki.python.org.br/Cnpj
    Adapted and tested under Python3.4 in 2017-02-04 by Anselmo B. D.
    """
    def __init__(self):
        """
        Class to interact with CNPJ brazilian numbers
        """
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
        # defining some variables
        lista_validacao_um = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
        lista_validacao_dois = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

        # cleaning the cnpj
        cnpj = re.sub("[^0-9]", "", cnpj)

        # verifying the lenght of the cnpj
        if len(cnpj) < 12 or len(cnpj) > 15:
            raise ValueError(
                'Argument cnpj "{}" must contain from 12 to 15 digits '
                'and contain {}'.format(cnpj, len(cnpj)))

        # calculating the first digit
        soma = 0
        id = 0
        for numero in cnpj:

            # to do not raise indexerrors
            try:
                lista_validacao_um[id]
            except:
                break

            soma += int(numero) * int(lista_validacao_um[id])
            id += 1

        soma = soma % 11
        if soma < 2:
            digito_um = 0
        else:
            digito_um = 11 - soma

        # converting to string, for later comparison
        digito_um = str(digito_um)

        # calculating the second digit
        # suming the two lists
        soma = 0
        id = 0

        # suming the two lists
        for numero in cnpj:

            # to do not raise indexerrors
            try:
                lista_validacao_dois[id]
            except:
                break

            soma += int(numero) * int(lista_validacao_dois[id])
            id += 1

        # defining the digit
        soma = soma % 11
        if soma < 2:
            digito_dois = 0
        else:
            digito_dois = 11 - soma

        digito_dois = str(digito_dois)

        # returnig
        return digito_um + digito_dois

    def format(self, cnpj):
        """
        Method to format cnpj numbers.
        Tests:

        >>> print Cnpj().format('53612734000198')
        53.612.734/0001-98
        """
        return "%s.%s.%s/%s-%s" % \
            (cnpj[0:2], cnpj[2:5], cnpj[5:8], cnpj[8:12], cnpj[12:14])


if __name__ == '__main__':
    pass
