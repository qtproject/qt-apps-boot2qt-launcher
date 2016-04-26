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
#include <QtCore/QDebug>

#include <QtWidgets/QApplication>
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>
#include <QtCore/QFile>

#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlComponent>

#if defined(USE_QTWEBENGINE)
#include <qtwebengineglobal.h>
#endif

#include "engine.h"
#include "applicationsmodel.h"
#include "logmanager.h"
#include "applicationsettings.h"

void displayHelp(const char *appName)
{
    printf("Usage: \n"
           " > %s [options]\n"
           "\n"
           "Options:\n"
           " --main-file [qml-file]             Launches an alternative QML file\n"
           " --applications-root [path]         Specify a different applications root\n"
           " --no-boot-animation                Disable startup animation\n"
           " --show-fps                         Show FPS\n"
           , appName
           );
}

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    //Use Flat style for Qt Quick Controls by default
    qputenv("QT_QUICK_CONTROLS_STYLE", "Flat");

#if defined(USE_QTWEBENGINE)
    // This is currently needed by all QtWebEngine applications using the HW accelerated QQuickWebView.
    // It enables sharing the QOpenGLContext of all QQuickWindows of the application.
    // We have to do so until we expose public API for it in Qt or choose to enable it by default.
    QtWebEngine::initialize();
#endif

    QString fontName = QStringLiteral("/system/lib/fonts/DejaVuSans.ttf");
    if (QFile::exists(fontName)) {
        QFontDatabase::addApplicationFont(fontName);
        QFont font("DejaVu Sans");
        QGuiApplication::setFont(font);
    } else {
        QFont font;
        font.setStyleHint(QFont::SansSerif);
        QGuiApplication::setFont(font);
    }

    ApplicationSettings applicationSettings;

    if (!applicationSettings.parseCommandLineArguments()) {
        displayHelp(argv[0]);
        return 0;
    }

    if (applicationSettings.isLogcatEnable()) {
        LogManager::install();
    }

    qDebug() << "Main File:" << applicationSettings.mainFile();
    qDebug() << "Applications Root:" << applicationSettings.appsRoot();
    qDebug() << "Boot Animation:" << (applicationSettings.isBootAnimationEnabled() ? "yes" : "no");
    qDebug() << "Show FPS:" << (applicationSettings.isShowFPSEnabled() ? "yes" : "no");
    qDebug() << "Log redirection:" << (applicationSettings.isLogcatEnable() ? "yes" : "no");


    qmlRegisterType<ApplicationsModel>("com.qtcompany.B2QtLauncher", 1, 0, "LauncherApplicationsModel");
    qmlRegisterType<Engine>("com.qtcompany.B2QtLauncher", 1, 0, "LauncherEngine");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("applicationSettings", &applicationSettings);
    engine.rootContext()->setContextProperty("qpa_platform", qGuiApp->platformName());
    engine.load(applicationSettings.mainFile());

    app.exec();
}
