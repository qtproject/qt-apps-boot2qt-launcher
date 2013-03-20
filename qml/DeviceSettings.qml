import QtQuick 2.0
import QtDroid.Utils 1.0

Column {

    spacing: engine.fontSize()
    width: parent.width;
    property real labelWidth: Math.min(engine.sensibleButtonSize() * 2, width * 0.45);

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        width: labelWidth;
        height: width / 4;
        text: "Power Off!"
        onClicked: DroidUtils.powerOffSystem();
    }

    Button {
        anchors.horizontalCenter: parent.horizontalCenter
        width: labelWidth;
        height: width / 4;
        text: "Reboot!"
        onClicked: DroidUtils.rebootSystem();
    }

    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: 1
        height: engine.fontSize() * 1.2
        Text {
            id: label
            anchors.right: parent.left;
            anchors.margins: engine.fontSize();
            font.pixelSize: engine.fontSize();
            color: "white";
            text: "Brightness:"
        }
        Slider {
            anchors.left: parent.right;
            width: label.width;
            height: engine.fontSize();
            Component.onCompleted: initialValue = 0.5;
            onValueChanged: DroidUtils.setDisplayBrightness(3 + value * 252);
        }
    }



}

