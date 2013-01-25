import QtQuick 2.0

import "bootscreen"

Item {
    id: root

    width: 1280
    height: 800

    Rectangle {
        color: "red"
        anchors.fill: parent
    }

    Loader {
        id: bootScreenLoader
        anchors.fill: parent
        sourceComponent: BootScreen {}
    }

    Loader {
        id: homeScreenLoader
    }

}
