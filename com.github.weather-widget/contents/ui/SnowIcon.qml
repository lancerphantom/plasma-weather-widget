import QtQuick

Item {
    id: root

    // Cloud
    Item {
        width:  root.width  * 0.88
        height: root.height * 0.48
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height * 0.04

        Rectangle {
            width: parent.width * 0.88; height: parent.height * 0.46
            radius: height / 2; color: "#7888A0"
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            width: parent.width * 0.40; height: parent.width * 0.40
            radius: width / 2; color: "#7888A0"
            x: parent.width * 0.08; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.28
        }
        Rectangle {
            width: parent.width * 0.50; height: parent.width * 0.50
            radius: width / 2; color: "#8090A8"
            x: parent.width * 0.36; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.24
        }
    }

    // Snow flakes (dots)
    Repeater {
        model: [
            { px: 0.16, delay: 0 },
            { px: 0.38, delay: 450 },
            { px: 0.60, delay: 200 },
            { px: 0.78, delay: 630 }
        ]
        delegate: Rectangle {
            width:  root.width  * 0.10
            height: root.width  * 0.10
            radius: width / 2
            color: "#C0D8F0"
            x: root.width * modelData.px

            SequentialAnimation on y {
                loops: Animation.Infinite
                PauseAnimation  { duration: modelData.delay }
                PropertyAction  { value: root.height * 0.52 }
                NumberAnimation { to: root.height * 0.90; duration: 1200; easing.type: Easing.InOutQuad }
                PauseAnimation  { duration: 200 }
            }

            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PauseAnimation  { duration: modelData.delay }
                PropertyAction  { value: 0.9 }
                NumberAnimation { from: 0.9; to: 0.0; duration: 1200 }
                PauseAnimation  { duration: 200 }
            }

            // Gentle drift
            SequentialAnimation on x {
                loops: Animation.Infinite
                PauseAnimation  { duration: modelData.delay }
                NumberAnimation { from: root.width * modelData.px; to: root.width * modelData.px + root.width * 0.04; duration: 600; easing.type: Easing.InOutSine }
                NumberAnimation { to: root.width * modelData.px - root.width * 0.04; duration: 600; easing.type: Easing.InOutSine }
                NumberAnimation { to: root.width * modelData.px; duration: 200 }
            }
        }
    }
}
