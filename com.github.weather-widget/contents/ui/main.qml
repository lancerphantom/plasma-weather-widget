// File: contents/ui/main.qml
import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root

    property var weatherData: null
    property string errorText: ""

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []

        onNewData: (sourceName, data) => {
            if (data["exit code"] === 0) {
                try {
                    root.weatherData = JSON.parse(data["stdout"])
                    root.errorText = ""
                } catch (e) {
                    root.errorText = "JSON parse error"
                }
            } else {
                root.errorText = data["stderr"].trim()
            }
            disconnectSource(sourceName)
        }

        function exec(cmd) {
            connectSource(cmd)
        }
    }

    function fetchWeather() {
        var url = "https://api.open-meteo.com/v1/forecast"
            + "?latitude=9.98&longitude=76.28"
            + "&current=temperature_2m,weather_code,relative_humidity_2m,wind_speed_10m"
            + "&timezone=auto"
        executable.exec("curl -s '" + url + "'")
    }

    Timer {
        interval: 600000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetchWeather()
    }

    compactRepresentation: RowLayout {
        Kirigami.Icon {
            source: "weather-clear"
            Layout.fillHeight: true
            Layout.preferredWidth: height
        }
        PlasmaComponents.Label {
            text: {
                if (root.weatherData && root.weatherData.current) {
                    return root.weatherData.current.temperature_2m + "°C"
                }
                return "..."
            }
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
        spacing: Kirigami.Units.largeSpacing

        PlasmaComponents.Label {
            text: "Kochi, Kerala"
            font.bold: true
            font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.3
            Layout.alignment: Qt.AlignHCenter
        }

        PlasmaComponents.Label {
            text: {
                if (root.errorText) return "Error: " + root.errorText
                if (!root.weatherData || !root.weatherData.current) return "Loading..."
                var c = root.weatherData.current
                return c.temperature_2m + "°C\n"
                    + "Humidity: " + c.relative_humidity_2m + "%\n"
                    + "Wind: " + c.wind_speed_10m + " km/h"
            }
            Layout.alignment: Qt.AlignHCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    toolTipMainText: "Weather Widget"
    toolTipSubText: {
        if (root.weatherData && root.weatherData.current) {
            return root.weatherData.current.temperature_2m + "°C — Kochi"
        }
        return "Loading..."
    }
}
