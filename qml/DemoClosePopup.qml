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
import QtDeviceUtilities.QtButtonImageProvider 1.0

Rectangle {
    id: demoClosePopup
    width: parent.width
    height: parent.height
    color: "#09102b"
    opacity: 0.9

    function open()
    {
        visible = true;
    }

    function close()
    {
        visible = false;
    }

    Rectangle {
        id: frame
        color: "#09102b"
        border.color: "#9d9faa"
        border.width: 3
        anchors.centerIn: parent
        width: parent.width * 0.35
        height: parent.height * 0.4

        Column {
            anchors.centerIn: parent
            spacing: viewSettings.pageMargin

            Text {
                id: demoCloseConfirmText
                width: frame.width * 0.75
                height: frame.height * 0.25
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                fontSizeMode: Text.Fit
                minimumPixelSize: 1
                font.pixelSize: frame.width * 0.3
                color: "white"
                font.family: viewSettings.appFont
                font.styleName: "SemiBold"
                text: qsTr("Close the demo?")
            }
            QtButton {
                id: demoCloseConfirm
                height: frame.height * 0.15
                width: frame.width * 0.45
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("CONFIRM")
                borderColor: "transparent"
                fillColor: viewSettings.buttonGreenColor
                onClicked: {
                    root.closeApplication();
                    demoClosePopup.close()
                }
            }
            QtButton {
                height: frame.height * 0.15
                width: frame.width * 0.45
                anchors.horizontalCenter: parent.horizontalCenter
                borderColor: "transparent"
                fillColor: viewSettings.buttonGrayColor
                text: qsTr("CANCEL")
                onClicked: demoClosePopup.close()
            }
        }
    }
}
