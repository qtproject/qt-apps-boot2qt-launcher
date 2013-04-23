import QtQuick 2.0

Rectangle {

    width: 100
    height: 40

    gradient: Gradient {
        GradientStop { position: 0; color: pressed ? "steelblue" : "white"  }
        GradientStop { position: 1; color: pressed ? "lightsteelblue" : "darkgray" }
    }

    border.color: pressed ? "darkgray" : "lightgray"
    border.width: 1;

    radius: height / 4

    property alias text: label.text
    property alias pressed: mouse.pressed

    signal clicked;

    Text {
        id: label
        color: "black"
        font.pixelSize: parent.size / 2;
        anchors.centerIn: parent;
    }

    MouseArea {
        id: mouse
        anchors.fill: parent

        onClicked: parent.clicked()

    }
}
