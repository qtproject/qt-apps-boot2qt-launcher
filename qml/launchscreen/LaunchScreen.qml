import QtQuick 2.0

import "../common"

Item {

    id: root

    property real size: Math.min(root.width, root.height);
    property real cellSize: engine.sensibleButtonSize();

    property bool portrait: root.width < root.height;

    Component.onCompleted: {
        if (engine.backgroundColor != "")
            backgroundColor.visible = true;
        else {
            backgroundImage.visible = true;
        }
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

        anchors.centerIn: parent
        width: root.portrait ? root.height : root.width
        height: root.portrait ? root.width : root.height
        asynchronous: true;
        rotation: root.portrait ? 90 : 0
        opacity: status == Image.Ready ? 1 : 0

        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    GridViewWithInertia {
        clip: true;
        anchors.top: titleBar.bottom
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
        visible: parent.visible
    }



}
