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
    property int particleLifeTime: 2000;

    SequentialAnimation {
        id: entryAnimation
        NumberAnimation { target: logo; property: "opacity"; to: 1; duration: 500 }

        PauseAnimation { duration: 500 }
        ParallelAnimation {
            ScriptAction { script: {
                    starEmitter.burst(300);
                    sphereEmitter.burst(2000);
                }
            }
            NumberAnimation { target: logo; property: "opacity"; to: 0; duration: 200 }
            SequentialAnimation {
                PauseAnimation { duration: root.particleLifeTime }
                ScriptAction { script: { engine.markIntroAnimationDone(); } }
            }
        }
    }

    Component.onCompleted: {
        if (engine.bootAnimationEnabled) {
            entryAnimation.running = true
        } else {
            engine.markIntroAnimationDone()
        }
    }

    Image {
        id: logo;

        width: engine.centimeter() * 3;
        height: width * sourceSize.height / sourceSize.width;
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -Math.min(engine.screenWidth(), engine.screenHeight()) * 0.1
        source: "images/qt-logo.png"
        opacity: 0
    }

    Text {
        id: label

        anchors.top: logo.bottom
        anchors.topMargin: engine.mm(4)
        anchors.horizontalCenter: logo.horizontalCenter
        font.pixelSize: engine.fontSize() * 1.2
        color: "black"
        text: "Boot to Qt"
        opacity: logo.opacity * 0.5
    }

    ParticleSystem {
        id: sphereSystem;
        anchors.fill: logo

        running: visible && engine.glAvailable

        ImageParticle {
            id: sphereParticle
            source: "images/particle.png"
            color: "#80c342"
            alpha: .9
            colorVariation: 0.0
        }

        Emitter {
            id: sphereEmitter
            anchors.fill: parent
            lifeSpan: root.particleLifeTime
            size: 12
            sizeVariation: 4
            enabled: false

            velocity: PointDirection { xVariation: 0; yVariation: 20; }
            acceleration: PointDirection {
                id: sphereAccel
                yVariation: 0
            }

            shape: MaskShape {
                source: "images/qt-logo-green-mask.png"
            }
        }
    }

    ParticleSystem {
        id: starSystem;
        anchors.fill: logo

        running: visible && engine.glAvailable

        ImageParticle {
            id: starParticle
            source: "images/particle_star2.png"
        }

        Emitter {
            id: starEmitter
            anchors.fill: parent
            lifeSpan: root.particleLifeTime
            size: 24
            sizeVariation: 4
            enabled: false

            velocity: PointDirection { xVariation: 0; yVariation: 0; }
            acceleration: PointDirection {
                id: starAccel
                xVariation: 5000
            }

            shape: MaskShape {
                source: "images/qt-logo-white-mask.png"
            }
        }
    }


}
