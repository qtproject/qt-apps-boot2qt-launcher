// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick

Item {
    id: demoInfoPopup
    required property real pageMargin
    property alias description: tt.text

    function open()
    {
        visible = true;
    }

    function close()
    {
        visible = false;
    }

    Rectangle {
        anchors.fill: parent
        color: ViewSettings.backgroundColor
        opacity: 0.3
    }

    // Prevent user from interacting with the transparent demo on the background
    MouseArea {
        anchors.fill: parent
    }

    Image {
        id: frame
        source : "image://QtButtonImage/20/%1/%1".arg(ViewSettings.pine)
        anchors.centerIn: parent
        width: parent.width * 0.5
        height: parent.height * 0.8
        sourceSize: Qt.size(width, height)

        Image {
            id: builtWithQtIcon
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: demoInfoPopup.pageMargin
            source: "icons/Built_with_Qt_RGB_logo_white.svg"
            height: parent.height * 0.1
            width: height / sourceSize.height * sourceSize.width
        }

        Image {
            anchors.right: parent.right
            anchors.verticalCenter: builtWithQtIcon.verticalCenter
            anchors.margins: demoInfoPopup.pageMargin
            source: "icons/close_icon.svg"
            height: parent.height * 0.1
            width: height / sourceSize.height * sourceSize.width

            MouseArea {
                anchors.fill: parent
                anchors.margins: -demoInfoPopup.pageMargin * 0.5

                onClicked: demoInfoPopup.close()
            }
        }

        Text {
            id: infoTitle
            anchors.top: builtWithQtIcon.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: demoInfoPopup.pageMargin
            verticalAlignment: Text.AlignVCenter
            height: builtWithQtIcon.height
            font.pixelSize: height * 0.8
            color: "white"
            font.family: ViewSettings.appFont
            font.styleName: "SemiBold"
            text: qsTr("About Current Demo")
            wrapMode: Text.WordWrap
        }

        Text {
            id: tt
            anchors.top: infoTitle.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: demoInfoPopup.pageMargin
            font.family: ViewSettings.appFont
            font.styleName: "SemiBold"
            font.pixelSize: infoTitle.font.pixelSize * 0.5
            color: "white"
            text: ""
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }
}
