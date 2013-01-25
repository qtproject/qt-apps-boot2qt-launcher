#include <QDebug>
#include <QGuiApplication>
#include <QQuickView>

#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlComponent>

#include "engine.h"

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QQuickView view;

    Engine engine;

    QString mainFile = QStringLiteral("qml/Main.qml");

    QStringList args = app.arguments();
    for (int i=0; i<args.size(); ++i) {
        if (args.at(i) == QStringLiteral("--main-file")) {
            ++i;
            mainFile = args.at(i);

        }
    }

    qDebug() << "MainFile:" << mainFile;

    view.rootContext()->setContextProperty("engine", &engine);

    view.setSource(QUrl::fromLocalFile(mainFile));
    view.show();



    app.exec();
}
