import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Extras 1.4

Window {
    id: window
    width: 1300
    minimumWidth: 1300
    height: 500
    minimumHeight: 220
    title: "CF3-2022-V1.8"
    // @disable-check M16
    onClosing: {
        backend.rst()
        backend.close()
    }
    Component.onCompleted: {
        x = (Screen.width - width) / 2
        y = (Screen.height - height) / 2
    }

    TabBar {
        id: tabBar
        width: parent.width
        font.pointSize: 15
        spacing: 0
        currentIndex: stackView.currentIndex

        TabButton {
            id: cntrlPnl
            text: "Chilas Laser Control Panel"
        }
    }

    SwipeView {
        id: stackView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: tabBar.bottom
        anchors.bottom: pageIndicator.top
        currentIndex: tabBar.currentIndex

        PageCntrlPnl {
            id: pageCntrlPnl
        }
    }

    PageIndicator {
        id: pageIndicator
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        count: stackView.count
        currentIndex: stackView.currentIndex
    }

    Text {
        id: text1
        text: pageCntrlPnl.idn
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        font.pixelSize: 15
        anchors.bottomMargin: 5
        anchors.rightMargin: 10
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
