// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick

Item {
    id: root
    property alias source: contentRect.newImageSource

    onWidthChanged: contentRect.openChanged()
    onHeightChanged: contentRect.openChanged()

    Image {
        id: contentRect
        width: -root.width * .006
        height: -root.width * .006
        anchors.centerIn: parent
        smooth: !imageAnimation.running
        property bool open: false
        property string newImageSource: ""

        onNewImageSourceChanged: {
            if (contentRect.open && contentRect.newImageSource) {
                changeImageAnimation.restart()
            } else if (!contentRect.newImageSource.endsWith("_missing")) {
                contentRect.source = contentRect.newImageSource
            }
        }

        onStatusChanged: {
            if (status == Image.Ready)
                contentRect.open = true
            else if (status == Image.Error)
                contentRect.open = false
        }

        onOpenChanged: {
            if (open) {
                var scaleFactor = Math.min(root.width / sourceSize.width, root.height / sourceSize.height)
                contentRect.width = sourceSize.width * scaleFactor
                contentRect.height = sourceSize.height * scaleFactor
            } else {
                contentRect.width = -root.width * .006
                contentRect.height = -root.width * .006
            }
        }

        Behavior on width { NumberAnimation { id: imageAnimation; duration: 500; easing.type: Easing.InOutSine }}
        Behavior on height { NumberAnimation { duration: 500; easing.type: Easing.InOutSine }}

        SequentialAnimation {
            id: changeImageAnimation

            PropertyAction { target: contentRect; property: "open"; value: false}
            PauseAnimation { duration: 500 }

            ScriptAction {
                script: {
                    if (contentRect.newImageSource.endsWith("_missing")) contentRect.newImageSource = ""
                    contentRect.source = contentRect.newImageSource
                }
            }
        }

        Image {
            id: topCorner
            width: contentRect.open && contentRect.status == Image.Ready ? root.width * .2: root.width * .25
            height: width
            x: -width*.124
            y: x
            source: "images/QtCorner.png"

            Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.InOutSine }}
        }

        Image {
            id: bottomCorner
            width: topCorner.width
            height: width
            x: parent.width - width + width * .124
            y: parent.height - height + width * .124
            source: "images/QtCorner.png"
            mirror: true
            mirrorVertically: true
        }
    }
}
