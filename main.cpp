// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <QtCore/QFile>
#include <QtCore/QStandardPaths>
#include <QtCore/QSettings>
#include <QtGui/QFont>
#include <QtGui/QIcon>
#include <QtGui/QFontDatabase>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>

#if defined(USE_STATIC_BUILD_FLAG)
#include <QtQml/QQmlEngineExtensionPlugin>
Q_IMPORT_QML_PLUGIN(QtLauncherPlugin)
Q_IMPORT_QML_PLUGIN(QtImageProvidersPlugin)
#endif

void displayHelp(const char *appName)
{
    printf("Usage: \n"
           " > %s [options]\n"
           "\n"
           "Options:\n"
           " --applications-root [path]         Specify a different applications root\n"
           , appName
           );
}

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QString appsRoot;

    const QStringList args = app.arguments();
    for (int i = 1; i < args.size(); ++i) {
        const QString arg = args.at(i);
        if (arg == QStringLiteral("--applications-root")) {
            ++i;
            appsRoot = args.at(i);
        } else if (arg == QStringLiteral("-h")
                   || arg == QStringLiteral("--help")
                   || arg == QStringLiteral("-?")) {
            displayHelp(argv[0]);
            return 0;
        } else {
            qCritical() << "Unknown command line argument:" << args.at(i);
            displayHelp(argv[0]);
            return 0;
        }
    }

    if (appsRoot.isEmpty()) {
        QSettings settings("Qt", "QtLauncher");
        appsRoot = settings.value("defaultApplicationRoot").toString();
    }

    if (appsRoot.isEmpty()) {
        appsRoot = "/usr/share/examples/boot2qt-launcher-demos";
    }

    qInfo() << "Applications Root:" << appsRoot;

    QQmlApplicationEngine engine;

    engine.setInitialProperties({{"appsRoot", appsRoot}});
    engine.loadFromModule("QtLauncher", "Main");

    return app.exec();
}
