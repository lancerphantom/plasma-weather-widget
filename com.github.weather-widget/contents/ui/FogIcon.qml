import QtQuick

Item {
    id: root

    Repeater {
        model: [
            { py: 0.20, w: 0.70, delay: 0,    dir: 1  },
            { py: 0.38, w: 0.88, delay: 400,  dir: -1 },
            { py: 0.56, w: 0.75, delay: 200,  dir: 1  },
            { py: 0.73, w: 0.60, delay: 600,  dir: -1 }
        ]
        delegate: Rectangle {
            width:  root.width  * modelData.w
            height: root.height * 0.09
            radius: height / 2
            color: "#A0B0C0"
            opacity: 0.75
            y: root.height * modelData.py

            SequentialAnimation on x {
                loops: Animation.Infinite
                PauseAnimation  { duration: modelData.delay }
                NumberAnimation {
                    from: modelData.dir > 0 ? root.width * 0.02 : root.width * 0.10
                    to:   modelData.dir > 0 ? root.width * 0.10 : root.width * 0.02
                    duration: 3000; easing.type: Easing.InOutSine
                }
                NumberAnimation {
                    to: modelData.dir > 0 ? root.width * 0.02 : root.width * 0.10
                    duration: 3000; easing.type: Easing.InOutSine
                }
            }
        }
    }
}
