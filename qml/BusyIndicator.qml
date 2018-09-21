/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.4
import Circle 1.0

CircularIndicator {
    id: circularIndicator
    height: width
    padding: 23
    backgroundColor: viewSettings.loaderBackgroundColor
    progressColor: viewSettings.loaderForegroundColor

    SequentialAnimation {
        running: true

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
