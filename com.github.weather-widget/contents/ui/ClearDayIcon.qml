import QtQuick

Item {
    id: root

    // Slowly rotating sun group
    Item {
        id: sunGroup
        width: root.width * 0.88
        height: root.height * 0.88
        anchors.centerIn: parent

        RotationAnimator on rotation {
            from: 0
            to: 360
            duration: 14000
            loops: Animation.Infinite
        }

        // 8 rays — each is a full-size Item rotated around the center,
        // with a rounded rectangle at the top
        Repeater {
            model: 8
            delegate: Item {
                width: sunGroup.width
                height: sunGroup.height
                anchors.centerIn: parent

                transform: Rotation {
                    origin.x: width / 2
                    origin.y: height / 2
                    angle: index * 45
                }

                Rectangle {
                    width: sunGroup.width * 0.09
                    height: sunGroup.height * 0.19
                    radius: width / 2
                    color: "#FFB300"
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: sunGroup.height * 0.04
                }
            }
        }

        // Sun core
        Rectangle {
            width: sunGroup.width * 0.52
            height: sunGroup.height * 0.52
            radius: width / 2
            anchors.centerIn: parent
            color: "#FFB300"

            // Subtle glow
            layer.enabled: true
            layer.effect: null
        }
    }
}
