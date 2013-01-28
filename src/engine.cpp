#include "engine.h"

#include <QTimerEvent>

#define ENGINE_STATE_BOOTING QStringLiteral("booting")
#define ENGINE_STATE_RUNNING QStringLiteral("running")
#define ENGINE_STATE_APPRUNNING QStringLiteral("app-running")

Engine::Engine(QObject *parent) :
    QObject(parent)
{
    m_state = ENGINE_STATE_BOOTING;
    startTimer(10000);
}

void Engine::timerEvent(QTimerEvent *e)
{
    killTimer(e->timerId());
    m_state = ENGINE_STATE_RUNNING;
    emit stateChanged(m_state);
}
