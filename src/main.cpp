/****************************************************************************
**
** Copyright (C) 2018 The Qt Company Ltd.
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
#include <QtCore/QDebug>

#include <QtWidgets/QApplication>
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>
#include <QtCore/QFile>

#include <QtQml/QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlComponent>
#include <QStandardPaths>
#include <QIcon>

#include <QQuickStyle>

#if defined(USE_QTWEBENGINE)
#include <qtwebengineglobal.h>
#endif

#include "engine.h"
#include "applicationsmodel.h"
#include "applicationsettings.h"
#include "settingsmanager.h"
#include "imageproviders.h"
#include "circularindicator.h"
#include "automationhelper.h"

void displayHelp(const char *appName)
{
    printf("Usage: \n"
           " > %s [options]\n"
           "\n"
           "Options:\n"
           " --main-file [qml-file]             Launches an alternative QML file\n"
           " --applications-root [path]         Specify a different applications root\n"
           " --show-fps                         Show FPS\n"
           , appName
           );
}

int main(int argc, char **argv)
{
    QSettings launcherSettings("Qt", "QtLauncher");

    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QByteArray applicationsRootStr = launcherSettings.value("defaultApplicationRoot").toByteArray();
    qputenv("QT_QUICK_CONTROLS_CONF", applicationsRootStr + "/qtquickcontrols2/qtquickcontrols2.conf");
    QIcon::setThemeSearchPaths(QStringList() << applicationsRootStr + "/qtquickcontrols2/icons");

    QIcon::setThemeName("gallery");

    // Do not set HighDpiScaling for emulator, see QTBUG-64815
    if (qEnvironmentVariableIsEmpty("QTGLESSTREAM_DISPLAY")) {
       QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    }

    QApplication app(argc, argv);
    app.setApplicationVersion(APPLICATION_VERSION);

#if defined(USE_QTWEBENGINE)
    // This is currently needed by all QtWebEngine applications using the HW accelerated QQuickWebView.
    // It enables sharing the QOpenGLContext of all QQuickWindows of the application.
    // We have to do so until we expose public API for it in Qt or choose to enable it by default.
    QtWebEngine::initialize();
#endif

    QFontDatabase::addApplicationFont(":/qml/fonts/TitilliumWeb-Light.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/TitilliumWeb-Regular.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/TitilliumWeb-SemiBold.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/TitilliumWeb-Bold.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/TitilliumWeb-Black.ttf");

    //For eBike demo
    QFontDatabase::addApplicationFont(":/qml/fonts/Montserrat-Bold.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/Montserrat-Light.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/Montserrat-Medium.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/Montserrat-Regular.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/Teko-Bold.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/Teko-Light.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/Teko-Medium.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/Teko-Regular.ttf");
    QFontDatabase::addApplicationFont(":/qml/fonts/fontawesome-webfont.ttf");

    ApplicationSettings applicationSettings(applicationsRootStr);

    if (!applicationSettings.parseCommandLineArguments()) {
        displayHelp(argv[0]);
        return 0;
    }

    qDebug() << "Main File:" << applicationSettings.mainFile();
    qDebug() << "Applications Root:" << applicationSettings.appsRoot();
    qDebug() << "Show FPS:" << (applicationSettings.isShowFPSEnabled() ? "yes" : "no");


    qmlRegisterType<ApplicationsModel>("com.qtcompany.B2QtLauncher", 1, 0, "LauncherApplicationsModel");
    qmlRegisterType<Engine>("com.qtcompany.B2QtLauncher", 1, 0, "LauncherEngine");
    qmlRegisterType<CircularIndicator>("Circle", 1, 0, "CircularIndicator");
    qmlRegisterType<AutomationHelper>("AutomationHelper", 1, 0, "AutomationHelper");

    QQmlApplicationEngine engine;
    SettingsManager settings;

    QtImageProvider imageProvider;
    QtSquareImageProvider squareImageProvider;
    QtImageMaskProvider imageMaskProvider;

    // Material style can be set only for devices supporting GL
    QString style = launcherSettings.value("style").toString();
    if (Engine::checkForGlAvailability()) {
        if (style.isEmpty())
            launcherSettings.setValue("style", "Material");
    } else {
        qDebug() << "No GL available, skipping Material style";
        launcherSettings.setValue("style", "Default");
    }
    QQuickStyle::setStyle(launcherSettings.value("style").toString());

    engine.rootContext()->setContextProperty("_backgroundColor", launcherSettings.value("backgroundColor", "#09102b"));
    engine.rootContext()->setContextProperty("_primaryGreen", launcherSettings.value("primaryGreen", "#41cd52"));
    engine.rootContext()->setContextProperty("_mediumGreen", launcherSettings.value("mediumGreen", "#21be2b"));
    engine.rootContext()->setContextProperty("_darkGreen", launcherSettings.value("darkGreen", "#17a81a"));
    engine.rootContext()->setContextProperty("_primaryGrey", launcherSettings.value("primaryGrey", "#9d9faa"));
    engine.rootContext()->setContextProperty("_secondaryGrey", launcherSettings.value("secondaryGrey", "#3a4055"));

    engine.rootContext()->setContextProperty("VideosLocation",
                                             launcherSettings.value("videosLocation"));
    engine.rootContext()->setContextProperty("DefaultVideoUrl",
                                             launcherSettings.value("defaultVideoUrl"));


    engine.addImageProvider("QtImage", &imageProvider);
    engine.addImageProvider("QtSquareImage", &squareImageProvider);
    engine.addImageProvider("QtImageMask", &imageMaskProvider);
    engine.rootContext()->setContextProperty("globalSettings", &settings);
    engine.rootContext()->setContextProperty("applicationSettings", &applicationSettings);
    engine.rootContext()->setContextProperty("qpa_platform", qGuiApp->platformName());
    engine.rootContext()->setContextProperty("availableStyles", QQuickStyle::availableStyles());
    engine.load(applicationSettings.mainFile());

    return app.exec();
}
