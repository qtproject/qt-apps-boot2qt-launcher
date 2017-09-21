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
    //anchors.fill: parent
    height: width
    startAngle: 0 //speedometer.minValueAngle
    endAngle: 360  //speedometer.maxValueAngle
    minimumValue: 0
    maximumValue: 360//speedometer.maximumValue
    value: 180//speedometer.value
    padding: 23
    backgroundColor: "#848895"
    progressColor: "#41cd52"
    lineWidth: width * 0.1


    SequentialAnimation {
        running: true
        loops: Animation.Infinite
        NumberAnimation {
            target: circularIndicator
            property: "value"
            from: 0
            to: 360
            duration: 1000
        }
        NumberAnimation {
            target: circularIndicator
            property: "startAngle"
            from: 0
            to: 360
            duration: 1000
        }
        ScriptAction {
            script: circularIndicator.startAngle = 0
        }
    }
    RotationAnimator on rotation{
        loops: Animation.Infinite
        duration: 5000
        from: 0
        to: 360
    }
}
