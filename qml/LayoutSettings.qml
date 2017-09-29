/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.0

Item {
    id: root
    property string title: qsTr("Display Settings")
    property int titleWidth: width * 0.382
    property int margin: root.width * 0.05
    property int buttonSize: height * 0.15

    property bool gridSelected: globalSettings.gridSelected
    property bool mouseSelected: globalSettings.mouseSelected

    onGridSelectedChanged: updateTimer.start()
    onMouseSelectedChanged: updateTimer.start();

    Timer {
        id: updateTimer
        interval: 10
        onTriggered: {
            globalSettings.gridSelected = root.gridSelected
            globalSettings.mouseSelected = root.mouseSelected
        }
    }

    Column {
        spacing: root.margin * 0.2

        Text {
            color: "white"
            text: qsTr("Layout")
            font.pixelSize: pluginMain.subTitleFontSize
            font.family: appFont
        }

        Row {
            id: layoutRow
            spacing: root.margin

            ImageTextDelegate {
                height: root.buttonSize
                width: height
                onClicked: root.gridSelected = true
                sourceSelected: "icons/grid_icon.svg"
                sourceDisabled: "icons/grid_icon_disabled.svg"
                selected: root.gridSelected
                text: qsTr("GRID")
            }

            ImageTextDelegate {
                height: root.buttonSize
                width: height
                onClicked: root.gridSelected = false
                sourceSelected: "icons/detail_icon.svg"
                sourceDisabled: "icons/detail_icon_disabled.svg"
                selected: !root.gridSelected
                text: qsTr("DETAIL")
            }
        }

        Item {
            height: root.margin
            width: 1
        }

        Text {
            color: "white"
            text: qsTr("Input")
            font.pixelSize: pluginMain.subTitleFontSize
            font.family: appFont
        }

        Row {
            id: inputRow
            spacing: root.margin

            ImageTextDelegate {
                height: root.buttonSize
                width: height
                onClicked: root.mouseSelected = true
                sourceSelected: "icons/mouse_icon.svg"
                sourceDisabled: "icons/mouse_icon_disabled.svg"
                selected: root.mouseSelected
                text: qsTr("MOUSE")
            }
            ImageTextDelegate {
                id: detailButton
                height: root.buttonSize
                width: height
                onClicked: root.mouseSelected = false
                sourceSelected: "icons/touch_icon.svg"
                sourceDisabled: "icons/touch_icon_disabled.svg"
                selected: !root.mouseSelected
                text: qsTr("TOUCH")
            }
        }
    }
}
