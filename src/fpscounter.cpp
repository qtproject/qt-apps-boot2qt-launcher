/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
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
