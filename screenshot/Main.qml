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

import Qt.labs.screenshot 1.0

Item
{
    id: root;

    width: 1280
    height: 720

    Connections {
        target: applicationsModel
        onReady: listView.listIndex = 0;
    }

    ListView {
        id: listView

        anchors.fill: parent;

        model: applicationsModel

        delegate: Loader {
            width: root.width
            height: root.height
            source: location + "/main.qml";
            focus: false
            clip: true
        }

        interactive: false

        property int listIndex: -1;
        onListIndexChanged: positionViewAtIndex(listIndex, ListView.Beginning);
        function next() {
            if (listIndex < count - 1)
                ++listIndex;
            print("next: updating list index to: ", listIndex, count);
        }
        function previous() {
            if (listIndex > 0)
                --listIndex;
            print("prev: updating list index to: ", listIndex);
        }

    }

    ScreenShot {
        id: screenshot;
    }

    SequentialAnimation {
        id: grabAnimation;
        PropertyAction{ target: controls; property: "visible"; value: false }
        PauseAnimation { duration: 100 }
        ScriptAction {
            script: {
                var isPortrait = root.width < root.height;

                var size = Qt.size(400, 225);
                var smallSize = Qt.size(128, 72);
                var loc = applicationsModel.locationAt(listView.listIndex) + "/"
                var name = "preview_l"
                var ext = ".jpg"

                if (isPortrait) {
                    name = "preview_p"
                    size = Qt.size(400, 225);
                    smallSize = Qt.size(128, 72);
                }

                screenshot.grab(loc + name + ext, size); // medium resolution
                screenshot.grab(loc + name + "_lr" + ext, smallSize); // low resolution
            }
        }
        PauseAnimation { duration: 100 }
        PropertyAction { target: controls; property: "visible"; value: true }
    }

    Item {
        id: controls

        height: 40
        width: parent.width

        Button {
            id: prevButton
            width: 100
            text: "<<";
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2

            onClicked: listView.previous();
        }

        Button {
            id: nextButton
            width: 100
            height: parent.height
            text: ">>";

            anchors.right: parent.right
            anchors.margins: 2
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            onClicked: listView.next();
        }

        Button {
            text: 'Grab: "' + applicationsModel.nameAt(listView.listIndex) + '"'
            height: parent.height
            anchors.left: prevButton.right
            anchors.right: nextButton.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: 2

            onClicked: {
                grabAnimation.running = true;
            }
        }
    }

    Rectangle {
        id: blackOutLine
        anchors.fill: parent
        color: "transparent"
        border.color: "black"
        border.width: 3
        visible: !controls.visible
    }

}
