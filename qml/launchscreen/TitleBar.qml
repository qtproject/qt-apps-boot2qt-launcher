import QtQuick 2.0
import QtQuick.Particles 2.0

Rectangle {

    id: titleBar

    width: 600
    height: 50



    gradient: Gradient {
        GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.8); }
        GradientStop { position: 0.05; color: Qt.rgba(1, 1, 1, 0.25); }
        GradientStop { position: 0.3; color: Qt.rgba(0.2, 0.2, 0.2, 0.2); }
        GradientStop { position: 0.95; color: Qt.rgba(1, 1, 1, .2); }
        GradientStop { position: 1; color: Qt.rgba(0, 0, 0, 0.2); }
    }

    Text {
        id: clockText
        anchors.centerIn: parent
        color: "white"
        font.pixelSize: parent.height / 2;
        text: calculateTime();

        function calculateTime() {
            var d = new Date();
            var min = d.getMinutes();
            if (min < 10)
                min = "0" + min;
            var hour = d.getHours();
            if (hour < 10)
                hour = "0" + hour;
            return hour + ":" + min;
        }

        Timer {
            running: true
            interval: 60000
            repeat: true
            onTriggered: {
                clockText.text = clockText.calculateTime();
            }
        }

    }

    Rectangle {
        id: shadow
        width: parent.width
        height: parent.height / 2
        anchors.top: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(0, 0, 0, 0.5); }
            GradientStop { position: 1; color: Qt.rgba(0, 0, 0, 0.0); }
        }
    }

    Image {
        id: qtLogo
        source: "../common/images/qt-logo-small.png"
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        sourceSize.height: parent.height * 0.8
        visible: false
    }


    ShaderEffect {
        id: logoShader

        anchors.fill: qtLogo

        property variant source: qtLogo
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
            running: titleBar.visible
            onTriggered: animation.running = true
        }

        fragmentShader:
            "
            uniform lowp sampler2D source;
            uniform highp float t;
            varying highp vec2 qt_TexCoord0;
            void main() {
                lowp vec4 p = texture2D(source, qt_TexCoord0);
                highp float l = max(0.0, 1.0 - length(qt_TexCoord0.x + qt_TexCoord0.y - t));
                gl_FragColor = p + pow(l, 3.0) * p.w;
            }
            "
    }
}
