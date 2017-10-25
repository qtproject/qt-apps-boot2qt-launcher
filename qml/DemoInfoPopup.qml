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
import QtQuick.Controls 2.2

Rectangle {
    id: demoInfoPopup
    width: parent.width
    height: parent.height
    color: viewSettings.backgroundColor
    opacity: 0.9

    // Prevent user from interacting with the transparent demo on the background
    MouseArea {
        anchors.fill: parent
    }

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
        color: viewSettings.backgroundColor
        border.color: viewSettings.borderColor
        border.width: 3
        anchors.centerIn: parent
        width: parent.width * 0.5
        height: parent.height * 0.8

        Image {
            id: builtWithQtIcon
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: viewSettings.pageMargin
            source: "icons/Built_with_Qt_RGB_logo_white.svg"
            height: parent.height * 0.1
            width: height / sourceSize.height * sourceSize.width
        }

        Image {
            anchors.right: parent.right
            anchors.verticalCenter: builtWithQtIcon.verticalCenter
            anchors.margins: viewSettings.pageMargin
            source: "icons/close_icon.svg"
            height: parent.height * 0.1
            width: height / sourceSize.height * sourceSize.width
            MouseArea {
                anchors.fill: parent
                anchors.margins: -viewSettings.pageMargin * 0.5
                onClicked: demoInfoPopup.close()
            }
        }

        Text {
            id: infoTitle
            anchors.top: builtWithQtIcon.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: viewSettings.pageMargin
            verticalAlignment: Text.AlignVCenter
            height: builtWithQtIcon.height
            font.pixelSize: height * 0.8
            color: "white"
            font.family: viewSettings.appFont
            font.styleName: "SemiBold"
            text: qsTr("About Current Demo")
        }

        Flickable {
            id: flickable
            anchors.top: infoTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: viewSettings.pageMargin
            contentWidth: tt.width
            contentHeight: tt.height
            flickableDirection: Flickable.VerticalFlick
            clip: true

            Text {
                id: tt
                font.family: viewSettings.appFont
                font.styleName: "SemiBold"
                font.pixelSize: infoTitle.font.pixelSize * 0.5
                color: "#bbbbbb"
                text: engine.applicationDescription
                width: frame.width * 0.9
                wrapMode: Text.WordWrap
            }
        }

        FlickSlider {
            flickItem: flickable
            anchors.right: frame.right
            width: viewSettings.pageMargin * 0.5
        }
    }
}
