/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
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
#include <QtCore/QDebug>

#include <QtWidgets/QApplication>
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>
#include <QtGui/QScreen>
#include <QtGui/QPalette>

#if (QT_VERSION < QT_VERSION_CHECK(5, 3, 0))
#include <QtQuick/QQuickItem>
#endif
#include <QtQuick/QQuickView>

#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlComponent>

#if defined(USE_QTWEBENGINE)
#include <qtwebengineglobal.h>
#endif

#include "engine.h"
#include "applicationsmodel.h"
#include "logmanager.h"

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

/*
 * TODO:
 *  - add fps counter
 *  - settings screen
 *    - Qt logo with glitter and particles
 *    - Brightness control (when applicable)
 *    - Toggle FPS measurement
 *    - power off
 */

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

#if defined(USE_QTWEBENGINE)
    // This is currently needed by all QtWebEngine applications using the HW accelerated QQuickWebView.
    // It enables sharing the QOpenGLContext of all QQuickWindows of the application.
    // We have to do so until we expose a public API for it in Qt or choose to enable it
    // by default earliest in Qt 5.4.0.
    QWebEngine::initialize();
#endif

    QPalette pal;
    pal.setColor(QPalette::Text, Qt::black);
    pal.setColor(QPalette::WindowText, Qt::black);
    pal.setColor(QPalette::ButtonText, Qt::black);
    pal.setColor(QPalette::Base, Qt::white);
    QGuiApplication::setPalette(pal);

    QString fontName = QStringLiteral("/system/lib/fonts/DejaVuSans.ttf");
    if (QFile::exists(fontName)) {
        QFontDatabase::addApplicationFont(fontName);
        QFont font("DejaVu Sans");
        font.setPixelSize(12);
        QGuiApplication::setFont(font);
    } else {
        QFont font;
        font.setStyleHint(QFont::SansSerif);
        QGuiApplication::setFont(font);
    }

    QSize screenSize = QGuiApplication::primaryScreen()->size();

    QString mainFile = screenSize.width() < screenSize.height()
        ? QStringLiteral("qrc:///qml/main_landscape.qml")
        : QStringLiteral("qrc:///qml/Main.qml");
    QString appsRoot = QStringLiteral("/data/user/qt");

    QString bgImage = QStringLiteral(":/qml/images/bg_1280x800.jpg");
    bool logcat = false;
    QString bgColor;
    bool bootAnimation = true;
    bool showFps = false;

    QStringList args = app.arguments();
    for (int i=0; i<args.size(); ++i) {
        if (args.at(i) == QStringLiteral("--main-file")) {
            ++i;
            mainFile = args.at(i);
        } else if (args.at(i) == QStringLiteral("--applications-root")) {
            ++i;
            appsRoot = args.at(i);
        } else if (args.at(i) == QStringLiteral("--no-boot-animation")) {
            bootAnimation = false;
        } else if (args.at(i) == QStringLiteral("--show-fps")) {
            showFps = true;
        } else if (args.at(i) == QStringLiteral("--logcat")) {
            logcat = true;
        } else if (args.at(i) == QStringLiteral("-h")
                   || args.at(i) == QStringLiteral("--help")
                   || args.at(i) == QStringLiteral("-?")) {
            displayHelp(argv[0]);
            return 0;
        }
    }

    if (logcat) {
        LogManager::install();
    }

    qDebug() << "Main File:" << mainFile;
    qDebug() << "Applications Root:" << appsRoot;
    qDebug() << "Boot Animation:" << (bootAnimation ? "yes" : "no");
    qDebug() << "Show FPS:" << (showFps ? "yes" : "no");
    qDebug() << "Log redirection:" << (logcat ? "yes" : "no");

    QQuickView view;
#if (QT_VERSION < QT_VERSION_CHECK(5, 3, 0))
    // Ensure the width and height are valid because of QTBUG-36938.
    QObject::connect(&view, SIGNAL(widthChanged(int)), view.contentItem(), SLOT(setWidth(int)));
    QObject::connect(&view, SIGNAL(heightChanged(int)), view.contentItem(), SLOT(setHeight(int)));
#endif

    Engine engine;
    engine.setWindow(&view);
    engine.setFpsEnabled(showFps);
    engine.setQmlEngine(view.engine());
    engine.setBootAnimationEnabled(bootAnimation);

    ApplicationsModel appsModel;
    QObject::connect(&appsModel, SIGNAL(ready()), &engine, SLOT(markApplicationsModelReady()));
    appsModel.initialize(appsRoot);

    view.rootContext()->setContextProperty("engine", &engine);
    view.rootContext()->setContextProperty("applicationsModel", &appsModel);
    view.setColor(Qt::black);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl(mainFile));
    view.show();

    app.exec();
}
