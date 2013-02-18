import QtQuick 2.0

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
        id: button

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: parent.height * 0.2
        width: height

        source: "images/cog.png"

        MouseArea {
            id: buttonMouseArea
            anchors.fill: parent
            anchors.margins: -10
            enabled: engine.state == "running" || engine.state == "settings"
            onClicked: {
                if (engine.state == "settings")
                    engine.state = "running"
                else
                    engine.state = "settings"
            }
        }
    }


}
