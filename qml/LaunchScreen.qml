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
        dragMargin: list.height
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
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
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
