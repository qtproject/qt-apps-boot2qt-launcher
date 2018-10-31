/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
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


#define ENGINE_STATE_RUNNING QStringLiteral("running")
#define ENGINE_STATE_SETTINGS QStringLiteral("settings")

#define ENGINE_STATE_APPLAUNCHING QStringLiteral("app-launching")
#define ENGINE_STATE_APPRUNNING QStringLiteral("app-running")
#define ENGINE_STATE_APPCLOSING QStringLiteral("app-closing")

Engine::Engine(QQuickItem *parent)
    : QQuickItem(parent)
    , m_fpsCounter(nullptr)
    , m_fps(0)
    , m_intro_done(false)
    , m_apps_ready(false)
    , m_fps_enabled(false)
    , m_glAvailable(checkForGlAvailability())
{
    m_state = ENGINE_STATE_RUNNING;

    QScreen *screen = QGuiApplication::primaryScreen();
    m_screenSize = screen->size();
    m_dpcm = screen->physicalDotsPerInchY() / 2.54f;

    // Make the buttons smaller for smaller screens to compensate for that
    // one typically holds it nearer to the eyes.
    float low = 5;
    float high = 20;
    float screenSizeCM = qMax<float>(qMin(m_screenSize.width(), m_screenSize.height()) / m_dpcm, low);
    m_dpcm *= (screenSizeCM - low) / (high - low) * 0.5 + 0.5;
    m_screenWidth = m_screenSize.width();
    m_screenHeight = m_screenSize.height();

    connect(this, SIGNAL(windowChanged(QQuickWindow*)), this, SLOT(windowChanged(QQuickWindow*)));
}

bool Engine::checkForGlAvailability()
{
    QQuickWindow window;
    return ((window.sceneGraphBackend() != "software") &&
            (window.sceneGraphBackend() != "softwarecontext"));
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

void Engine::updateFPSCounter()
{
    if (m_fpsCounter) {
        delete m_fpsCounter;
        m_fpsCounter = nullptr;
    }

    if (m_fps_enabled && window()) {
        m_fpsCounter = new FpsCounter(window());
        connect(m_fpsCounter, SIGNAL(fps(qreal)), this, SLOT(setFps(qreal)));
    }
}

void Engine::setState(const QString &state)
{
    if (state == m_state)
        return;
    m_state = state;
    emit stateChanged(m_state);
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

void Engine::windowChanged(QQuickWindow *window)
{
    Q_UNUSED(window)
    //When window changes we need to recreate the fps counters
    updateFPSCounter();
}

void Engine::setFpsEnabled(bool enabled)
{
    if (m_fps_enabled == enabled)
        return;
    m_fps_enabled = enabled;

    updateFPSCounter();

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

bool Engine::fileExists(const QUrl &fileName)
{
    QFile file(fileName.toLocalFile());
    return file.exists();
}

void Engine::launchApplication(const QUrl &path, const QString &mainFile, const QString &name, const QString &desc)
{
    // only launch apps when in the homescreen...
    if (m_state != QStringLiteral("running"))
        return;

    m_applicationMain = m_applicationUrl = path;
    m_applicationMain.setPath(path.path() + "/" + mainFile);
    m_applicationName = name;
    m_applicationDescription = desc;
    emit applicationUrlChanged(m_applicationUrl);
    emit applicationMainChanged(m_applicationMain);
    emit applicationNameChanged(m_applicationName);
    emit applicationDescriptionChanged(m_applicationName);
    setState(ENGINE_STATE_APPLAUNCHING);
}

void Engine::closeApplication()
{
    emit activeIconChanged(nullptr);

    m_applicationMain = m_applicationUrl = QUrl();
    m_applicationName = QString();
    m_applicationDescription = QString();
    emit applicationUrlChanged(m_applicationUrl);
    emit applicationMainChanged(m_applicationMain);
    emit applicationNameChanged(m_applicationName);
    emit applicationDescriptionChanged(m_applicationName);

    setState(ENGINE_STATE_RUNNING);
}
