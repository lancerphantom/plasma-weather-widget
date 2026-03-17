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

    // Map WMO weather codes to KDE icon names
    function weatherIcon(code) {
        if (code === undefined || code === null) return "weather-clear"
        switch (code) {
            case 0:  return "weather-clear"
            case 1:  return "weather-few-clouds"
            case 2:  return "weather-clouds"
            case 3:  return "weather-overcast"
            case 45:
            case 48: return "weather-fog"
            case 51:
            case 53:
            case 55: return "weather-showers-scattered"
            case 56:
            case 57: return "weather-freezing-rain"
            case 61:
            case 63:
            case 65: return "weather-showers"
            case 66:
            case 67: return "weather-freezing-rain"
            case 71:
            case 73:
            case 75:
            case 77: return "weather-snow"
            case 80:
            case 81:
            case 82: return "weather-showers"
            case 85:
            case 86: return "weather-snow-scattered"
            case 95:
            case 96:
            case 99: return "weather-storm"
            default: return "weather-clear"
        }
    }

    // Map WMO weather codes to readable descriptions
    function weatherDescription(code) {
        if (code === undefined || code === null) return "Unknown"
        switch (code) {
            case 0:  return "Clear sky"
            case 1:  return "Mainly clear"
            case 2:  return "Partly cloudy"
            case 3:  return "Overcast"
            case 45: return "Fog"
            case 48: return "Depositing rime fog"
            case 51: return "Light drizzle"
            case 53: return "Moderate drizzle"
            case 55: return "Dense drizzle"
            case 56:
            case 57: return "Freezing drizzle"
            case 61: return "Light rain"
            case 63: return "Moderate rain"
            case 65: return "Heavy rain"
            case 66:
            case 67: return "Freezing rain"
            case 71: return "Light snow"
            case 73: return "Moderate snow"
            case 75: return "Heavy snow"
            case 77: return "Snow grains"
            case 80: return "Light showers"
            case 81: return "Moderate showers"
            case 82: return "Violent showers"
            case 85:
            case 86: return "Snow showers"
            case 95: return "Thunderstorm"
            case 96:
            case 99: return "Thunderstorm with hail"
            default: return "Unknown"
        }
    }

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
            source: {
                if (root.weatherData && root.weatherData.current) {
                    return root.weatherIcon(root.weatherData.current.weather_code)
                }
                return "weather-clear"
            }
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

        // Weather icon in popup
        Kirigami.Icon {
            source: {
                if (root.weatherData && root.weatherData.current) {
                    return root.weatherIcon(root.weatherData.current.weather_code)
                }
                return "weather-clear"
            }
            Layout.preferredWidth: Kirigami.Units.gridUnit * 4
            Layout.preferredHeight: Kirigami.Units.gridUnit * 4
            Layout.alignment: Qt.AlignHCenter
        }

        // Condition description
        PlasmaComponents.Label {
            text: {
                if (root.weatherData && root.weatherData.current) {
                    return root.weatherDescription(root.weatherData.current.weather_code)
                }
                return ""
            }
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.8
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
            var c = root.weatherData.current
            return c.temperature_2m + "°C — " + root.weatherDescription(c.weather_code)
        }
        return "Loading..."
    }
}
