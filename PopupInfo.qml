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

Popup {
    id: popupInfo
    width: parent.width/2
    height: parent.height/2
    anchors.centerIn: parent
    modal: true
    focus: true

    ScrollView {
        anchors.fill: parent
        wheelEnabled: true
        clip: true

        Column {
            id: columnInfo
            width: popupInfo.width
            height: popupInfo.height
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Text {
                text: "Laser Tunning Software (LTS)"
                font.bold: true
                width: parent.width
            }

            Text {
                text: "LTS is an open-source application that helps users control laser via serial commands."
                wrapMode: Text.Wrap
                width: parent.width
            }

            Text {
                text: "License Information:"
                font.bold: true
                width: parent.width
            }

            TextArea {
                text: "This application is licensed under the GNU General Public License v3.0 (GPLv3). You are free to use, modify, and distribute this software under the terms of this license.\n\nFor the full text of the license, please visit the GNU GPLv3 website: https://www.gnu.org/licenses/gpl-3.0.html."
                readOnly: true
                wrapMode: Text.Wrap
                width: parent.width
            }

            Text {
                text: "Source Code Availability:"
                font.bold: true
                width: parent.width
            }

            Text {
                text: "The source code for this application is available on GitHub: https://github.com/insigma-opensource/LTS"
                wrapMode: Text.Wrap
                width: parent.width
            }
        }
    }
}
