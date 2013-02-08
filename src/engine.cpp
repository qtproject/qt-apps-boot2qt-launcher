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
    , m_bootAnimationEnabled(true)
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


int Engine::sensibleButtonSize() const
{
    QScreen *screen = QGuiApplication::primaryScreen();

    QSize screenSize = screen->size();
    int baseSize = qMin(screenSize.width(), screenSize.height());
    float dpcm = screen->physicalDotsPerInchY() / 2.54f;

    // 3cm buttons, nice and big...
    int buttonSize = int(dpcm * 3);

    // Clamp buttonSize to screen..
    if (buttonSize > baseSize)
        buttonSize = baseSize;

    qDebug() << "screen size: " << screenSize;
    qDebug() << "physical screen size: " << screen->physicalSize();
    qDebug() << "pdpi: " << screen->physicalDotsPerInch() << (screenSize.width() / screen->physicalSize().width() * 2.54);

    qDebug() << "baseSize: " << baseSize;
    qDebug() << "buttonSize: " << buttonSize;

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

    qDebug() << "before setting state";
    setState(ENGINE_STATE_APPLAUNCHING);
    qDebug() << "after setting state";
}

void Engine::closeApplication()
{
    qDebug() << "App closed..";

    m_activeIcon = 0;
    emit activeIconChanged(0);

    m_applicationMain = m_applicationUrl = QUrl();
    emit applicationUrlChanged(m_applicationUrl);
    emit applicationMainChanged(m_applicationMain);

    setState(ENGINE_STATE_RUNNING);
}
