import QtQuick

Item {
    id: root
    property int weatherCode: 0
    property bool isDay: true

    Loader {
        anchors.fill: parent
        sourceComponent: {
            switch (root.weatherCode) {
                case 0:  return root.isDay ? _clearDay    : _clearNight
                case 1:
                case 2:  return root.isDay ? _partlyDay   : _partlyNight
                case 3:  return _overcast
                case 45:
                case 48: return _fog
                case 51:
                case 53:
                case 55:
                case 61:
                case 63:
                case 65:
                case 80:
                case 81:
                case 82: return _rain
                case 56:
                case 57:
                case 66:
                case 67:
                case 71:
                case 73:
                case 75:
                case 77:
                case 85:
                case 86: return _snow
                case 95:
                case 96:
                case 99: return _storm
                default: return root.isDay ? _clearDay : _clearNight
            }
        }
    }

    Component { id: _clearDay;    ClearDayIcon          {} }
    Component { id: _clearNight;  ClearNightIcon        {} }
    Component { id: _partlyDay;   PartlyCloudyDayIcon   {} }
    Component { id: _partlyNight; PartlyCloudyNightIcon {} }
    Component { id: _overcast;    OvercastIcon          {} }
    Component { id: _fog;         FogIcon               {} }
    Component { id: _rain;        RainIcon              {} }
    Component { id: _snow;        SnowIcon              {} }
    Component { id: _storm;       StormIcon             {} }
}
