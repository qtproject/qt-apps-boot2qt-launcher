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
