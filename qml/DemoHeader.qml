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

Rectangle {
    id: demoHeaderBar
    width: parent.width
    height: viewSettings.demoHeaderHeight
    color: viewSettings.backgroundColor
    opacity: 0.9
    y: 0
    z: 1
    visible: engine.state === "app-running"
    Behavior on y { NumberAnimation { duration: 100 } }

    property bool open: y > -height/2

    signal infoClicked()
    signal closeClicked()

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: viewSettings.pageMargin * 0.3
        spacing: viewSettings.pageMargin

        Image {
            id: headerLogo
            source: "icons/qt_logo_green_rgb.svg"
            height: parent.height
            width: height / sourceSize.height * sourceSize.width
        }

        Text {
            id: demoName
            height: parent.height
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: parent.height * 0.5
            font.family: viewSettings.appFont
            font.styleName: "SemiBold"
            color: "white"
            text: engine.applicationName
        }
    }

    Row {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: viewSettings.pageMargin * 0.3
        spacing: viewSettings.pageMargin

        Image {
            id: infoImg
            height: parent.height
            width: height
            source: "icons/info_icon.svg"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -parent.height * 0.2
                onClicked: demoHeaderBar.infoClicked()
            }
        }

        Image {
            id: applicationCloseButton
            objectName: "applicationCloseButton"
            height: parent.height
            width: height
            source: "icons/close_icon.svg"
            MouseArea {
                anchors.fill: parent
                anchors.margins: -parent.height * 0.2
                onClicked: demoHeaderBar.closeClicked()
            }
        }
    }

    Image {
        id: headerToggleButton
        source: "icons/header_toggle_icon.svg"
        height: parent.height * 0.5
        width: height / sourceSize.height * sourceSize.width
        anchors.horizontalCenter: parent.horizontalCenter
        y: open ? parent.height - height/2 : parent.height
        rotation: open ? 180 : 0

        Behavior on rotation { NumberAnimation { duration: 100 } }
        Behavior on y { NumberAnimation { duration: 100 } }

        MouseArea {
            anchors.fill: parent
            anchors.margins: -parent.height * 0.5
            drag.target: demoHeaderBar
            drag.axis: Drag.YAxis
            drag.minimumX: -demoHeaderBar.height
            drag.maximumY: 0

            onClicked: {
                if (demoHeaderBar.y < -demoHeaderBar.height / 2)
                    demoHeaderBar.y = 0
                else
                    demoHeaderBar.y = -demoHeaderBar.height
            }
            onReleased: demoHeaderBar.y = demoHeaderBar.y > -demoHeaderBar.height / 4 ? 0 : -demoHeaderBar.height
        }
    }
}
