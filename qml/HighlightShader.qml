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

ShaderEffect {
    id: root

    property variant source;

    property alias interval: shaderTrigger.interval
    property bool running: true;

    property real t: -1;
    NumberAnimation on t { id: shaderAnimation; from: -2;  to: 3; duration: 2000; loops: 1; running: false }

    Timer {
        id: shaderTrigger
        repeat: true
        interval: 10000
        running: visible && root.running;
        onTriggered: shaderAnimation.running = true
    }

    fragmentShader:
        "
            uniform lowp sampler2D source;
            uniform highp float t;
            uniform lowp float qt_Opacity;
            varying highp vec2 qt_TexCoord0;
            void main() {
                lowp vec4 p = texture2D(source, qt_TexCoord0) * qt_Opacity;
                highp float l = max(0.0, 1.0 - length(qt_TexCoord0.x + qt_TexCoord0.y - t));
                gl_FragColor = p + pow(l, 3.0) * p.w;
            }
            "
}
