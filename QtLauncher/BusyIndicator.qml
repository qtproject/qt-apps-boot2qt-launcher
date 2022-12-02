// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick
import QtLauncher

CircularIndicator {
    id: circularIndicator
    height: width
    padding: width * 0.1
    lineWidth: width * 0.05
    backgroundColor: ViewSettings.loaderBackgroundColor
    progressColor: ViewSettings.loaderForegroundColor

    SequentialAnimation {
        running: circularIndicator.visible

        // Fill 20 degrees of the circle before starting looping
        NumberAnimation {
            target: circularIndicator
            property: "spanAngle"
            from: 0
            to: 20
            duration: 200
        }

        SequentialAnimation {
            loops: Animation.Infinite

            // Fill the circle, except have both caps still visible
            NumberAnimation {
                target: circularIndicator
                property: "spanAngle"
                from: 20
                to: 345
                duration: 800
            }

            // Clear the circle, except for a 20 degree head start. The head start is to
            // avoid an abrupt change in the cap of the indicator arc from an end to a beginning.
            ParallelAnimation {

                NumberAnimation {
                    target: circularIndicator
                    property: "startAngle"
                    from: 0
                    to: 360
                    duration: 800
                    onStopped: circularIndicator.startAngle = 0
                }

                NumberAnimation {
                    target: circularIndicator
                    property: "spanAngle"
                    from: 345
                    to: 20
                    duration: 800
                }
            }
        }
    }
}
