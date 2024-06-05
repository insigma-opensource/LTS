import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Extras 1.4

Window {
    id: window
    width: 570
    minimumWidth: 570
    height: 500
    minimumHeight: 500
    title: "CF3-v2.0-INT"
    // @disable-check M16
    onClosing: {
        backend.systStat(0)
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
    }

    SwipeView {
        id: stackView
        anchors.top: tabBar.bottom
        anchors.bottom: pageIndicator.top
        currentIndex: tabBar.currentIndex
        anchors.left: parent.left
        anchors.right: parent.right

        PageCntrlPnl {
            id: pageCntrlPnl
            width: parent.width
            height: parent.height
        }
    }

    PageIndicator {
        id: pageIndicator
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        count: stackView.count
        currentIndex: stackView.currentIndex
        visible: false
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
