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
