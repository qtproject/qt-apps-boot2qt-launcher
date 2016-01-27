/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
**
****************************************************************************/
import QtQuick 2.0

Item {

    id: root

    property real size: Math.min(root.width, root.height);
    property int itemsPerScreen: 2
    property int offset: 10

    PathView {
        id: list
        y: 10
        width: parent.width
        height: parent.height

        property real cellWidth: (list.width - (root.itemsPerScreen - 1) /** list.spacing*/) / root.itemsPerScreen
        property real cellHeight: (list.height / root.itemsPerScreen)

        maximumFlickVelocity: 5000
        pathItemCount: list.count

        model: applicationsModel;
        preferredHighlightBegin: 1/(list.count/2)
        preferredHighlightEnd: 1
        currentIndex: -1

        path: Path {
            startX: -list.cellWidth - offset*2; startY: list.y + list.cellHeight/2
            PathLine{ x: (list.cellWidth + offset)*list.count - list.cellWidth - offset*2; y: list.y + list.cellHeight/2}
        }

        highlightMoveDuration: 700

        delegate: ApplicationIcon {
            id: iconRoot;
            width: list.cellWidth
            height: list.cellHeight
            function select() {
                list.currentIndex = index;
            }
           onClicked: {
               select()
           }
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

        onCountChanged: if (count > 0 && currentIndex < 0) currentIndex = 0
    }

    Text {
        id: nameLabel
        x: list.width/4 + engine.mm(2)
        y: list.cellHeight + engine.mm(10)
        width: list.cellWidth - engine.mm(2)
        font.pixelSize: engine.fontSize()
        color: "black"
        font.bold: true
        wrapMode: Text.WordWrap
        textFormat: Text.PlainText
        renderType: Text.NativeRendering
    }

    Text {
        id: descriptionLabel
        width: nameLabel.width
        font.pixelSize: engine.smallFontSize()
        color: "black"
        x: nameLabel.x
        anchors.top: nameLabel.bottom
        anchors.topMargin: engine.fontSize()
        anchors.bottom: parent.bottom
        wrapMode: Text.WordWrap
        textFormat: Text.PlainText
        renderType: Text.NativeRendering
    }
}
