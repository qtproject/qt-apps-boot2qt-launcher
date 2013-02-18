import QtQuick 2.0

Item {
    id: root

    width: 100
    height: 62

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

}
