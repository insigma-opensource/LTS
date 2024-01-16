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
        source: "chilas.png"
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
