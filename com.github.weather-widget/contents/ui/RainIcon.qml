import QtQuick

Item {
    id: root

    // Cloud
    Item {
        id: cloud
        width:  root.width  * 0.88
        height: root.height * 0.50
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * 0.04

        Rectangle {
            width: parent.width * 0.88; height: parent.height * 0.46
            radius: height / 2; color: "#607080"
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            width: parent.width * 0.40; height: parent.width * 0.40
            radius: width / 2; color: "#607080"
            x: parent.width * 0.08; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.28
        }
        Rectangle {
            width: parent.width * 0.50; height: parent.width * 0.50
            radius: width / 2; color: "#687888"
            x: parent.width * 0.36; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.24
        }
    }

    // Rain drops
    Repeater {
        model: [
            { px: 0.18, delay: 0 },
            { px: 0.38, delay: 350 },
            { px: 0.58, delay: 175 },
            { px: 0.76, delay: 520 }
        ]
        delegate: Rectangle {
            width:  root.width  * 0.06
            height: root.height * 0.18
            radius: width / 2
            color: "#6090C8"
            x: root.width * modelData.px

            SequentialAnimation on y {
                loops: Animation.Infinite
                PauseAnimation   { duration: modelData.delay }
                PropertyAction   { value: root.height * 0.54 }
                NumberAnimation  { to: root.height * 0.90; duration: 700; easing.type: Easing.InQuad }
                PauseAnimation   { duration: 280 }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PauseAnimation   { duration: modelData.delay }
                PropertyAction   { value: 0.9 }
                NumberAnimation  { to: 0.0; duration: 700 }
                PauseAnimation   { duration: 280 }
            }
        }
    }
}
