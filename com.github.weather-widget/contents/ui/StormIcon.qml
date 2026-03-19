import QtQuick

Item {
    id: root

    // Dark cloud
    Item {
        width:  root.width  * 0.88
        height: root.height * 0.46
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * 0.04

        Rectangle {
            width: parent.width * 0.88; height: parent.height * 0.46
            radius: height / 2; color: "#485868"
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            width: parent.width * 0.38; height: parent.width * 0.38
            radius: width / 2; color: "#485868"
            x: parent.width * 0.08; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.28
        }
        Rectangle {
            width: parent.width * 0.48; height: parent.width * 0.48
            radius: width / 2; color: "#506070"
            x: parent.width * 0.38; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.24
        }
    }

    // Lightning bolt (two rectangles forming a zigzag)
    Item {
        id: bolt
        x: root.width * 0.42
        y: root.height * 0.44
        width:  root.width  * 0.18
        height: root.height * 0.34

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { from: 1.0; to: 1.0; duration: 1800 }
            NumberAnimation { from: 1.0; to: 0.0; duration: 60 }
            NumberAnimation { from: 0.0; to: 1.0; duration: 60 }
            NumberAnimation { from: 1.0; to: 0.0; duration: 60 }
            NumberAnimation { from: 0.0; to: 1.0; duration: 100 }
            NumberAnimation { from: 1.0; to: 0.0; duration: 60 }
            NumberAnimation { from: 0.0; to: 1.0; duration: 60 }
        }

        Rectangle {
            width: parent.width * 0.35; height: parent.height * 0.55
            color: "#FFE040"; radius: 2
            x: parent.width * 0.35; y: 0
            rotation: 20; transformOrigin: Item.Bottom
        }
        Rectangle {
            width: parent.width * 0.35; height: parent.height * 0.55
            color: "#FFE040"; radius: 2
            x: parent.width * 0.10; y: parent.height * 0.44
            rotation: 20; transformOrigin: Item.Top
        }
    }

    // Rain drops
    Repeater {
        model: [
            { px: 0.12, delay: 0 },
            { px: 0.62, delay: 280 },
            { px: 0.78, delay: 100 }
        ]
        delegate: Rectangle {
            width:  root.width  * 0.06
            height: root.height * 0.16
            radius: width / 2; color: "#6090C8"
            x: root.width * modelData.px

            SequentialAnimation on y {
                loops: Animation.Infinite
                PauseAnimation  { duration: modelData.delay }
                PropertyAction  { value: root.height * 0.52 }
                NumberAnimation { to: root.height * 0.90; duration: 650; easing.type: Easing.InQuad }
                PauseAnimation  { duration: 300 }
            }
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PauseAnimation  { duration: modelData.delay }
                PropertyAction  { value: 0.9 }
                NumberAnimation { to: 0.0; duration: 650 }
                PauseAnimation  { duration: 300 }
            }
        }
    }
}
