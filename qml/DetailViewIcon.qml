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

ApplicationIcon {

    Image {
        id: selectedItem
        anchors.fill: preview
        source: "image://QtImageMask/"
        sourceSize: Qt.size(width, height)
        visible: isSelected
    }

    Text {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: viewSettings.pageMargin
        height: parent.height * 0.2
        font.pixelSize: parent.height * 0.08
        text: name
        font.family: viewSettings.appFont
        font.styleName: "SemiBold"
        color: "white"
        wrapMode: Text.Wrap
        visible: highlight && !isSelected
    }

    Component.onCompleted: {
        if (index == 0)
            clicked(location, mainFile, name, description)
    }
}