import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id: appIcon;

    width: 400
    height: 400

//    property bool launching;

//    SequentialAnimation {
//        NumberAnimation { target: appIcon; property: "scale"; duration: 300; to: 0.9; easing.type: Easing.InOutQuad }
//        NumberAnimation { target: appIcon; property: "scale"; duration: 300; to: 1.1; easing.type: Easing.InOutQuad }
//        running: appIcon.launching
//        loops: Animation.Infinite;
//    }

    opacity: (engine.state != "app-launching" && engine.state != "app-running") || engine.activeIcon == appIcon ? 1 : 0.2
    Behavior on opacity { NumberAnimation { duration: 200 } }

    Rectangle {
        id: box;

        x: appIcon.width * 0.2
        y: appIcon.width * 0.1
        width: appIcon.width * 0.6;
        height: appIcon.width * 0.6;

        gradient: Gradient {
            GradientStop { position: 0; color: Qt.rgba(1, 1, 1, 0.2) }
            GradientStop { position: 1; color: Qt.rgba(0, 0, 0, 0.2) }
        }

        radius: appIcon.width * 0.1
        border.width: appIcon.width * 0.02;
        border.color: "white";

        antialiasing: true;

        Image {
            source: iconName != "" ? location + "/" + largeIconName : ""
            anchors.fill: parent
            anchors.margins: parent.width * 0.1
            smooth: true
            asynchronous: true;
        }

        Text {
            color: "white"
            visible: iconName == ""
            font.pixelSize: parent.height * 0.6
            anchors.centerIn: parent
            text: "?"
        }

    }

    MouseArea {
        id: mouse
        anchors.fill: box
        onClicked: engine.launchApplication(location, mainFile, appIcon);
    }

    Text {
        id: label
        anchors.horizontalCenter: box.horizontalCenter
        anchors.top: box.bottom
        anchors.topMargin: box.height * 0.05
        width: box.width

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        color: "white"

        font.pixelSize: box.height * 0.15;
        font.bold: true
        text: name
    }

    Component {
        id: shadow
        DropShadow {
            color: Qt.rgba(0, 0, 0, .6);
            fast: true
            samples: 8
            radius: 16
            spread: 0.7
            verticalOffset: appIcon.width * 0.02
            horizontalOffset: appIcon.width * 0.02
            cached: true
        }
    }

    layer.smooth: engine.hasIconShadows
    layer.enabled: engine.hasIconShadows
    layer.effect: engine.hasIconShadows ? shadow : undefined;

}
