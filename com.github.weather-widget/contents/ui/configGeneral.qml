// File: contents/ui/configGeneral.qml
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: page
    width: childrenRect.width
    height: childrenRect.height

    property string title: i18n("General")

    property alias cfg_cityName: cityField.text
    property alias cfg_latitude: latField.text
    property alias cfg_longitude: lonField.text
    property alias cfg_updateInterval: intervalSpinBox.value

    property string cfg_cityNameDefault: "Kochi, Kerala"
    property string cfg_latitudeDefault: "9.98"
    property string cfg_longitudeDefault: "76.28"
    property int cfg_updateIntervalDefault: 10

    property var searchResults: []
    property bool isSearching: false
    property bool userIsTyping: false
    property var activeRequest: null

    Component.onCompleted: {
        // Pre-warm the connection so first real search is fast
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://geocoding-api.open-meteo.com/v1/search?name=a&count=1&language=en")
        xhr.onreadystatechange = function() {}
        xhr.send()
    }

    Timer {
        id: debounce
        interval: 300
        onTriggered: {
            var query = cityField.text.trim()
            if (query.length < 3) {
                searchResults = []
                return
            }
            if (page.activeRequest) {
                page.activeRequest.abort()
            }
            isSearching = true
            var xhr = new XMLHttpRequest()
            page.activeRequest = xhr
            var url = "https://geocoding-api.open-meteo.com/v1/search?name="
                + encodeURIComponent(query) + "&count=5&language=en"
            xhr.open("GET", url)
            xhr.onreadystatechange = function() {
                if (xhr.readyState === XMLHttpRequest.DONE) {
                    isSearching = false
                    page.activeRequest = null
                    if (xhr.status === 200) {
                        try {
                            var data = JSON.parse(xhr.responseText)
                            if (data.results && data.results.length > 0) {
                                searchResults = data.results
                            } else {
                                searchResults = []
                            }
                        } catch (e) {
                            searchResults = []
                        }
                    }
                }
            }
            xhr.send()
        }
    }

    function selectResult(result) {
        userIsTyping = false
        cityField.text = result.name
            + (result.admin1 ? ", " + result.admin1 : "")
            + (result.country ? ", " + result.country : "")
        latField.text = result.latitude.toFixed(4)
        lonField.text = result.longitude.toFixed(4)
        searchResults = []
    }

    Kirigami.FormLayout {
        anchors.left: parent.left
        anchors.right: parent.right

        ColumnLayout {
            Kirigami.FormData.label: i18n("City name:")
            Layout.fillWidth: true
            spacing: 0

            QQC2.TextField {
                id: cityField
                placeholderText: i18n("Start typing a city name...")
                Layout.fillWidth: true
                onTextChanged: {
                    if (userIsTyping) {
                        debounce.restart()
                    }
                }
                onPressed: userIsTyping = true
            }

            RowLayout {
                visible: page.isSearching
                spacing: Kirigami.Units.smallSpacing
                QQC2.BusyIndicator {
                    running: true
                    Layout.preferredWidth: Kirigami.Units.gridUnit * 1.5
                    Layout.preferredHeight: Kirigami.Units.gridUnit * 1.5
                }
                QQC2.Label {
                    text: i18n("Searching…")
                    opacity: 0.7
                    font: Kirigami.Theme.smallFont
                }
            }

            Rectangle {
                visible: page.searchResults.length > 0
                Layout.fillWidth: true
                implicitHeight: resultsList.implicitHeight
                color: Kirigami.Theme.backgroundColor
                border.color: Kirigami.Theme.disabledTextColor
                border.width: 1
                radius: 4

                ColumnLayout {
                    id: resultsList
                    anchors.left: parent.left
                    anchors.right: parent.right
                    spacing: 0

                    Repeater {
                        model: page.searchResults

                        delegate: QQC2.ItemDelegate {
                            Layout.fillWidth: true
                            highlighted: hovered
                            contentItem: ColumnLayout {
                                spacing: 0
                                QQC2.Label {
                                    text: modelData.name
                                        + (modelData.admin1 ? ", " + modelData.admin1 : "")
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                                QQC2.Label {
                                    text: (modelData.country || "")
                                        + "  (" + modelData.latitude.toFixed(2)
                                        + "°, " + modelData.longitude.toFixed(2) + "°)"
                                    opacity: 0.5
                                    font: Kirigami.Theme.smallFont
                                    elide: Text.ElideRight
                                    Layout.fillWidth: true
                                }
                            }
                            onClicked: selectResult(modelData)
                        }
                    }
                }
            }
        }

        QQC2.TextField {
            id: latField
            Kirigami.FormData.label: i18n("Latitude:")
            placeholderText: i18n("Auto-filled from city search")
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            readOnly: true
            opacity: 0.7
        }

        QQC2.TextField {
            id: lonField
            Kirigami.FormData.label: i18n("Longitude:")
            placeholderText: i18n("Auto-filled from city search")
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            readOnly: true
            opacity: 0.7
        }

        QQC2.SpinBox {
            id: intervalSpinBox
            Kirigami.FormData.label: i18n("Update interval (minutes):")
            from: 1
            to: 100
        }
    }
}
