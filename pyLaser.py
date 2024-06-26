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

class pyLaser(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.ser = None
        self.initOn = 0
        self.sweepOn = 0

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
            self.write("LSR:ILEV %.1f" % arg)
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
            self.write("DRV:D %d %.3f" % (arg1, arg2))
            success = self.read()
            self.write("DRV:D? %d" % arg1)
        return self.read()

    @Slot(QUrl, result=list)
    def getSettings(self, path):
        self.pathSettings = path.toLocalFile()
        self.settings = np.genfromtxt(path.toLocalFile(), delimiter=';')
        print(self.settings)
        self.end=len(self.settings[:, 0]) - 1
        return [self.end, float(self.settings[:, 4].min()), float(self.settings[:, 4].max())]

    @Slot(int, result=list)
    def setConfig(self, index):
        print(float(self.settings[index, 0]), float(self.settings[index, 1]), float(self.settings[index, 2]), float(self.settings[index, 3]), float(self.settings[index, 4]))
        return [float(self.settings[index, 0]), float(self.settings[index, 1]), float(self.settings[index, 2]), float(self.settings[index, 3]), float(self.settings[index, 4])]

    @Slot(float, result=int)
    def findWl(self, wl):
        return int(np.argmin(np.abs(self.settings[:, 4] - wl)))

    @Slot(result=str)
    @Slot(int, result=str)
    def drvCycInt(self, arg=None):
        if arg is None:
            self.write("DRV:CYC:INT?")
        else:
            self.write("DRV:CYC:INT %d" % arg)
            success = self.read()
            self.write("DRV:CYC:INT?")
        return self.read()

    @Slot(result=str)
    @Slot(int, result=str)
    def drvCycCoun(self, arg=None):
        if arg is None:
            self.write("DRV:CYC:COUN?")
        else:
            self.write("DRV:CYC:COUN %d" % arg)
            success = self.read()
            self.write("DRV:CYC:COUN?")
        return self.read()

    @Slot(result=str)
    def drvCycRun(self):
        self.write("DRV:CYC:RUN")
        success = self.read()
        return success

    @Slot(result=str)
    def drvCycAbrt(self):
        self.write("DRV:CYC:ABRT")
        success = self.read()
        return success

    @Slot(int, result=str)
    def drvCycSave(self, arg):
        self.write("DRV:CYC:SAVE %d" % arg)
        success = self.read()
        return success

    @Slot()
    def startInitScan(self):
        if not self.initOn:
            self.initOn = 1
            self.initProg = ""
            t = threading.Thread(target=self.initScan, daemon=True)
            t.start()

    @Slot()
    def stopInitScan(self):
        self.initOn = 0

    def initScan(self):
        lutLen = len(self.settings[:, 4])
        if lutLen > 7743:
            lutLen = 7743
        self.drvCycCoun(lutLen)
        for i in range(lutLen):
            self.drvD(3, float(self.settings[i, 1]))
            self.drvD(4, float(self.settings[i, 2]))
            self.drvD(0, float(self.settings[i, 3]))
            self.drvD(5, float(self.settings[i, 0]))
            success = self.drvCycSave(i)
            if success == "0":
                self.initProg = str(i+1) + "/" + str(lutLen)
            else:
                self.initProg = success[2:]
                break
            if not self.initOn:
                break
        self.initOn = 0
        self.initProg = self.initProg + " Done!"

    @Slot(result=str)
    def initProgress(self):
        return self.initProg

    @Slot(int, result=str)
    def drvCycLoad(self, arg):
        self.write("DRV:CYC:LOAD %d" % arg)
        success = self.read()
        return success

    @Slot(list)
    def startSweep(self, f):
        if not self.sweepOn:
            self.sweepOn = 1
            t = threading.Thread(target=self.sweep, args=(f,), daemon=True)
            t.start()

    @Slot()
    def stopSweep(self):
        self.sweepOn = 0

    ### Old Functions###
    # 0: count, 1: interval, 2: loopOn, 3: slow
    def sweep(self, f):
        while self.sweepOn:
            if f[3]:
                for i in range(len(self.settings[:, 0])):
                    self.drvD(3, float(self.settings[i, 1]))
                    self.drvD(4, float(self.settings[i, 2]))
                    self.drvD(0, (float(self.settings[i, 3])**2+25)**0.5)
                    time.sleep(0.1)
                    self.drvD(0, (float(self.settings[i, 3])**2+12)**0.5)
                    time.sleep(0.1)
                    self.drvD(0, float(self.settings[i, 3]))
                    time.sleep(f[1])

                    if not self.sweepOn:
                        break
                if f[2] == 0:
                    self.sweepOn = 0
                    break
            else:
                for i in range(f[0]):
                    self.drvCycLoad(i)
                    time.sleep(f[1])
                    if not self.sweepOn:
                        break
                if f[2] == 0:
                    self.sweepOn = 0
                    break
