import QtQuick 2.0

MouseArea {
    id: mouseArea
    anchors.fill: parent
    onPressed: function(mouse) { mouse.accepted = false }
    onWheel: {

        let focus = activeFocusItem

        if (focus instanceof TextInput) {

            let dotLoc = focus.text.length - focus.text.split('.')[0].length - 1
            let curs = focus.text.length - focus.cursorPosition
            let del = dotLoc - curs

            if (wheel.angleDelta.y > 0) {
                if (dotLoc > curs) {
                    focus.text = (parseFloat(focus.text) + 10**(curs-dotLoc)).toFixed(dotLoc === -1 ? 0:dotLoc)
                } else if (dotLoc < curs) {
                    focus.text = (parseFloat(focus.text) + 10**(curs-dotLoc-1)).toFixed(dotLoc === -1 ? 0:dotLoc)
                } else {
                    focus.text = (parseFloat(focus.text) + 10**(curs-dotLoc)).toFixed(dotLoc === -1 ? 0:dotLoc)
                }
            } else {
                if (dotLoc > curs) {
                    focus.text = (parseFloat(focus.text) - 10**(curs-dotLoc)).toFixed(dotLoc === -1 ? 0:dotLoc)
                } else if (dotLoc < curs) {
                    focus.text = (parseFloat(focus.text) - 10**(curs-dotLoc-1)).toFixed(dotLoc === -1 ? 0:dotLoc)
                } else {
                    focus.text = (parseFloat(focus.text) + 10**(curs-dotLoc)).toFixed(dotLoc === -1 ? 0:dotLoc)
                }
            }
            dotLoc = focus.text.length - focus.text.split('.')[0].length - 1
            focus.cursorPosition = focus.text.length - dotLoc + del
        }
    }
}

// Old Version

//MouseArea {
//    id: mouseArea
//    anchors.fill: parent
//    cursorShape: Qt.IBeamCursor
//    onPressed: function(mouse) { mouse.accepted = false }
//    onWheel: {

//        let dotLoc = parent.text.length - parent.text.split('.')[0].length - 1
//        let curs = parent.text.length - parent.cursorPosition
//        let del = dotLoc - curs

//        if (wheel.angleDelta.y > 0) {
//            if (dotLoc > curs) {
//                parent.text = parseFloat(parent.text) + 10**(curs-dotLoc)
//            } else if (dotLoc < curs) {
//                parent.text = parseFloat(parent.text) + 10**(curs-dotLoc-1)
//            } else {
//                parent.text = parseFloat(parent.text) + 10**(curs-dotLoc)
//            }
//        } else {
//            if (dotLoc > curs) {
//                parent.text = parseFloat(parent.text) - 10**(curs-dotLoc)
//            } else if (dotLoc < curs) {
//                parent.text = parseFloat(parent.text) - 10**(curs-dotLoc-1)
//            } else {
//                parent.text = parseFloat(parent.text) + 10**(curs-dotLoc)
//            }
//        }
//        dotLoc = parent.text.length - parent.text.split('.')[0].length - 1
//        parent.cursorPosition = parent.text.length - dotLoc + del
//    }
//}
