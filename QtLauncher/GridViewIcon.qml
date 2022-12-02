// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick

ApplicationIcon {
    id: root
    hoverSource: "image://QtImageMask/hover"

    Image {
        id: glow
        anchors.centerIn: root.preview
        width: root.preview.width * 2.1
        height: root.preview.height * 2.1
        source: "images/glow.png"
        sourceSize: Qt.size(width, height)
        opacity: root.highlight ? 1 : 0
        z: -100

        Behavior on opacity { OpacityAnimator { duration: 200; easing.type: Easing.InOutSine }}
    }

    Text {
        anchors.fill: parent
        anchors.margins: root.pageMargin * 2
        font.pixelSize: parent.height * 0.08
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: root.name
        font.family: ViewSettings.appFont
        font.styleName: "SemiBold"
        color: ViewSettings.pine
        wrapMode: Text.WordWrap
        visible: root.highlight
    }
}
