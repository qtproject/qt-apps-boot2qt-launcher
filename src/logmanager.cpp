/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
#include "logmanager.h"

#include <QDebug>

#ifdef Q_OS_LINUX_ANDROID
#include <android/log.h>

#include <QByteArray>
#include <QString>
#include <QStringList>
#include <QFileInfo>
#include <QCoreApplication>

void qt_android_message_handler(QtMsgType type, const QMessageLogContext &context, const QString &msg)
{
    QByteArray localMsg = msg.toLocal8Bit();
    static QByteArray appName = (QCoreApplication::applicationName().isEmpty()
            ? QFileInfo(QCoreApplication::arguments().at(0)).fileName()
            : QCoreApplication::applicationName()).toLocal8Bit();

    switch (type) {
    case QtDebugMsg:
        __android_log_print(ANDROID_LOG_DEBUG, appName.constData(), "%s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtWarningMsg:
        __android_log_print(ANDROID_LOG_WARN, appName.constData(), "%s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtCriticalMsg:
        __android_log_print(ANDROID_LOG_ERROR, appName.constData(), "%s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        break;
    case QtFatalMsg:
        __android_log_print(ANDROID_LOG_FATAL, appName.constData(), "(FATAL) %s (%s:%u, %s)\n", localMsg.constData(), context.file, context.line, context.function);
        abort();
    }
}


void LogManager::install()
{
    qDebug() << "Installing logger...";
    qInstallMessageHandler(qt_android_message_handler);
}

#else

void LogManager::install()
{
    qDebug() << "Logging happens to stderr on non-android builds";
}
#endif
