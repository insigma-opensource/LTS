import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Extras 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

Pane {
    id: serialPage
    width: 640
    height: 500

    Component.onCompleted: {
        backend.pushExtras(extras)
    }

    property var extras: [serialRead]

    Frame {
        id: serialPageFrame
        anchors.fill: parent
        
        Column {
            id: mainColumn
            spacing: 10

            Text {
                id: serialInputLabel
                height: 20
                text: "Serial Input"
                font.pointSize: 12
                font.bold : true
                minimumPixelSize: 15
            }

            Row {
                id: serialTextRow
                height: 40
                spacing: 10

                TextField {
                    id: serialInput
                    width: (serialPageFrame.width/8)*3
                    placeholderText: "Enter Serial Input Here"
                    onTextChanged: console.log("Text changed to:", text)
                }

                Button {
                    id: serialInputSent
                    text: "SEND"
                    width: (serialPageFrame.width/8)
                    onClicked: {
                        console.log(serialInput.text)
                        backend.write(serialInput.text)
                        backend.read2Terminal()
                        flickableTerminal.contentY = flickableTerminal.contentHeight - flickableTerminal.height
                    }
                }
            }

            Rectangle {
                id: serialInputReadRec
                width: serialPageFrame.width/2
                height: (serialPageFrame.height/8)*5
                border.color: "grey"
                border.width: 1
                radius: 3
                color: "#F2F2F2"

                ScrollView {
                    id: serialInputReadScroll
                    anchors.fill: serialInputReadRec
                    anchors.margins: 10
                    clip: true
                    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                    Flickable {
                        id: flickableTerminal
                        contentWidth: serialRead.width
                        contentHeight: serialRead.height
                        width: parent.width
                        height: parent.height
                    
                        Text {
                            id: serialRead
                            wrapMode: Text.WordWrap
                            text: " "
                            font.pointSize: 10
                        }
                    }
                }
            }
        }
    }
}
