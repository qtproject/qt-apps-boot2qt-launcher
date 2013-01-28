#include "engine.h"

#include <QFile>
#include <QTimerEvent>

#define ENGINE_STATE_BOOTING QStringLiteral("booting")
#define ENGINE_STATE_RUNNING QStringLiteral("running")
#define ENGINE_STATE_APPRUNNING QStringLiteral("app-running")



Engine::Engine(QObject *parent)
    : QObject(parent)
    , m_intro_done(false)
    , m_apps_ready(false)
{
    m_state = ENGINE_STATE_BOOTING;
}


void Engine::updateReadyness()
{
    if (!m_intro_done)
        return;
    if (!m_apps_ready)
        return;

    m_state = ENGINE_STATE_RUNNING;
    emit stateChanged(m_state);
}

void Engine::initialize()
{
    qDebug("Engine::initialize...");
}

void Engine::setBackgroundImage(const QUrl &name)
{
    if (m_bgImage == name)
        return;

    if (!name.isLocalFile() || QFile::exists(name.toLocalFile()))
        m_bgImage = name;
    else
        m_bgImage = QUrl();
    emit backgroundImageChanged(m_bgImage);
}
