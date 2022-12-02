// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Window
import QtLauncher
import QtLauncher.QtImageProviders

Item {
    id: mainWindow
    anchors.fill: parent
    required property LauncherCompositor compositor
    required property ListModel shellSurfaces
    required property Window window
    required property real pageMargin

    ApplicationsModel {
        id: applicationsModel

        onReady: {
            engine.markApplicationsModelReady();
            contentLoader.active = true
        }

        Component.onCompleted: {
            //Set the directory to parse for apps
            initialize(mainWindow.compositor.appsRoot);
        }

        function launchFromIndex(index: int) {
            demoInfoPopup.description = applicationsModel.query(index, "description")
            demoHeader.title = applicationsModel.query(index, "name")
            mainWindow.compositor.scalableDemo = applicationsModel.query(index, "scalable")

            var iconFile = "" + applicationsModel.query(index, "icon")

            //We don't have thumbnail image for this demo, let's schedule a screenshot
            if (iconFile.endsWith("_missing")) {
                demoSurface.scheduleScreenshot(iconFile.replace("_missing", ""))
            }

            appLoadScreen.applicationName = applicationsModel.query(index, "name")
            appLoadScreen.visible = true

            engine.launchApplication(applicationsModel.query(index, "binary"),
                                     applicationsModel.query(index, "arguments"),
                                     applicationsModel.query(index, "environment")
                                     )
        }
    }

    Background {
        engine: engine
        BootScreen {
            id: appLoadScreen
            visible: false
            anchors.fill: parent
        }
    }

    Component {
        id: gridComponent

        LaunchScreen {
            id: launchScreen
            appsModel: applicationsModel
            pageMargin: mainWindow.pageMargin
        }
    }

    Component {
        id: detailComponent

        DetailView {
            id: detailView
            appsModel: applicationsModel
            pageMargin: mainWindow.pageMargin
        }
    }

    Engine {
        id: engine
    }

    Item {
        id: root
        anchors.fill: parent

        Loader {
            id: contentLoader
            visible: engine.state === "running"
            anchors.fill: parent
            anchors.topMargin: header.height + mainWindow.pageMargin
            sourceComponent: SettingsManager.gridSelected ? gridComponent : detailComponent
            active: false
        }

        Header {
            id: header
            pageMargin: mainWindow.pageMargin
            visible: engine.state === "running"
        }

        DemoSurface {
            id: demoSurface
            model: mainWindow.shellSurfaces
            anchors.fill: parent
            onSurfaceVisible: (visible)=> { appLoadScreen.visible = visible; }
            onSurfaceDestroyed: (index)=> { mainWindow.shellSurfaces.remove(index); }
        }

        DemoHeader {
            id: demoHeader
            engine: engine
            pageMargin: mainWindow.pageMargin
            visible: engine.state === "app-running"
            onInfoClicked: demoInfoPopup.open()
            onCloseClicked: engine.closeApplication();
        }

        DemoInfoPopup {
            id: demoInfoPopup
            pageMargin: mainWindow.pageMargin
            visible: false
            height: mainWindow.height
            width: mainWindow.width
            z: demoHeader.z + 1
        }
    }
}
