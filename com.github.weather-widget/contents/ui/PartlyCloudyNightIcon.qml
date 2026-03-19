import QtQuick

Item {
    id: root

    // Moon (background, top-right)
    Item {
        width:  root.width  * 0.50
        height: root.height * 0.50
        x: root.width  * 0.42
        y: root.height * 0.04

        Rectangle {
            width: parent.width * 0.75; height: parent.height * 0.75
            radius: width / 2; color: "#DDD8B0"; anchors.centerIn: parent
            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 1.05; duration: 2500; easing.type: Easing.InOutSine }
                NumberAnimation { from: 1.05; to: 1.0; duration: 2500; easing.type: Easing.InOutSine }
            }
            Rectangle { // crescent shadow
                width: parent.width * 0.78; height: parent.height * 0.78
                radius: width / 2; color: "#1A2A3A"
                x: -parent.width * 0.18; anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // Drifting cloud (foreground)
    Item {
        id: cloudGroup
        width:  root.width  * 0.82
        height: root.height * 0.55
        y: root.height * 0.42

        SequentialAnimation on x {
            loops: Animation.Infinite
            NumberAnimation { from: root.width*0.0; to: root.width*0.04; duration: 3500; easing.type: Easing.InOutSine }
            NumberAnimation { from: root.width*0.04; to: root.width*0.0; duration: 3500; easing.type: Easing.InOutSine }
        }

        Rectangle {
            width: parent.width * 0.85; height: parent.height * 0.46
            radius: height / 2; color: "#707880"
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            width: parent.width * 0.40; height: parent.width * 0.40
            radius: width / 2; color: "#707880"
            x: parent.width * 0.10; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.30
        }
        Rectangle {
            width: parent.width * 0.48; height: parent.width * 0.48
            radius: width / 2; color: "#787F88"
            x: parent.width * 0.35; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.26
        }
    }
}
