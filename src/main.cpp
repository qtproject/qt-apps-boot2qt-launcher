#include <QtCore/QDebug>

#include <QtGui/QGuiApplication>
#include <QtGui/QFont>
#include <QtGui/QFontDatabase>
#include <QtGui/QScreen>
#include <QtGui/QPalette>

#include <QtQuick/QQuickView>

#include <QtQml/QQmlEngine>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlComponent>

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
    QGuiApplication app(argc, argv);

    QPalette pal;
    pal.setColor(QPalette::Text, Qt::black);
    pal.setColor(QPalette::WindowText, Qt::black);
    pal.setColor(QPalette::ButtonText, Qt::black);
    pal.setColor(QPalette::Base, Qt::white);
    QGuiApplication::setPalette(pal);

    QString fontName = QStringLiteral("/system/lib/fonts/OpenSans-Regular.ttf");
    if (QFile::exists(fontName)) {
        QFontDatabase::addApplicationFont(fontName);
        QFont font("Open Sans");
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
