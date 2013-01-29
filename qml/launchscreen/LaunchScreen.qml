import QtQuick 2.0

import QtGraphicalEffects 1.0

import "../common"

Item {

    id: root

    property real size: Math.min(root.width, root.height);
    property real cellSize: size / 3;

    Image {
        source: engine.backgroundImage;
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: 1024
        asynchronous: true;
    }

//    NoisyGradient {
//        anchors.fill: parent
//        gradient: Gradient {
//            GradientStop { position: 0; color: "lightsteelblue" }
//            GradientStop { position: 1; color: "gray" }
//        }
//    }

    GridView {
        anchors.fill: parent
        model: applicationsModel;

        cellWidth: root.cellSize
        cellHeight: root.cellSize

        delegate: Item {

            width: root.cellSize
            height: root.cellSize

            Rectangle {
                id: box;

                x: root.cellSize * 0.2
                y: root.cellSize * 0.1
                width: root.cellSize * 0.6;
                height: root.cellSize * 0.6;

                gradient: Gradient {
                    GradientStop { position: 0; color: Qt.rgba(1, 1, 1, 0.2) }
                    GradientStop { position: 1; color: Qt.rgba(0, 0, 0, 0.2) }
                }

                radius: root.cellSize * 0.1
                border.width: root.cellSize * 0.02;
                border.color: "white";

                antialiasing: true;

                Image {
                    source: iconName != "" ? location + "/" + largeIconName : ""
                    anchors.fill: parent
                    anchors.margins: parent.width * 0.1
                    smooth: true
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

            layer.enabled: true
            layer.effect: DropShadow {
                color: Qt.rgba(0, 0, 0, 1);
                fast: true
                samples: 8
                radius: 16
                verticalOffset: root.cellSize * 0.02
                horizontalOffset: root.cellSize * 0.02
                cached: true
            }
        }
    }
}
