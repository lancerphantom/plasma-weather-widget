// Generated from SVG file /tmp/meteocons-svg/drizzle.svg
import QtQuick
import QtQuick.VectorImage
import QtQuick.VectorImage.Helpers
import QtQuick.Shapes

Item {
    implicitWidth: 512
    implicitHeight: 512
    component AnimationsInfo : QtObject
    {
        property bool paused: false
        property int loops: 1
        signal restart()
    }
    property AnimationsInfo animations : AnimationsInfo {}
    transform: [
        Scale { xScale: width / 512; yScale: height / 512 }
    ]
    id: _qt_node0
    Item {
        id: _qt_node1
        transform: TransformGroup {
            id: _qt_node1_transform_base_group
            Translate { x: 81; y: 145}
        }
    }
    Shape {
        id: _qt_node2
        opacity: 0
        transform: TransformGroup {
            id: _qt_node2_transform_base_group
            TransformGroup {
                id: _qt_node2_transform_group_0
                Translate { x: 0; y: 120 }
            }
        }
        Connections { target: _qt_node0.animations; function onRestart() {_qt_node2_transform_animation.restart() } }
        ParallelAnimation {
            id:_qt_node2_transform_animation
            loops: _qt_node0.animations.loops
            paused: _qt_node0.animations.paused
            running: true
            onLoopsChanged: { if (running) { restart() } }
            SequentialAnimation {
                loops: 0
                ScriptAction {
                    script: _qt_node2_transform_base_group.activateOverride(_qt_node2_transform_group_0)
                }
                ParallelAnimation {
                }
                ScriptAction {
                    script: {
                    }
                }
            }
        }
        ShapePath {
            id: _qt_shapePath_0
            strokeColor: "#ff0a5ad4"
            strokeWidth: 1
            capStyle: ShapePath.FlatCap
            joinStyle: ShapePath.MiterJoin
            miterLimit: 10
            fillGradient: LinearGradient {
                x1: 1314.8
                y1: -739.9
                x2: 1324.2
                y2: -715.3
                GradientStop { position: 0; color: "#ff0b65ed" }
                GradientStop { position: 0.5; color: "#ff0a5ad4" }
                GradientStop { position: 1; color: "#ff0950bc" }
            }
            fillTransform: PlanarTransform.fromAffineMatrix(0.987688, -0.156434, 0.156434, 0.987688, -989.44, 1287.05)
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 200 376 C 195.582 376 192 372.418 192 368 L 192 356 C 192 351.582 195.582 348 200 348 C 204.418 348 208 351.582 208 356 L 208 368 C 208 372.418 204.418 376 200 376 " }
        }
    }
    Shape {
        id: _qt_node3
        opacity: 0
        transform: TransformGroup {
            id: _qt_node3_transform_base_group
            TransformGroup {
                id: _qt_node3_transform_group_0
                Translate { x: 0; y: 120 }
            }
        }
        Connections { target: _qt_node0.animations; function onRestart() {_qt_node3_transform_animation.restart() } }
        ParallelAnimation {
            id:_qt_node3_transform_animation
            loops: _qt_node0.animations.loops
            paused: _qt_node0.animations.paused
            running: true
            onLoopsChanged: { if (running) { restart() } }
            SequentialAnimation {
                loops: 0
                ScriptAction {
                    script: _qt_node3_transform_base_group.activateOverride(_qt_node3_transform_group_0)
                }
                ParallelAnimation {
                }
                ScriptAction {
                    script: {
                    }
                }
            }
        }
        ShapePath {
            id: _qt_shapePath_1
            strokeColor: "#ff0a5ad4"
            strokeWidth: 1
            capStyle: ShapePath.FlatCap
            joinStyle: ShapePath.MiterJoin
            miterLimit: 10
            fillGradient: LinearGradient {
                x1: 1370.1
                y1: -731.1
                x2: 1379.5
                y2: -706.5
                GradientStop { position: 0; color: "#ff0b65ed" }
                GradientStop { position: 0.5; color: "#ff0a5ad4" }
                GradientStop { position: 1; color: "#ff0950bc" }
            }
            fillTransform: PlanarTransform.fromAffineMatrix(15.803, -4.38017, 2.50295, 27.6553, -15583, 36385.4)
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 256 376 C 251.582 376 248 372.418 248 368 L 248 356 C 248 351.582 251.582 348 256 348 C 260.418 348 264 351.582 264 356 L 264 368 C 264 372.418 260.418 376 256 376 " }
        }
    }
    Shape {
        id: _qt_node4
        opacity: 0
        transform: TransformGroup {
            id: _qt_node4_transform_base_group
            TransformGroup {
                id: _qt_node4_transform_group_0
                Translate { x: 0; y: 120 }
            }
        }
        Connections { target: _qt_node0.animations; function onRestart() {_qt_node4_transform_animation.restart() } }
        ParallelAnimation {
            id:_qt_node4_transform_animation
            loops: _qt_node0.animations.loops
            paused: _qt_node0.animations.paused
            running: true
            onLoopsChanged: { if (running) { restart() } }
            SequentialAnimation {
                loops: 0
                ScriptAction {
                    script: _qt_node4_transform_base_group.activateOverride(_qt_node4_transform_group_0)
                }
                ParallelAnimation {
                }
                ScriptAction {
                    script: {
                    }
                }
            }
        }
        ShapePath {
            id: _qt_shapePath_2
            strokeColor: "#ff0a5ad4"
            strokeWidth: 1
            capStyle: ShapePath.FlatCap
            joinStyle: ShapePath.MiterJoin
            miterLimit: 10
            fillGradient: LinearGradient {
                x1: 1425.4
                y1: -722.4
                x2: 1434.9
                y2: -697.8
                GradientStop { position: 0; color: "#ff0b65ed" }
                GradientStop { position: 0.5; color: "#ff0a5ad4" }
                GradientStop { position: 1; color: "#ff0950bc" }
            }
            fillTransform: PlanarTransform.fromAffineMatrix(15.803, -4.38017, 2.50295, 27.6553, -15527, 36385.4)
            fillRule: ShapePath.WindingFill
            PathSvg { path: "M 312 376 C 307.582 376 304 372.418 304 368 L 304 356 C 304 351.582 307.582 348 312 348 C 316.418 348 320 351.582 320 356 L 320 368 C 320 372.418 316.418 376 312 376 " }
        }
    }
}
