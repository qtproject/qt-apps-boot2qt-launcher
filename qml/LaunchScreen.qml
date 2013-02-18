import QtQuick 2.0

Item {

    id: root

    property real size: Math.min(root.width, root.height);
    property real cellSize: engine.sensibleButtonSize();

    GridViewWithInertia {
        clip: true;
        anchors.top: parent.top
        anchors.bottom: parent.bottom
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



}
