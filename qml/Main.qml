import QtQuick 2.0

import "bootscreen"
import "launchscreen"

Item {
    id: root

    width: 1280
    height: 800

    states: [
        State {
            name: "booting"
            PropertyChanges { target: launchScreenLoader; opacity: 0 }
        },
        State {
            name: "running"
            PropertyChanges { target: launchScreenLoader; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            from: "booting"
            to: "running"
            SequentialAnimation {
                NumberAnimation { target: launchScreenLoader; property: "opacity"; duration: 1000; easing.type: Easing.InOutQuad }
                PropertyAction { target: bootScreenLoader; property: "sourceComponent"; value: undefined }
            }
        }
    ]

    state: engine.state

    Loader {
        id: launchScreenLoader
        anchors.fill: parent
        sourceComponent: LaunchScreen {}
    }

    Loader {
        id: bootScreenLoader
        anchors.fill: parent
        sourceComponent: BootScreen {}
    }

    Component.onCompleted: {
        engine.initialize();
    }
}
