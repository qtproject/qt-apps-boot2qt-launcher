/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://qt.digia.com
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://qt.digia.com
**
****************************************************************************/
#ifndef FPSCOUNTER_H
#define FPSCOUNTER_H

#include <QObject>
#include <QElapsedTimer>

class QQuickWindow;

class FpsCounter : public QObject
{
    Q_OBJECT
public:
    FpsCounter(QQuickWindow *window);

    void timerEvent(QTimerEvent *);
    
signals:
    void fps(qreal newFps);

public slots:
    void frameSwapped() { ++m_frameCounter; }

private:
    QElapsedTimer m_timer;
    int m_frameCounter;
};

#endif // FPSCOUNTER_H
