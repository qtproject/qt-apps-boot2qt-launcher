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
                ScriptAction { script: bootScreenLoader.sourceComponent = undefined }
            }
        },
        Transition {
            from: "app-launching"
            to: "app-running"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: applicationLoader; property: "opacity"; duration: 1000 }
                    NumberAnimation { target: applicationCloseButton; property: "opacity"; duration: 1000 }
                }
                PropertyAction { target: launchScreenLoader; property: "opacity"; value: 0}
            }
        },
        Transition {
            from: "app-running"
            to: "app-closing"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: applicationLoader; property: "opacity"; duration: 1000 }
                    NumberAnimation { target: applicationCloseButton; property: "opacity"; duration: 1000 }
                }
                NumberAnimation { target: applicationLoader; property: "opacity"; duration: 1000 }
                ScriptAction { script: engine.closeApplication(); }
            }
        }

    ]

    state: engine.state

    onStateChanged: {
        print("-- state: " + state + " --");
    }

    Loader {
        id: launchScreenLoader
        anchors.fill: parent
        sourceComponent: LaunchScreen {}
    }

    Loader {
        id: bootScreenLoader
        anchors.fill: parent
        sourceComponent: BootScreen {}

        onSourceComponentChanged: print("bootScreenLoader: sourceComponent changed to: " + sourceComponent);

        onStatusChanged: {
            switch (status) {
            case Loader.Null: print("bootScreenLoader status: Null"); break;
            case Loader.Ready: print("bootScreenLoader status: Ready"); break;
            case Loader.Error: print("bootScreenLoader status: Error"); break;
            case Loader.Loading: print("bootScreenLoader status: Loading"); break;
            default: print("bootScreenLoader: unknown status: " + status); break;
            }
        }
    }

    Timer {
        id: failedAppLaunchTrigger;
        interval: 500;
        running: false
        repeat: false
        onTriggered: {
            engine.closeApplication()
        }
    }

    Loader {
        id: applicationLoader
        opacity: 0;

        asynchronous: true;
        source: engine.applicationUrl

        onStatusChanged: {
            switch (status) {
            case Loader.Null: print("applicationLoader status: Null"); break;
            case Loader.Ready: print("applicationLoader status: Ready"); break;
            case Loader.Error: print("applicationLoader status: Error"); break;
            case Loader.Loading: print("applicationLoader status: Loading"); break;
            default: print("applicationLoader: unknown status: " + status); break;
            }

            if (status == Loader.Error) {
                print("applicationLoader: app failed, reverting to 'running' state");
                failedAppLaunchTrigger.running = true;
            }

        }

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
