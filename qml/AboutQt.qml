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

    Flickable {
        width: parent.width
        height: parent.height
        contentHeight: aboutQtColumn.height
        contentWidth: aboutQtColumn.width
        clip: true

        Column {
            id: aboutQtColumn
            spacing: pluginMain.spacing
            Image {
                height: root.height * 0.125
                source: "icons/qt_logo_green_rgb.svg"
                fillMode: Image.PreserveAspectFit
            }

            Text {
                text: qsTr("This is Qt for Device Creation feature 'Boot to Qt (B2Qt)' Demo Launcher application. " +
                      "In addition to providing a host for various demo applications demonstrating Qt capabilities " +
                      "for embedded use cases, this application itself is manifesting how to create a booting, " +
                      "embedded application and a launcher with Qt on top of various different hardware and operating " +
                      "systems. In other words, this same application can be seen on several different hardware and " +
                      "operating system combinations either as a launchable app from the OS or as a full boot experience.")
                color: "white"
                font.pixelSize: pluginMain.valueFontSize
                font.family: appFont
                width: root.width
                wrapMode: Text.Wrap
            }

            Text {
                text: qsTr("Qt version: ") + engine.qtVersion
                color: "white"
                font.pixelSize: pluginMain.valueFontSize
                font.family: appFont
            }

            Text {
                text: qsTr("Demo Launcher application version: ") + Qt.application.version
                color: "white"
                font.pixelSize: pluginMain.valueFontSize
                font.family: appFont
            }

            Text {
                text: qsTr("The Qt Company")
                color: "white"
                font.pixelSize: pluginMain.subTitleFontSize
                font.family: appFont
            }

            Text {
                text: qsTr("The Qt Company develops and delivers the Qt development framework " +
                           "under commercial and open source licenses. We enable the reuse of " +
                           "software code across all operating systems, platforms and screen " +
                           "types, from desktops and embedded systems to wearables and mobile " +
                           "devices. Qt is used by approximately one million developers worldwide " +
                           "and is the platform of choice for in-vehicle digital cockpits, " +
                           "automation systems, medical devices, Digital TV/STB and other " +
                           "business critical applications in 70+ industries. With more than 250 " +
                           "employees worldwide, the company is headquartered in Espoo, Finland " +
                           "and is listed on Nasdaq Helsinki Stock Exchange. To learn more visit " +
                           "http://qt.io")
                color: "white"
                font.pixelSize: pluginMain.valueFontSize
                font.family: appFont
                width: root.width
                wrapMode: Text.Wrap
            }
        }
    }
}
