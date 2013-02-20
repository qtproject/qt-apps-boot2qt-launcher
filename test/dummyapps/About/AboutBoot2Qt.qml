import QtQuick 2.0

Item {

    Title {
        id: title
        text: "Boot2Qt"
    }

    ContentText {
        id: brief
        width: parent.width
        text: "Boot2Qt is the working name for a light-weight UI stack for embedded linux,
               based on the Qt Framework. Boot2Qt places Qt on top of an Android kernel/baselayer
               and offers an elegant means of developing beautiful and performant embedded
               devices."
    }

    Column {
        width: engine.sensibleButtonSize()
        spacing: engine.smallFontSize()

        Box { text: "Application" }
        Box { text: "Qt Framework" }
        Box { text: "Android Baselayer" }
        Box { text: "Embedded Hardware" }
    }

    ContentText {
        id: description
        width: parent.width
        text: "Boot2Qt runs on top of Android 4.0 based kernels and has been tested and verified on
               a number of different hardware configurations, including:
               <ul>
                 <li>Google Nexus 7</li>
                 <li>Beagle Board xM</li>
                 <li>Freescale i.MX 6</li>
               </ul>
               Rough minimal requirements for running Boot2Qt are:
               <ul>
                 <li>256Mb of RAM</li>
                 <li>500Mhz CPU, 1Ghz preferred for 60 FPS velvet UIs</li>
                 <li>OpenGL ES 2.0 support</li>
                 <li>Android 4.0+ compatible hardware</li>
               </ul>
              "
    }


}
