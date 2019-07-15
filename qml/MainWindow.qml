/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.4
import QtQuick.Window 2.2
import QtQuick.VirtualKeyboard 2.1
import QtDeviceUtilities.SettingsUI 1.0
import com.qtcompany.B2QtLauncher 1.0

Item {
    id: mainWindow
    anchors.fill: parent
    Component {
        id: emptyComponent
        Item {
            objectName: "empty"
        }
    }

    Component {
        id: gridComponent
        LaunchScreen {
            objectName: "launchScreen"
            id: launchScreen
        }
    }

    Component {
        id: detailComponent
        DetailView {
            objectName: "detailView"
            id: detailView
        }
    }

    Component {
        id: settingsUIComponent
        SettingsUI {
            id: settingsUI
            objectName: "settingsView"
            anchors.fill: parent
            model: "settings.xml"
            margin: viewSettings.pageMargin
            onClosed: root.closeApplication()
        }
    }

    LauncherApplicationsModel {
        id: applicationsModel
        onReady: engine.markApplicationsModelReady();
        Component.onCompleted: {
            //Set the directory to parse for apps
            initialize(applicationSettings.appsRoot);
        }
    }

    LauncherEngine {
        id: engine
        fpsEnabled: applicationSettings.isShowFPSEnabled
    }

    Item {
        id: root
        anchors.centerIn: parent
        property bool portraitMode: Screen.desktopAvailableHeight > Screen.desktopAvailableWidth ? true : false
        property bool demoHeaderEnabled: applicationLoader.sourceComponent !== settingsUIComponent
        property int rotateAmount: globalSettings.rotationSelected ? 180 : 0
        rotation: portraitMode ? 90 + rotateAmount : 0 + rotateAmount
        width: portraitMode ? window.height : window.width
        height: portraitMode ? window.width : window.height

        function closeApplication()
        {
            engine.closeApplication()
            applicationLoader.setSource("")
            applicationLoader.sourceComponent = emptyComponent
        }

        function launchApplication(loc, mainFile, name, desc)
        {
            engine.launchApplication(loc, mainFile, name, desc)
            applicationLoader.source = engine.applicationMain
        }

        function launchSettings()
        {
            engine.state = "app-launching"
            applicationLoader.sourceComponent = settingsUIComponent
        }

        Background {}

        Header {
            id: header
            enabled: engine.state == "running"
            onMenuClicked: root.launchSettings()
        }

        Loader {
            id: contentLoader
            anchors.fill: parent
            anchors.topMargin: header.height + viewSettings.pageMargin
            sourceComponent: globalSettings.gridSelected ? gridComponent : detailComponent
            enabled: engine.state != "settings"
        }

        states: [
            State {
                name: "running"
                PropertyChanges { target: applicationLoader; opacity: 0; }
                PropertyChanges { target: contentLoader; opacity: 1 }
                PropertyChanges { target: header; opacity: 1 }
                PropertyChanges { target: bootScreenLoader; opacity: 0 }
            },
            State {
                name: "app-launching"
                PropertyChanges { target: header; opacity: 0 }
                PropertyChanges { target: bootScreenLoader; opacity: 1 }
            },
            State {
                name: "app-running"
                PropertyChanges { target: applicationLoader; opacity: 1 }
                PropertyChanges { target: contentLoader; opacity: 0 }
                PropertyChanges { target: header; opacity: 0 }
                PropertyChanges { target: bootScreenLoader; opacity: 0 }
            },
            State {
                name: "settings"
                PropertyChanges { target: applicationLoader; opacity: 1 }
                PropertyChanges { target: contentLoader; opacity: 1 }
                PropertyChanges { target: header; opacity: 0 }
                PropertyChanges { target: bootScreenLoader; opacity: 0 }
            },
            State {
                name: "app-closing"
                PropertyChanges { target: applicationLoader; opacity: 0; source: "" }
                PropertyChanges { target: contentLoader; opacity: 0 }
                PropertyChanges { target: header; opacity: 0 }
                PropertyChanges { target: bootScreenLoader; opacity: 0 }
            }
        ]

        state: engine.state

        Timer {
            id: failedAppLaunchTrigger;
            interval: viewSettings.stateDelay;
            running: false
            repeat: false
            onTriggered: root.closeApplication()
        }

        Loader {
            id: applicationLoader
            objectName: "applicationLoader"
            opacity: 0;
            visible: opacity > 0.1
            anchors.fill: parent

            asynchronous: true;
            onStatusChanged: {
                if (status == Loader.Error)
                    failedAppLaunchTrigger.start();
            }
            onLoaded: {
                if (applicationLoader.item.objectName == "settingsView")
                    engine.state = "settings"
                else if (applicationLoader.item.objectName !== "empty")
                    engine.state = "app-running";
            }
            Behavior on anchors.topMargin {NumberAnimation{ duration: 200 } }
        }

        DemoHeader {
            id: demoHeader
            visible: applicationLoader.visible && root.demoHeaderEnabled
            onInfoClicked: demoInfoPopup.open()
            onCloseClicked: root.closeApplication();
        }
        Loader {
            id: bootScreenLoader
            visible: opacity > 0
            anchors.fill: parent
            sourceComponent: BootScreen {
                applicationName: engine.applicationName
            }
        }

        DemoInfoPopup {
            id: demoInfoPopup
            visible: false
            height: mainWindow.height
            width: mainWindow.width
            z: demoHeader.z + 1
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
            visible: y < root.height
            onActiveChanged: {
                if (!active)
                    applicationLoader.anchors.topMargin = 0;
                else {
                    autoScroller.open();
                }
            }
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
            AutoScroller {
                id: autoScroller
            }
        }

        GlobalIndicator {
            id: fps
            enabled: engine.fpsEnabled
            text: "FPS: " + engine.fps
        }

        GlobalIndicator {
            id: demoModeIndicator
            enabled: demoMode.demoIsRunning
            text: qsTr("DEMO MODE - Tap screen to use")
            anchors.bottom: fps.enabled ? fps.top : parent.bottom
        }
    }

    DemoMode {
        id: demoMode
        demoHeader: demoHeader
        launcherHeader: header
        visibleItem: (applicationLoader.item && (applicationLoader.item.objectName !== "empty")) ?
                         applicationLoader.item : contentLoader.item
    }

    // MouseArea for capturing mouse clicks/presses
    MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true

        // Press or click
        function pressedOrClicked(mouse) {
            if (mouse.source === Qt.MouseEventSynthesizedByApplication) {
                mouse.accepted = false
                return
            }
            mouse.accepted = demoMode.demoIsRunning
            demoMode.stopDemos()
        }

        onClicked: pressedOrClicked(mouse)
        onPressed: pressedOrClicked(mouse)
    }
}
