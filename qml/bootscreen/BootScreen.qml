import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    property real size: Math.min(root.width, root.height);

    SequentialAnimation {
        id: entryAnimation
        NumberAnimation { target: logo; property: "opacity"; from: 0; to: 1; duration: 2000; easing.type: Easing.InOutQuad }
        PropertyAction { target: starSystem; property: "running"; value: true }
        PauseAnimation { duration: 1000 }
        NumberAnimation { target: label; property: "opacity"; from: 0; to: 1; duration: 5000; easing.type: Easing.InOutQuad }
        ScriptAction { script: { engine.markIntroAnimationDone(); } }
    }

    Component.onCompleted: {
        if (1) {
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
        id: starSystem;
        anchors.fill: logo

        running: false

        ImageParticle {
            source: "../common/images/particle_star.png"
            anchors.fill: parent
            color: "white"
            alpha: 0
            colorVariation: 0.2
        }

        Emitter {
            id: starEmitter
            anchors.fill: parent
            emitRate: 100
            lifeSpan: 1500
            size: 16
            sizeVariation: 8

            velocity: PointDirection { xVariation: 10; yVariation: 10; }
            acceleration: PointDirection {xVariation: 10; yVariation: 10; }

            shape: MaskShape {
                source: "../common/images/qt-logo-mask.png"
            }
        }
    }
}
