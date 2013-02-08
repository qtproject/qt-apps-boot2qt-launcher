import QtQuick 2.0

import "../common"

Item {

    id: root

    property real size: Math.min(root.width, root.height);
    property real cellSize: engine.sensibleButtonSize();

    Component.onCompleted: {
        if (engine.backgroundColor != "")
            backgroundColor.visible = true;
        else if (engine.backgroundImage != "")
            backgroundImage.visible = true;
        else
            backgroundGradient.visible = true
    }

    Rectangle {
        id: backgroundColor
        visible: false
        anchors.fill: parent
        color: engine.backgroundColor
        onColorChanged: print(color);
    }

    Image {
        id: backgroundImage
        visible: false
        source: engine.backgroundImage;
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: 1024
        sourceSize.height: 1024
        asynchronous: true;
        onSourceChanged: print("image source is: " + source);
    }

    NoisyGradient {
        id: backgroundGradient
        visible: false
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "lightsteelblue" }
            GradientStop { position: 1; color: "black" }
        }
    }

    GridViewWithInertia {
        anchors.top: titleBar.bottom
        anchors.topMargin: titleBar.height;
        anchors.bottom: root.bottom
        anchors.horizontalCenter: root.horizontalCenter
        width: Math.floor(root.width / root.cellSize) * root.cellSize;

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
