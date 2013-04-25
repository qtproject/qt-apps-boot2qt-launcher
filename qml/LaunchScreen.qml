import QtQuick 2.0

Item {

    id: root

    property real size: Math.min(root.width, root.height);
    property int itemsPerScreen: 2

    ListView {
        id: list
        y: 10
        width: parent.width
        height: parent.height / root.itemsPerScreen

        orientation: ListView.Horizontal

        maximumFlickVelocity: 5000

        model: applicationsModel;

        spacing: 10

        delegate: ApplicationIcon {

            width: (list.width - (root.itemsPerScreen - 1) * list.spacing) / root.itemsPerScreen
            height: list.height

            offset: list.contentX;

            onClicked: {
                list.currentIndex = index;
                list.startOffset = list.contentX;
            }

        }

        property int startOffset: 0;
        onContentXChanged: {
            if (list.currentIndex >= 0 && Math.abs(startOffset - contentX) > list.width / root.itemsPerScreen) {
                list.currentIndex = -1;
            }
        }

        onCurrentIndexChanged: {
            if (list.currentIndex >= 0) {
                descriptionLabel.text = applicationsModel.query(list.currentIndex, "description");
                nameLabel.text = applicationsModel.query(list.currentIndex, "name");
            } else {
                descriptionLabel.text = ""
                nameLabel.text = ""
            }
        }
    }

    Text {
        id: nameLabel
        font.pixelSize: engine.fontSize()
        color: "white"
        font.bold: true

        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: list.bottom
        anchors.topMargin: engine.centimeter() * 2;

        wrapMode: Text.WordWrap
    }

    Text {
        id: descriptionLabel
        font.pixelSize: engine.smallFontSize()
        color: "white"

        anchors.left: parent.left
        anchors.right: logo.left
        anchors.top: nameLabel.bottom
        anchors.bottom: parent.bottom
        anchors.margins: engine.centimeter();

        wrapMode: Text.WordWrap
    }

    GlimmeringQtLogo {
        id: logo

        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.margins: width / 4;
    }

}
