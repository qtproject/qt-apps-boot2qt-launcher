/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
**
****************************************************************************/
import QtQuick 2.0

Item {

    id: root

    property real size: Math.min(root.width, root.height);
    property int itemsPerScreen: 2

    ListView {
        id: list
        y: 10
        width: parent.width
        height: parent.height

        property real cellWidth: (list.width - (root.itemsPerScreen - 1) * list.spacing) / root.itemsPerScreen
        property real cellHeight: (list.height / root.itemsPerScreen)

        orientation: ListView.Horizontal

        maximumFlickVelocity: 5000

        model: applicationsModel;

        spacing: 10

        leftMargin: width / 2 - cellWidth / 2
        rightMargin: width / 2 - cellWidth / 2

        highlight: Rectangle { color: "red" }
        highlightFollowsCurrentItem: false
        highlightMoveDuration: 10

        delegate: ApplicationIcon {
            id: iconRoot;

            width: list.cellWidth
            height: list.cellHeight

            offset: list.contentX;

            function select() {
                list.targetContentX = iconRoot.x - (list.width / 2 - list.cellWidth / 2);
                list.targetIndex = index;
                if (Math.abs(list.targetContentX - list.contentX) < 50) {
                    moveAnimation.duration = 50
                } else {
                    moveAnimation.duration = 500
                }
                animateToCenter.running = true;
            }
            onClicked: select()
        }

        property int targetIndex;
        property real targetContentX: 0
        SequentialAnimation {
            id: animateToCenter;
            NumberAnimation { id: moveAnimation; target: list; property: "contentX"; to: list.targetContentX; duration: 300; easing.type: Easing.InOutCubic }
            PropertyAction { target: list; property: "currentIndex"; value: list.targetIndex }
        }

        onCurrentIndexChanged: {
            if (list.currentIndex >= 0) {
                descriptionLabel.text = applicationsModel.query(list.currentIndex, "description");
                nameLabel.text = applicationsModel.query(list.currentIndex, "name");
            } else {
                descriptionLabel.text = ""
                nameLabel.text = ""
            }
        }

        onMovementEnded: {
            var hCenter = mapToItem(contentItem, width / 2, engine.centimeter())
            var demo = itemAt(hCenter.x, hCenter.y)
            if (demo)
                demo.select()
        }

        onCountChanged: if (count > 0 && currentIndex < 0) currentIndex = 0

        MouseArea {
            anchors.fill: parent
            onPressed: {
                animateToCenter.stop()
                mouse.accepted = false
            }
        }
    }

    Text {
        id: nameLabel
        font.pixelSize: engine.fontSize()
        color: "white"
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter;
        y: list.cellHeight + engine.centimeter() * 0.5
        wrapMode: Text.WordWrap
    }

    Text {
        id: descriptionLabel
        font.pixelSize: engine.smallFontSize()
        color: "white"
        anchors.left: parent.left
        anchors.right: logo.left
        anchors.top: nameLabel.bottom
        anchors.bottom: parent.bottom
        anchors.margins: engine.centimeter();
        wrapMode: Text.WordWrap
    }

    GlimmeringQtLogo {
        id: logo
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: width / 4;
    }

}
