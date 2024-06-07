from PySide2.QtCore import QObject, Slot, QUrl

import serial
from serial.tools.list_ports import comports
import numpy as np
import time
import threading
import csv
from concurrent.futures import ThreadPoolExecutor

class pyLaser(QObject):
    def __init__(self):
        QObject.__init__(self)
        self.ser = None
        self.initOn = 0
        self.sweepOn = 0
        self.activeExecution = 0
        self.TerminalText = " "
        self.TerminalLineCount = 0
        self.executor = ThreadPoolExecutor()

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
    
    def configureLaser(self):
        time.sleep(0.1)
        self.systStat(1)
        self.tecTemp(21)
        self.lsrIlev(250.000)
        self.drvD(2,2.420)
        self.drvD(1,0.930)
        self.drvD(3,0.000)

    @Slot()
    def call_configureLaser(self):
        if not self.activeExecution:
            self.activeExecution = 1
            configureLaser_thread = self.executor.submit(self.configureLaser())
            self.activeExecution = 0

    @Slot()
    def call_hysterises(self):
        if not self.activeExecution:
            self.activeExecution = 1
            hysterises_thread = self.executor.submit(self.hysterises())
            self.activeExecution = 0

    @Slot()
    def call_configFeedback(self):
        if not self.activeExecution:
            self.activeExecution = 1
            configFeedback_thread = self.executor.submit(self.configFeedback())
            self.activeExecution = 0
        
    @Slot(result=str)
    def rst(self):  # resets system
        self.write("*RST")
        success = self.read()
        time.sleep(2)

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
    def fbStat(self, arg=None):  # control and return system state
        if arg is None:
            self.write("FB:STAT?")
        else:
            self.write("FB:STAT %d" % arg)
            success = self.read()
            self.write("FB:STAT?")
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
    
    def hysterises(self):
        time.sleep(0.1)
        dv_sq_values = [35, 26, 20, 15, 12.5, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
        for dv_sq in dv_sq_values:
            voltage = np.sqrt(3.8341**2 + dv_sq)
            print("drvD 3 ", voltage)
            self.drvD(3, voltage)
            time.sleep(0.1)
        
    def configFeedback(self):
        time.sleep(0.1)

        self.write("FB:NSEL 0")
        self.read()
        self.write("FB:SRC 4")
        self.read()
        self.write("FB:DST 1")
        self.read()
        self.write("FB:INT 500")
        self.read()
        self.write("FB:SETP 23.0")
        self.read()
        self.write("FB:KP -0.026000")
        self.read()
        self.write("FB:KI 0.000000")
        self.read()
        self.write("FB:KD 0.000000")
        self.read()


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
