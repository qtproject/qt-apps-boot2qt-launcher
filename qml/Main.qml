/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.VirtualKeyboard 2.0
import com.qtcompany.B2QtLauncher 1.0

Window {
    id: window

    visible: true
    width: qpa_platform == "wayland" ? 800 : Screen.desktopAvailableWidth
    height: qpa_platform == "wayland" ? 600 : Screen.desktopAvailableHeight

    color: "white"
    property color qtgreen: '#80c342'

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

            Image {
                id: applicationCloseButton
                source: "images/close-button.png"
                anchors.horizontalCenter: parent.horizontalCenter
                enabled: engine.state == "app-running"
                y: -height * .6
                z: 1

                Behavior on y { NumberAnimation { duration: 100 } }

                MouseArea {
                    anchors.fill: parent
                    anchors.bottomMargin: applicationCloseButton.y < -applicationCloseButton.height / 2 ? 0 : -parent.height * .5
                    drag.target: applicationCloseButton
                    drag.axis: Drag.YAxis
                    drag.minimumX: -applicationCloseButton.height * .6
                    drag.maximumY: 0

                    onClicked: {
                        if (applicationCloseButton.y < -applicationCloseButton.height / 2) {
                            applicationCloseButton.y = 0
                            return;
                        }

                        engine.state = "app-closing"
                        applicationCloseButton.y = -applicationCloseButton.height * .6
                    }

                    onReleased: applicationCloseButton.y = applicationCloseButton.y > -applicationCloseButton.height / 5 ?
                                    0 :
                                    -applicationCloseButton.height * .6
                }
            }
        }

        /*  Handwriting input panel for full screen handwriting input.

            This component is an optional add-on for the InputPanel component, that
            is, its use does not affect the operation of the InputPanel component,
            but it also can not be used as a standalone component.

            The handwriting input panel is positioned to cover the entire area of
            application. The panel itself is transparent, but once it is active the
            user can draw handwriting on it.
        */
        HandwritingInputPanel {
            z: 79
            id: handwritingInputPanel
            anchors.fill: parent
            inputPanel: inputPanel
            Rectangle {
                z: -1
                anchors.fill: parent
                color: "black"
                opacity: 0.10
            }
        }

        /*  Container area for the handwriting mode button.

            Handwriting mode button can be moved freely within the container area.
            In this example, a single click changes the handwriting mode and a
            double-click changes the availability of the full screen handwriting input.
        */
        Item {
            z: 89
            visible: handwritingInputPanel.enabled && Qt.inputMethod.visible
            anchors { left: parent.left; top: parent.top; right: parent.right; bottom: inputPanel.top; }
            HandwritingModeButton {
                id: handwritingModeButton
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 10
                floating: true
                flipable: true
                width: 76
                height: width
                state: handwritingInputPanel.state
                onClicked: handwritingInputPanel.active = !handwritingInputPanel.active
                onDoubleClicked: handwritingInputPanel.available = !handwritingInputPanel.available
            }
            onVisibleChanged: console.log("hw visible: "+visible)
            Component.onCompleted: console.log("input visible " +visible)
        }

        /*  Keyboard input panel.
            The keyboard is anchored to the bottom of the application.
        */
        InputPanel {
            id: inputPanel
            z: 99
            y: root.height
            anchors.left: root.left
            anchors.right: root.right

            states: State {
                name: "visible"
                /*  The visibility of the InputPanel can be bound to the Qt.inputMethod.visible property,
                    but then the handwriting input panel and the keyboard input panel can be visible
                    at the same time. Here the visibility is bound to InputPanel.active property instead,
                    which allows the handwriting panel to control the visibility when necessary.
                */
                when: inputPanel.active
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
            AutoScroller {}
        }

        Item {
            id: splashScreen
            visible: opacity > 0
            anchors.fill: parent

            BusyIndicator {
                id: busyIndicator
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: splashLabel.top
                anchors.bottomMargin: height * .5
                width: parent.width * .1
            }

            Text {
                id: splashLabel
                color: "black"
                text: qsTr("Loading %1...").arg(engine.applicationName)
                anchors.bottom: codeLessImage.top
                anchors.bottomMargin: font.pixelSize
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: engine.fontSize() * 1.2
            }

            Image {
                id: codeLessImage
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
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 20
            GlimmeringQtLogo {
                id: logo
                anchors.bottom: parent.bottom
                anchors.left: parent.left
            }

            Text {
                id: urlLabel;
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Visit Qt.io/qt-for-device-creation"
                color: qtgreen
                font.pixelSize: engine.sensibleButtonSize() * 0.2
            }
            Image{
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                source:"images/settings.png"
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        //Find launchersettings application from appsRoots
                        //There can be several roots which are split with ':'
                        var fileArray = applicationSettings.appsRoot.split(":")
                        for ( var i = 0; i < fileArray.length; i++ ) {
                            var file = fileArray[i]
                            var prepend = "file://"
                            file = prepend.concat(file)
                            file += "/launchersettings"

                            if (engine.fileExists(file + "/main.qml")) {
                                engine.launchApplication(file, "main.qml", "Launcher Settings")
                                break
                            }
                        }
                    }
                }
            }
        }
    }
}
