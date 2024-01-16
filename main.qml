import QtQuick 2.15

QtObject {
    id: root
    property var control: Control {
        visible: false
    }

    property var splash: Splash {
        onTimeout: {
            root.control.visible = true
        }
    }
}
