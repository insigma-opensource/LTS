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
            self.write("DRV:D %d %.2f" % (arg1, arg2))
            success = self.read()
            self.write("DRV:D? %d" % arg1)
        return self.read()

    @Slot()
    def drvClr(self):  # sets all actuators to zero
        self.write("DRV:CLR")
        success = self.read()

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
                             [5, set[2], set[2], set[2]],
                             [7, set[4], float(set[4])+0.5, float(set[4])+1],
                             [8, set[5], set[5], set[5]]])
        np.savetxt(date+'.csv', settings, delimiter=";", fmt=['%d', '%.2f', '%.2f', '%.2f'])

    @Slot(result=str)
    @Slot(float, result=str)
    def setP(self, arg=None):  # control and return P
        if arg is None:
            self.write("TEC:CTRL:PSHR?")
        else:
            self.write("TEC:CTRL:PSHR %.3f" % arg)
            success = self.read()
            self.write("TEC:CTRL:PSHR?")
        return self.read()

    @Slot(result=str)
    @Slot(float, result=str)
    def setI(self, arg=None):  # control and return I
        if arg is None:
            self.write("TEC:CTRL:ISHR?")
        else:
            self.write("TEC:CTRL:ISHR %.3f" % arg)
            success = self.read()
            self.write("TEC:CTRL:ISHR?")
        return self.read()

    @Slot(result=str)
    @Slot(float, result=str)
    def setD(self, arg=None):  # control and return D
        if arg is None:
            self.write("TEC:CTRL:DSHR?")
        else:
            self.write("TEC:CTRL:DSHR %.3f" % arg)
            success = self.read()
            self.write("TEC:CTRL:DSHR?")
        return self.read()

    @Slot(result=str)
    @Slot(float, result=str)
    def iMax(self, arg=None):  # control and return max tec I
        if arg is None:
            self.write("TEC:CFG:ILIM?")
        else:
            self.write("TEC:CFG:ILIM %.3f" % arg)
            success = self.read()
            self.write("TEC:CFG:ILIM?")
        return self.read()
