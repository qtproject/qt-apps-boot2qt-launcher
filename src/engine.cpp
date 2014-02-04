/****************************************************************************
**
** Copyright (C) 2013 Digia Plc
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

    // Make the buttons smaller for smaller screens to compensate for that
    // one typically holds it nearer to the eyes.
    float low = 5;
    float high = 20;
    float screenSizeCM = qMax<float>(qMin(m_screenSize.width(), m_screenSize.height()) / m_dpcm, low);
    m_dpcm *= (screenSizeCM - low) / (high - low) * 0.5 + 0.5;
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

void Engine::launchApplication(const QUrl &path, const QString &mainFile, const QString &name)
{
    // only launch apps when in the homescreen...
    if (m_state != QStringLiteral("running"))
        return;

    m_applicationMain = m_applicationUrl = path;
    m_applicationMain.setPath(path.path() + "/" + mainFile);
    m_applicationName = name;
    emit applicationUrlChanged(m_applicationUrl);
    emit applicationMainChanged(m_applicationMain);
    emit applicationNameChanged(m_applicationName);
    setState(ENGINE_STATE_APPLAUNCHING);
}

void Engine::closeApplication()
{
    emit activeIconChanged(0);

    m_applicationMain = m_applicationUrl = QUrl();
    m_applicationName = QString();
    emit applicationUrlChanged(m_applicationUrl);
    emit applicationMainChanged(m_applicationMain);
    emit applicationNameChanged(m_applicationName);

    setState(ENGINE_STATE_RUNNING);
}
