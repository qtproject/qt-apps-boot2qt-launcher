import QtQuick 2.0

Rectangle {
    id: root

    width: parent.width
    height: engine.smallFontSize() * 3

    radius: 10
    border.width: 2
    border.color: "white"

    antialiasing: true

    property alias text: label.text;

    property color accentColor: "palegreen"

    gradient: Gradient {
        GradientStop { position: 0; color: "white"; }
        GradientStop { position: 0; color: root.accentColor; }
    }

    Text {
        font.pixelSize: engine.smallFontSize()
        color: "white"
        anchors.centerIn: parent
    }

}
