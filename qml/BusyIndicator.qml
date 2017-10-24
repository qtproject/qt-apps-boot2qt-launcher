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

        // Fill 1/5 of the circle before starting looping
        NumberAnimation {
            target: circularIndicator
            property: "endAngle"
            from: 0
            to: 72
            duration: 200
        }

        SequentialAnimation {
            loops: Animation.Infinite

            // Fill rest of the circle
            NumberAnimation {
                target: circularIndicator
                property: "endAngle"
                from: 72
                to: 360
                duration: 800
            }

            // Fill 1/5 of the circle and clear previous fill
            ParallelAnimation {
                NumberAnimation {
                    target: circularIndicator
                    property: "startAngle"
                    from: -360
                    to: 0
                    duration: 200
                    onStopped: circularIndicator.startAngle = 0
                }
                NumberAnimation {
                    target: circularIndicator
                    property: "endAngle"
                    from: 360
                    to: 72
                    duration: 200
                }
            }
        }
    }
}
