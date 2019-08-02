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
#include "applicationsettings.h"

#include <QtCore/QCoreApplication>
#include <QtCore/QDebug>
#include <QtCore/QStringList>

ApplicationSettings::ApplicationSettings(QString appsRoot, QObject *parent)
    : QObject(parent)
    , m_mainFile(QUrl(QStringLiteral("qrc:///qml/Main.qml")))
    , m_appsRoot(appsRoot)
    , m_isShowFPSEnabled(false)
{
}

QString ApplicationSettings::appsRoot() const
{
    return m_appsRoot;
}

bool ApplicationSettings::isShowFPSEnabled() const
{
    return m_isShowFPSEnabled;
}

bool ApplicationSettings::parseCommandLineArguments()
{
    const QStringList args = QCoreApplication::arguments();
    for (int i = 1; i < args.size(); ++i) {
        const QString arg = args.at(i);
        if (arg == QStringLiteral("--main-file")) {
            ++i;
            m_mainFile = QUrl::fromUserInput(args.at(i));
        } else if (arg == QStringLiteral("--applications-root")) {
            ++i;
            m_appsRoot = args.at(i);
        } else if (arg == QStringLiteral("--show-fps")) {
            m_isShowFPSEnabled = true;
        } else if (arg == QStringLiteral("-h")
                   || arg == QStringLiteral("--help")
                   || arg == QStringLiteral("-?")) {
            return false;
        } else {
            qCritical() << "Unknown command line argument:" << args.at(i);
            return false;
        }
    }
    return true;
}

QUrl ApplicationSettings::mainFile() const
{
    return m_mainFile;
}
