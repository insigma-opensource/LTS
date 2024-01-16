import sys
import os

from PySide2.QtGui import QGuiApplication, QIcon
from PySide2.QtQml import QQmlApplicationEngine
from PySide2.QtCore import QUrl

import pyLaser

if __name__ == "__main__":
    app = QGuiApplication(sys.argv)
    app.setOrganizationName("RA")
    app.setWindowIcon(QIcon("icon.ico"))

    engine = QQmlApplicationEngine()

    laser = pyLaser.pyLaser()
    engine.rootContext().setContextProperty("backend", laser)

    engine.load(os.path.join(os.path.dirname(__file__), "main.qml"))

    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec_())
