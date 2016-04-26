/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
#include "fpscounter.h"

#include <QtQuick/QQuickWindow>

FpsCounter::FpsCounter(QQuickWindow *window)
{
    connect(window, SIGNAL(frameSwapped()), this, SLOT(frameSwapped()));
    startTimer(1000);
    m_frameCounter = 0;
    m_timer.start();
}

void FpsCounter::timerEvent(QTimerEvent *)
{
    emit fps(m_frameCounter * 1000.0 / m_timer.elapsed());
    m_frameCounter = 0;
    m_timer.start();
}
