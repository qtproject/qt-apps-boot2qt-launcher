/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
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
import QtQuick 2.0

// QTBUG-50992, using customized ScrollBar inside Loader does not work, implement with rectangle
Rectangle {
    property var flickItem
    property bool isVertical: true

    color: viewSettings.scrollBarColor
    anchors.margins: viewSettings.pageMargin * 0.375
    height: isVertical ? flickItem.height * 0.3 : viewSettings.pageMargin * 0.25
    width: isVertical ? viewSettings.pageMargin * 0.25 : flickItem.width * 0.2

    // How much (0...1) the view area covers from the content height/width
    property real visibilityRatio: isVertical ? flickItem.visibleArea.heightRatio : flickItem.visibleArea.widthRatio

    // How many pixels the slider can move in the view area
    property real moveSize: isVertical ? flickItem.height - height : flickItem.width - width

    // Coefficient between x/y position (0...1) and slider move pixels
    property real slideCoefficient: (visibilityRatio < 1) ? (moveSize)/(1 - visibilityRatio) : 1

    // Slider is only visible if view area is smaller than the content
    visible: (visibilityRatio < 1)

    // Actual calculation of the slider position
    x: isVertical ? 0 : slideCoefficient * flickItem.visibleArea.xPosition + flickItem.x
    y: isVertical ? slideCoefficient * flickItem.visibleArea.yPosition + flickItem.y : 0
}
