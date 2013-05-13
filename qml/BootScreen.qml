import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    property real size: Math.min(root.width, root.height);

    property int particleLifeTime: 2000;

    SequentialAnimation {
        id: entryAnimation
        NumberAnimation { target: logo; property: "opacity"; to: 1; duration: 500 }

//        NumberAnimation { target: logo; property: "t"; from: 0; to: 5; duration: 2000; easing.type: Easing.InCubic }

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
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -root.size * 0.1 + Math.random() * t;
        anchors.horizontalCenterOffset: Math.random() * t;
        source: "images/qt-logo.png"
        opacity: 0

        property real t;

    }

    Text {
        id: label

        anchors.centerIn: parent
        anchors.verticalCenterOffset: -root.size * 0.1 + logo.height / 2 + 20

        font.pixelSize: size * 0.04
        color: "white"
        text: "Boot to Qt"
        opacity: logo.opacity * 0.5
    }

    ParticleSystem {
        id: sphereSystem;
        anchors.fill: logo

        running: visible

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

        running: visible


        ImageParticle {
            id: starParticle
            source: "images/particle_star.png"
            color: "#ffffff"
            alpha: 0
            colorVariation: 0
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
