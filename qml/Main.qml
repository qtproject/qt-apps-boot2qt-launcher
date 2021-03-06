/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
**
****************************************************************************/
import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.Enterprise.VirtualKeyboard 1.2
import com.qtcompany.B2QtLauncher 1.0


Window {
    id: window

    visible: true
    width: qpa_platform == "wayland" ? 800 : Screen.desktopAvailableWidth
    height: qpa_platform == "wayland" ? 600 : Screen.desktopAvailableHeight

    color: "black"
    property color qtpurple: '#ae32a0'

    Item {
        id: root
        anchors.centerIn: window.contentItem
        property bool portraitMode: Screen.desktopAvailableHeight > Screen.desktopAvailableWidth ? true : false
        rotation: portraitMode ? 90 : 0
        width: portraitMode ? window.height : window.width
        height: portraitMode ? window.width : window.height

        property int stateDelay: 400;
        property int bootDelay: 1000;

        LauncherApplicationsModel {
            id: applicationsModel
            onReady: {
                engine.markApplicationsModelReady();
            }
            Component.onCompleted: {
                //Set the directory to parse for apps
                initialize(applicationSettings.appsRoot);
            }
        }

        LauncherEngine {
            id: engine
            bootAnimationEnabled: applicationSettings.isBootAnimationEnabled
            fpsEnabled: applicationSettings.isShowFPSEnabled
        }

        states: [
            State {
                name: "booting"
                PropertyChanges { target: appGrid; opacity: 0 }
                PropertyChanges { target: splashScreen; opacity: 0 }
                PropertyChanges { target: url; opacity: 0 }
            },
            State {
                name: "running"
                PropertyChanges { target: appGrid; opacity: 1 }
                PropertyChanges { target: applicationLoader; opacity: 0 }
                PropertyChanges { target: splashScreen; opacity: 0 }
            },
            State {
                name: "app-launching"
                PropertyChanges { target: appGrid; opacity: 0 }
                PropertyChanges { target: splashScreen; opacity: 1 }
            },
            State {
                name: "app-running"
                PropertyChanges { target: applicationLoader; opacity: 1 }
                PropertyChanges { target: appGrid; opacity: 0 }
                PropertyChanges { target: splashScreen; opacity: 0 }
                PropertyChanges { target: url; opacity: 0 }
            },
            State {
                name: "app-closing"
                PropertyChanges { target: applicationLoader; opacity: 0 }
                PropertyChanges { target: appGrid; opacity: 0 }
                PropertyChanges { target: splashScreen; opacity: 0 }
            }
        ]

        transitions: [
            Transition {
                from: "booting"
                to: "running"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target: appGrid; property: "opacity"; duration: root.bootDelay; easing.type: Easing.InOutQuad }
                    }

                    ScriptAction { script: bootScreenLoader.sourceComponent = undefined }
                }
            },
            Transition {
                NumberAnimation { property: "opacity"; duration: root.stateDelay }
            },
            Transition {
                from: "running"
                to: "app-launching"
                SequentialAnimation {
                    NumberAnimation { property: "opacity"; duration: root.stateDelay }
                    PauseAnimation { duration: 500 }
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
                    ScriptAction { script: {
                            engine.closeApplication();
                            applicationLoader.source = "";
                        }
                    }
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
                        NumberAnimation { target: appGrid; property: "opacity"; duration: root.stateDelay }
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
    //    onStateChanged: print("---state: " + engine.state);

        LaunchScreen {
            id: appGrid
            visible: opacity > 0
            anchors.fill: parent
        }

        Loader {
            id: bootScreenLoader
            visible: opacity > 0
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
            visible: opacity > 0

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: inputPanel.top
            asynchronous: false;

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
                engine.state = "app-running";
            }

            Rectangle {
                id: applicationCloseButton;

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: parent.width / 4
                y: -height / 2;

                width: closeLabel.width + engine.centimeter() * 2
                height: engine.fontSize() * 3;
                radius: height / 2;

                gradient: Gradient {
                    GradientStop { position: 0.5; color: "gray" }
                    GradientStop { position: 1; color: "black"; }
                }

    //            border.color: "gray"

                Text {
                    id: closeLabel
                    color: "white"
                    text: "Close"
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: parent.height / 4;
                    font.pixelSize: engine.fontSize();
                }

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

        InputPanel {
            id: inputPanel
            z: 99
            y: root.height
            anchors.left: root.left
            anchors.right: root.right

            states: State {
                name: "visible"
                when: Qt.inputMethod.visible
                PropertyChanges {
                    target: inputPanel
                    y: root.height - inputPanel.height
                }
            }
            transitions: Transition {
                from: ""
                to: "visible"
                reversible: true
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Item {
            id: splashScreen
            visible: opacity > 0

            anchors.fill: parent

            Text {
                id: splashLabel
                color: "white"
                text: "Loading..."
                anchors.centerIn: parent;
                anchors.verticalCenterOffset: -height
                font.pixelSize: engine.titleFontSize()
            }

            Image {
                source: "images/codeless.png"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom;
                anchors.margins: parent.height * 0.1;
            }

        }

        Item {
            id: fps
            opacity: engine.fpsEnabled ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 500 } }

            anchors.bottom: parent.bottom;
            anchors.left: parent.left;
            width: fpsLabel.width
            height: fpsLabel.height

            Rectangle {
                color: "black"
                opacity: 0.5
                anchors.fill: fpsLabel
            }

            Text {
                id: fpsLabel;
                color: "white"
                text: "FPS: " + engine.fps
                font.pixelSize: engine.sensibleButtonSize() * 0.2
            }
        }

        Item {
            id: url
            anchors.bottom: parent.bottom;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.margins: height/2
            width: urlLabel.width
            height: urlLabel.height

            Rectangle {
                color: "black"
                opacity: 0.7
                anchors.fill: urlLabel
            }

            Text {
                id: urlLabel;
                text: "http://www.qt.io/qt-for-device-creation"
                color: qtpurple
                font.pixelSize: engine.sensibleButtonSize() * 0.2
                font.bold: true
            }
        }
    }
}
