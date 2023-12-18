// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include "engine.h"

#include <QFileInfo>
#include <QDir>
#include <QStandardPaths>

#define ENGINE_STATE_RUNNING QStringLiteral("running")
#define ENGINE_STATE_APPLAUNCHING QStringLiteral("app-launching")
#define ENGINE_STATE_APPRUNNING QStringLiteral("app-running")
#define ENGINE_STATE_APPCLOSING QStringLiteral("app-closing")

Engine::Engine(QQuickItem *parent)
    : QQuickItem(parent)
{
    m_state = ENGINE_STATE_RUNNING;

    connect(&m_process, &QProcess::stateChanged, this,
            [=](QProcess::ProcessState newState) {
        if (newState == QProcess::Starting) setState(ENGINE_STATE_APPLAUNCHING);
        if (newState == QProcess::Running) setState(ENGINE_STATE_APPRUNNING);
        if (newState == QProcess::NotRunning) setState(ENGINE_STATE_RUNNING);
    }
    );

    connect(&m_process, &QProcess::errorOccurred, this,
            [=](QProcess::ProcessError error) {
        qWarning() << m_process.readAllStandardError();
        m_process.close();
        setState(ENGINE_STATE_RUNNING);
    }
    );
}

void Engine::setState(const QString &state)
{
    if (state == m_state)
        return;
    m_state = state;
    emit engineStateChanged(m_state);
}

void Engine::markApplicationsModelReady()
{
    m_state = ENGINE_STATE_RUNNING;
    emit engineStateChanged(m_state);
}

void Engine::launchApplication(const QString &binary, const QString &arguments, const QVariantMap &env)
{
    if (m_state != ENGINE_STATE_RUNNING)
        return;

    setState(ENGINE_STATE_APPLAUNCHING);

    QProcessEnvironment environment = QProcessEnvironment::systemEnvironment();
    environment.insert("QT_IM_MODULE", "");
    environment.insert("QT_QPA_PLATFORM", "wayland-egl");
    environment.insert("WAYLAND_DISPLAY", QStringLiteral("%1/boot2qt-democompositor").arg(QStandardPaths::writableLocation(QStandardPaths::RuntimeLocation)));

    for (QVariantMap::const_iterator i = env.begin(); i !=env.end(); ++i) {
        environment.insert(i.key(), i.value().toString());
    }

    QFileInfo info(binary);
    m_process.setProcessEnvironment(environment);
    m_process.setProgram(info.absoluteFilePath());
    m_process.setWorkingDirectory(info.dir().path());
    m_process.setArguments(arguments.split(" "));
    m_process.start();
}

void Engine::closeApplication()
{
    m_process.close();
}
