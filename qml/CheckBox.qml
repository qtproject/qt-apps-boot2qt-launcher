import QtQuick 2.0

Rectangle {
    width: 100
    height: 62

    border.width: 2
    border.color: Qt.rgba(1, 1, 1, 0.8);

    antialiasing: true

    property bool checked;

    color: "transparent"

    radius: 10

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "white"
        visible: parent.checked

        radius: parent.radius - anchors.margins
        antialiasing: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.checked = !parent.checked
    }
}
