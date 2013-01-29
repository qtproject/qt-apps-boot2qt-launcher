import QtQuick 2.0

import "../common"

Item {

    id: root

    property real size: Math.min(root.width, root.height);
    property real cellSize: engine.sensibleButtonSize();

    Image {
        id: backgroundImage
        source: engine.backgroundImage;
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: 1024
        asynchronous: true;
    }

    NoisyGradient {
        visible: backgroundImage.source == "";
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "lightsteelblue" }
            GradientStop { position: 1; color: "black" }
        }
    }

    GridView {
        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        width: parent.width
        model: applicationsModel;

        cellWidth: root.cellSize
        cellHeight: root.cellSize

        delegate: ApplicationIcon {
            width: root.cellSize
            height: root.cellSize
        }
    }

    TitleBar {
        id: titleBar
        height: engine.titleBarSize();
        width: parent.width
    }

}
