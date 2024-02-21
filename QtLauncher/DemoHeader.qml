// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick

Rectangle {
    id: demoHeaderBar
    required property Engine engine
    required property real pageMargin
    width: parent.width
    height: demoHeaderBar.pageMargin * 2.5
    color: ViewSettings.backgroundColor
    opacity: 0.9
    y: 0
    z: 1
    visible: engine.state === "app-running" || engine.state === "app-launching"

    Behavior on y { YAnimator { duration: 100 } }

    property alias title: demoName.text
    property bool open: y > -height/2

    signal infoClicked()
    signal closeClicked()

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: demoHeaderBar.pageMargin * 0.3
        spacing: demoHeaderBar.pageMargin

        Image {
            id: headerLogo
            source: "icons/qt_logo_green_rgb.svg"
            height: parent.height
            width: height / sourceSize.height * sourceSize.width
        }

        Text {
            id: demoName
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height * 0.5
            font.family: ViewSettings.appFont
            font.styleName: "SemiBold"
            color: "white"
        }
    }

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: demoHeaderBar.pageMargin * 0.3
        spacing: demoHeaderBar.pageMargin

        Image {
            id: infoImg
            height: parent.height
            width: height
            source: "icons/info_icon.svg"

            MouseArea {
                anchors.fill: parent
                anchors.margins: -parent.height * 0.5
                enabled: demoHeaderBar.open
                onClicked: demoHeaderBar.infoClicked()
            }
        }

        Image {
            id: applicationCloseButton
            height: parent.height
            width: height
            source: "icons/close_icon.svg"

            MouseArea {
                anchors.fill: parent
                anchors.margins: -parent.height * 0.5
                enabled: demoHeaderBar.open
                onClicked: demoHeaderBar.closeClicked()
            }
        }
    }

    Image {
        id: headerToggleButton
        source: "icons/header_toggle_icon.svg"
        height: parent.height * 0.5
        width: height / sourceSize.height * sourceSize.width
        anchors.horizontalCenter: parent.horizontalCenter
        y: demoHeaderBar.open ? parent.height - height/2 : parent.height
        rotation: demoHeaderBar.open ? 180 : 0
        Drag.active: headerToggleMouseArea.drag.active

        Behavior on rotation { RotationAnimator { duration: 100 } }
        Behavior on y { YAnimator { duration: 100 } }

        MouseArea {
            id: headerToggleMouseArea
            anchors.fill: parent
            anchors.margins: -parent.height * 0.5
            drag.target: demoHeaderBar
            drag.axis: Drag.YAxis
            drag.minimumX: -demoHeaderBar.height
            drag.maximumY: 0

            DropArea {
                anchors.fill: parent
                onDropped: demoHeaderVisibilityDelay.restart()
            }

            onClicked: {
                if (demoHeaderBar.y < -demoHeaderBar.height / 2) {
                    demoHeaderBar.y = 0
                    demoHeaderVisibilityDelay.restart()
                } else {
                    demoHeaderBar.y = -demoHeaderBar.height
                }
            }

            onReleased: {
                demoHeaderBar.y = demoHeaderBar.y > -demoHeaderBar.height / 4 ? 0 : -demoHeaderBar.height
                parent.Drag.drop()
            }
        }
    }

    Component.onCompleted: demoHeaderVisibilityDelay.start()

    Timer {
        id: demoHeaderVisibilityDelay
        interval: 3000
        onTriggered: {
            if (!demoHeaderVisibilityDelay.running)
                demoHeaderBar.y = -demoHeaderBar.height
        }
    }
}
