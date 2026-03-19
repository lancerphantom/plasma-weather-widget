import QtQuick

Item {
    id: root

    // Twinkling stars
    Repeater {
        model: [
            { px: 0.18, py: 0.15, s: 0.045, delay: 0 },
            { px: 0.70, py: 0.10, s: 0.035, delay: 700 },
            { px: 0.82, py: 0.40, s: 0.04,  delay: 1400 },
            { px: 0.12, py: 0.55, s: 0.03,  delay: 500 }
        ]
        delegate: Rectangle {
            x: root.width  * modelData.px
            y: root.height * modelData.py
            width:  root.width  * modelData.s
            height: root.width  * modelData.s
            radius: width / 2
            color: "#E8F0FF"
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PauseAnimation   { duration: modelData.delay }
                NumberAnimation  { from: 0.3; to: 1.0; duration: 900; easing.type: Easing.InOutSine }
                NumberAnimation  { from: 1.0; to: 0.3; duration: 900; easing.type: Easing.InOutSine }
            }
        }
    }

    // Moon (full circle with offset cutout to fake crescent)
    Item {
        id: moonGroup
        anchors.centerIn: parent
        width:  root.width  * 0.72
        height: root.height * 0.72

        // Moon body
        Rectangle {
            id: moonBody
            width:  moonGroup.width  * 0.62
            height: moonGroup.height * 0.62
            radius: width / 2
            color: "#DDD8B0"
            anchors.centerIn: parent

            SequentialAnimation on scale {
                loops: Animation.Infinite
                NumberAnimation { from: 1.0; to: 1.04; duration: 2500; easing.type: Easing.InOutSine }
                NumberAnimation { from: 1.04; to: 1.0; duration: 2500; easing.type: Easing.InOutSine }
            }

            // Crescent shadow overlay
            Rectangle {
                width:  parent.width  * 0.78
                height: parent.height * 0.78
                radius: width / 2
                color: "#1A2A3A"
                x: -parent.width * 0.18
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
