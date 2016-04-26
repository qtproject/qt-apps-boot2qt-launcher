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

Item {

    id: appIcon;

    property real offset;

    property real x1: (x - offset) / PathView.view.width * Math.PI;
    property real x2: (x + width - offset) / PathView.view.width * Math.PI;
    property real shift: Math.min(height, width) * 0.05

    signal clicked;

    Image {
        id: preview;
        source: icon
        asynchronous: true
        anchors.fill: parent
        visible: false || !engine.glAvailable
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.color: "white"
            border.width: 2
        }
        Rectangle {
            anchors.fill: parent
            anchors.margins: 2
            color: "transparent"
            border.color: "black"
            border.width: 2
        }
    }
    ShaderEffectSource {
        id: source
        sourceItem: preview
    }
    ShaderEffect {
        id: shader

        visible: preview.status == Image.Ready

        anchors.fill: parent
        property variant source: source

        property real x1: appIcon.x1;
        property real x2: appIcon.x2 - appIcon.x1;
        property real shift: appIcon.shift;

        property real selection: appIcon.PathView.isCurrentItem ? 1 : 0.7;
        property real border: 1.0 / height * 3

        Behavior on selection {
            NumberAnimation { duration: 300; }
            enabled: shader.visible
        }

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

            uniform lowp float border;
            varying highp vec2 v_TexCoord;
            void main() {
                lowp float b_max = 1.0 - border;
                lowp float b_min = border;
                if (v_TexCoord.x < b_max && v_TexCoord.x > b_min && v_TexCoord.y < b_max && v_TexCoord.y > b_min) {
                gl_FragColor = vec4(texture2D(source, v_TexCoord).rgb * selection, 1.0) * qt_Opacity;
                } else {
                    gl_FragColor = vec4(texture2D(source, v_TexCoord).rgb * 1.0, 1.0) * qt_Opacity;
                }
            }
            "
    }
    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            if (appIcon.PathView.isCurrentItem) {
                engine.launchApplication(location, mainFile, name)
            } else {
                appIcon.clicked();
            }
        }
    }

}
