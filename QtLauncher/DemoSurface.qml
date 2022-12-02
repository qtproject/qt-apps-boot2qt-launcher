// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick
import QtWayland.Compositor

Repeater {
    id: root
    property string filename: ""
    anchors.fill: parent

    signal surfaceVisible(visible: bool)
    signal surfaceDestroyed(index: int)

    function scheduleScreenshot(filename: string) {
        root.filename = filename
    }

    delegate: ShellSurfaceItem {
        id: chrome
        required property var modelData
        required property int index
        anchors.centerIn: parent
        shellSurface: modelData

        onWidthChanged: downscaleIfNeeded()
        onHeightChanged: downscaleIfNeeded()

        function downscaleIfNeeded() {
            if (width <= root.width && height <= root.height) {
                scale = 1.0
                return;
            }
            scale = Math.min(root.width / width, root.height / height)
        }

        onSurfaceChanged: {
            if (root.filename) ssTimer.start()
            root.surfaceVisible(false)
        }

        onSurfaceDestroyed: root.surfaceDestroyed(index)

        Timer {
            id: ssTimer
            interval: 5000
            running: false

            onTriggered: {
                chrome.grabToImage(function(result) {
                    result.saveToFile(root.filename);
                    root.filename = ""
                    demoHeader.title = qsTr("Screenshot taken. Thumbnail for this demo will be updated on next startup.")
                })
            }
        }
    }
}
