// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick

Image {
    id: root
    height: parent.height
    width: height
    sourceSize: Qt.size(width, height)

    signal clicked()

    MouseArea {
        anchors.fill: parent
        anchors.margins: - width * 0.3

        onClicked: root.clicked()
    }
}
