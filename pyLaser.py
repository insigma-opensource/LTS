#****************************************************************************
#This file is part of LTS.
#
#LTS is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#LTS is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program. If not, see <https://www.gnu.org/licenses/>.
#****************************************************************************

from PySide2.QtCore import QObject, Slot, QUrl

import serial
from serial.tools.list_ports import comports
import numpy as np
import time

class pyLaser(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.ser = None

    @Slot(result=list)
    def listPorts(self):
        self.ports = []
        self.portList = []
        for n, (port, desc, hwid) in enumerate(sorted(comports()), 1):
            self.ports.append(port)
            self.portList.append(port + " - " + desc)
        return self.portList

    @Slot(int)
    def openPort(self, port):
        if(self.ser is None):
            self.ser = serial.Serial(self.ports[port],
                                     57600,
                                     serial.EIGHTBITS,
                                     serial.PARITY_NONE,
                                     serial.STOPBITS_ONE,
                                     5)

    @Slot(str)
    def write(self, command):
        print(command)
        # print(hex(int.from_bytes((command + "\r\n").encode(), "big")))
        if(self.ser is not None):
            self.ser.write((command + "\r\n").encode())

    @Slot(result=str)
    def read(self):
        if(self.ser is not None):
            data = self.ser.readline().decode("utf-8")[:-2]
            print(data)
            return data
        else:
            return "0.00"

    @Slot()
    def rstSer(self):
        if(self.ser is not None):
            self.ser.reset_input_buffer()

    @Slot()
    def close(self):
        if(self.ser is not None):
            self.ser.close()

    @Slot(result=str)
    def idn(self):  # returns the device string
        self.write("*IDN?")
        return self.read()

    @Slot(result=str)
    def rst(self):  # resets system
        self.write("*RST")
        success = self.read()

    @Slot(result=str)
    @Slot(int, result=str)
    def systStat(self, arg=None):  # control and return system state
        if arg is None:
            self.write("SYST:STAT?")
        else:
            self.write("SYST:STAT %d" % arg)
            success = self.read()
            self.write("SYST:STAT?")
        return self.read()

    @Slot(result=str)
    @Slot(int, result=str)
    def drvStat(self, arg=None):  # control and return driver state
        if arg is None:
            self.write("DRV:STAT?")
        else:
            self.write("DRV:STAT %d" % arg)
            success = self.read()
            self.write("DRV:STAT?")
        return self.read()

    @Slot(int, result=str)
    @Slot(int, float, result=str)
    def drvD(self, arg1, arg2=None):  # control and return driver level
        if arg2 is None:
            self.write("DRV:D? %d" % arg1)
        else:
            self.write("DRV:D %d %.2f" % (arg1, arg2))
            success = self.read()
            self.write("DRV:D? %d" % arg1)
        return self.read()

    @Slot()
    def drvClr(self):  # sets all actuators to zero
        self.write("DRV:CLR")
        success = self.read()

    @Slot()
    def systP(self):
        self.write("SYST:PWD X")
        success = self.read()

    @Slot(int, result=str)
    def tecStat(self, arg):
        self.write("TEC:STAT %d" % arg)
        success = self.read()

    @Slot(QUrl, result=list)
    def getSettings(self, path):
        self.settings = np.genfromtxt(path.toLocalFile(), delimiter=';')
        print(self.settings)
        return self.settings.tolist()

    @Slot(list)
    def saveSettings(self, set):
        date = time.strftime("%y%m%d-%H%M%S")
        settings = np.array([[0, set[3], set[3], set[3]],
                             [3, set[0], set[0], set[0]],
                             [4, set[1], set[1], set[1]],
                             [5, set[2], set[2], set[2]]])
        np.savetxt(date+'.csv', settings, delimiter=";", fmt=['%d', '%.2f', '%.2f', '%.2f'])
