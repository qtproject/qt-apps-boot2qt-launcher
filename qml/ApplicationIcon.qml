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
import QtQuick.Controls 2.1

Item {
    id: appIcon
    signal clicked(string sLocation, string sMainFile, string sName, string sDescription)
    property bool highlight: false
    property bool isSelected: false
    property alias preview: preview
    property alias hoverSource: hoverItem.source

    Image {
        id: preview;
        anchors.fill: parent
        anchors.margins: viewSettings.pageMargin*0.5
        source: "image://QtSquareImage/" + icon
        sourceSize: Qt.size(width, height)

        Image {
            id: hoverItem
            anchors.fill: parent
            source: "image://QtImageMask/hover/namebox"
            sourceSize: Qt.size(width, height)
            opacity: highlight ? 1.0 : 0.0
            visible: !isSelected && opacity > 0.01

            Behavior on opacity { NumberAnimation { duration: 300 } }
        }
    }


    MouseArea {
        anchors.fill: parent
        onClicked: appIcon.clicked(location, mainFile, name, description)
        hoverEnabled: globalSettings.mouseSelected
        onEntered: {
            if (globalSettings.mouseSelected)
                highlight = true;
        }
        onExited: {
            if (globalSettings.mouseSelected)
                highlight = false
        }
    }
}
