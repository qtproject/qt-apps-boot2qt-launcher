// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic

Item {
    id: gridroot
    anchors.fill: parent
    property alias appsModel: grid.model
    required property real pageMargin

    GridView {
        id: grid
        anchors.fill: parent
        anchors.leftMargin: gridroot.pageMargin * 1.5
        anchors.rightMargin: gridroot.pageMargin * 0.5
        cacheBuffer: 10000
        cellWidth: width / 3
        cellHeight: cellWidth

        ScrollBar.vertical: FlickSlider { pageMargin: gridroot.pageMargin }

        delegate: GridViewIcon {
            required property var model
            required property int index

            pageMargin: gridroot.pageMargin
            height: grid.cellHeight *.9
            width: grid.cellWidth *.9
            onClicked: gridroot.appsModel.launchFromIndex(index)
        }
    }
}
