#include "engine.h"
#include "fpscounter.h"

#include <QFile>
#include <QTimerEvent>
#include <QDebug>

#include <QGuiApplication>
#include <QScreen>

#include <QQmlEngine>

#include <QQuickItem>
#include <QQuickWindow>


#define ENGINE_STATE_BOOTING QStringLiteral("booting")
#define ENGINE_STATE_RUNNING QStringLiteral("running")
#define ENGINE_STATE_SETTINGS QStringLiteral("settings")

#define ENGINE_STATE_APPLAUNCHING QStringLiteral("app-launching")
#define ENGINE_STATE_APPRUNNING QStringLiteral("app-running")
#define ENGINE_STATE_APPCLOSING QStringLiteral("app-closing")

Engine::Engine(QObject *parent)
    : QObject(parent)
    , m_qmlEngine(0)
    , m_activeIcon(0)
    , m_fpsCounter(0)
    , m_fps(0)
    , m_intro_done(false)
    , m_apps_ready(false)
    , m_fps_enabled(false)
    , m_bootAnimationEnabled(true)
{
    m_state = ENGINE_STATE_BOOTING;

    QScreen *screen = QGuiApplication::primaryScreen();
    m_screenSize = screen->size();
    m_dpcm = screen->physicalDotsPerInchY() / 2.54f;
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

void Engine::setState(const QString &state)
{
    if (state == m_state)
        return;
    m_state = state;
    emit stateChanged(m_state);
}


void Engine::setBootAnimationEnabled(bool enabled)
{
    if (m_bootAnimationEnabled == enabled)
        return;

    m_bootAnimationEnabled = enabled;
    emit bootAnimationEnabledChanged(enabled);
}

void Engine::setBackgroundImage(const QUrl &name)
{
    if (m_bgImage == name)
        return;

    m_bgImage = name;
    emit backgroundImageChanged(m_bgImage);
}

void Engine::setBackgroundColor(const QString &color)
{
    if (m_bgColor == color)
        return;

    m_bgColor = color;
    emit backgroundColorChanged(m_bgColor);
}

int Engine::titleBarSize() const
{
    return int(QGuiApplication::primaryScreen()->physicalDotsPerInch() / 2.54f);
}

void Engine::setFps(qreal fps)
{
    fps = qRound(fps);
    if (qFuzzyCompare(m_fps, fps))
        return;
    m_fps = fps;
    emit fpsChanged(m_fps);
}

void Engine::setFpsEnabled(bool enabled)
{
    if (m_fps_enabled == enabled)
        return;
    m_fps_enabled = enabled;

    if (m_fps_enabled) {
        m_fpsCounter = new FpsCounter(m_window);
        connect(m_fpsCounter, SIGNAL(fps(qreal)), this, SLOT(setFps(qreal)));
    } else {
        delete m_fpsCounter;
        m_fpsCounter = 0;
    }

    emit fpsEnabledChanged(m_fps_enabled);
}


int Engine::sensibleButtonSize() const
{
    // 3cm buttons, nice and big...
    int buttonSize = int(m_dpcm * 3);

    int baseSize = qMin(m_screenSize.width(), m_screenSize.height());

    // Clamp buttonSize to screen..
    if (buttonSize > baseSize)
        buttonSize = baseSize;

    return buttonSize;
}

void Engine::launchApplication(const QUrl &path, const QString &mainFile, QQuickItem *appIcon)
{
    // only launch apps when in the homescreen...
    if (m_state != QStringLiteral("running"))
        return;

    m_activeIcon = appIcon;
    emit activeIconChanged(m_activeIcon);

    m_applicationMain = m_applicationUrl = path;
    m_applicationMain.setPath(path.path() + "/" + mainFile);
    emit applicationUrlChanged(m_applicationUrl);
    emit applicationMainChanged(m_applicationMain);
    setState(ENGINE_STATE_APPLAUNCHING);
}

void Engine::closeApplication()
{
    m_activeIcon = 0;
    emit activeIconChanged(0);

    m_applicationMain = m_applicationUrl = QUrl();
    emit applicationUrlChanged(m_applicationUrl);
    emit applicationMainChanged(m_applicationMain);

    setState(ENGINE_STATE_RUNNING);
}
