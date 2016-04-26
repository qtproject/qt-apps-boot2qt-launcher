/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
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
