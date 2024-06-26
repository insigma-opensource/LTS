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
    property string idn: "Not connected"
    property bool lutOn: false

    Row {
        id: rowCntrlPnl
        width: parent.width
        height: parent.height
        spacing: (width - 7*frameHeater1.width - frameCurrent.width - frameSw.width)/8

        Frame {
            id: frameHeater1
            width: 130
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
                        text: "Heater "
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textIHS1
                        text: "0"
                        font.pixelSize: 18
                        selectByMouse: true
                    }
                }

                Row {
                    id: rowHeater1
                    height: columnHeater1.height - textHeaderHeater1.height - colSetGetHeater1.height - switchAh.height - 3*columnHeater1.spacing
                    anchors.horizontalCenter: parent.horizontalCenter

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
                            if (switchAh.checked) {
                                timerAh.restart()
                            } else {
                                gaugeHeater1.value = backend.drvD(parseInt(textIHS1.text), value.toFixed(3)).slice(2)
                            }
                        }

                        Timer {
                            id: timerAh
                            interval: 100; running: false; repeat: true
                            property int t_coun: 0
                            onTriggered: {
                                gaugeHeater1.value = backend.drvD(parseInt(textIHS1.text), ((sliderHeater1.value**2+(3-t_coun)*10)**0.5).toFixed(3)).slice(2)
                                t_coun++
                                if(t_coun > 3) {
                                    stop()
                                    t_coun = 0
                                    interval = 100
                                } else if(t_coun > 2) {
                                    interval = 500
                                }
                            }
                        }
                    }
                }

                Switch {
                    id: switchAh
                    text: "Anti-Hyst."
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetHeater1
                    width: parent.width
                    height: 41

                    Row {
                        id: rowSetHeater1
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: textSetHeater1
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                            minimumPixelSize: 15
                        }

                        TextInput {
                            id: textEditSetHeater1
                            text: sliderHeater1.value.toFixed(3)
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                            cursorVisible: true
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; top: 14; bottom: 0;}
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
                                            sliderHeater1.value += (10**curs)/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater1.value -= 1
                                        } else {
                                            sliderHeater1.value -= (10**curs)/1000
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
                            text: "Get: " + gaugeHeater1.value.toFixed(3) + " V"
                            font.pixelSize: 18
                            minimumPixelSize: 15
                        }
                    }
                }
            }
        }

        Frame {
            id: frameHeater2
            width: 130
            height: parent.height

            Column {
                id: columnHeater2
                anchors.fill: parent

                Row {
                    id: row2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater2
                        text: "Heater "
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textIHS2
                        text: "1"
                        font.pixelSize: 18
                        selectByMouse: true
                    }

                }

                Row {
                    id: rowHeater2
                    height: columnHeater2.height - textHeaderHeater2.height - colSetGetHeater2.height - 2*columnHeater2.spacing
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
                            gaugeHeater2.value = backend.drvD(parseInt(textIHS2.text), value.toFixed(3)).slice(2)
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
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            id: textSetHeater2
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetHeater2
                            text: sliderHeater2.value.toFixed(3)
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 14;}
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
                                            sliderHeater2.value += (10**curs)/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater2.value -= 1
                                        } else {
                                            sliderHeater2.value -= (10**curs)/1000
                                        }
                                    }
                                    textEditSetHeater2.cursorPosition = textEditSetHeater2.text.length - curs
                                }
                            }
                        }
                    }

                    Row {
                        id: rowGetHeater2
                        anchors.left: rowSetHeater2.left
                        Text {
                            id: textGetHeater2
                            text: "Get: " + gaugeHeater2.value.toFixed(3) + " V"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameHeater3
            width: 130
            height: parent.height

            Column {
                id: columnHeater3
                anchors.fill: parent

                Row {
                    id: row3
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater3
                        text: "Heater "
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textIHS3
                        text: "2"
                        font.pixelSize: 18
                        selectByMouse: true
                    }

                }

                Row {
                    id: rowHeater3
                    height: columnHeater3.height - textHeaderHeater3.height - colSetGetHeater3.height - 2*columnHeater3.spacing
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
                            gaugeHeater3.value = backend.drvD(parseInt(textIHS3.text), value.toFixed(3)).slice(2)
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
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            id: textSetHeater3
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetHeater3
                            text: sliderHeater3.value.toFixed(3)
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 14;}
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
                                            sliderHeater3.value += (10**curs)/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater3.value -= 1
                                        } else {
                                            sliderHeater3.value -= (10**curs)/1000
                                        }
                                    }
                                    textEditSetHeater3.cursorPosition = textEditSetHeater3.text.length - curs
                                }
                            }
                        }
                    }

                    Row {
                        id: rowGetHeater3
                        anchors.left: rowSetHeater3.left
                        Text {
                            id: textGetHeater3
                            text: "Get: " + gaugeHeater3.value.toFixed(3) + " V"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameHeater4
            width: 130
            height: parent.height

            Column {
                id: columnHeater4
                anchors.fill: parent
                spacing: 15

                Row {
                    id: row4
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater4
                        text: "Heater "
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textIHS4
                        text: "3"
                        font.pixelSize: 18
                        selectByMouse: true
                    }
                }

                Row {
                    id: rowHeater4
                    height: columnHeater1.height - textHeaderHeater1.height - colSetGetHeater1.height - switchAh.height - 3*columnHeater1.spacing
                    anchors.horizontalCenter: parent.horizontalCenter

                    Gauge {
                        id: gaugeHeater4
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
                        id: sliderHeater4
                        height: parent.height
                        antialiasing: true
                        wheelEnabled: true
                        stepSize: 0.01
                        to: 14
                        orientation: Qt.Vertical
                        value: 0

                        onValueChanged: {
                            if (switchAh2.checked) {
                                timerAh2.restart()
                            }
                            gaugeHeater4.value = backend.drvD(parseInt(textIHS4.text), value.toFixed(3)).slice(2)
                        }

                        Timer {
                            id: timerAh2
                            interval: 100; running: false; repeat: true
                            property int t_coun: 0
                            onTriggered: {
                                gaugeHeater4.value = backend.drvD(parseInt(textIHS4.text), ((sliderHeater4.value**2+(3-t_coun)*10)**0.5).toFixed(3)).slice(2)
                                t_coun++
                                if(t_coun > 3) {
                                    stop()
                                    t_coun = 0
                                    interval = 100
                                } else if(t_coun > 2) {
                                    interval = 500
                                }
                            }
                        }
                    }
                }

                Switch {
                    id: switchAh2
                    text: "Anti-Hyst."
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetHeater4
                    width: parent.width
                    height: 41

                    Row {
                        id: rowSetHeater4
                        anchors.horizontalCenter: parent.horizontalCenter

                        Text {
                            id: textSetHeater4
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                            minimumPixelSize: 15
                        }

                        TextInput {
                            id: textEditSetHeater4
                            text: sliderHeater4.value.toFixed(3)
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                            cursorVisible: true
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; top: 14; bottom: 0;}
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
                                            sliderHeater4.value += (10**curs)/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater4.value -= 1
                                        } else {
                                            sliderHeater4.value -= (10**curs)/1000
                                        }
                                    }
                                    textEditSetHeater4.cursorPosition = textEditSetHeater4.text.length - curs
                                }
                            }
                        }
                    }

                    Row {
                        id: rowGetHeater4
                        anchors.left: rowSetHeater4.left

                        Text {
                            id: textGetHeater4
                            text: "Get: " + gaugeHeater4.value.toFixed(3) + " V"
                            font.pixelSize: 18
                            minimumPixelSize: 15
                        }
                    }
                }


            }
        }

        Frame {
            id: frameHeater5
            width: 130
            height: parent.height

            Column {
                id: columnHeater5
                anchors.fill: parent

                Row {
                    id: row5
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater5
                        text: "Heater "
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textIHS5
                        text: "4"
                        font.pixelSize: 18
                        selectByMouse: true
                    }

                }

                Row {
                    id: rowHeater5
                    height: columnHeater5.height - textHeaderHeater5.height - colSetGetHeater5.height - 2*columnHeater5.spacing
                    Gauge {
                        id: gaugeHeater5
                        height: parent.height
                        antialiasing: true
                        tickmarkStepSize: 1
                        minimumValue: 0
                        value: sliderHeater5.value
                        minorTickmarkCount: 1
                        maximumValue: 14
                        Behavior on value { NumberAnimation { duration: 100 } }
                    }

                    Slider {
                        id: sliderHeater5
                        height: parent.height
                        antialiasing: true
                        stepSize: 0.01
                        wheelEnabled: true
                        value: 0
                        orientation: Qt.Vertical
                        to: 14
                        onValueChanged: {
                            gaugeHeater5.value = backend.drvD(parseInt(textIHS5.text), value.toFixed(3)).slice(2)
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetHeater5
                    width: parent.width
                    height: 41
                    Row {
                        id: rowSetHeater5
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            id: textSetHeater5
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetHeater5
                            text: sliderHeater5.value.toFixed(3)
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 14;}
                            onAccepted: {
                                sliderHeater5.value = text
                            }

                            MouseArea {
                                id: mouseAreaPrecisionH5
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onPressed: function(mouse) { mouse.accepted = false }
                                onWheel: {
                                    var oldCurs = textEditSetHeater5.cursorPosition
                                    var curs = textEditSetHeater5.text.length - oldCurs
                                    if (wheel.angleDelta.y > 0) {
                                        if (curs > 2) {
                                            sliderHeater5.value += 1
                                        } else {
                                            sliderHeater5.value += (10**curs)/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater5.value -= 1
                                        } else {
                                            sliderHeater5.value -= (10**curs)/1000
                                        }
                                    }
                                    textEditSetHeater5.cursorPosition = textEditSetHeater5.text.length - curs
                                }
                            }
                        }
                    }

                    Row {
                        id: rowGetHeater5
                        anchors.left: rowSetHeater5.left
                        Text {
                            id: textGetHeater5
                            text: "Get: " + gaugeHeater5.value.toFixed(3) + " V"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameHeater6
            width: 130
            height: parent.height

            Column {
                id: columnHeater6
                anchors.fill: parent

                Row {
                    id: row6
                    anchors.horizontalCenter: parent.horizontalCenter

                    Text {
                        id: textHeaderHeater6
                        text: "Heater "
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: textIHS6
                        text: "5"
                        font.pixelSize: 18
                        selectByMouse: true
                    }

                }

                Row {
                    id: rowHeater6
                    height: columnHeater6.height - textHeaderHeater6.height - colSetGetHeater6.height - 2*columnHeater6.spacing
                    Gauge {
                        id: gaugeHeater6
                        height: parent.height
                        antialiasing: true
                        tickmarkStepSize: 1
                        minimumValue: 0
                        value: sliderHeater6.value
                        minorTickmarkCount: 1
                        maximumValue: 14
                        Behavior on value { NumberAnimation { duration: 100 } }
                    }

                    Slider {
                        id: sliderHeater6
                        height: parent.height
                        antialiasing: true
                        stepSize: 0.01
                        wheelEnabled: true
                        value: 0
                        orientation: Qt.Vertical
                        to: 14
                        onValueChanged: {
                            gaugeHeater6.value = backend.drvD(parseInt(textIHS6.text), value.toFixed(3)).slice(2)
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Column {
                    id: colSetGetHeater6
                    width: parent.width
                    height: 41
                    Row {
                        id: rowSetHeater6
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            id: textSetHeater6
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetHeater6
                            text: sliderHeater6.value.toFixed(3)
                            font.pixelSize: 18
                            selectByMouse: true
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 14;}
                            onAccepted: {
                                sliderHeater6.value = text
                            }

                            MouseArea {
                                id: mouseAreaPrecisionH6
                                anchors.fill: parent
                                cursorShape: Qt.IBeamCursor
                                onPressed: function(mouse) { mouse.accepted = false }
                                onWheel: {
                                    var oldCurs = textEditSetHeater6.cursorPosition
                                    var curs = textEditSetHeater6.text.length - oldCurs
                                    if (wheel.angleDelta.y > 0) {
                                        if (curs > 2) {
                                            sliderHeater6.value += 1
                                        } else {
                                            sliderHeater6.value += (10**curs)/1000
                                        }

                                    } else {
                                        if (curs > 2) {
                                            sliderHeater6.value -= 1
                                        } else {
                                            sliderHeater6.value -= (10**curs)/1000
                                        }
                                    }
                                    textEditSetHeater6.cursorPosition = textEditSetHeater6.text.length - curs
                                }
                            }
                        }
                    }

                    Row {
                        id: rowGetHeater6
                        anchors.left: rowSetHeater6.left
                        Text {
                            id: textGetHeater6
                            text: "Get: " + gaugeHeater6.value.toFixed(3) + " V"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameWl
            width: 130
            height: parent.height

            enabled: true
            Column {
                id: columnWl
                anchors.fill: parent
                Text {
                    id: textHeaderWl
                    text: "Wavelength"
                    font.pixelSize: 18
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Row {
                    id: rowWl
                    height: columnWl.height - textHeaderWl.height - colSetGetWl.height - 2*columnWl.spacing
                    anchors.horizontalCenter: parent.horizontalCenter

                    Gauge {
                        id: gaugeWl
                        height: parent.height
                        antialiasing: true
                        minorTickmarkCount: 3
                        value: 0
                        maximumValue: 1600
                        minimumValue: 1500
                        tickmarkStepSize: (maximumValue - minimumValue)/10
                        Behavior on value { NumberAnimation { duration: 100 } }
                        style: GaugeStyle {
                            tickmarkLabel: Text {
                                text: control.formatValue(styleData.value.toFixed(0))
                                font: control.font
                                color: "#c8c8c8"
                                antialiasing: true
                            }
                        }
                    }

                    Slider {
                        id: sliderWl
                        height: parent.height
                        enabled: false
                        antialiasing: true
                        wheelEnabled: true
                        orientation: Qt.Vertical
                        from: 0
                        to: 10
                        stepSize: 1
                        value: 0

                        property var config: []

                        onValueChanged: {
                            config = backend.setConfig(value)

                            textEditSetWl.text = config[4].toFixed(3)

                            sliderHeater3.value === config[2] ? sliderHeater3.valueChanged() : sliderHeater3.value = config[2]
                            sliderHeater2.value === config[1] ? sliderHeater2.valueChanged() : sliderHeater2.value = config[1]
                            sliderHeater4.value === config[3] ? sliderHeater4.valueChanged() : sliderHeater4.value = config[3]
                            sliderHeater1.value === config[0] ? sliderHeater1.valueChanged() : sliderHeater1.value = config[0]
                        }
                    }
                }

                Column {
                    id: colSetGetWl
                    width: parent.width
                    height: 41
                    Row {
                        id: rowSetWl
                        anchors.horizontalCenter: parent.horizontalCenter
                        Text {
                            id: textSetWl
                            text: "Set: "
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 18
                        }

                        TextInput {
                            id: textEditSetWl
                            text: "0.000"
                            font.pixelSize: 18
                            onAccepted: {
                                sliderWl.value = backend.findWl(text)
                            }
                            validator: DoubleValidator{ locale: ""; bottom: 1500; top: 1600;}
                            selectByMouse: true
                        }
                    }

                    Row {
                        id: rowGetWl
                        anchors.left: rowSetWl.left
                        Text {
                            id: textGetWl
                            text: "Get: -- nm"
                            font.pixelSize: 18
                        }
                    }
                }
                spacing: 15
            }
        }

        Frame {
            id: frameCurrent
            width: 145
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
                    Gauge {
                        id: gaugeCurrent
                        height: parent.height
                        antialiasing: true
                        tickmarkStepSize: 50
                        minimumValue: 0
                        value: sliderCurrent.value
                        minorTickmarkCount: 3
                        maximumValue: sliderCurrent.to
                        Behavior on value { NumberAnimation { duration: 100 } }
                    }

                    Slider {
                        id: sliderCurrent
                        height: parent.height
                        antialiasing: true
                        value: 0
                        stepSize: 10
                        wheelEnabled: true
                        orientation: Qt.Vertical
                        to: 300
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
                        anchors.horizontalCenter: parent.horizontalCenter
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
                            validator: DoubleValidator{ locale: ""; bottom: 0; top: 300;}
                            onAccepted: {
                                sliderCurrent.value = text
                            }
                        }
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
            width: 210
            height: parent.height

            Column {
                id: columnSw
                anchors.fill: parent
                spacing: 5

                Image {
                    id: image
                    height: button.height *1.5
                    source: "chilas.png"
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                }

                Row {
                    id: rowSwStat

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
                        onToggled: {
                            backend.drvStat(checked+0)
                            button2.clicked()
                        }
                    }
                }


                Row {
                    id: rowSwStat1
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
                            backend.systStat(checked+0)
                            button2.clicked()
                        }
                    }
                }

                ComboBox {
                    id: comboBox
                    width: parent.width
                    model: ["Select COM"]
                    popup.onVisibleChanged: {
                        if(popup.visible) {
                            model = backend.listPorts()
                        }
                    }
                    onActivated: {
                        backend.openPort(currentIndex)
                        backend.rst()
                        busyIndicator.running = true
                        rstWait.start()

                    }

                    Timer {
                        id: rstWait
                        interval: 2000; running: false; repeat: false
                        onTriggered: {
                            busyIndicator.running = false
                            pageCntrlPnl.idn = backend.idn()
                        }
                    }
                }

                Button {
                    id: button1
                    width: parent.width
                    text: qsTr("System Reset")
                    enabled: false
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
                        specs = backend.getSettings(fileUrl)

                        sliderWl.to = specs[0]
                        gaugeWl.minimumValue = Math.min(specs[1].toFixed(0), specs[2].toFixed(0))
                        gaugeWl.maximumValue = Math.max(specs[1].toFixed(0), specs[2].toFixed(0))

                        sliderWl.enabled = true
                        lutOn = true
                    }
                    onRejected: {
                        close()
                    }
                }
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.verticalCenter: parent.verticalCenter
        antialiasing: true
        running: false
        anchors.horizontalCenter: parent.horizontalCenter
    }

    function setWl(wl) {
        sliderWl.value = backend.findWl(wl)
    }
}




/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
