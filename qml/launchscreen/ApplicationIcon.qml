import QtQuick 2.0

Item {

    id: root

    Rectangle {
        anchors.fill: parent;
        border.width: 1
        border.color: "white"
        color: "transparent"
    }

    Rectangle {
        id: box;

        x: root.cellSize * 0.2
        y: root.cellSize * 0.1
        width: root.cellSize * 0.6;
        height: root.cellSize * 0.6;

        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(1, 1, 1, 0.1) }
            GradientStop { position: 1; color: Qt.rgba(0, 0, 0, 0.1) }
        }

        radius: root.cellSize * 0.1
        border.width: root.cellSize * 0.02;
        border.color: "gray";

        antialiasing: true;

        Image {
            source: location + "/" + largeIconName;
            anchors.fill: parent
            anchors.margins: parent.width * 0.1
            smooth: true
            visible: iconName != "";
        }

        Text {
            color: "white"
            visible: iconName == ""
            font.pixelSize: parent.height * 0.6
            anchors.centerIn: parent
            text: "?"
        }
    }

    Text {
        id: label
        anchors.horizontalCenter: box.horizontalCenter
        anchors.top: box.bottom
        anchors.topMargin: box.height * 0.05
        width: box.width

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        color: "white"

        font.pixelSize: box.height * 0.15;
        font.bold: true
        text: name
    }
}

