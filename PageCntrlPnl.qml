import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Extras 1.4
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

Pane {
    id: pageCntrlPnl
    width: 540
    height: 500
    property string idn: "Not connected"
    property bool lutOn: false

    Frame {
        id: frameSw
        width: parent.width
        height: parent.height

        Column {
            id: columnSw
            width: parent.width
            anchors.bottom: indicatorRow.top
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15

            Image {
                id: image
                height: button1.height *1.5
                anchors.horizontalCenter: parent.horizontalCenter
                source: "chilas.png"
                fillMode: Image.PreserveAspectFit
            }

            ComboBox {
                id: comboBox
                width: (parent.width/9)*6
                anchors.horizontalCenter: parent.horizontalCenter
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

                    buttonStart.visible     = true
                    buttonStart.enabled     = true
                    button1.visible         = true
                    button2.visible         = true
                    laserConnectionStatusText.visible = true
                    comboBox.visible = false

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

            Text {
                id: laserConnectionStatusText
                width: (parent.width/9)*6
                height: (buttonStart.height/9)*6
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Laser connected")
                font.bold: false
                font.pixelSize:32
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: false
            }

            Button {
                id: buttonStart
                width: (parent.width/9)*6
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Start laser")
                enabled: false
                visible: false
                checked: false
                onClicked: {
                    busyIndicator.running = true

                    if (!(parseInt(backend.systStat().slice(2)))) {
                        startWait.start()
                        backend.call_configureLaser()
                        backend.call_hysterises()
                        
                        backend.call_configFeedback()

                    }else{
                        backend.fbStat(0)
                        if (parseInt(backend.fbStat().slice(2))) {
                            feedbackIndicator.color = "green" 
                        }else { 
                            feedbackIndicator.color = "red"
                        }
                        backend.systStat(0) 

                        if (parseInt(backend.systStat().slice(2))) {
                            statusIndicator1.color = "green"
                            buttonStart.text = "Stop laser"
                            button1.enabled = true
                            button2.enabled = true
                        } else {
                            statusIndicator1.color = "red"
                            buttonStart.text = "Start laser"
                            button1.enabled = false
                            button2.enabled = false
                        }
                        busyIndicator.running = false
                    }
                }

                Timer {
                    id: startWait
                    interval: 5000; running: false; repeat: false
                    onTriggered: {
                        if (parseInt(backend.systStat().slice(2))) {
                            statusIndicator1.color = "green"
                            buttonStart.text = "Stop laser"
                            button1.enabled = true
                            button2.enabled = true
                        } else {
                            statusIndicator1.color = "red"
                            buttonStart.text = "Start laser"
                            button1.enabled = false
                            button2.enabled = false
                        }
                        pageCntrlPnl.idn = backend.idn()
                        busyIndicator.running = false
                    }
                }
            }

            Button {
                id: button1
                width: (parent.width/9)*6
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Reset laser")
                enabled: false
                visible: false
                checked: false
                onClicked: {
                    buttonStart.text = "Start laser"
                    buttonStart.enabled = false
                    button1.enabled     = false
                    button2.enabled     = false

                    busyIndicator.running = true
                    restartWait.start()

                    backend.call_configureLaser()
                    backend.call_hysterises()

                    backend.call_configFeedback()

                    if (parseInt(backend.fbStat().slice(2))) {
                        feedbackIndicator.color = "green"
                    }else { 
                        feedbackIndicator.color = "red"
                    }
                }

                Timer {
                    id: restartWait
                    interval: 5000; running: false; repeat: false
                    onTriggered: {
                        if (parseInt(backend.systStat().slice(2))) {
                            statusIndicator1.color = "green"
                            buttonStart.text = "Stop laser"
                            buttonStart.enabled = true
                            button1.enabled     = true
                            button2.enabled     = true
                        } else {
                            statusIndicator1.color = "red"
                            buttonStart.enabled = false
                            button1.enabled     = false
                            button2.enabled     = false
                        }
                        busyIndicator.running = false
                    }
                }
            }

            Button {
                id: button2
                width: (parent.width/9)*6
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Enable feedback loop")
                enabled: false
                visible: false
                checked: false
                onClicked: {
                    busyIndicator.running = true
                    feedbackWait.start()

                    if (!(parseInt(backend.fbStat().slice(2)))) {
                        backend.fbStat(1)
                    } else {
                        backend.fbStat(0)
                    }
                }
                Timer {
                    id: feedbackWait
                    interval: 1000; running: false; repeat: false

                    onTriggered: {
                        if (parseInt(backend.fbStat().slice(2))) {
                            feedbackIndicator.color = "green"
                            button2.text = "Disable feedback loop"
                        } else {
                            feedbackIndicator.color = "red"
                            button2.text = "Enable feedback loop" 
                        }
                        busyIndicator.running = false
                    }
                }
            }
        }

        Row{
            id:indicatorRow
            spacing: 35
            anchors.bottom: parent.bottom

            Column{
                id:statusIndicatorColumn
                spacing: 5
                                    
                    Text {
                        id: statusIndicatorText
                        text: qsTr("Status:")
                    }

                    StatusIndicator {
                        id: statusIndicator1
                        active: true
                        color: "red"
                    }
            }

            Column{
                id:feedbackIndicatorColumn
                spacing: 5
                                    
                    Text {
                        id: feedbackIndicatorText
                        text: qsTr("Feedback:")
                    }

                    StatusIndicator {
                        id: feedbackIndicator
                        active: true
                        color: "red"
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
    }
}





/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
