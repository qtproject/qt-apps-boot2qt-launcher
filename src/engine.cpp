#include "engine.h"

#include <QFile>
#include <QTimerEvent>
#include <QDebug>

#include <QGuiApplication>
#include <QScreen>

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


int Engine::titleBarSize() const
{
    return int(QGuiApplication::primaryScreen()->physicalDotsPerInch() / 2.54f);
}


int Engine::sensibleButtonSize() const
{
    QScreen *screen = QGuiApplication::primaryScreen();

    QSize screenSize = screen->size();
    qDebug() << "Screensize is: " << screenSize;
    int baseSize = qMin(screenSize.width(), screenSize.height());
    float dpcm = screen->physicalDotsPerInch() / 2.54f;

    // 3cm buttons, nice and big...
    int buttonSize = int(dpcm * 4);

    qDebug() << dpcm << buttonSize << screen->logicalDotsPerInch() << screen->physicalDotsPerInch();

    // Clamp buttonSize to screen..
    if (buttonSize > baseSize)
        buttonSize = baseSize;

    return buttonSize;
}
