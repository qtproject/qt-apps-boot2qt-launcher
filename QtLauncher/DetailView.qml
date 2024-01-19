// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only
pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Basic
import QtLauncher

Item {
    id: detailRoot
    anchors.fill: parent
    property alias appsModel: thumbList.model
    required property real pageMargin

    Item {
        id: detailInformation
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: listHolder.top
        anchors.margins: detailRoot.pageMargin

        CornerFrameImage {
            id: largeImg
            anchors.right: parent.right
            height: parent.height
            width: parent.width * 0.5

            MouseArea {
                anchors.fill: parent
                onClicked: detailRoot.appsModel.launchFromIndex(thumbList.currentIndex)
            }
        }

        Flickable {
            id: detailFlickable
            anchors.left: parent.left
            anchors.right: largeImg.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.bottomMargin: detailRoot.pageMargin * 0.5
            anchors.rightMargin: detailRoot.pageMargin
            contentHeight: descriptionHolder.height
            contentWidth: width
            clip: true

            ScrollBar.vertical: FlickSlider { pageMargin: detailRoot.pageMargin }

            Column {
                id: descriptionHolder
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: detailRoot.pageMargin * 0.5
                spacing: detailRoot.pageMargin * 0.5

                Text {
                    id: descriptionTitle
                    font.pixelSize: detailInformation.height * 0.11
                    width: descriptionHolder.width
                    text: qsTr("Demo Title")
                    color: ViewSettings.neon
                    font.family: ViewSettings.appFont
                    font.styleName: "SemiBold"
                    wrapMode: Text.WordWrap
                }

                Rectangle {
                    id: btmLine
                    width: descriptionTitle.paintedWidth
                    height: 2
                }

                Text {
                    id: descriptionText
                    anchors.margins: detailRoot.pageMargin * 0.5
                    font.pixelSize: detailInformation.height * 0.05
                    font.family: ViewSettings.appFont
                    width: descriptionHolder.width
                    wrapMode: Text.WordWrap
                    color: "white"
                    elide: Text.ElideRight
                }
            }
        }
    }

    Rectangle {
        id: listHolder
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height * 0.35
        color: ViewSettings.demolistBackgroundColor

        ListView {
            id: thumbList
            anchors.fill: parent
            anchors.margins: detailRoot.pageMargin * 0.5
            orientation: ListView.Horizontal
            onCurrentIndexChanged: {
                descriptionTitle.text = model.query(currentIndex, "name")
                descriptionText.text = model.query(currentIndex, "description")
                largeImg.source = model.query(currentIndex, "icon")
            }

            delegate: DetailViewIcon {
                required property var model
                required property int index
                pageMargin: detailRoot.pageMargin
                height: thumbList.height
                width: height
                isSelected: thumbList.currentIndex === index

                onClicked: thumbList.currentIndex = index
            }

            ScrollBar.horizontal: FlickSlider { pageMargin: detailRoot.pageMargin }
        }
    }
}
