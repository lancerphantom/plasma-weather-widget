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

    function dayName(dateStr) {
        var d = new Date(dateStr + "T00:00:00")
        var today = new Date()
        today.setHours(0, 0, 0, 0)
        var diff = Math.round((d - today) / 86400000)
        if (diff === 0) return "Today"
        if (diff === 1) return "Tomorrow"
        return d.toLocaleDateString(Qt.locale(), "ddd")
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
        var lat = plasmoid.configuration.latitude
        var lon = plasmoid.configuration.longitude
        var url = "https://api.open-meteo.com/v1/forecast"
            + "?latitude=" + lat + "&longitude=" + lon
            + "&current=temperature_2m,weather_code,relative_humidity_2m,wind_speed_10m,apparent_temperature"
            + "&daily=temperature_2m_max,temperature_2m_min,weather_code"
            + "&forecast_days=5"
            + "&timezone=auto"
        executable.exec("curl -s '" + url + "'")
    }

    // Re-fetch when location changes
    Connections {
        target: plasmoid.configuration
        function onLatitudeChanged() { fetchWeather() }
        function onLongitudeChanged() { fetchWeather() }
    }

    Timer {
        interval: plasmoid.configuration.updateInterval * 60000
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
                    return Math.round(root.weatherData.current.temperature_2m) + "°"
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
        Layout.preferredHeight: Kirigami.Units.gridUnit * 22
        Layout.minimumWidth: Kirigami.Units.gridUnit * 18
        spacing: Kirigami.Units.largeSpacing

        // Error state
        PlasmaComponents.Label {
            text: "Error: " + root.errorText
            visible: root.errorText !== ""
            color: Kirigami.Theme.negativeTextColor
            Layout.alignment: Qt.AlignHCenter
        }

        // Loading state
        PlasmaComponents.Label {
            text: "Loading..."
            visible: !root.weatherData && root.errorText === ""
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.6
        }

        // --- Current weather section ---
        ColumnLayout {
            visible: root.weatherData && root.weatherData.current
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            // City name
            PlasmaComponents.Label {
                text: plasmoid.configuration.cityName
                font.bold: true
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.4
                Layout.alignment: Qt.AlignHCenter
            }

            // Big icon + temperature row
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Kirigami.Units.largeSpacing

                Kirigami.Icon {
                    source: root.weatherData && root.weatherData.current
                        ? root.weatherIcon(root.weatherData.current.weather_code)
                        : "weather-clear"
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 5
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 5
                }

                ColumnLayout {
                    spacing: 0
                    PlasmaComponents.Label {
                        text: root.weatherData && root.weatherData.current
                            ? Math.round(root.weatherData.current.temperature_2m) + "°C"
                            : ""
                        font.pointSize: Kirigami.Theme.defaultFont.pointSize * 2.5
                        font.weight: Font.Light
                    }
                    PlasmaComponents.Label {
                        text: root.weatherData && root.weatherData.current
                            ? root.weatherDescription(root.weatherData.current.weather_code)
                            : ""
                        opacity: 0.7
                    }
                }
            }

            // Feels like
            PlasmaComponents.Label {
                text: root.weatherData && root.weatherData.current
                    ? "Feels like " + Math.round(root.weatherData.current.apparent_temperature) + "°C"
                    : ""
                opacity: 0.6
                Layout.alignment: Qt.AlignHCenter
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                height: 1
                color: Kirigami.Theme.textColor
                opacity: 0.15
            }

            // Detail row: humidity + wind
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Kirigami.Units.gridUnit * 2

                RowLayout {
                    spacing: Kirigami.Units.smallSpacing
                    Kirigami.Icon {
                        source: "compass"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                    }
                    PlasmaComponents.Label {
                        text: root.weatherData && root.weatherData.current
                            ? root.weatherData.current.wind_speed_10m + " km/h"
                            : ""
                        opacity: 0.8
                    }
                }

                RowLayout {
                    spacing: Kirigami.Units.smallSpacing
                    Kirigami.Icon {
                        source: "weather-showers"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.small
                        Layout.preferredHeight: Kirigami.Units.iconSizes.small
                    }
                    PlasmaComponents.Label {
                        text: root.weatherData && root.weatherData.current
                            ? root.weatherData.current.relative_humidity_2m + "%"
                            : ""
                        opacity: 0.8
                    }
                }
            }
        }

        // Divider before forecast
        Rectangle {
            visible: root.weatherData && root.weatherData.daily
            Layout.fillWidth: true
            height: 1
            color: Kirigami.Theme.textColor
            opacity: 0.15
        }

        // --- 5-day forecast ---
        RowLayout {
            visible: root.weatherData && root.weatherData.daily
            Layout.fillWidth: true
            spacing: 0

            Repeater {
                model: root.weatherData && root.weatherData.daily
                    ? root.weatherData.daily.time.length : 0

                delegate: ColumnLayout {
                    Layout.fillWidth: true
                    spacing: Kirigami.Units.smallSpacing

                    PlasmaComponents.Label {
                        text: root.weatherData
                            ? root.dayName(root.weatherData.daily.time[index])
                            : ""
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        font.bold: index === 0
                        Layout.alignment: Qt.AlignHCenter
                        opacity: index === 0 ? 1.0 : 0.8
                    }

                    Kirigami.Icon {
                        source: root.weatherData
                            ? root.weatherIcon(root.weatherData.daily.weather_code[index])
                            : "weather-clear"
                        Layout.preferredWidth: Kirigami.Units.iconSizes.medium
                        Layout.preferredHeight: Kirigami.Units.iconSizes.medium
                        Layout.alignment: Qt.AlignHCenter
                    }

                    PlasmaComponents.Label {
                        text: root.weatherData
                            ? Math.round(root.weatherData.daily.temperature_2m_max[index]) + "°"
                            : ""
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        font.bold: index === 0
                        Layout.alignment: Qt.AlignHCenter
                    }

                    PlasmaComponents.Label {
                        text: root.weatherData
                            ? Math.round(root.weatherData.daily.temperature_2m_min[index]) + "°"
                            : ""
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        font.bold: index === 0
                        Layout.alignment: Qt.AlignHCenter
                        opacity: 0.5
                    }
                }
            }
        }

        // Spacer to push content up
        Item {
            Layout.fillHeight: true
        }
    }

    toolTipMainText: plasmoid.configuration.cityName
    toolTipSubText: {
        if (root.weatherData && root.weatherData.current) {
            var c = root.weatherData.current
            return Math.round(c.temperature_2m) + "°C — " + root.weatherDescription(c.weather_code)
        }
        return "Loading..."
    }
}
