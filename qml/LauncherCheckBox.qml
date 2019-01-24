/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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
import QtQuick 2.9
import QtQuick.Controls 2.2

CheckBox {
    id: checkBox
    text: qsTr("Flip screen")

    indicator: Rectangle {
        implicitHeight: 26
        implicitWidth: 26
        height: pluginMain.buttonHeight
        width: height
        x: checkBox.leftPadding
        y: parent.height / 2 - height / 2
        color: "transparent"
        border.color: "#9d9faa"
        border.width: 2
        radius: 4

        Image {
            anchors.centerIn: parent
            sourceSize.width: parent.width
            sourceSize.height: parent.height
            width: parent.width * 0.9
            height: width
            source: "icons/checkmark.svg"
            visible: checkBox.checked
            antialiasing: true
            smooth: true
            fillMode: Image.PreserveAspectFit
        }
    }

    contentItem: Text {
        text: checkBox.text
        font.family: appFont
        font.pixelSize: pluginMain.subTitleFontSize
        opacity: enabled ? 1.0 : 0.3
        color: checkBox.down ? "#17a81a" : "#41cd52"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: checkBox.indicator.width + checkBox.spacing
        height: pluginMain.fieldTextHeight
        font.styleName: checkBox.checked ? "Bold" : "Regular"
    }
}
