import QtQuick 2.0

Rectangle {
    width: 600
    height: 50

    gradient: Gradient {
        GradientStop { position: 0; color: Qt.rgba(1, 1, 1, 0.5) }
        GradientStop { position: 1; color: Qt.rgba(0.0, 0.0, 0.0, 0.6) }
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
            onTriggered:  clockText.text = calcualteTime();
        }

    }

    Rectangle {
        id: shadow
        width: parent.width
        height: parent.height / 2
        anchors.top: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(0, 0, 0, 0.3); }
            GradientStop { position: 1; color: Qt.rgba(0, 0, 0, 0.0); }
        }
    }

}
