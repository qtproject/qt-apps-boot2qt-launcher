// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtQuick.Window
import QtWayland.Compositor

LauncherCompositor {
    id: compositor

    waylandOutput.window: Window {
        id: window
        visible: true
        width: Screen.desktopAvailableWidth
        height: Screen.desktopAvailableHeight
        color: ViewSettings.backgroundColor

        property real pageMargin: ViewSettings.margin * Math.min(window.width, window.height)

        Loader {
            id: mainWindowLoader
            anchors.fill: parent
            active: false
            asynchronous: true

            onLoaded: {
                splashScreenLoader.item.visible = false;
                splashScreenLoader.source = "";
            }
        }

        Loader {
            id: splashScreenLoader
            anchors.fill: parent
            sourceComponent: Item {
                anchors.fill: parent

                BootScreen {
                    anchors.fill: parent
                    applicationName: qsTr("Qt Launcher")
                }
            }
            onLoaded: {
                mainWindowLoader.setSource("qrc:/qt/qml/QtLauncher/MainWindow.qml", {"compositor" : compositor, "shellSurfaces" : compositor.shellSurfaces, "window" : window, "pageMargin" : window.pageMargin})
                mainWindowLoader.active = true;
            }
        }

        Loader {
            anchors.fill: parent
            source: "qrc:/qt/qml/QtLauncher/Keyboard.qml"
        }
    }
}
