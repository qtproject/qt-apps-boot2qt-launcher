import QtQuick 2.0

Item {

    id: appIcon;

    property real offset;

    property real x1: (x - offset) / ListView.view.width * Math.PI;
    property real x2: (x + width - offset) / ListView.view.width * Math.PI;
    property real shift: Math.min(height, width) * 0.05

    signal clicked;

    Image {
        id: preview;
        source: icon
        asynchronous: true
        visible: false
   }

    ShaderEffect {
        id: shader

        visible: preview.status == Image.Ready;

        anchors.fill: parent
        property variant source: preview

        property real x1: appIcon.x1;
        property real x2: appIcon.x2;
        property real shift: appIcon.shift;

        property real selection: appIcon.ListView.isCurrentItem ? 1.1 + 0.3 * Math.sin(_t) : 1;
        property real _t;
        NumberAnimation on _t { from: 0; to: 2 * Math.PI; duration: 3000; loops: Animation.Infinite; running: appIcon.ListView.isCurrentItem && shader.visible }

        mesh: "5x2"
        blending: false

        vertexShader:
            "
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;

            uniform highp mat4 qt_Matrix;
            uniform lowp float x1;
            uniform lowp float x2;
            uniform lowp float shift;

            varying highp vec2 v_TexCoord;
            varying float v_Opacity;

            void main() {
                v_TexCoord = qt_MultiTexCoord0;

                vec4 pos = qt_Vertex;
                float modShift = shift * sin(x1 + qt_MultiTexCoord0.x * (x2 - x1));
                pos.y += mix(modShift, -modShift, qt_MultiTexCoord0.y);

                gl_Position = qt_Matrix * pos;
            }
            "

        fragmentShader:
            "
            uniform lowp float qt_Opacity;
            uniform sampler2D source;
            uniform lowp float selection;

            varying highp vec2 v_TexCoord;
            void main() {
                gl_FragColor = texture2D(source, v_TexCoord) * qt_Opacity * selection;
            }
            "
    }

    ShaderEffect {
        id: reflection

        width: shader.width
        height: shader.height * reflectionRatio

        anchors.top: shader.bottom;
        anchors.topMargin: height * 0.05;

        property real reflectionRatio: 0.7

        opacity: 0.5

        property real x1: appIcon.x1;
        property real x2: appIcon.x2;
        property real shift: appIcon.shift;

        visible: shader.visible
        property variant source: shader.source

        mesh: "8x1"

        vertexShader:
            "
            attribute highp vec4 qt_Vertex;
            attribute highp vec2 qt_MultiTexCoord0;

            uniform highp mat4 qt_Matrix;
            uniform lowp float x1;
            uniform lowp float x2;
            uniform lowp float shift;

            varying highp vec2 v_TexCoord;
            varying float v_Opacity;

            void main() {
                v_TexCoord = vec2(qt_MultiTexCoord0.x, 1.0 - qt_MultiTexCoord0.y);

                vec4 pos = qt_Vertex;
                float modShift = shift * sin(x1 + qt_MultiTexCoord0.x * (x2 - x1));
                pos.y -= modShift;

                gl_Position = qt_Matrix * pos;
            }
            "

        fragmentShader:
            "
            uniform lowp float qt_Opacity;
            uniform sampler2D source;
            varying highp vec2 v_TexCoord;
            void main() {
                gl_FragColor = texture2D(source, v_TexCoord) * qt_Opacity * v_TexCoord.y;
            }
            "
    }

    Image {
        id: playButton
        source: "images/play.png"
        anchors.centerIn: parent
        opacity: appIcon.ListView.isCurrentItem ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            if (appIcon.ListView.isCurrentItem) {
                engine.launchApplication(location, mainFile, name)
            } else {
                appIcon.clicked();
            }
        }
    }

}
