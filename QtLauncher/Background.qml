// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick

Image {
    required property Engine engine
    anchors.fill: parent
    source: "images/backImg.jpg"
    fillMode: Image.PreserveAspectCrop

    // QTBUG-63585, background image causes poor performance of flickable items
    // on low-end gpu devices
    visible: engine.state !== "running"

    Rectangle {
        anchors.fill: parent
        color: ViewSettings.backgroundColor
        opacity: 0.9
    }
}
