// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick

ApplicationIcon {
    id: root

    Image {
        id: selectedItem
        anchors.fill: root.preview
        source: "image://QtImageMask/"
        sourceSize: Qt.size(width, height)
        visible: root.isSelected
    }

    Image {
        id: glow
        anchors.centerIn: root.preview
        width: root.preview.width * 2.1
        height: root.preview.height * 2.1
        source: "images/glow.png"
        opacity: root.isSelected
        z: -1

        Behavior on opacity { OpacityAnimator { duration: 200; easing.type: Easing.InOutSine }}
    }

    Text {
        anchors.fill: parent
        anchors.margins: root.pageMargin
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: parent.height * 0.1
        text: root.name
        font.family: ViewSettings.appFont
        color: ViewSettings.pine
        wrapMode: Text.WordWrap
        visible: root.highlight && !root.isSelected
    }
}
