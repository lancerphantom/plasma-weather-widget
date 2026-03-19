// Generated from SVG file /tmp/meteocons-svg/overcast-day-snow.svg
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
            Translate { x: 56; y: 109}
        }
    }
    Item {
        id: _qt_node2
        transform: TransformGroup {
            id: _qt_node2_transform_base_group
            Translate { x: 177.9; y: 337.5}
        }
    }
}
