import QtQuick 2.0

Rectangle {
    width: 600
    height: 400

    gradient: Gradient {
        GradientStop { position: 0; color: "aquamarine" }
        GradientStop { position: 1; color: "black" }
    }

    Text {
        anchors.centerIn: parent
        text: "Basic Application"
        font.pixelSize: parent.height * 0.1
        color: "white"
        style: Text.Raised
    }
}
