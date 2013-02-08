import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: appIcon;

    width: 400
    height: 400

    opacity: (engine.state != "app-launching" && engine.state != "app-running") || engine.activeIcon == appIcon ? 1 : 0.2
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Image {
        id: icon
        source: iconName != "" ? location + "/" + iconName : ""
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.6;
        height: width
        sourceSize: Qt.size(width, height);
        smooth: true
        asynchronous: true;
        scale: mouse.pressed ? 1.1 : 1
        opacity: mouse.pressed ? 0.8 : 1
    }

    Text {
        color: "white"
        visible: iconName == ""
        font.pixelSize: parent.height * 0.6
        anchors.centerIn: icon
        text: "?"
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: engine.launchApplication(location, mainFile, appIcon);
    }

    Rectangle {
        anchors.fill: label
        anchors.topMargin: - icon.height * 0.05;
        anchors.bottomMargin: - icon.height * 0.05;
        color: Qt.rgba(0, 0, 0, 0.3);
        radius: icon.height * 0.1
        antialiasing: true
    }

    Text {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: icon.bottom
        anchors.topMargin: icon.height * 0.05
        width: icon.width

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        color: "white"

        font.pixelSize: 18;
        font.bold: true
        text: name
        style: Text.Raised
    }


}
