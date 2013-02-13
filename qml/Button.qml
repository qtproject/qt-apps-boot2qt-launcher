import QtQuick 2.0

Rectangle {
    width: 100
    height: 62

    border.width: 2
    border.color: Qt.rgba(1, 1, 1, 0.8);

    antialiasing: true

    property alias pressed: mouse.pressed;
    property alias text: label.text;

    signal clicked

    color: "transparent"

    radius: 10

    Rectangle {
        anchors.fill: parent
        anchors.margins: 4
        color: "white"
        visible: parent.pressed

        opacity: 0.5

        radius: parent.radius - anchors.margins
        antialiasing: true
    }

    Text {
        id: label;
        anchors.centerIn: parent
        font.pixelSize: engine.fontSize();
        color: "white"
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
