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
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

Pane {
    id: pageCntrlPnl
    width: 1200
    height: 500
    enabled: true
    property string idn: "Not connected"

    Row {
        id: rowCntrlPnl
        width: parent.width
        height: parent.height
        spacing: (width - 6*frameHeater1.width - frameSw.width)/6

        Frame {
            id: frameHeater1
            width: 160
            height: parent.height

            Column {
                id: columnHeater1
                anchors.fill: parent
                spacing: 15

                Row {
                    id: row1
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater1
                        text: "Phase 5"
                        font.pixelSize: 18
                    }
                }

                Row {
                    id: rowHeater1
                    height: columnHeater1.height - textHeaderHeater1.height - colSetGetHeater1.height - 2*columnHeater1.spacing
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: pageCntrlPnl.height < 250 ? false : true

                    Gauge {
                        id: gaugeHeater1
                        height: parent.height
                        antialiasing: true
                        value: 0
                        minimumValue: 0
                        maximumValue: 14
                        tickmarkStepSize: 1
                        minorTickmarkCount: 1
                        Behavior on value { NumberAnimation { duration: 100 } }
                    }

                    Slider {
                        id: sliderHeater1
                        height: parent.height
                        antialiasing: true
                        wheelEnabled: true
                        stepSize: 0.01
                        to: 14
                        orientation: Qt.Vertical
                        value: 0
                        onValueChanged: {
                            gaugeHeater1.value = backend.drvD(5, value.toFixed(2)).slice(2)
                        }
                    }
                }

                Column {
                    id: colSetGetHeater1
                    width: parent.width
                    height: 41

                    Row {
                        id: rowSetHeater1
                        anchors.left: parent.left
                        anchors.leftMargin: 40

                        Text {
                            id: textSetHeater1
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                            minimumPixelSize: 15
                        }

                        TextInput {
                            id: textEditSetHeater1
                            text: sliderHeater1.value.toFixed(2)
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                            cursorVisible: true
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; top: 12; bottom: 0;}
                            onAccepted: {
                                sliderHeater1.value = text
                            }

                            MouseArea {
                                id: mouseAreaPrecisionH1
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onPressed: function(mouse) { mouse.accepted = false }
                                onWheel: {
                                    var oldCurs = textEditSetHeater1.cursorPosition
                                    var curs = textEditSetHeater1.text.length - oldCurs
                                    if (wheel.angleDelta.y > 0) {
                                        if (curs > 2) {
                                            sliderHeater1.value += 1
                                        } else {
                                            sliderHeater1.value += (10**(curs+1))/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater1.value -= 1
                                        } else {
                                            sliderHeater1.value -= (10**(curs+1))/1000
                                        }
                                    }
                                    textEditSetHeater1.cursorPosition = textEditSetHeater1.text.length - curs
                                }
                            }
                        }
                    }

                    Row {
                        id: rowGetHeater1
                        anchors.left: rowSetHeater1.left

                        Text {
                            id: textGetHeater1
                            text: "Get: " + gaugeHeater1.value.toFixed(2) + " V"
                            font.pixelSize: 18
                            minimumPixelSize: 15
                        }
                    }
                }


            }
        }

        Frame {
            id: frameHeater2
            width: 160
            height: parent.height

            Column {
                id: columnHeater2
                anchors.fill: parent

                Row {
                    id: row2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater2
                        text: "Large Ring 3"
                        font.pixelSize: 18
                    }
                }

                Row {
                    id: rowHeater2
                    height: columnHeater2.height - textHeaderHeater2.height - colSetGetHeater2.height - 2*columnHeater2.spacing
                    visible: pageCntrlPnl.height < 250 ? false : true

                    Gauge {
                        id: gaugeHeater2
                        height: parent.height
                        antialiasing: true
                        tickmarkStepSize: 1
                        minimumValue: 0
                        value: sliderHeater2.value
                        minorTickmarkCount: 1
                        maximumValue: 14
                        Behavior on value { NumberAnimation { duration: 100 } }
                    }

                    Slider {
                        id: sliderHeater2
                        height: parent.height
                        antialiasing: true
                        stepSize: 0.01
                        wheelEnabled: true
                        value: 0
                        orientation: Qt.Vertical
                        to: 14
                        onValueChanged: {
                            gaugeHeater2.value = backend.drvD(3, value.toFixed(2)).slice(2)
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetHeater2
                    width: parent.width
                    height: 41
                    Row {
                        id: rowSetHeater2
                        anchors.left: parent.left
                        Text {
                            id: textSetHeater2
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetHeater2
                            text: sliderHeater2.value.toFixed(2)
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 12;}
                            onAccepted: {
                                sliderHeater2.value = text
                            }

                            MouseArea {
                                id: mouseAreaPrecisionH2
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onPressed: function(mouse) { mouse.accepted = false }
                                onWheel: {
                                    var oldCurs = textEditSetHeater2.cursorPosition
                                    var curs = textEditSetHeater2.text.length - oldCurs
                                    if (wheel.angleDelta.y > 0) {
                                        if (curs > 2) {
                                            sliderHeater2.value += 1
                                        } else {
                                            sliderHeater2.value += (10**(curs+1))/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater2.value -= 1
                                        } else {
                                            sliderHeater2.value -= (10**(curs+1))/1000
                                        }
                                    }
                                    textEditSetHeater2.cursorPosition = textEditSetHeater2.text.length - curs
                                }
                            }
                        }
                        anchors.leftMargin: 40
                    }

                    Row {
                        id: rowGetHeater2
                        anchors.left: rowSetHeater2.left
                        Text {
                            id: textGetHeater2
                            text: "Get: " + gaugeHeater2.value.toFixed(2) + " V"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameHeater3
            width: 160
            height: parent.height

            Column {
                id: columnHeater3
                anchors.fill: parent

                Row {
                    id: row3
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater3
                        text: "Small Ring 4"
                        font.pixelSize: 18
                    }
                }

                Row {
                    id: rowHeater3
                    height: columnHeater3.height - textHeaderHeater3.height - colSetGetHeater3.height - 2*columnHeater3.spacing
                    visible: pageCntrlPnl.height < 250 ? false : true

                    Gauge {
                        id: gaugeHeater3
                        height: parent.height
                        antialiasing: true
                        tickmarkStepSize: 1
                        minimumValue: 0
                        value: sliderHeater3.value
                        minorTickmarkCount: 1
                        maximumValue: 14
                        Behavior on value { NumberAnimation { duration: 100 } }
                    }

                    Slider {
                        id: sliderHeater3
                        height: parent.height
                        antialiasing: true
                        stepSize: 0.01
                        wheelEnabled: true
                        value: 0
                        orientation: Qt.Vertical
                        to: 14
                        onValueChanged: {
                            gaugeHeater3.value = backend.drvD(4, value.toFixed(2)).slice(2)
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetHeater3
                    width: parent.width
                    height: 41
                    Row {
                        id: rowSetHeater3
                        anchors.left: parent.left
                        Text {
                            id: textSetHeater3
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetHeater3
                            text: sliderHeater3.value.toFixed(2)
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 12;}
                            onAccepted: {
                                sliderHeater3.value = text
                            }

                            MouseArea {
                                id: mouseAreaPrecisionH3
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onPressed: function(mouse) { mouse.accepted = false }
                                onWheel: {
                                    var oldCurs = textEditSetHeater3.cursorPosition
                                    var curs = textEditSetHeater3.text.length - oldCurs
                                    if (wheel.angleDelta.y > 0) {
                                        if (curs > 2) {
                                            sliderHeater3.value += 1
                                        } else {
                                            sliderHeater3.value += (10**(curs+1))/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater3.value -= 1
                                        } else {
                                            sliderHeater3.value -= (10**(curs+1))/1000
                                        }
                                    }
                                    textEditSetHeater3.cursorPosition = textEditSetHeater3.text.length - curs
                                }
                            }
                        }
                        anchors.leftMargin: 40
                    }

                    Row {
                        id: rowGetHeater3
                        anchors.left: rowSetHeater3.left
                        Text {
                            id: textGetHeater3
                            text: "Get: " + gaugeHeater3.value.toFixed(2) + " V"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameHeater4
            width: 160
            height: parent.height

            Column {
                id: columnHeater4
                anchors.fill: parent

                Row {
                    id: row4
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater4
                        text: "Tunable Coupler 0"
                        font.pixelSize: 18
                    }
                }

                Row {
                    id: rowHeater4
                    height: columnHeater4.height - textHeaderHeater4.height - colSetGetHeater4.height - 2*columnHeater4.spacing
                    visible: pageCntrlPnl.height < 250 ? false : true

                    Gauge {
                        id: gaugeHeater4
                        height: parent.height
                        antialiasing: true
                        tickmarkStepSize: 1
                        minimumValue: 0
                        value: sliderHeater4.value
                        minorTickmarkCount: 1
                        maximumValue: 14
                        Behavior on value { NumberAnimation { duration: 100 } }
                    }

                    Slider {
                        id: sliderHeater4
                        height: parent.height
                        antialiasing: true
                        stepSize: 0.01
                        wheelEnabled: true
                        value: 0
                        orientation: Qt.Vertical
                        to: 14
                        onValueChanged: {
                            gaugeHeater4.value = backend.drvD(0, value.toFixed(2)).slice(2)
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetHeater4
                    width: parent.width
                    height: 41
                    Row {
                        id: rowSetHeater4
                        anchors.left: parent.left
                        Text {
                            id: textSetHeater4
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetHeater4
                            text: sliderHeater4.value.toFixed(2)
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 12;}
                            onAccepted: {
                                sliderHeater4.value = text
                            }

                            MouseArea {
                                id: mouseAreaPrecisionH4
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onPressed: function(mouse) { mouse.accepted = false }
                                onWheel: {
                                    var oldCurs = textEditSetHeater4.cursorPosition
                                    var curs = textEditSetHeater4.text.length - oldCurs
                                    if (wheel.angleDelta.y > 0) {
                                        if (curs > 2) {
                                            sliderHeater4.value += 1
                                        } else {
                                            sliderHeater4.value += (10**(curs+1))/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater4.value -= 1
                                        } else {
                                            sliderHeater4.value -= (10**(curs+1))/1000
                                        }
                                    }
                                    textEditSetHeater4.cursorPosition = textEditSetHeater4.text.length - curs
                                }
                            }
                        }
                        anchors.leftMargin: 40
                    }

                    Row {
                        id: rowGetHeater4
                        anchors.left: rowSetHeater4.left
                        Text {
                            id: textGetHeater4
                            text: "Get: " + gaugeHeater4.value.toFixed(2) + " V"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameTec
            width: 160
            height: parent.height

            Column {
                id: columnTec
                anchors.fill: parent

                Row {
                    id: row5
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20

                    Text {
                        id: textHeaderTec
                        text: "TEC "
                        font.pixelSize: 18
                    }

                    Button {
                        id: configTec
                        height: 22
                        text: "\u2699"
                        leftPadding: 0
                        antialiasing: true
                        rightPadding: 0
                        font.pointSize: 20
                        background: Rectangle {}
                        onClicked: popupPid.open()
                        visible: true
                    }
                }

                Row {
                    id: rowTec
                    height: columnTec.height - textHeaderTec.height - colSetGetTec.height - 2*columnTec.spacing
                    visible: pageCntrlPnl.height < 250 ? false : true

                    Gauge {
                        id: gaugeTec
                        height: parent.height
                        antialiasing: true
                        tickmarkStepSize: 1
                        minimumValue: 15
                        value: -1
                        minorTickmarkCount: 1
                        maximumValue: 30
                        Behavior on value { NumberAnimation { duration: 100 } }

                        Timer {
                            id: timerTemp
                            interval: 1000; repeat: true; running: switch3.checked
                            onTriggered: {
                                gaugeTec.value = backend.tecTemp().slice(2)
                            }
                        }
                    }

                    Slider {
                        id: sliderTec
                        height: parent.height
                        antialiasing: true
                        stepSize: 0.01
                        wheelEnabled: true
                        value: 21
                        orientation: Qt.Vertical
                        to: 30
                        from: 15
                        onValueChanged: {
                            backend.tecTemp(value.toFixed(2)).slice(2)
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetTec
                    width: parent.width
                    height: 41
                    Row {
                        id: rowSetTec
                        anchors.left: parent.left
                        Text {
                            id: textSetTec
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetTec
                            text: sliderTec.value.toFixed(2)
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 15; top: 30;}
                            onAccepted: {
                                sliderTec.value = text
                            }

                            MouseArea {
                                id: mouseAreaPrecisionTec
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onPressed: function(mouse) { mouse.accepted = false }
                                onWheel: {
                                    var oldCurs = textEditSetTec.cursorPosition
                                    var curs = textEditSetTec.text.length - oldCurs
                                    if (wheel.angleDelta.y > 0) {
                                        if (curs > 2) {
                                            sliderTec.value += 1
                                        } else {
                                            sliderTec.value += (10**(curs+1))/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderTec.value -= 1
                                        } else {
                                            sliderTec.value -= (10**(curs+1))/1000
                                        }
                                    }
                                    textEditSetTec.cursorPosition = textEditSetTec.text.length - curs
                                }
                            }
                        }
                        anchors.leftMargin: 40
                    }

                    Row {
                        id: rowGetTec
                        anchors.left: rowSetTec.left
                        Text {
                            id: textGetTec
                            text: "Get: " + gaugeTec.value.toFixed(2) + " °C"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameCurrent
            width: 160
            height: parent.height
            Column {
                id: columnCurrent
                anchors.fill: parent
                Text {
                    id: textCurrent
                    text: "Current"
                    font.pixelSize: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Row {
                    id: rowCurrent
                    height: columnCurrent.height - textCurrent.height - colSetGetCurrent.height - 2*columnCurrent.spacing
                    visible: pageCntrlPnl.height < 250 ? false : true

                    Gauge {
                        id: gaugeCurrent
                        height: parent.height
                        antialiasing: true
                        tickmarkStepSize: 50
                        minimumValue: 0
                        value: 0
                        minorTickmarkCount: 3
                        maximumValue: 250
                        Behavior on value { NumberAnimation { duration: 100 } }
                    }

                    Slider {
                        id: sliderCurrent
                        height: parent.height
                        antialiasing: true
                        value: 0
                        stepSize: 0.01
                        wheelEnabled: true
                        orientation: Qt.Vertical
                        to: 250
                        onValueChanged: {
                            gaugeCurrent.value = backend.lsrIlev(value.toFixed(2)).slice(2)
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetCurrent
                    width: parent.width
                    height: 41
                    Row {
                        id: rowSetCurrent
                        anchors.left: parent.left
                        Text {
                            id: textSetCurrent
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }


                        TextInput {
                            id: textEditSetCurrent
                            text: sliderCurrent.value.toFixed(2)
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 250;}
                            onAccepted: {
                                sliderCurrent.value = text
                            }

                            MouseArea {
                                id: mouseAreaPrecisionCur
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onPressed: function(mouse) { mouse.accepted = false }
                                onWheel: {
                                    var oldCurs = textEditSetCurrent.cursorPosition
                                    var curs = textEditSetCurrent.text.length - oldCurs
                                    if (wheel.angleDelta.y > 0) {
                                        if (curs > 2) {
                                            sliderCurrent.value += (10**(curs))/1000
                                        } else {
                                            sliderCurrent.value += (10**(curs+1))/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderCurrent.value -= (10**(curs))/1000
                                        } else {
                                            sliderCurrent.value -= (10**(curs+1))/1000
                                        }
                                    }
                                    textEditSetCurrent.cursorPosition = textEditSetCurrent.text.length - curs
                                }
                            }
                        }

                        anchors.leftMargin: 40
                    }

                    Row {
                        id: rowGetCurrent
                        anchors.left: rowSetCurrent.left

                        Text {
                            id: textGetCurrent
                            text: "Get: " + gaugeCurrent.value.toFixed(2) + " mA"
                            font.pixelSize: 18
                        }

                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameSw
            width: 244
            height: parent.height
            clip: true

            Column {
                id: columnSw
                anchors.fill: parent
                spacing: 15

                Image {
                    id: image
                    height: button.height *1.5
                    source: "chilas.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                }

                Row {
                    id: rowSwStat
                    visible: pageCntrlPnl.height < 250 ? false : true

                    StatusIndicator {
                        id: statusIndicator
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.bottom: parent.bottom
                        active: switchBoost.checked
                    }

                    Switch {
                        id: switchBoost
                        text: qsTr("Boost Cnvrtr")
                        anchors.verticalCenter: parent.verticalCenter
                        enabled: false
                        onToggled: {
                            backend.drvStat(checked+0)
                            button2.clicked()
                        }
                    }
                }


                Row {
                    id: rowSwStat1
                    visible: pageCntrlPnl.height < 250 ? false : true

                    StatusIndicator {
                        id: statusIndicator1
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.bottom: parent.bottom
                        active: switch2.checked
                    }

                    Switch {
                        id: switch2
                        text: qsTr("Current")
                        anchors.verticalCenter: parent.verticalCenter
                        enabled: false
                        onToggled: {
                            backend.lsrStat(checked+0)
                            button2.clicked()
                        }
                    }
                }


                Row {
                    id: rowSwStat2
                    StatusIndicator {
                        id: statusIndicator2
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.bottom: parent.bottom
                        active: switch3.checked
                    }

                    Switch {
                        id: switch3
                        text: qsTr("System")
                        anchors.verticalCenter: parent.verticalCenter
                        onToggled: {
                            pageCntrlPnl.enabled = false
                            busyIndicator.running = true
                            offOnTimer.start()
                        }

                        Timer {
                            id: offOnTimer
                            interval: 500; running: false; repeat: true;
                            property int cFunc: 0
                            onTriggered: {
                                if(switch3.checked) {

                                    if(cFunc == 0) {
                                        backend.systStat(switch3.checked+0)
                                        button2.clicked()
                                        cFunc++
                                    } else if(cFunc == 1) {
                                        switch2.toggle()
                                        switch2.toggled()
                                        cFunc++
                                    } else if(cFunc == 2) {
                                        switchBoost.toggle()
                                        switchBoost.toggled()
                                        offOnTimer.stop()
                                        busyIndicator.running = false
                                        pageCntrlPnl.enabled = true
                                    }
                                } else {
                                    if(cFunc == 2) {
                                        switchBoost.toggle()
                                        switchBoost.toggled()
                                        cFunc--
                                    } else if(cFunc == 1) {
                                        switch2.toggle()
                                        switch2.toggled()
                                        cFunc--
                                    } else if(cFunc == 0) {
                                        backend.systStat(switch3.checked+0)
                                        button2.clicked()
                                        offOnTimer.stop()
                                        busyIndicator.running = false
                                        pageCntrlPnl.enabled = true
                                    }
                                }
                            }
                        }
                    }
                }

                ComboBox {
                    id: comboBox
                    width: parent.width
                    visible: pageCntrlPnl.height < 250 ? false : true
                    model: ["Select COM"]
                    popup.onVisibleChanged: {
                        if(popup.visible) {
                            model = backend.listPorts()
                        }
                    }
                    onActivated: {
                        pageCntrlPnl.enabled = false
                        busyIndicator.running = true
                        rstWait.start()
                        backend.openPort(currentIndex)
                        backend.rst()

                    }

                    Timer {
                        id: rstWait
                        interval: 2000; running: false; repeat: false
                        onTriggered: {
                            pageCntrlPnl.idn = backend.idn()
                            busyIndicator.running = false
                            pageCntrlPnl.enabled = true
                        }
                    }
                }

                Button {
                    id: button1
                    width: parent.width
                    text: qsTr("System Reset")
                    enabled: false
                    visible: false
                    onClicked: {
                        backend.rst()
                        button2.clicked()
                    }
                }

                Button {
                    id: button2
                    width: parent.width
                    text: qsTr("Get Values")
                    enabled: false
                    visible: false
                    onClicked: {
                        sliderHeater1.value = backend.drvD(0).slice(2)
                        sliderHeater2.value = backend.drvD(3).slice(2)
                        sliderHeater3.value = backend.drvD(4).slice(2)
                        sliderCurrent.value = backend.lsrIlev().slice(2)
                        print(backend.systStat().slice(2))
                        print(backend.lsrStat().slice(2))
                        print(backend.drvStat().slice(2))
                    }
                }

                Button {
                    id: button
                    width: parent.width
                    visible: pageCntrlPnl.height < 250 ? false : true
                    text: qsTr("Load Settings")
                    enabled: true
                    onClicked: fileDialog.open()
                }

                FileDialog {
                    id: fileDialog
                    title: "Please choose a settings file"
                    folder: shortcuts.home
                    nameFilters: [ "Text files (*.txt *.csv)", "All files (*)" ]

                    property var specs: []
                    onAccepted: {
                        pageCntrlPnl.enabled = false
                        busyIndicator.running = true
                        specs = backend.getSettings(fileUrl)
                        preSet.cntr = fileDialog.specs[0].length-1

                        preSet.restart()
                    }
                    onRejected: {
                        close()
                    }
                }

                Button {
                    id: buttonSave
                    width: parent.width
                    visible: pageCntrlPnl.height < 250 ? false : true
                    text: qsTr("Save")
                    enabled: true
                    onClicked: {
                        backend.saveSettings([sliderHeater2.value,
                                                     sliderHeater3.value,
                                                     sliderHeater1.value,
                                                     sliderHeater4.value,
                                                     sliderTec.value,
                                                     sliderCurrent.value])
                        text = "Saved!"
                        saved.restart()
                    }
                    Timer {
                        id: saved
                        interval: 1000; running: false; repeat: false;
                        onTriggered: {
                            parent.text = "Save"
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: popupPid
        modal: true
        focus: true
        contentHeight: framePid.height
        contentWidth: framePid.width
        anchors.centerIn: Overlay.overlay
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        onAboutToShow: {
            textGetP.text = "Get P: " + backend.setP()
            textGetI.text = "Get I: " + backend.setI()
            textGetD.text = "Get D: " + backend.setD()
            textGetILim.text = "Get Max Current: " + backend.iMax()
        }

        ScrollView {
            anchors.fill: parent
            contentHeight: framePid.height
            contentWidth: framePid.width
            wheelEnabled: true

        Frame {
            id: framePid
            width: 230
            height: 400
            clip: true

            WheelEditInput {
                id: weiPid
            }

            Column {
                id: columnPid
                anchors.fill: parent
                spacing: 20

                Text {
                    id: textHeaderPid
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Config."
                    font.pixelSize: 18
                }

                Row {
                    id: rowSetP
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    Text {
                        id: textSetP
                        text: "Set P: "
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textEditSetP
                        text: "0"
                        font.pixelSize: 18
                        selectByMouse: true
                        validator: DoubleValidator{ locale: ""; bottom: 0; top: 10;}
                        onAccepted: {
                            textGetP.text = "Get P: " + backend.setP(text)
                            colorA.restart()
                        }

                        ColorAnimation on color { id: colorA; running: false; from: "#41cd52"; to: "#000000"; duration: 1500}
                    }
                }

                Row {
                    id: rowGetP
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    Text {
                        id: textGetP
                        text: "Get P: 0"
                        font.pixelSize: 18
                    }
                }

                Row {
                    id: rowSetI
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    Text {
                        id: textSetI
                        text: "Set I: "
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textEditSetI
                        text: "0"
                        font.pixelSize: 18
                        selectByMouse: true
                        validator: DoubleValidator{ locale: ""; bottom: 0; top: 10;}
                        onAccepted: {
                            textGetI.text = "Get I: " + backend.setI(text)
                            colorB.restart()
                        }

                        ColorAnimation on color { id: colorB; running: false; from: "#41cd52"; to: "#000000"; duration: 1500}
                    }
                }

                Row {
                    id: rowGetI
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    Text {
                        id: textGetI
                        text: "Get I: 0"
                        font.pixelSize: 18
                    }
                }

                Row {
                    id: rowSetD
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    Text {
                        id: textSetD
                        text: "Set D: "
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textEditSetD
                        text: "0"
                        font.pixelSize: 18
                        selectByMouse: true
                        validator: DoubleValidator{ locale: ""; bottom: 0; top: 10;}
                        onAccepted: {
                            textGetD.text = "Get D: " + backend.setD(text)
                            colorC.restart()
                        }

                        ColorAnimation on color { id: colorC; running: false; from: "#41cd52"; to: "#000000"; duration: 1500}
                    }
                }

                Row {
                    id: rowGetD
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    Text {
                        id: textGetD
                        text: "Get D: 0"
                        font.pixelSize: 18
                    }
                }

                Row {
                    id: rowSetILim
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    Text {
                        id: textSetILim
                        text: "Set Max Current: "
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textEditSetILim
                        text: "0"
                        font.pixelSize: 18
                        selectByMouse: true
                        validator: DoubleValidator{ locale: ""; bottom: 0; top: 10;}
                        onAccepted: {
                            textGetILim.text = "Get Max Current: " + backend.iMax(text)
                            colorD.restart()
                        }

                        ColorAnimation on color { id: colorD; running: false; from: "#41cd52"; to: "#000000"; duration: 1500}
                    }
                }

                Row {
                    id: rowGetILim
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    Text {
                        id: textGetILim
                        text: "Get Max Current: 0"
                        font.pixelSize: 18
                    }
                }
            }
        }
    } }

    BusyIndicator {
        id: busyIndicator
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        running: false
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Timer {
        id: preSet
        interval: 2000; running: false; repeat: true; triggeredOnStart: true;
        property int cntr: 3
        onTriggered: {
            sliderHeater2.value = fileDialog.specs[1][cntr]
            sliderHeater3.value = fileDialog.specs[2][cntr]
            sliderHeater1.value = fileDialog.specs[3][cntr]
            sliderHeater4.value = fileDialog.specs[0][cntr]
            sliderTec.value = fileDialog.specs[4][cntr]
            sliderCurrent.value = fileDialog.specs[5][cntr]
            cntr--

            if(cntr == 0) {
                preSet.stop()
                cntr = fileDialog.specs[0].length-1
                busyIndicator.running = false
                pageCntrlPnl.enabled = true
            }
        }
    }
}




/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
