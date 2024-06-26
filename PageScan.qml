/****************************************************************************
This file is part of LTS.

LTS is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

LTS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
****************************************************************************/

import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Extras 1.4
import Qt.labs.qmlmodels 1.0

Pane {
    id: pageScan
    width: 640
    height: 500

    property bool lutOn: false
    property bool scanOn: false

    Row {
        id: rowMode
        anchors.fill: parent
        spacing: 20

        Frame {
            id: frameControl
            width: 280
            height: parent.height

            Column {
                id: columnControl
                width: 200
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: (parent.height - Array.from(visibleChildren).map((value) => value.height).reduce((sum, value) => sum + value)) / (visibleChildren.length - 1);

                Text {
                    id: textCommands
                    text: "SCAN COMMANDS"
                    font.pixelSize: 15
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: buttonInit
                    width: parent.width
                    enabled: lutOn && !scanOn
                    text: "Initiate"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        popupInit.open()
                        backend.startInitScan(textInit)
                        timerText.restart()
                    }
                }

                Text {
                    id: textInit
                    text: ""
                    visible: false
                    color: "#FF0000"
                    font.pixelSize: 10
                    anchors.horizontalCenter: parent.horizontalCenter

                    Timer {
                        id: timerText
                        interval: 200
                        repeat: true
                        onTriggered: {
                            textInit.visible = true
                            textInit.text = backend.initProgress()
                            if (textInit.text.slice(-1) === "!") { stop();popupInit.close() }
                        }
                    }
                }

                Popup {
                    id: popupInit
                    modal: true
                    focus: true
                    contentHeight: parent.height/2
                    contentWidth: parent.width
                    anchors.centerIn: Overlay.overlay
                    closePolicy: Popup.NoAutoClose

                    BusyIndicator {
                        id: busyIndicator
                        anchors.verticalCenter: parent.verticalCenter
                        antialiasing: true
                        running: parent.enabled
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Button {
                        id: buttonAbrtInit
                        width: parent.width
                        text: "Abort Initialization"
                        anchors.bottom: textInitPopup.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            backend.stopInitScan()
                            popupInit.close()
                        }
                    }

                    Text {
                        id: textInitPopup
                        text: textInit.text
                        visible: textInit.visible
                        color: "#FF0000"
                        font.pixelSize: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.bottom: parent.bottom
                    }
                }

                Button {
                    id: buttonStart
                    width: parent.width
                    text: "Start"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        let success = backend.drvCycRun()
                        if (success[0] === "0") { textStart.text = ""; textStart.visible = false; scanOn = true } else { (textStart.text = success.substr(2)); textStart.visible = true }
                    }
                }

                Text {
                    id: textStart
                    text: ""
                    visible: false
                    font.pixelSize: 10
                    color: "#FF0000"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Button {
                    id: buttonStop
                    width: parent.width
                    text: "Stop"
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        let success = backend.drvCycAbrt()
                        if (success[0] === "0") { textStop.text = ""; textStop.visible = false; scanOn = false } else { (textStop.text = success.substr(2)); textStop.visible = true }
                    }
                }

                Text {
                    id: textStop
                    text: ""
                    visible: false
                    font.pixelSize: 10
                    color: "#FF0000"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Frame {
                    id: frameInt
                    width: parent.width
                    height: 90
                    Text {
                        id: textInt
                        text: "Step Time [μs]"
                        font.pixelSize: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    SpinBox {
                        id: spinBoxInt
                        locale: Qt.locale("en_EN")
                        anchors.top: textInt.bottom
                        editable: true
                        anchors.topMargin: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        stepSize: 100
                        from: 200
                        to: 15000
                        value: 1000
                        wheelEnabled: true
                        ColorAnimation { target: spinBoxInt.background; property: "color"; id: caInt; running: false; from: "#41cd52"; to: color; duration: 1000}
                        onValueModified: { backend.drvCycInt(value); caInt.restart() }
                    }
                }

                Frame {
                    id: frameCount
                    width: parent.width
                    height: 90
                    Text {
                        id: textCount
                        text: "Count"
                        font.pixelSize: 15
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    SpinBox {
                        id: spinBoxCoun
                        locale: Qt.locale("en_EN")
                        anchors.top: textCount.bottom
                        editable: true
                        wheelEnabled: true
                        anchors.topMargin: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        from: 1
                        value: 1000
                        to: 7743
                        stepSize: 1
                        focus: true
                        ColorAnimation { target: spinBoxCoun.background; property: "color"; id: caCoun; running: false; from: "#41cd52"; to: color; duration: 1000}
                        onValueModified: { backend.drvCycCoun(value); caCoun.restart() }
                    }
                }
            }
        }

//        Frame {
//            id: frameControl
//            width: 280
//            height: parent.height

//            Column {
//                id: columnControl
//                width: 200
//                anchors.horizontalCenter: parent.horizontalCenter
//                spacing: (parent.height - Array.from(visibleChildren).map((value) => value.height).reduce((sum, value) => sum + value)) / (visibleChildren.length - 1);

//                Text {
//                    id: textCommands
//                    text: "SCAN COMMANDS"
//                    font.pixelSize: 15
//                    anchors.horizontalCenter: parent.horizontalCenter
//                }

//                Button {
//                    id: buttonInit
//                    width: parent.width
//                    enabled: lutOn && !scanOn
//                    text: "Initiate"
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    onClicked: {
//                        popupInit.open()
//                        backend.startInitScan(textInit)
//                        timerText.restart()
//                    }
//                }

//                Text {
//                    id: textInit
//                    text: ""
//                    visible: false
//                    color: "#FF0000"
//                    font.pixelSize: 10
//                    anchors.horizontalCenter: parent.horizontalCenter

//                    Timer {
//                        id: timerText
//                        interval: 200
//                        repeat: true
//                        onTriggered: {
//                            textInit.visible = true
//                            textInit.text = backend.initProgress()
//                            if (textInit.text.slice(-1) === "!") { stop();popupInit.close() }
//                        }
//                    }
//                }

//                Popup {
//                    id: popupInit
//                    modal: true
//                    focus: true
//                    contentHeight: parent.height/2
//                    contentWidth: parent.width
//                    anchors.centerIn: Overlay.overlay
//                    closePolicy: Popup.NoAutoClose

//                    BusyIndicator {
//                        id: busyIndicator
//                        anchors.verticalCenter: parent.verticalCenter
//                        antialiasing: true
//                        running: parent.enabled
//                        anchors.horizontalCenter: parent.horizontalCenter
//                    }

//                    Button {
//                        id: buttonAbrtInit
//                        width: parent.width
//                        text: "Abort Initialization"
//                        anchors.bottom: textInitPopup.top
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        onClicked: {
//                            backend.stopInitScan()
//                            popupInit.close()
//                        }
//                    }

//                    Text {
//                        id: textInitPopup
//                        text: textInit.text
//                        visible: textInit.visible
//                        color: "#FF0000"
//                        font.pixelSize: 10
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        anchors.bottom: parent.bottom
//                    }
//                }

//                Button {
//                    id: buttonStart
//                    width: parent.width
//                    text: "Start"
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    onClicked: {
//                        backend.startSweep([spinBoxCoun.value,
//                                            spinBoxInt.value/1000,
//                                            1,
//                                            switchSlow.checked+0])
//                        scanOn = true
//                    }
//                }

//                Button {
//                    id: buttonScanOnce
//                    width: parent.width
//                    text: "Scan Once"
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    onClicked: {
//                        backend.startSweep([spinBoxCoun.value,
//                                            spinBoxInt.value/1000,
//                                            0,
//                                            switchSlow.checked+0])
//                        scanOn = true
//                        timerScanOn.restart()
//                    }
//                }

//                Timer {
//                    id: timerScanOn
//                    interval: spinBoxCoun.value*spinBoxInt.value
//                    repeat: false
//                    running: false
//                    onTriggered: scanOn = false
//                }

//                Button {
//                    id: buttonStop
//                    width: parent.width
//                    text: "Stop"
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    onClicked: {
//                        backend.stopSweep()
//                        scanOn = false
//                    }
//                }

//                Frame {
//                    id: frameInt
//                    width: parent.width
//                    height: 90
//                    Text {
//                        id: textInt
//                        text: "Step Time [s]"
//                        font.pixelSize: 15
//                        anchors.horizontalCenter: parent.horizontalCenter
//                    }

//                    SpinBox {
//                        id: spinBoxInt
//                        locale: Qt.locale("en_EN")
//                        anchors.top: textInt.bottom
//                        editable: true
//                        anchors.topMargin: 10
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        stepSize: 10
//                        from: 20
//                        to: 600000
//                        value: 1000
//                        wheelEnabled: true

//                        validator: DoubleValidator {
//                            locale: spinBoxInt.locale.name
//                            bottom: Math.min(spinBoxInt.from, spinBoxInt.to)
//                            top: Math.max(spinBoxInt.from, spinBoxInt.to)
//                        }

//                        textFromValue: function(value, locale) {
//                            return Number(value / 1000).toLocaleString(locale, 'f', 3)
//                        }

//                        valueFromText: function(text, locale) {
//                            return Number.fromLocaleString(locale, text) * 1000
//                        }
//                    }
//                }

//                Frame {
//                    id: frameCount
//                    width: parent.width
//                    height: 90
//                    Text {
//                        id: textCount
//                        text: "Count"
//                        font.pixelSize: 15
//                        anchors.horizontalCenter: parent.horizontalCenter
//                    }

//                    SpinBox {
//                        id: spinBoxCoun
//                        locale: Qt.locale("en_EN")
//                        anchors.top: textCount.bottom
//                        editable: true
//                        wheelEnabled: true
//                        anchors.topMargin: 10
//                        anchors.horizontalCenter: parent.horizontalCenter
//                        from: 1
//                        value: 1000
//                        to: 7743
//                        stepSize: 1
//                        focus: true
//                        enabled: !switchSlow.checked
//                    }
//                }

//                Switch {
//                    id: switchSlow
//                    text: "Slow"
//                    anchors.horizontalCenter: parent.horizontalCenter
//                    enabled: pageScan.lutOn
//                }
//            }
//        }
    }
}
