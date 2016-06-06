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
import QtQuick.Particles 2.0

Item {
    id: root

    width: image.width
    height: image.height

    Image {
        id: image

        width: engine.centimeter() * 1.2;
        height: width * sourceSize.height / sourceSize.width;

        source: "images/qt-logo.png"
        visible: !engine.glAvailable
        layer.enabled: true
    }

    HighlightShader {
        source: image
        running: engine.glAvailable
        interval: 10000
        anchors.fill: image;
    }

    ParticleSystem {
        id: starSystem;

        anchors.fill: image
        running: visible && engine.glAvailable

        ImageParticle {
            id: starParticle
            source: "images/particle_star2.png"
            color: "#ffffff"
            alpha: 0
            colorVariation: 0
        }

        Emitter {
            id: starEmitter
            anchors.fill: parent
            lifeSpan: 2000
            emitRate: 3
            size: 20
            sizeVariation: 4
            enabled: visible && engine.glAvailable

            velocity: PointDirection { xVariation: 0; yVariation: 0; }
            acceleration: PointDirection {
                id: starAccel
                y: -10
                xVariation: 5
                yVariation: 5
            }

            shape: MaskShape {
                source: "images/qt-logo-white-mask.png"
            }
        }
    }
}
