import QtQuick

Item {
    id: root

    // Back cloud (lighter, drifts right)
    Item {
        id: backCloud
        width:  root.width  * 0.72
        height: root.height * 0.50
        y: root.height * 0.10

        SequentialAnimation on x {
            loops: Animation.Infinite
            NumberAnimation { from: root.width*0.18; to: root.width*0.24; duration: 4000; easing.type: Easing.InOutSine }
            NumberAnimation { from: root.width*0.24; to: root.width*0.18; duration: 4000; easing.type: Easing.InOutSine }
        }

        Rectangle {
            width: parent.width * 0.85; height: parent.height * 0.44
            radius: height / 2; color: "#8898A8"
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            width: parent.width * 0.38; height: parent.width * 0.38
            radius: width / 2; color: "#8898A8"
            x: parent.width * 0.12; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.28
        }
        Rectangle {
            width: parent.width * 0.44; height: parent.width * 0.44
            radius: width / 2; color: "#8898A8"
            x: parent.width * 0.38; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.24
        }
    }

    // Front cloud (darker, drifts left)
    Item {
        id: frontCloud
        width:  root.width  * 0.82
        height: root.height * 0.54
        y: root.height * 0.38

        SequentialAnimation on x {
            loops: Animation.Infinite
            NumberAnimation { from: root.width*0.06; to: root.width*0.0; duration: 3500; easing.type: Easing.InOutSine }
            NumberAnimation { from: root.width*0.0; to: root.width*0.06; duration: 3500; easing.type: Easing.InOutSine }
        }

        Rectangle {
            width: parent.width * 0.88; height: parent.height * 0.46
            radius: height / 2; color: "#68788A"
            anchors.bottom: parent.bottom; anchors.horizontalCenter: parent.horizontalCenter
        }
        Rectangle {
            width: parent.width * 0.40; height: parent.width * 0.40
            radius: width / 2; color: "#68788A"
            x: parent.width * 0.10; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.30
        }
        Rectangle {
            width: parent.width * 0.50; height: parent.width * 0.50
            radius: width / 2; color: "#707888"
            x: parent.width * 0.36; anchors.bottom: parent.bottom; anchors.bottomMargin: parent.height * 0.26
        }
    }
}
