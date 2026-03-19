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

    // Day/night from sunrise-sunset; falls back to hour-based guess
    property bool isDay: {
        if (root.weatherData && root.weatherData.daily
                && root.weatherData.daily.sunrise
                && root.weatherData.daily.sunrise.length > 0) {
            var now = new Date()
            var sunrise = new Date(root.weatherData.daily.sunrise[0])
            var sunset  = new Date(root.weatherData.daily.sunset[0])
            return now >= sunrise && now < sunset
        }
        var h = new Date().getHours()
        return h >= 6 && h < 20
    }

    // Returns a Lottie JSON path — day/night aware for codes that have variants
    function lottieIcon(code, dayTime) {
        var d = dayTime ? "day" : "night"
        if (code === undefined || code === null) return Qt.resolvedUrl("icons/clear-" + d + ".png")
        switch (code) {
            case 0:  return Qt.resolvedUrl("icons/clear-" + d + ".png")
            case 1:
            case 2:  return Qt.resolvedUrl("icons/partly-cloudy-" + d + ".png")
            case 3:  return Qt.resolvedUrl("icons/overcast-" + d + ".png")
            case 45:
            case 48: return Qt.resolvedUrl("icons/fog-" + d + ".png")
            case 51:
            case 53:
            case 55: return Qt.resolvedUrl("icons/drizzle.png")
            case 56:
            case 57: return Qt.resolvedUrl("icons/sleet.png")
            case 61:
            case 63:
            case 65: return Qt.resolvedUrl("icons/overcast-" + d + "-rain.png")
            case 66:
            case 67: return Qt.resolvedUrl("icons/sleet.png")
            case 71:
            case 73:
            case 75:
            case 77: return Qt.resolvedUrl("icons/overcast-" + d + "-snow.png")
            case 80:
            case 81:
            case 82: return Qt.resolvedUrl("icons/overcast-" + d + "-rain.png")
            case 85:
            case 86: return Qt.resolvedUrl("icons/overcast-" + d + "-snow.png")
            case 95: return Qt.resolvedUrl("icons/thunderstorms-" + d + "-rain.png")
            case 96:
            case 99: return Qt.resolvedUrl("icons/hail.png")
            default: return Qt.resolvedUrl("icons/clear-" + d + ".png")
        }
    }

    // KDE icon names — used only in compact panel representation
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
            + "&daily=temperature_2m_max,temperature_2m_min,weather_code,sunrise,sunset"
            + "&forecast_days=5"
            + "&timezone=auto"
        executable.exec("curl -s '" + url + "'")
    }

    Connections {
        target: plasmoid.configuration
        function onLatitudeChanged()  { fetchWeather() }
        function onLongitudeChanged() { fetchWeather() }
    }

    Timer {
        interval: plasmoid.configuration.updateInterval * 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: fetchWeather()
    }

    // --- Compact (panel) representation — static KDE icon + temperature ---
    compactRepresentation: RowLayout {
        Kirigami.Icon {
            source: root.weatherData && root.weatherData.current
                ? root.weatherIcon(root.weatherData.current.weather_code)
                : "weather-clear"
            Layout.fillHeight: true
            Layout.preferredWidth: height
        }
        PlasmaComponents.Label {
            text: root.weatherData && root.weatherData.current
                ? Math.round(root.weatherData.current.temperature_2m) + "°"
                : "..."
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
        }
        MouseArea {
            anchors.fill: parent
            onClicked: root.expanded = !root.expanded
        }
    }

    // --- Full (popup) representation ---
    fullRepresentation: ColumnLayout {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 22
        Layout.minimumWidth: Kirigami.Units.gridUnit * 18
        spacing: Kirigami.Units.largeSpacing

        PlasmaComponents.Label {
            text: "Error: " + root.errorText
            visible: root.errorText !== ""
            color: Kirigami.Theme.negativeTextColor
            Layout.alignment: Qt.AlignHCenter
        }

        PlasmaComponents.Label {
            text: "Loading..."
            visible: !root.weatherData && root.errorText === ""
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.6
        }

        // --- Current weather ---
        ColumnLayout {
            visible: root.weatherData && root.weatherData.current
            Layout.fillWidth: true
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                text: plasmoid.configuration.cityName
                font.bold: true
                font.pointSize: Kirigami.Theme.defaultFont.pointSize * 1.4
                Layout.alignment: Qt.AlignHCenter
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: Kirigami.Units.largeSpacing

                // Main animated weather icon
                AnimatedWeatherIcon {
                    weatherCode: root.weatherData && root.weatherData.current
                        ? root.weatherData.current.weather_code : 0
                    isDay: root.isDay
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 6
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 6
                    width: Kirigami.Units.gridUnit * 6
                    height: Kirigami.Units.gridUnit * 6
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

            PlasmaComponents.Label {
                text: root.weatherData && root.weatherData.current
                    ? "Feels like " + Math.round(root.weatherData.current.apparent_temperature) + "°C"
                    : ""
                opacity: 0.6
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: Kirigami.Units.smallSpacing
                Layout.bottomMargin: Kirigami.Units.smallSpacing
                height: 1
                color: Kirigami.Theme.textColor
                opacity: 0.15
            }

            // Wind + humidity
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
                            ? root.weatherData.current.wind_speed_10m + " km/h" : ""
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
                            ? root.weatherData.current.relative_humidity_2m + "%" : ""
                        opacity: 0.8
                    }
                }
            }
        }

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
            Layout.alignment: Qt.AlignHCenter
            spacing: 0

            Repeater {
                model: root.weatherData && root.weatherData.daily
                    ? root.weatherData.daily.time.length : 0

                delegate: ColumnLayout {
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 4
                    Layout.maximumWidth: Kirigami.Units.gridUnit * 4
                    spacing: Kirigami.Units.smallSpacing / 2

                    PlasmaComponents.Label {
                        text: root.weatherData
                            ? root.dayName(root.weatherData.daily.time[index]) : ""
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        font.bold: index === 0
                        Layout.alignment: Qt.AlignHCenter
                        opacity: index === 0 ? 1.0 : 0.8
                        elide: Text.ElideRight
                    }

                    // Forecast icons — animated, always day variant
                    AnimatedWeatherIcon {
                        weatherCode: root.weatherData
                            ? root.weatherData.daily.weather_code[index] : 0
                        isDay: true
                        width: Kirigami.Units.iconSizes.large
                        height: Kirigami.Units.iconSizes.large
                        Layout.preferredWidth: Kirigami.Units.iconSizes.large
                        Layout.preferredHeight: Kirigami.Units.iconSizes.large
                        Layout.alignment: Qt.AlignHCenter
                    }

                    PlasmaComponents.Label {
                        text: root.weatherData
                            ? Math.round(root.weatherData.daily.temperature_2m_max[index]) + "°" : ""
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        font.bold: true
                        Layout.alignment: Qt.AlignHCenter
                    }

                    PlasmaComponents.Label {
                        text: root.weatherData
                            ? Math.round(root.weatherData.daily.temperature_2m_min[index]) + "°" : ""
                        font.pointSize: Kirigami.Theme.smallFont.pointSize
                        Layout.alignment: Qt.AlignHCenter
                        opacity: 0.5
                    }
                }
            }
        }

        Rectangle {
            visible: root.weatherData && root.weatherData.daily
            Layout.fillWidth: true
            height: 1
            color: Kirigami.Theme.textColor
            opacity: 0.15
        }

        // --- Sunrise / Sunset ---
        RowLayout {
            visible: root.weatherData && root.weatherData.daily
                && root.weatherData.daily.sunrise
                && root.weatherData.daily.sunrise.length > 0
            Layout.fillWidth: true
            Layout.bottomMargin: Kirigami.Units.smallSpacing

            Item { Layout.fillWidth: true }

            RowLayout {
                spacing: Kirigami.Units.smallSpacing
                Kirigami.Icon {
                    source: "weather-clear"
                    Layout.preferredWidth: Kirigami.Units.iconSizes.small
                    Layout.preferredHeight: Kirigami.Units.iconSizes.small
                }
                PlasmaComponents.Label {
                    text: {
                        if (!root.weatherData || !root.weatherData.daily || !root.weatherData.daily.sunrise) return ""
                        return Qt.formatTime(new Date(root.weatherData.daily.sunrise[0]), "h:mm AP")
                    }
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    opacity: 0.8
                }
            }

            Item { Layout.fillWidth: true }

            RowLayout {
                spacing: Kirigami.Units.smallSpacing
                Kirigami.Icon {
                    source: "weather-clear-night"
                    Layout.preferredWidth: Kirigami.Units.iconSizes.small
                    Layout.preferredHeight: Kirigami.Units.iconSizes.small
                }
                PlasmaComponents.Label {
                    text: {
                        if (!root.weatherData || !root.weatherData.daily || !root.weatherData.daily.sunset) return ""
                        return Qt.formatTime(new Date(root.weatherData.daily.sunset[0]), "h:mm AP")
                    }
                    font.pointSize: Kirigami.Theme.smallFont.pointSize
                    opacity: 0.8
                }
            }

            Item { Layout.fillWidth: true }
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
