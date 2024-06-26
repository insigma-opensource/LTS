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

Window {
    color: "transparent"
    title: "LTS"
    modality: Qt.ApplicationModal
    flags: Qt.SplashScreen

    property int timeoutInterval: 500
    signal timeout

    x: (Screen.width - splashImage.width) / 2
    y: (Screen.height - splashImage.height) / 2

    width: splashImage.width
    height: splashImage.height

    Image {
        id: splashImage
        source: "insigma.png"
        sourceSize.width: 500
    }

    Timer {
        interval: splash.timeoutInterval; running: true; repeat: false
        onTriggered: {
            splash.visible = false
            splash.timeout()
        }
    }

    Component.onCompleted: visible = true
}
