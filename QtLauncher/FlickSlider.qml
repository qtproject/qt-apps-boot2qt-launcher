// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtQuick.Controls.Basic

ScrollBar {
    id: root
    required property real pageMargin
    contentItem: Rectangle {
        color: ViewSettings.scrollBarColor
        implicitWidth: root.orientation === Qt.Horizontal ? root.availableWidth : root.pageMargin * 0.25
        implicitHeight: root.orientation === Qt.Vertical ? root.availableHeight : root.pageMargin * 0.25
        opacity: (root.active && root.size < 1.0) ? 1.0 : 0

        Behavior on opacity { OpacityAnimator { duration: 500 } }
    }
}
