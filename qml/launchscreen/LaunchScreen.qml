import QtQuick 2.0

import "../common"

Item  {

    NoisyGradient {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "#484860" }
            GradientStop { position: 1; color: "#000000" }
        }
    }




}
