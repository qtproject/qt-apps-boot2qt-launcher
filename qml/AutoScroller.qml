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
import QtQuick 2.0
import QtQuick.VirtualKeyboard 2.0

Item {
    property var inputItem: InputContext.priv.inputItem
    property var appLoader

    onInputItemChanged: open();

    function open() {
        appLoader = null
        if (inputItem) {
            var parent_ = inputItem.parent
            var found = false
            while (parent_) {
                if (parent_.objectName == "applicationLoader") {
                    appLoader = parent_
                    found = true
                    break;
                }
                parent_ = parent_.parent
            }
            if (found) delayedLoading.triggered()
        }
    }

    function ensureVisible(loader) {
        if (Qt.inputMethod.visible && inputItem && loader) {

            //Check if the text field is under the virtual keyboard. Also add some margin just to make sure.
            if (inputItem.mapToItem(loader, 0,0).y > root.height - inputPanel.height - root.height * 0.125) {

                //Scroll the text field to the vertical center of the remaining screen space above the virtual keyboard.
                loader.anchors.topMargin = ((root.height - inputPanel.height) / 2) - inputItem.mapToItem(loader, 0,0).y - (inputItem.height / 2);
            } else {
                loader.anchors.topMargin = 0;
            }
        }
    }
    Timer {
        id: delayedLoading
        interval: 10
        onTriggered: {
            ensureVisible(appLoader)
        }
    }
}
