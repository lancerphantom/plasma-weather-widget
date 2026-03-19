import QtQuick

Item {
    id: root

    // Small rotating sun (background, top-right)
    Item {
        id: sunGroup
        width:  root.width  * 0.55
        height: root.height * 0.55
        x: root.width  * 0.38
        y: root.height * 0.04

        RotationAnimator on rotation {
            from: 0; to: 360; duration: 14000; loops: Animation.Infinite
        }

        Repeater {
            model: 8
            delegate: Item {
                width: sunGroup.width; height: sunGroup.height
                anchors.centerIn: parent
                transform: Rotation { origin.x: width/2; origin.y: height/2; angle: index * 45 }
                Rectangle {
                    width: sunGroup.width * 0.1; height: sunGroup.height * 0.2
                    radius: width / 2; color: "#FFB300"
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: sunGroup.height * 0.04
                }
            }
        }

        Rectangle {
            width: sunGroup.width * 0.50; height: sunGroup.height * 0.50
            radius: width / 2; color: "#FFB300"; anchors.centerIn: parent
        }
    }

    // Drifting cloud (foreground, lower-left)
    Item {
        id: cloudGroup
        width:  root.width  * 0.82
        height: root.height * 0.55
        y: root.height * 0.42

        SequentialAnimation on x {
            loops: Animation.Infinite
            NumberAnimation { from: root.width*0.0; to: root.width*0.04; duration: 3000; easing.type: Easing.InOutSine }
            NumberAnimation { from: root.width*0.04; to: root.width*0.0; duration: 3000; easing.type: Easing.InOutSine }
        }

        Rectangle { // body
            width: parent.width * 0.85; height: parent.height * 0.46
            radius: height / 2; color: "#C0CCD8"
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle { // left puff
            width: parent.width * 0.40; height: parent.width * 0.40
            radius: width / 2; color: "#C0CCD8"
            x: parent.width * 0.10; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.30
        }
        Rectangle { // right puff
            width: parent.width * 0.48; height: parent.width * 0.48
            radius: width / 2; color: "#C8D4E0"
            x: parent.width * 0.35; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.26
        }
    }
}
