#include "applicationsettings.h"
#include <QtCore/QCoreApplication>
/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
**
****************************************************************************/

#include <QtCore/QStringList>

ApplicationSettings::ApplicationSettings(QObject *parent)
    : QObject(parent)
    , m_mainFile(QUrl(QStringLiteral("qrc:///qml/Main.qml")))
    , m_appsRoot("/data/user/qt")
    , m_isLogcatEnabled(false)
    , m_isBootAnimationEnabled(true)
    , m_isShowFPSEnabled(false)
{
}

QString ApplicationSettings::appsRoot() const
{
    return m_appsRoot;
}

bool ApplicationSettings::isLogcatEnable() const
{
    return m_isLogcatEnabled;
}

bool ApplicationSettings::isBootAnimationEnabled() const
{
    return m_isBootAnimationEnabled;
}

bool ApplicationSettings::isShowFPSEnabled() const
{
    return m_isShowFPSEnabled;
}

bool ApplicationSettings::parseCommandLineArguments()
{
    QStringList args = QCoreApplication::instance()->arguments();
    for (int i=0; i<args.size(); ++i) {
        if (args.at(i) == QStringLiteral("--main-file")) {
            ++i;
            m_mainFile = QUrl::fromUserInput(args.at(i));
        } else if (args.at(i) == QStringLiteral("--applications-root")) {
            ++i;
            m_appsRoot = args.at(i);
        } else if (args.at(i) == QStringLiteral("--no-boot-animation")) {
            m_isBootAnimationEnabled = false;
        } else if (args.at(i) == QStringLiteral("--show-fps")) {
            m_isShowFPSEnabled = true;
        } else if (args.at(i) == QStringLiteral("--logcat")) {
            m_isLogcatEnabled = true;
        } else if (args.at(i) == QStringLiteral("-h")
                   || args.at(i) == QStringLiteral("--help")
                   || args.at(i) == QStringLiteral("-?")) {
            return false;
        }
    }
    return true;
}

QUrl ApplicationSettings::mainFile() const
{
    return m_mainFile;
}
