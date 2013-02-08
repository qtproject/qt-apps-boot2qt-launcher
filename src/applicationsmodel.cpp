#include "applicationsmodel.h"

#include <QCoreApplication>
#include <QDirIterator>
#include <QEvent>
#include <QThread>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>

const QEvent::Type RESULT_EVENT = (QEvent::Type) (QEvent::User + 1);
class ResultEvent : public QEvent
{
public:
    ResultEvent(const QList<AppData> &r)
        : QEvent(RESULT_EVENT)
        , results(r)
    {
    }
    QList<AppData> results;
};

class IndexingThread : public QThread
{
public:

    void run() {
        QDirIterator iterator(root);

        QList<AppData> results;

        while (iterator.hasNext()) {
            QString path = iterator.next();

            if (!QFile::exists(path + "/main.qml"))
                continue;

            AppData data;
            data.location = QUrl::fromLocalFile(path);
            data.name = iterator.fileName();
            data.main = "main.qml";

            QFile file(path + "/description.txt");
            if (file.open(QFile::ReadOnly))
                data.description = QString::fromUtf8(file.readAll());

            data.iconName = QFile::exists(path + "/icon.png")
                    ? QStringLiteral("icon.png")
                    : QString();
            data.largeIconName = QFile::exists(path + "/icon-large.png")
                    ? QStringLiteral("icon-large.png")
                    : data.iconName;

            results << data;
        }

        qDebug() << "Indexer: all done... total:" << results.size();

        QCoreApplication::postEvent(model, new ResultEvent(results));
    }

    QString root;
    ApplicationsModel *model;
};

ApplicationsModel::ApplicationsModel(QObject *parent) :
    QAbstractItemModel(parent)
{
}

QHash<int, QByteArray> ApplicationsModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[NameRole] = "name";
    names[DescriptionRole] = "description";
    names[MainFileRole] = "mainFile";
    names[LocationRole] = "location";
    names[IconNameRole] = "iconName";
    names[LargeIconNameRole] = "largeIconName";
    return names;
}



void ApplicationsModel::initialize(const QString &appsRoot)
{
    IndexingThread *thread = new IndexingThread;
    thread->root = appsRoot;
    thread->model = this;
    thread->start();
}

bool ApplicationsModel::event(QEvent *e)
{
    if (e->type() == RESULT_EVENT) {
        beginResetModel();
        m_data = static_cast<ResultEvent *>(e)->results;
        endResetModel();
        emit ready();
        return true;
    }

    return QAbstractItemModel::event(e);
}

QVariant ApplicationsModel::data(const QModelIndex &index, int role) const
{
    Q_ASSERT(index.row() >= 0 && index.row() < m_data.size());
    Q_ASSERT(index.column() == 0);

    const AppData &ad = m_data.at(index.row());

    switch (role) {
    case NameRole: return ad.name;
    case DescriptionRole: return ad.name;
    case LocationRole: return ad.location;
    case MainFileRole: return ad.main;
    case IconNameRole: return ad.iconName;
    case LargeIconNameRole: return ad.largeIconName;
    default: qDebug() << "ApplicationsModel::data: unhandled role" << role;
    }

    return QVariant();
}
