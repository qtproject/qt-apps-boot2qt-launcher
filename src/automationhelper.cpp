/****************************************************************************
**
** Copyright (C) 2019 The Qt Company Ltd.
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
#include "automationhelper.h"
#include <QCoreApplication>
#include <QApplication>
#include <QQuickWindow>

AutomationHelper::AutomationHelper(QObject* parent) :
    QObject(parent)
{
}

/*!
 * \brief Click center of given QQuickItem
 * \param item Item to click
 */
void AutomationHelper::click(QQuickItem* item)
{
    QQuickWindow* window = item->window();
    if (!window) {
        qWarning()<<"No window for item "<<item;
        return;
    }

    int centerX = static_cast<int>(item->width()/2);
    int centerY = static_cast<int>(item->height()/2);
    QPointF globalCoordinates = item->mapToGlobal(QPoint(centerX, centerY));
    QPointF windowCoordinates = window->mapFromGlobal(globalCoordinates.toPoint());

    QMouseEvent pressEvent(QEvent::MouseButtonPress, windowCoordinates, windowCoordinates, windowCoordinates,
                           Qt::MouseButton::LeftButton, Qt::NoButton, Qt::NoModifier, Qt::MouseEventSynthesizedByApplication);
    QMouseEvent releaseEvent(QEvent::MouseButtonRelease, windowCoordinates, windowCoordinates, windowCoordinates,
                             Qt::MouseButton::LeftButton, Qt::NoButton, Qt::NoModifier, Qt::MouseEventSynthesizedByApplication);
    QApplication::instance()->sendEvent(window, &pressEvent);
    QApplication::instance()->sendEvent(window, &releaseEvent);
}

/*!
 * \brief Click center of child item of given QQuickItem
 * \param item Item which child to click
 * \param childObjectName Object name of the child to click
 */
void AutomationHelper::clickChildObject(QQuickItem* item, QString childObjectName)
{
    QQuickItem* obj = findChildObject(item, childObjectName);
    if (!obj) {
        qWarning()<<"No such child "<<childObjectName<<" for "<<item;
        return;
    }

    click(obj);
}

/*!
 * \brief Find child item of given QQuickItem
 *
 * This function is needed for exposing findChildObject to QML
 * \param item Item which child to find
 * \param childObjectName Object name of the child to find
 * \return found child
 */
QQuickItem* AutomationHelper::findChildObject(QQuickItem* item, QString childObjectName)
{
    return item->findChild<QQuickItem*>(childObjectName);
}
