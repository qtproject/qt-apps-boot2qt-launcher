#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>

class Engine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state NOTIFY stateChanged)

public:
    explicit Engine(QObject *parent = 0);
    
    QString state() const { return m_state; }

protected:
    void timerEvent(QTimerEvent *event);

signals:
    void stateChanged(QString state);
    
public slots:

private:
    QString m_state;
    
};

#endif // ENGINE_H
