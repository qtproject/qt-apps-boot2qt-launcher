// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtLauncher

Item {
    id: bootScreen
    opacity: 0.95
    property alias applicationName: applicationNameText.text

    Column {
        anchors.centerIn: parent

        BusyIndicator {
            anchors.horizontalCenter: parent.horizontalCenter
            width: bootScreen.width * 0.1
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: ViewSettings.appFont
            font.pixelSize: bootScreen.height * 0.05
            color: "white"
            text: qsTr("Loading")
        }

        Text {
            id: applicationNameText
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: ViewSettings.appFont
            font.pixelSize: bootScreen.height * 0.05
            font.styleName: "Bold"
            color: "white"
        }
    }
}
