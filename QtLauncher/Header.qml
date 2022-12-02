// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick

Item {
    id: root
    required property real pageMargin
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: root.pageMargin * 5

    Rectangle {
        anchors.fill: parent
        visible: SettingsManager.gridSelected
        gradient: Gradient {
            GradientStop { position: 0.0; color: ViewSettings.backgroundColor }
            GradientStop { position: 1.0; color: "transparent" }
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: root.pageMargin

        Item {
            id: settingsMenu
            anchors.left: parent.left
            anchors.top: parent.top
            height: parent.height
            width: opened ? parent.width - qtLogo.width : height
            clip: true

            property bool opened: false

            Behavior on width {NumberAnimation { duration: 500 } }

            function close() {
                closeTimer.stop()
                settingsMenu.opened = false
                gearAnimation.direction = RotationAnimator.Counterclockwise
                gearAnimation.restart()
            }

            function open() {
                settingsMenu.opened = true
                gearAnimation.direction = RotationAnimator.Clockwise
                gearAnimation.restart()
                closeTimer.restart()
            }

            Timer {
                id: closeTimer
                interval: 10000
                onTriggered: settingsMenu.close()
            }

            MouseArea {
                id: hoverMouseArea
                anchors.fill: parent
                hoverEnabled: true
                enabled: SettingsManager.mouseSelected
                onEntered: if (!settingsMenu.opened) settingsMenu.open()
                onExited: if (settingsMenu.opened) settingsMenu.close()
            }

            MouseArea {
                anchors.left: parent.left
                anchors.top: parent.top
                height: parent.height
                width: height

                onClicked: {
                    if (settingsMenu.opened)
                        settingsMenu.close()
                    else
                        settingsMenu.open()
                }
            }

            Image {
                id: menuIcon
                anchors.left: parent.left
                anchors.top: parent.top
                source: "icons/settings_icon.svg"
                height: parent.height
                width: height
                sourceSize: Qt.size(width, height)

                RotationAnimator {
                    id: gearAnimation
                    target: menuIcon
                    duration: 500
                    from: 0
                    to: 180
                }
            }

            Row {
                id: settingsRow
                anchors.top: parent.top
                anchors.left: menuIcon.right
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.leftMargin: height * .5
                spacing: height

                Rectangle {
                    width: 2
                    height: parent.height
                    color: "white"
                }

                SettingsButton {
                    id: layoutIcon
                    source: SettingsManager.gridSelected ? "icons/grid_icon.svg" : "icons/detail_icon.svg"

                    onClicked: {
                        closeTimer.restart()
                        SettingsManager.gridSelected = !SettingsManager.gridSelected
                    }
                }

                Rectangle {
                    width: 2
                    height: parent.height
                    color: "white"
                }

                SettingsButton {
                    id: mouseIcon
                    source: SettingsManager.mouseSelected ? "icons/mouse_icon.svg" : "icons/touch_icon.svg"

                    onClicked: {
                        closeTimer.restart()
                        SettingsManager.mouseSelected = !SettingsManager.mouseSelected
                    }
                }

                Rectangle {
                    width: 2
                    height: parent.height
                    color: "white"
                }
            }
        }

        Image {
            id: qtLogo
            anchors.right: parent.right
            anchors.top: parent.top
            source: "icons/qt_logo_green_rgb.svg"
            height: parent.height
            width: height / sourceSize.height * sourceSize.width
        }
    }
}
