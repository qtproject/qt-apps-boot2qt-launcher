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
