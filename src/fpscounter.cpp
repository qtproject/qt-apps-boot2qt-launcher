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



