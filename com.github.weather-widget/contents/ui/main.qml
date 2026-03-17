// File: contents/ui/main.qml
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    compactRepresentation: RowLayout {
        Kirigami.Icon {
            source: "weather-clear"
            Layout.fillHeight: true
            Layout.preferredWidth: height
        }
        PlasmaComponents.Label {
            text: "Weather"
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }

    fullRepresentation: ColumnLayout {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 22
        Layout.preferredHeight: Kirigami.Units.gridUnit * 16

        PlasmaComponents.Label {
            text: "Weather Widget — popup works!"
            Layout.alignment: Qt.AlignCenter
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.2
        }
    }

    toolTipMainText: "Weather Widget"
    toolTipSubText: "Open-Meteo powered"
}
