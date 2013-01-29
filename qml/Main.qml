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
            PropertyChanges { target: applicationLoader; opacity: 0 }
            PropertyChanges { target: applicationCloseButton; opacity: 0 }
        },
        State {
            name: "app-launching"
        },
        State {
            name: "app-running"
            PropertyChanges { target: applicationLoader; opacity: 1 }
            PropertyChanges { target: applicationCloseButton; opacity: 1 }
            PropertyChanges { target: launchScreenLoader; opacity: 0 }
        },
        State {
            name: "app-closing"
            PropertyChanges { target: applicationLoader; opacity: 0 }
            PropertyChanges { target: applicationCloseButton; opacity: 0 }
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
        },
        Transition {
            from: "app-launching"
            to: "app-running"
            SequentialAnimation {
                ScriptAction { script: print("running -> app-launching"); }
                NumberAnimation { property: "opacity"; duration: 1000 }
            }
        },
        Transition {
            from: "app-running"
            to: "app-closing"
            SequentialAnimation {
                NumberAnimation { property: "opacity"; duration: 1000 }
                ScriptAction { script: engine.closeApplication(); }
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

    Loader {
        id: applicationLoader
        opacity: 0;

        asynchronous: true;
        source: engine.applicationUrl

        onSourceChanged: print("App Source: '" + source + "'");
        onStatusChanged: print("Loader Status: '" + status + "'");

        onLoaded: {
            print("onLoaded: " + status);
            item.x = 0
            item.y = 0
            item.width = root.width
            item.height = root.height
            engine.state = "app-running";
        }
    }

    Image {
        id: applicationCloseButton;
        source: "common/images/application-close.png"
        width: engine.titleBarSize();
        height: width
        anchors.right: parent.right
        anchors.top: parent.top
        opacity: 0;
        MouseArea {
            anchors.fill: parent
            onClicked: {
                engine.state = "app-closing"
            }
        }
    }

}
