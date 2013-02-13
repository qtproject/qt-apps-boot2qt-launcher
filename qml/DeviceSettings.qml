import QtQuick 2.0


Column {

    spacing: engine.fontSize()

    width: parent.width;
    property real labelWidth: engine.sensibleButtonSize() * 2;

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        width: labelWidth;
        height: width / 4;
        text: "Power Off!"
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        width: labelWidth;
        height: width / 4;
        text: "Reboot!"
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 1
        height: engine.fontSize() * 1.2
        Text {  anchors.right: parent.left; anchors.margins: engine.fontSize(); font.pixelSize: engine.fontSize(); color: "white"; text: "Brightness:" }
        Slider { anchors.left: parent.right; width: labelWidth; height: engine.fontSize(); onValueChanged: print("value is now: " + value)}
    }



}

