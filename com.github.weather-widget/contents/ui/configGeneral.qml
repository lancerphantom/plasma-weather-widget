// File: contents/ui/configGeneral.qml
import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

Item {
    id: page
    width: childrenRect.width
    height: childrenRect.height

    property alias cfg_cityName: cityField.text
    property alias cfg_latitude: latField.text
    property alias cfg_longitude: lonField.text
    property alias cfg_updateInterval: intervalSpinBox.value

    property var searchResults: []
    property bool isSearching: false
    property bool userIsTyping: false
    property var activeRequest: null

    Component.onCompleted {
        var xhr = new XMLHttpRequest()
        xhr.open("GET", "https://geocoding-api.open-meteo.com/v1/search?name=test&count=1")
        xhr.send()
    }


    Timer {
        id: debounce
        interval: 200
        onTriggered: {
            var query = cityField.text.trim()
            if (query.length < 3) {
                searchResults = []
                return
            }

            // Abort previous request
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

            QQC2.BusyIndicator {
                visible: page.isSearching
                running: visible
                Layout.preferredWidth: Kirigami.Units.gridUnit * 2
                Layout.preferredHeight: Kirigami.Units.gridUnit * 2
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
            placeholderText: "9.98"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        QQC2.TextField {
            id: lonField
            Kirigami.FormData.label: i18n("Longitude:")
            placeholderText: "76.28"
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        QQC2.SpinBox {
            id: intervalSpinBox
            Kirigami.FormData.label: i18n("Update interval (minutes):")
            from: 1
            to: 120
        }
    }
}
