import QtQuick 2.0

import "bootscreen"
import "launchscreen"

Item {
    id: root

    width: 1280
    height: 800

    property int stateDelay: 200;

    states: [
        State {
            name: "booting"
            PropertyChanges { target: launchScreenLoader; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 0 }
        },
        State {
            name: "running"
            PropertyChanges { target: launchScreenLoader; opacity: 1 }
            PropertyChanges { target: applicationLoader; opacity: 0 }
            PropertyChanges { target: applicationCloseButton; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 0 }
        },
        State {
            name: "app-launching"
            PropertyChanges { target: launchScreenLoader; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 1 }
        },
        State {
            name: "app-running"
            PropertyChanges { target: applicationLoader; opacity: 1 }
            PropertyChanges { target: applicationCloseButton; opacity: 1 }
            PropertyChanges { target: launchScreenLoader; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 0 }
        },
        State {
            name: "app-closing"
            PropertyChanges { target: applicationLoader; opacity: 0 }
            PropertyChanges { target: applicationCloseButton; opacity: 0 }
            PropertyChanges { target: launchScreenLoader; opacity: 1 }
            PropertyChanges { target: splashScreen; opacity: 0 }
            PropertyChanges { target: launchScreenLoader; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            from: "booting"
            to: "running"
            SequentialAnimation {
                NumberAnimation { target: launchScreenLoader; property: "opacity"; duration: root.stateDelay; easing.type: Easing.InOutQuad }
                ScriptAction { script: bootScreenLoader.sourceComponent = undefined }
            }
        },
        Transition {
            from: "running"
            to: "app-launching"
            SequentialAnimation {
                NumberAnimation { property: "opacity"; duration: root.stateDelay }
                PauseAnimation { duration: 1000 }
                ScriptAction { script: {
                        applicationLoader.source = engine.applicationMain;
                    }
                }
            }
        },
        Transition {
            from: "app-launching"
            to: "running"
            SequentialAnimation {
                NumberAnimation { target: launchScreenLoader; property: "opacity"; duration: root.stateDelay }
            }
        },
        Transition {
            from: "app-launching"
            to: "app-running"
            NumberAnimation { property: "opacity"; duration: root.stateDelay }
        },
        Transition {
            from: "app-running"
            to: "app-closing"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: applicationLoader; property: "opacity"; duration: root.stateDelay }
                    NumberAnimation { target: applicationCloseButton; property: "opacity"; duration: root.stateDelay}
                }
                NumberAnimation { target: applicationLoader; property: "opacity"; duration: root.stateDelay }
                ScriptAction { script: {
                        engine.closeApplication();
                        applicationLoader.source = "";
                    }
                }
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
        sourceComponent: LaunchScreen {
            visible: parent.opacity > 0;
        }
    }

    Loader {
        id: bootScreenLoader
        anchors.fill: parent
        sourceComponent: BootScreen {}
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
            item.x = 0
            item.y = 0
            item.width = root.width
            item.height = root.height
            engine.state = "app-running";
        }
    }

    Item {
        id: splashScreen

        anchors.fill: parent

        Image {
            id: splashIcon
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: splashLabel.top
            anchors.bottomMargin: splashLabel.height
            source: engine.applicationUrl != "" ? engine.applicationUrl + "/icon.png" : ""
            asynchronous: true;
            opacity: status == Image.Ready ? 1 : 0;
            Behavior on opacity { NumberAnimation { duration: 50; } }
            onSourceChanged: print("loading image: " + source);
        }

        Text {
            id: splashLabel
            color: "white"
            anchors.centerIn: parent;
            anchors.verticalCenterOffset: height
            text: "Loading..."
            font.pixelSize: parent.height * 0.02;
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
