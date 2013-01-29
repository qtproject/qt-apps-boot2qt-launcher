#include "engine.h"

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

#define ENGINE_STATE_APPLAUNCHING QStringLiteral("app-launching")
#define ENGINE_STATE_APPRUNNING QStringLiteral("app-running")
#define ENGINE_STATE_APPCLOSING QStringLiteral("app-closing")

Engine::Engine(QObject *parent)
    : QObject(parent)
    , m_qmlEngine(0)
    , m_activeIcon(0)
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

void Engine::setState(const QString &state)
{
    if (state == m_state)
        return;
    m_state = state;
    emit stateChanged(m_state);
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
    int baseSize = qMin(screenSize.width(), screenSize.height());
    float dpcm = screen->physicalDotsPerInch() / 2.54f;

    // 3cm buttons, nice and big...
    int buttonSize = int(dpcm * 4);

    // Clamp buttonSize to screen..
    if (buttonSize > baseSize)
        buttonSize = baseSize;

    return buttonSize;
}

void Engine::launchApplication(const QUrl &path, const QString &mainFile, QQuickItem *appIcon)
{
    m_activeIcon = appIcon;
    emit activeIconChanged(m_activeIcon);

    m_applicationUrl = path;
    m_applicationUrl.setPath(path.path() + "/" + mainFile);
    emit applicationUrlChanged(m_applicationUrl);

    qDebug() << "before setting state";
    setState(ENGINE_STATE_APPLAUNCHING);
    qDebug() << "after setting state";
}

void Engine::closeApplication()
{
    qDebug() << "App closed..";

    m_activeIcon = 0;
    emit activeIconChanged(0);

    m_applicationUrl = QUrl();
    emit applicationUrlChanged(m_applicationUrl);

    setState(ENGINE_STATE_RUNNING);
}
