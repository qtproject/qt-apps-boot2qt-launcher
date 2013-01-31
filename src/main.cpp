#include <QDebug>
#include <QGuiApplication>
#include <QQuickView>

#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>

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
           " --background-image [path]          Specify a different background image\n"
           " --background-color [html-color]    Specify a background color, overrides image\n"
           " --no-icon-shadow                   Disable drop shadow on icons\n"
           , appName
           );

}

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QString mainFile = QStringLiteral("qml/Main.qml");
    QString appsRoot = QStringLiteral("/data/user/qt");

    QString bgImage = QStringLiteral("/data/user/qt/bg.jpg");
    bool logcat = false;
    QString bgColor;
    bool iconShadow = true;

    QStringList args = app.arguments();
    for (int i=0; i<args.size(); ++i) {
        if (args.at(i) == QStringLiteral("--main-file")) {
            ++i;
            mainFile = args.at(i);
        } else if (args.at(i) == QStringLiteral("--applications-root")) {
            ++i;
            appsRoot = args.at(i);
        } else if (args.at(i) == QStringLiteral("--background-image")) {
            ++i;
            bgImage = args.at(i);
        } else if (args.at(i) == QStringLiteral("--background-color")) {
            ++i;
            if (QColor(args.at(i)).isValid())
                bgColor = args.at(i);
        } else if (args.at(i) == QStringLiteral("--no-icon-shadow")) {
            iconShadow = false;
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
    qDebug() << "Background Image:" << bgImage;
    qDebug() << "Background Color:" << bgColor;
    qDebug() << "Icon Shadows:" << (iconShadow ? "enabled" : "disabled");
    qDebug() << "Log redirection:" << (logcat ? "enabled" : "disabled");

    QQuickView view;

    Engine engine;
    engine.setBackgroundImage(QUrl::fromLocalFile(bgImage));
    engine.setBackgroundColor(bgColor);
    engine.setQmlEngine(view.engine());
    engine.setHasIconShadows(iconShadow);

    ApplicationsModel appsModel;
    QObject::connect(&appsModel, SIGNAL(ready()), &engine, SLOT(markApplicationsModelReady()));
    appsModel.initialize(appsRoot);

    view.rootContext()->setContextProperty("engine", &engine);
    view.rootContext()->setContextProperty("applicationsModel", &appsModel);
    view.setColor(Qt::black);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl(QStringLiteral("qrc:///") + mainFile));
    view.show();

    app.exec();
}
