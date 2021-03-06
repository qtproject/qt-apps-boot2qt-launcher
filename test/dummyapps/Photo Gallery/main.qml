/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://www.qt.io/
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.0
import Qt.labs.folderlistmodel 1.0

Item {
    id: root

    width: 320
    height: 480

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    FolderListModel {
        id: imageList
        folder: "/data/images"
        nameFilters: ["*.png", "*.jpg"]
    }

    GridView {
        id: grid

        anchors.fill: parent

        cellHeight: root.width / 3
        cellWidth: cellHeight

        model: imageList

//        NumberAnimation on contentY { from: 0; to: 2000; duration: 3000; loops: 1; easing.type: Easing.InOutCubic }

        delegate: Rectangle {

            id: box
            color: "white"
            width: grid.cellWidth
            height: grid.cellHeight
            scale: 0.97
            rotation: 2;
            antialiasing: true

            Rectangle {
                id: sepia
                color: "#b08050"
                width: image.width
                height: image.height
                anchors.centerIn: parent

                property real fakeOpacity: image.status == Image.Ready ? 1.5 : 0
                Behavior on fakeOpacity { NumberAnimation { duration: 1000 } }

                opacity: fakeOpacity
                visible: image.opacity <= 0.99;
                antialiasing: true
            }

            Image {
                id: image
                source: filePath
                width: grid.cellWidth * 0.9
                height: grid.cellHeight * 0.9
                anchors.centerIn: sepia
                asynchronous: true
                opacity: sepia.fakeOpacity - .5
                sourceSize.width: width;
                antialiasing: true
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    print("doing stuff..")
                    root.showBigImage(filePath, box.x - grid.contentX, box.y - grid.contentY, image);
                }
            }
        }
    }

    function showBigImage(filePath, itemX, itemY, image) {
        fakeBigImage.x = itemX;
        fakeBigImage.y = itemY;
        fakeBigImage.sourceSize = image.sourceSize;
        fakeBigImage.source = filePath;

        print("painted sizes: ", fakeBigImage.paintedHeight, fakeBigImage.paintedWidth)

        beginEnterLargeAnimation.running = true;
    }

    property int time: 500;
    property real xPos: width < height ? 0 : width / 2 - height / 2;
    property real yPos: width < height ? height / 2 - width / 2: 0;
    property real size: Math.min(width, height);

    states: [
        State { name: "grid" },
        State { name: "enter-large" },
        State { name: "large" },
        State { name: "exit-large" }
    ]

    SequentialAnimation {
        id: beginEnterLargeAnimation
        PropertyAction { target: mouseArea; property: "enabled"; value: "true" }
        PropertyAction { target: fakeBigImage; property: "rotation"; value: 2; }
        PropertyAction { target: fakeBigImage; property: "scale"; value: 0.97 * 0.9; }
        PropertyAction { target: fakeBigImage; property: "width"; value: grid.cellWidth; }
        PropertyAction { target: fakeBigImage; property: "height"; value: grid.cellHeight; }
        PropertyAction { target: fakeBigImage; property: "visible"; value: true; }

        ParallelAnimation {
            NumberAnimation { target: fakeBigImage; property: "rotation"; to: 0; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "scale"; to: 1; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "x"; to: root.xPos; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "y"; to: root.yPos; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "width"; to: root.size; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "height"; to: root.size; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: grid; property: "opacity"; to: 0; duration: root.time; easing.type: Easing.InOutCubic }
        }
        ScriptAction {
            script: {

                bigImage = realBigImageComponent.createObject(root);
                bigImage.source = fakeBigImage.source;
            }
        }
    }

    property Item bigImage;
    property real targetRotation: 0;
    property real targetWidth: 0
    property real targetHeight: 0
    property bool bigImageShowing: false;

    SequentialAnimation {
        id: finalizeEnterLargeAnimation
        ScriptAction { script: {
                fakeBigImage.anchors.centerIn = root;
            }
        }
        ParallelAnimation {
            NumberAnimation { target: bigImage; property: "opacity"; to: 1; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "rotation"; to: root.targetRotation; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: bigImage; property: "rotation"; to: root.targetRotation; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "width"; to: root.targetWidth; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: fakeBigImage; property: "height"; to: root.targetHeight; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: bigImage; property: "width"; to: root.targetWidth; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: bigImage; property: "height"; to: root.targetHeight; duration: root.time; easing.type: Easing.InOutCubic }
        }
        PropertyAction { target: fakeBigImage; property: "visible"; value: false }
        PropertyAction { target: root; property: "bigImageShowing"; value: true }
    }

    SequentialAnimation {
        id: backToGridAnimation
        ParallelAnimation {
            NumberAnimation { target: bigImage; property: "opacity"; to: 0; duration: root.time; easing.type: Easing.InOutCubic }
            NumberAnimation { target: grid; property: "opacity"; to: 1; duration: root.time; easing.type: Easing.InOutCubic }
        }
        PropertyAction { target: fakeBigImage; property: "source"; value: "" }
        PropertyAction { target: root; property: "bigImageShowing"; value: false }
        PropertyAction { target: mouseArea; property: "enabled"; value: false }
        ScriptAction { script: {
                bigImage.destroy();
                fakeBigImage.anchors.centerIn = undefined
            }
        }
    }

    Image {
        id: fakeBigImage
        width: grid.cellWidth
        height: grid.cellHeight
        visible: false
        antialiasing: true
    }

    Component {
        id: realBigImageComponent

        Image {
            id: realBigImage

            anchors.centerIn: parent;

            asynchronous: true;

            // Bound size to the current display size, to try to avoid any GL_MAX_TEXTURE_SIZE issues.
            sourceSize: Qt.size(Math.max(root.width, root.height), Math.max(root.width, root.height));

            opacity: 0
            onStatusChanged: {

                if (status != Image.Ready)
                    return;

                var imageIsLandscape = width > height;
                var screenIsLandscape = root.width > root.height;

                var targetScale;

                // Rotation needed...
                if (imageIsLandscape != screenIsLandscape) {
                    root.targetRotation = 90;
                    var aspect = width / height
                    var screenAspect = root.height / root.width
                    print("Aspect ratios in portrait: ", aspect, screenAspect);

                    if (aspect > screenAspect) {
                        targetScale = root.height / width
                    } else {
                        targetScale = root.width / height;
                    }
                } else {
                    root.targetRotation = 0;
                    var aspect = height / width;
                    var screenAspect = root.height / root.width
                    print("Aspect ratios in portrait: ", aspect, screenAspect);

                    if (aspect > screenAspect) {
                        targetScale = root.height / height
                    } else {
                        targetScale = root.width / width;
                    }
                }

                root.targetWidth = width * targetScale
                root.targetHeight = height * targetScale;

                width = root.size
                height = root.size;

                print("BigImage size: ", width, height, targetWidth, targetHeight);

                finalizeEnterLargeAnimation.running = true;
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: false

        onClicked: {
            if (root.bigImageShowing)
                backToGridAnimation.running = true;
        }
    }

}
