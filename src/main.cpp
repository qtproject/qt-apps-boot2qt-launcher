#include <QDebug>
#include <QGuiApplication>
#include <QQuickView>

#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>

#include "engine.h"
#include "applicationsmodel.h"

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QString mainFile = QStringLiteral("qml/Main.qml");
    QString appsRoot = QStringLiteral("/data/user/qt");

    QString bgImage = QStringLiteral("/data/user/qt/bg.jpg");

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
        }
    }

    qDebug() << "Main File:" << mainFile;
    qDebug() << "Applications Root:" << appsRoot;
    qDebug() << "Background Image:" << bgImage;

    QQuickView view;

    Engine engine;
    engine.setBackgroundImage(QUrl::fromLocalFile(bgImage));
    engine.setQmlEngine(view.engine());

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
