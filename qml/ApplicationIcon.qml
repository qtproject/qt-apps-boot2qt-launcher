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

    id: appIcon;

    property real offset;

    property real x1: (x - offset) / ListView.view.width * Math.PI;
    property real x2: (x + width - offset) / ListView.view.width * Math.PI;
    property real shift: Math.min(height, width) * 0.05

    signal clicked;

    Image {
        id: preview;
        source: icon
        asynchronous: true
        anchors.fill: parent
        visible: false || !engine.glAvailable
   }

    ShaderEffect {
        id: shader

        visible: preview.status == Image.Ready

        anchors.fill: parent
        property variant source: preview

        property real x1: appIcon.x1;
        property real x2: appIcon.x2 - appIcon.x1;
        property real shift: appIcon.shift;

        property real selection: appIcon.ListView.isCurrentItem ? 1.1 + 0.3 * Math.sin(_t) : 1;
        property real _t;
        NumberAnimation on _t { from: 0; to: 2 * Math.PI; duration: 3000; loops: Animation.Infinite; running: appIcon.ListView.isCurrentItem && shader.visible }

        mesh: "5x2"
        blending: false

        vertexShader:
            "
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;

            uniform highp mat4 qt_Matrix;
            uniform highp float x1;
            uniform highp float x2;
            uniform highp float shift;

            varying highp vec2 v_TexCoord;

            void main() {
                v_TexCoord = qt_MultiTexCoord0;
                highp float modShift = shift * sin(x1 + qt_MultiTexCoord0.x * x2);
                gl_Position = qt_Matrix * (qt_Vertex + vec4(0, mix(modShift, -modShift, qt_MultiTexCoord0.y), 0, 0));
            }
            "

        fragmentShader:
            "
            uniform lowp float qt_Opacity;
            uniform sampler2D source;
            uniform lowp float selection;

            varying highp vec2 v_TexCoord;
            void main() {
                gl_FragColor = vec4(texture2D(source, v_TexCoord).rgb * selection, 1.0) * qt_Opacity;
            }
            "
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            if (appIcon.ListView.isCurrentItem) {
                engine.launchApplication(location, mainFile, name)
            } else {
                appIcon.clicked();
            }
        }
    }

}
