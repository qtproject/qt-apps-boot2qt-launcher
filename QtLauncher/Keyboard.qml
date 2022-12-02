// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick.VirtualKeyboard

InputPanel {
    visible: active
    y: active ? parent.height - height : parent.height
    anchors.left: parent.left
    anchors.right: parent.right
}
