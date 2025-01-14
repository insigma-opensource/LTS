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
import threading
import csv

class pyLaser(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.ser = None
        self.initOn = 0
        self.sweepOn = 0
        self.TerminalText = " "
        self.TerminalLineCount = 0

    @Slot(result=list)
    def listPorts(self):
        self.ports = []
        self.portList = []
        for n, (port, desc, hwid) in enumerate(sorted(comports()), 1):
            self.ports.append(port)
            self.portList.append(port + " - " + desc)
        #print(comports()[0].hwid, "---", comports()[0].vid, "---", comports()[0].pid, "---", comports()[0].serial_number, "---", comports()[0].manufacturer,  "---", comports()[0].product)
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
            return "0.000"
        
    @Slot(list)
    def pushExtras(self, extras): 
        self.TerminalRead = extras[0]
    
    @Slot()
    def read2Terminal(self):
        if self.ser is not None:
            data = self.read()  
            self.TerminalLineCount += 1
            self.TerminalText = self.TerminalText + "\n" + " " + str(self.TerminalLineCount) + " " + "->"  + data
            self.TerminalRead.setProperty("text", self.TerminalText)
        else:
            print("Serial communication not initialized.")
            self.TerminalLineCount += 1
            self.TerminalText = self.TerminalText + "\n " + " " + str(self.TerminalLineCount) + " " + "-> Serial communication not initialized."
            self.TerminalRead.setProperty("text", self.TerminalText)

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
        return self.read()[2:-2].replace(",", " ")

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
    def lsrStat(self, arg=None):  # control and return laser state
        if arg is None:
            self.write("LSR:STAT?")
        else:
            self.write("LSR:STAT %d" % arg)
            success = self.read()
            self.write("LSR:STAT?")
        return self.read()

    @Slot(result=str)
    @Slot(float, result=str)
    def lsrIlev(self, arg=None):  # control and return laser current level
        if arg is None:
            self.write("LSR:ILEV?")
        else:
            self.write("LSR:ILEV %.2f" % arg)
            success = self.read()
            self.write("LSR:ILEV?")
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
            self.write("DRV:D %d %.4f" % (arg1, arg2))
            success = self.read()
            self.write("DRV:D? %d" % arg1)
        return self.read()

    @Slot(result=str)
    @Slot(float, result=str)
    def tecTemp(self, arg=None):  # control and return tec temp level
        if arg is None:
            self.write("TEC:TEMP?")
        else:
            self.write("TEC:TTGT %.2f" % arg)
            success = self.read()
            self.write("TEC:TTGT?")
        return self.read()

    @Slot(int, result=str)
    def measM(self, arg):
        self.write("MEAS:M? %d" % arg)
        return self.read()

    @Slot(QUrl, result=list)
    def getSettings(self, path):

        self.pathSettings = path.toLocalFile()

        try:
            with open(self.pathSettings, "r") as f:
                dialect = csv.Sniffer().sniff(f.read())
                f.seek(0)
                reader = csv.reader(f, dialect)
                self.settings = np.array(list(reader)).astype(float)

            print(self.settings)
            self.end=len(self.settings[:, 0]) - 1
            return [self.end, float(self.settings[:, 4].min()), float(self.settings[:, 4].max())]
        except Exception as e:
            print("Non-standard lookup table - ", e)
            return 0

    @Slot(int, result=list)
    def setConfig(self, index):
        print(float(self.settings[index, 0]), float(self.settings[index, 1]), float(self.settings[index, 2]), float(self.settings[index, 3]), float(self.settings[index, 4]))
        return [float(self.settings[index, 0]), float(self.settings[index, 1]), float(self.settings[index, 2]), float(self.settings[index, 3]), float(self.settings[index, 4])]

    @Slot(float, result=int)
    def findWl(self, wl):
        return int(np.argmin(np.abs(self.settings[:, 4] - wl)))
