import QtQuick 2.0

Item {
    id: root

    width: 1280
    height: 800

    property int stateDelay: 300;

    states: [
        State {
            name: "booting"
            PropertyChanges { target: appGrid; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 0 }
            PropertyChanges { target: titleBar; opacity: 0 }
            PropertyChanges { target: background; opacity: 0 }
        },
        State {
            name: "running"
            PropertyChanges { target: appGrid; opacity: 1 }
            PropertyChanges { target: applicationLoader; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 0 }
            PropertyChanges { target: titleBar; opacity: 1 }
            PropertyChanges { target: background; opacity: 1 }
        },
        State {
            name: "settings"
            PropertyChanges { target: appGrid; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 0 }
            PropertyChanges { target: titleBar; opacity: 1 }
            PropertyChanges { target: background; opacity: 1 }
        },

        State {
            name: "app-launching"
            PropertyChanges { target: appGrid; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 1 }
            PropertyChanges { target: titleBar; opacity: 0 }
            PropertyChanges { target: background; opacity: 0 }
        },
        State {
            name: "app-running"
            PropertyChanges { target: applicationLoader; opacity: 1 }
            PropertyChanges { target: appGrid; opacity: 0 }
            PropertyChanges { target: splashScreen; opacity: 0 }
            PropertyChanges { target: titleBar; opacity: 0 }
            PropertyChanges { target: background; opacity: 0 }
        },
        State {
            name: "app-closing"
            PropertyChanges { target: applicationLoader; opacity: 0 }
            PropertyChanges { target: appGrid; opacity: 1 }
            PropertyChanges { target: splashScreen; opacity: 0 }
            PropertyChanges { target: titleBar; opacity: 1 }
            PropertyChanges { target: background; opacity: 1 }
        }
    ]

    transitions: [
        Transition {
            from: "booting"
            to: "running"
            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation { target: appGrid; property: "opacity"; duration: root.stateDelay; easing.type: Easing.InOutQuad }
                    NumberAnimation { target: background; property: "opacity"; duration: root.stateDelay; easing.type: Easing.InOutQuad }
                    NumberAnimation { target: titleBar; property: "opacity"; duration: root.stateDelay; easing.type: Easing.InOutQuad }
                }

                ScriptAction { script: bootScreenLoader.sourceComponent = undefined }
            }
        },
        Transition {
            from: "running"
            to: "app-launching"
            SequentialAnimation {
                NumberAnimation { property: "opacity"; duration: root.stateDelay }
                PauseAnimation { duration: 300 }
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
                NumberAnimation { target: appGrid; property: "opacity"; duration: root.stateDelay }
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

    Background {
        id: background
        anchors.fill: parent
    }

    LaunchScreen {
        id: appGrid
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
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

        anchors.fill: parent

        asynchronous: true;

        onStatusChanged: {
//            switch (status) {
//            case Loader.Null: print("applicationLoader status: Null"); break;
//            case Loader.Ready: print("applicationLoader status: Ready"); break;
//            case Loader.Error: print("applicationLoader status: Error"); break;
//            case Loader.Loading: print("applicationLoader status: Loading"); break;
//            default: print("applicationLoader: unknown status: " + status); break;
//            }
            if (status == Loader.Error) {
//                print("applicationLoader: app failed, reverting to 'running' state");
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

        Image {
            id: applicationCloseButton;
            source: "images/application-close.png"
            width: engine.titleBarSize();
            height: width
            anchors.right: parent.right
            anchors.top: parent.top
            enabled: engine.state == "app-running"
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    engine.state = "app-closing"
                }
            }
            z: 1
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

    TitleBar {
        id: titleBar
        height: engine.titleBarSize();
        width: parent.width
        visible: parent.visible
    }




}
