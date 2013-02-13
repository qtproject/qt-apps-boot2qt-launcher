import QtQuick 2.0

Item {
    id: root

    property real value: grip.x / (root.width - grip.width) ;

    Rectangle {
        id: line
        x: grip.width / 2
        anchors.verticalCenter: parent.verticalCenter
        height: 4
        width: parent.width - grip.width
        color: Qt.rgba(1, 1, 1, 0.2);
        radius: 2
        antialiasing: true
    }

    Rectangle {
        id: grip
        anchors.verticalCenter: parent.verticalCenter
        height: engine.fontSize() - 8
        width: height
        color: Qt.rgba(1, 1, 1, 1);
        radius: 6
        antialiasing: true
        border.color: "white"
        border.width: 2

        MouseArea {
            id: mouse
            anchors.fill: parent
            anchors.margins: -10
            drag.target: parent
            drag.axis: Drag.XAxis;
            drag.maximumX: root.width - grip.width
            drag.minimumX: 0
        }

    }

}
