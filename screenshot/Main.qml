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

import Qt.labs.screenshot 1.0
import QtQuick.Window 2.0
import com.qtcompany.B2QtLauncher 1.0


Window
{
    id: root
    visible: true

    width: 1280
    height: 720

    LauncherApplicationsModel {
        id: applicationsModel
        onReady: {
            engine.markApplicationsModelReady();
        }
        Component.onCompleted: {
            //Set the directory to parse for apps
            initialize(applicationSettings.appsRoot);
        }
    }

    LauncherEngine {
        id: engine
        bootAnimationEnabled: applicationSettings.isBootAnimationEnabled
        fpsEnabled: applicationSettings.isShowFPSEnabled
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

                var size = Qt.size(800, 450);
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
                //screenshot.grab(loc + name + "_lr" + ext, smallSize); // low resolution
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
        anchors.margins: 3
        color: "transparent"
        border.color: "black"
        border.width: 3
        visible: !controls.visible
    }

    Rectangle {
        id: whiteOutLine
        anchors.fill: parent
        color: "transparent"
        border.color: "white"
        border.width: 3
        visible: !controls.visible
    }

}
