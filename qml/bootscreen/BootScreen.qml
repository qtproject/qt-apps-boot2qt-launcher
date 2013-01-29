import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    property real size: Math.min(root.width, root.height);


    SequentialAnimation {
        id: entryAnimation
        ParallelAnimation {
            SequentialAnimation {
                PropertyAction { target: sphereEmitter; property: "emitRate"; value: 50 }
                PropertyAction { target: sphereSystem; property: "running"; value: true }
                PauseAnimation { duration: 3000 }
                PropertyAction { target: sphereEmitter; property: "emitRate"; value: 200 }
                PropertyAction { target: starSystem; property: "running"; value: true }
                PauseAnimation { duration: 5000 }
                ScriptAction { script: {
                        starAccel.xVariation = 20;
                        starAccel.yVariation = 20;
                        sphereAccel.xVariation = 20
                        sphereAccel.yVariation = 20
                        sphereParticle.alpha = 0;
                    }
                }
                PauseAnimation { duration: 3000 }
                PropertyAction { target: starEmitter; property: "enabled"; value: false }
                PropertyAction { target: sphereEmitter; property: "enabled"; value: false }
                PauseAnimation { duration: 4000 }
            }
            SequentialAnimation {
                PauseAnimation { duration: 5000 }
                NumberAnimation { target: label; property: "opacity"; to: 1; duration: 3000 }
                PauseAnimation { duration: 4000 }
                NumberAnimation { target: label; property: "opacity"; to: 0; duration: 3000 }
            }
        }

        ScriptAction { script: {
                engine.markIntroAnimationDone();
            }
        }

    }

    Component.onCompleted: {
        if (0) {
            engine.markIntroAnimationDone()
        } else {
            entryAnimation.running = true
        }
    }

    Image {
        id: logo;
        source: "../common/images/qt-logo.png"
        width: root.size / 2;
        height: root.size / 2;
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -root.size * 0.1
        smooth: true
        opacity: 0
    }

    Text {
        id: label

        anchors.horizontalCenter: logo.horizontalCenter
        anchors.top: logo.bottom

        font.pixelSize: size * 0.1
        color: "white"
        text: "Boot 2 Qt"
        opacity: 0
    }

    ParticleSystem {
        id: sphereSystem;
        anchors.fill: logo

        running: false

        ImageParticle {
            id: sphereParticle
            source: "../common/images/particle.png"
            anchors.fill: parent
            color: "#80c342"
            alpha: 0
            colorVariation: 0.0
        }

        Emitter {
            id: sphereEmitter
            anchors.fill: parent
            emitRate: 100
            lifeSpan: 5000
            size: 15
            sizeVariation: 8

            velocity: PointDirection { xVariation: 1; yVariation: 1; }
            acceleration: PointDirection {
                id: sphereAccel
                xVariation: 0;
                yVariation: 0;
            }

            shape: MaskShape {
                source: "../common/images/qt-logo.png"
            }
        }
    }

    ParticleSystem {
        id: starSystem;
        anchors.fill: logo

        running: false

        ImageParticle {
            id: starParticle
            source: "../common/images/particle_star.png"
            anchors.fill: parent
            color: "#ffffff"
            alpha: 0
            colorVariation: 0
        }

        Emitter {
            id: starEmitter
            anchors.fill: parent
            emitRate: 200
            lifeSpan: 5000
            size: 24
            sizeVariation: 8

            velocity: PointDirection { xVariation: 1; yVariation: 1; }
            acceleration: PointDirection {
                id: starAccel
                xVariation: 0;
                yVariation: 0;
            }

            shape: MaskShape {
                source: "../common/images/qt-logo-mask.png"
            }
        }
    }
}
