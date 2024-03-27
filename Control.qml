import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Extras 1.4

Window {
    id: window
    width: 1300
    minimumWidth: 1300
    height: 480
    minimumHeight: 480
    title: "CT3-2022-V1.11H6"
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
            text: "Control Panel"
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
            onLutOnChanged: lutOn ? pageScan.lutOn = true:pageScan.lutOn = false
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
        id: textIdn
        text: pageCntrlPnl.idn
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        font.pixelSize: 15
        anchors.bottomMargin: 5
        anchors.rightMargin: 15
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
