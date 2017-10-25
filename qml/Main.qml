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
import QtQml 2.2
import QtQuick 2.6
import QtQuick.Window 2.2

Window {
    id: window

    visible: true
    width: Screen.desktopAvailableWidth
    height: Screen.desktopAvailableHeight

    color: viewSettings.backgroundColor
    property alias appFont: viewSettings.appFont

    ViewSettings {
        id: viewSettings
    }

    Loader {
        id: mainWindowLoader
        anchors.fill: parent
        active: false
        source: "qrc:///qml/MainWindow.qml"
        asynchronous: true
        onLoaded: {
            item.visible = true;
            splashScreenLoader.item.visible = false;
            splashScreenLoader.source = "";
        }
    }

    Loader {
        id: splashScreenLoader
        anchors.fill: parent
        sourceComponent: Item {
            anchors.fill: parent

            Image {
                anchors.fill: parent
                source: "images/backImg.jpg"
                fillMode: Image.PreserveAspectCrop
            }

            BootScreen {
                anchors.fill: parent
                applicationName: qsTr("Qt Launcher")
            }
        }
        onLoaded: {
            mainWindowLoader.active = true;
        }
    }
}
