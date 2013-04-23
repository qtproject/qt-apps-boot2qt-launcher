import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    width: image.width
    height: image.height

    Image {
        id: image

        width: engine.centimeter() * 1.5;
        height: width * sourceSize.height / sourceSize.width;

        source: "images/qt-logo.png"
        visible: false
    }

    HighlightShader {
        source: image
        running: true
        interval: 10000
        anchors.fill: image;
    }

    ParticleSystem {
        id: starSystem;

        anchors.fill: image
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
            lifeSpan: 2000
            emitRate: 3
            size: 20
            sizeVariation: 4
            enabled: visible

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
