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

Rectangle {

    width: 100
    height: 40

    gradient: Gradient {
        GradientStop { position: 0; color: pressed ? "steelblue" : "white"  }
        GradientStop { position: 1; color: pressed ? "lightsteelblue" : "darkgray" }
    }

    border.color: pressed ? "darkgray" : "lightgray"
    border.width: 1;

    radius: height / 4

    property alias text: label.text
    property alias pressed: mouse.pressed

    signal clicked;

    Text {
        id: label
        color: "black"
        font.pixelSize: parent.size / 2;
        anchors.centerIn: parent;
    }

    MouseArea {
        id: mouse
        anchors.fill: parent

        onClicked: parent.clicked()

    }
}
