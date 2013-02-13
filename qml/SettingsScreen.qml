import QtQuick 2.0
import QtQuick.Particles 2.0

Item {
    id: root

    property real labelWidth: engine.sensibleButtonSize() * 2;
    property real contentHeight: engine.fontSize() * 1.2

    //    onHeightChanged: print("grid height is: " + height);


    //    model: 1;

    //    delegate:

    //        Component {
    //            id: settingsContent;

    Column {
        id: column;
        width: root.width
        spacing: engine.fontSize()

        Item {
            width: root.width
            height: engine.titleBarSize();
        }

        Loader {
            source: "DeviceSettings.qml"
            width: parent.width
        }

        Item {
            anchors.horizontalCenter: parent.horizontalCenter;
            width: 1
            height: root.contentHeight
            Text {  anchors.right: parent.left; anchors.margins: engine.fontSize(); font.pixelSize: engine.fontSize(); color: "white"; text: "Show FPS:" }
            CheckBox { anchors.left: parent.right; width: engine.fontSize(); height: width; onCheckedChanged: engine.fpsEnabled = checked; checked: engine.fpsEnabled }
        }

        Item {
            anchors.horizontalCenter: parent.horizontalCenter

            width: 1;
            height: root.contentHeight;
            Text { anchors.right: parent.left; anchors.margins: engine.fontSize(); font.pixelSize: engine.fontSize(); color: "white"; text: "Qt Version:" }
            Text { anchors.left: parent.right; font.pixelSize: engine.fontSize(); color: "white"; text: engine.qtVersion }
        }

        ShaderEffect {
            id: logoShader

            width: source.width
            height: source.height

            anchors.horizontalCenter: parent.horizontalCenter

            property variant source: Image { source: "images/codeless.png" }

            property real t: -1;
            NumberAnimation on t {
                id: animation;
                from: -2;
                to: 3;
                duration: 2000;
                loops: 1
                running: false
            }
            Timer {
                id: shaderTrigger
                repeat: true
                interval: 10000
                running: root.opacity > 0
                onTriggered: animation.running = true
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

            ParticleSystem {
                id: sphereSystem;
                anchors.fill: logoShader

                z: -1

                MouseArea {
                    id: particleTrigger
                    anchors.fill: parent
                    onClicked: emitter.burst(100);
                }

                running: root.opacity > 0

                ImageParticle {
                    source: "images/particle.png"
                    anchors.fill: parent
                    color: "white"
                    alpha: 0
                    colorVariation: 0.0
                    entryEffect: ImageParticle.None
                }

                Emitter {
                    id: emitter
                    anchors.fill: parent
                    enabled: false
                    lifeSpan: 5000
                    size: 8
                    sizeVariation: 4

                    velocity: PointDirection { xVariation: 40; yVariation: 30; y: -40 }
                    acceleration: PointDirection {
                        id: sphereAccel
                        xVariation: 5;
                        yVariation: 5;
                        y: 60
                    }

                    shape: MaskShape {
                        source: "images/codeless.png"
                    }
                }
            }


        }


    }

}
