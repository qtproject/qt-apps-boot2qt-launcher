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
import QtDeviceUtilities.QtButtonImageProvider 1.0

Item {
    id: detailRoot
    anchors.fill: parent

    Item {
        id: detailInformation
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: listHolder.top
        anchors.margins: viewSettings.pageMargin

        Image {
            id: largeImg
            anchors.right: parent.right
            height: parent.height
            width: height / sourceSize.height * sourceSize.width
            source: ""
        }

        Column {
            id: descriptionHolder
            anchors.left: parent.left
            anchors.right: largeImg.left
            anchors.margins: viewSettings.pageMargin * 0.5
            anchors.rightMargin: viewSettings.pageMargin
            spacing: viewSettings.pageMargin * 0.5

            Text{
                id: descriptionTitle
                font.pixelSize: detailInformation.height * 0.11
                width: descriptionHolder.width
                text: "Demo Title"
                color: "white"
                font.family: viewSettings.appFont
                font.styleName: "SemiBold"
                wrapMode: Text.WordWrap
            }

            Rectangle {
                id: btmLine
                width: parent.width * 0.5
                height: 2
            }
        }

        Text {
            id: descriptionText
            anchors.top: descriptionHolder.bottom
            anchors.bottom: startButton.top
            anchors.left: parent.left
            anchors.margins: viewSettings.pageMargin * 0.5
            font.pixelSize: detailInformation.height * 0.05
            font.family: viewSettings.appFont
            width: descriptionHolder.width
            wrapMode: Text.WordWrap
            color: "white"
            elide: Text.ElideRight
        }
        QtButton {
            id: startButton
            height: detailInformation.height * 0.14
            width: height * 3
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: viewSettings.pageMargin * 0.5
            text: qsTr("START")
            borderColor: "transparent"
            fillColor: viewSettings.buttonGreenColor
            onClicked: root.launchApplication(startButton.loc, startButton.main, startButton.name, startButton.desc)
            property string loc
            property string main
            property string name
            property string desc
        }
    }

    Rectangle {
        id: listHolder
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.35
        color: "black"

        ListView {
            id: thumbList
            anchors.fill: parent
            anchors.margins: viewSettings.pageMargin * 0.5
            orientation: ListView.Horizontal
            model: applicationsModel

            delegate: DetailViewIcon {
                id: iconRoot2
                height: thumbList.height
                width: height
                isSelected: thumbList.currentIndex == index

                onClicked: {
                    descriptionTitle.text = name
                    descriptionText.text = description
                    largeImg.source = "image://QtImage/" + icon

                    startButton.loc = location
                    startButton.main = mainFile
                    startButton.name = name
                    startButton.desc = description

                    thumbList.currentIndex = index
                }
            }
            ScrollBar.horizontal: ScrollBar{
                parent: thumbList.parent
                anchors.bottom: parent.bottom
                anchors.bottomMargin: viewSettings.pageMargin * 0.3
                anchors.left: parent.left
                anchors.leftMargin: viewSettings.pageMargin
                anchors.right: parent.right
                anchors.rightMargin: viewSettings.pageMargin
                size: 0.3
                contentItem: Rectangle{
                    color: "#41cd52"
                    implicitHeight: thumbList.height * 0.03
                }
            }
        }
    }
}
