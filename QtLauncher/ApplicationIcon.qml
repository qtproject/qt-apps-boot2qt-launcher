// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick

Item {
    id: appIcon
    required property string name
    required property string icon
    required property real pageMargin

    property bool highlight: false
    property bool isSelected: false
    property alias preview: previewImage
    property alias hoverSource: hoverItem.source

    signal clicked()

    Image {
        id: previewImage;
        anchors.fill: parent
        anchors.margins: appIcon.pageMargin * 0.5
        source: appIcon.highlight ? "image://QtSquareImage/%1".arg(appIcon.icon) :
                            "image://QtSquareImage/gradient/%1".arg(appIcon.icon)
        sourceSize: Qt.size(width, height)

        Image {
            id: hoverItem
            anchors.fill: parent
            source: "image://QtImageMask/hover"
            sourceSize: Qt.size(width, height)
            opacity: appIcon.highlight ? 1.0 : 0.0
            visible: !appIcon.isSelected && appIcon.highlight
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: SettingsManager.mouseSelected

        onClicked: appIcon.clicked()

        onEntered: {
            if (hoverEnabled)
                appIcon.highlight = true;
        }
        onExited: {
            if (hoverEnabled)
                appIcon.highlight = false
        }
    }
}
