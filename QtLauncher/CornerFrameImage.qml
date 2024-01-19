// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick

Item {
    id: root
    property alias source: contentRect.newImageSource

    onWidthChanged: contentRect.openChanged()
    onHeightChanged: contentRect.openChanged()

    Item {
        id: glowItem
        anchors.fill: contentRect
        visible: contentRect.open

        SequentialAnimation on opacity {
            running: glowItem.visible
            loops: SequentialAnimation.Infinite
            OpacityAnimator {
                from: 0
                to: .5
                duration: 2000
                easing.type: Easing.InOutSine
            }
            OpacityAnimator {
                from: .5
                to: .0
                duration: 2000
                easing.type: Easing.InOutSine
            }
            PauseAnimation {
                duration: 1000
            }
        }

        Image {
            id: borderCorner1
            source: "images/glow_corner.png"
            anchors.right: glowItem.left
            anchors.bottom: glowItem.top
            width: pageMargin * 1.5
            height: width
        }
        Image {
            id: border1
            source: "images/glow_border.png"
            anchors.left: borderCorner1.right
            anchors.right: borderCorner2.left
            anchors.bottom: glowItem.top
            height: pageMargin * 1.5
        }
        Image {
            id: borderCorner2
            source: "images/glow_corner.png"
            anchors.left: glowItem.right
            anchors.bottom: glowItem.top
            width: pageMargin * 1.5
            height: width
            mirror: true
        }
        Image {
            id: border2
            source: "images/glow_border2.png"
            anchors.left: glowItem.right
            anchors.top: borderCorner2.bottom
            anchors.bottom: borderCorner3.top
            mirror: true
            width: pageMargin * 1.5
        }
        Image {
            id: border3
            source: "images/glow_border2.png"
            anchors.right: glowItem.left
            anchors.top: borderCorner1.bottom
            anchors.bottom: borderCorner3.top
            width: pageMargin * 1.5
        }
        Image {
            id: borderCorner3
            source: "images/glow_corner.png"
            anchors.right: glowItem.left
            anchors.top: glowItem.bottom
            mirrorVertically: true
            width: pageMargin * 1.5
            height: width
        }

        Image {
            id: border4
            source: "images/glow_border.png"
            anchors.left: borderCorner3.right
            anchors.right: borderCorner4.left
            anchors.top: glowItem.bottom
            mirrorVertically: true
            height: pageMargin * 1.5
        }

        Image {
            id: borderCorner4
            source: "images/glow_corner.png"
            anchors.left: glowItem.right
            anchors.top: glowItem.bottom
            mirror: true
            mirrorVertically: true
            width: pageMargin * 1.5
            height: width
        }
    }

    Image {
        id: contentRect
        width: -root.width * .006
        height: -root.width * .006
        anchors.centerIn: parent
        smooth: !imageAnimation.running
        property bool open: false
        property string newImageSource: ""

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: ViewSettings.neon
            border.width: 1
        }

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
