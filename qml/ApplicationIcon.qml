import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: appIcon;

    width: 400
    height: 400

    Image {
        id: icon
        source: iconName != "" ? location + "/" + iconName : ""
        y: parent.height * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.6;
        height: width
        sourceSize: Qt.size(width, height);
        smooth: true
        asynchronous: true;
        opacity: status == Image.Ready ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
    }

    Image {
        id: replacementIcon
        source: "images/qt-logo.png"
        anchors.fill: icon
        sourceSize: Qt.size(width, height);
        visible: icon.opacity == 0
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: engine.launchApplication(location, mainFile, appIcon);
    }

    Rectangle {
        anchors.fill: label
        anchors.margins: -icon.height * 0.04;
        color: Qt.rgba(0, 0, 0, 0.3);
        radius: icon.height * 0.1
        antialiasing: true
    }

    Text {
        id: label
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: icon.bottom
        anchors.topMargin: parent.height * 0.08;
        width: icon.width

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        color: "white"

        font.pixelSize: engine.smallFontSize();
        font.bold: true
        text: name
        style: Text.Raised
    }


}
