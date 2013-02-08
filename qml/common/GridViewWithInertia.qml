import QtQuick 2.0

Flickable
{
    id: root

    property real inertia: 0.1;

    property alias delegate: repeater.delegate
    property alias model: repeater.model

    property real cellWidth;
    property real cellHeight;

    onXChanged: print("X: " + x);
    onYChanged: print("Y: " + y);
    onWidthChanged: print("WIDTH: " + width);
    onHeightChanged: print("HEIGHT: " + height);

    contentWidth: grid.width
    contentHeight: grid.height

    flickableDirection: Flickable.VerticalFlick

    Item {
        id: shiftTrickery

        width: grid.width
        height: grid.height

        Rectangle {
            width: 100
            height: 100
            color: "red"
            y: 300
            x: 200
        }

        Grid {
            id: grid

            y: -contentItem.y + offsetY;
            x: -contentItem.x + offsetX;
            width: root.width

            columns: root.width / root.cellWidth;

            onWidthChanged: print("grid.width: " + width);


            property real offsetY: 0;
            property real offsetX: 0;

            property real inertia: root.inertia;
            property real t;
            NumberAnimation on t {
                id: animation;
                from: 0;
                to: 1;
                duration: 1000;
                loops: Animation.Infinite
                running: Math.abs(grid.y) > 0.001 || Math.abs(grid.x) > 0.001
                onRunningChanged: running ? print("animation started") : print("animation stopped")
            }

            onTChanged: {
                offsetY += (contentItem.y - offsetY) * inertia
                offsetX += (contentItem.x - offsetX) * inertia
            }

            Repeater {
                id: repeater
            }
        }
    }


}
