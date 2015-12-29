/****************************************************************************
**
** Copyright (C) 2015 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
**
****************************************************************************/
import QtQuick 2.4

Image {
    height: width
    source: "images/spinner.png"
    sourceSize.width: Math.min(127, width)
    sourceSize.height: Math.min(127, height)

    RotationAnimator on rotation {
        duration: 800
        loops: Animation.Infinite
        from: 0
        to: 360
        running: visible
    }
}
