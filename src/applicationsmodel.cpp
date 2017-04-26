/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
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
#include "applicationsmodel.h"

#include <QCoreApplication>
#include <QDirIterator>
#include <QEvent>
#include <QThread>
#include <QDebug>
#include <QRegExp>
#include <QJsonDocument>
#include <QJsonObject>
#include <QXmlStreamReader>

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

static bool appOrder(const AppData& a, const AppData& b)
{
    if (a.priority != b.priority)
        return a.priority > b.priority;
    else
        return a.name < b.name;
}

class IndexingThread : public QThread
{
public:

    void run()
    {
        QList<AppData> results;
        QList<QString> roots = root.split(":");
        target = qgetenv("B2QT_BASE") + "-" + qgetenv("B2QT_PLATFORM");
        foreach (const QString &root, roots) {
            if (QFile::exists(root + "/demos.xml")) {

                QFile file(root + "/demos.xml");

                if (!file.open(QIODevice::ReadOnly))
                    break;

                QXmlStreamReader xml(&file);

                AppData data;
                bool exclude = false;

                while (!xml.atEnd()) {
                    switch (xml.readNext()) {

                    case QXmlStreamReader::StartElement:
                        if (xml.name().toString().toLower() == "application") {

                            const QStringList excludeList = xml.attributes().value("exclude").toString().split(QStringLiteral(";"));

                            exclude = excludeList.contains(target) || excludeList.contains(QStringLiteral("all"));

                            if (exclude)
                                break;

                            data.name = xml.attributes().value("title").toString().trimmed();

                            QString path = xml.attributes().value("location").toString();
                            data.location = QUrl::fromLocalFile(path);

                            data.main = QString("/%1").arg(xml.attributes().value("main").toString());

                            QString imageName = xml.attributes().value("icon").toString();

                            data.icon = QFile::exists(imageName)
                                    ? QUrl::fromLocalFile(imageName)
                                    : QUrl("qrc:///qml/images/codeless.png");


                            data.priority = xml.attributes().value("priority").toInt();

                        } else if (xml.name().toString().toLower() == "description") {
                            data.description = xml.readElementText().trimmed();
                        }
                        break;

                    case QXmlStreamReader::EndElement:
                        if (xml.name().toString().toLower() == "application" && !exclude)
                            results << data;
                        break;

                    default:
                        break;
                    }
                }

                if (xml.error() != QXmlStreamReader::NoError)
                    qWarning("XML Parser error: %s", qPrintable(xml.errorString()));
            }
        }

        std::sort(results.begin(), results.end(), appOrder);

        qDebug() << "Indexer: all done... total:" << results.size();
        QCoreApplication::postEvent(model, new ResultEvent(results));
    }

    QString root;
    ApplicationsModel *model;
    QString target;
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
    names[IconRole] = "icon";
    names[PriorityRole] = "priority";
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
    case DescriptionRole: return ad.description;
    case LocationRole: return ad.location;
    case MainFileRole: return ad.main;
    case IconRole: return ad.icon;
    case PriorityRole: return ad.priority;
    default: qDebug() << "ApplicationsModel::data: unhandled role" << role;
    }

    return QVariant();
}

QString ApplicationsModel::nameAt(int i) const
{
    if (i < 0 || i >= m_data.size()) {
        return "ERROR: out-of-range";
    }
    return m_data[i].name;
}

QString ApplicationsModel::locationAt(int i) const
{
    if (i < 0 || i >= m_data.size()) {
        return "ERROR: out-of-range";
    }
    return m_data[i].location.toLocalFile();
}

QVariant ApplicationsModel::query(int i, const QString &name) const
{
    if (i < 0 || i >= m_data.size()) {
        return QVariant();
    }

    const AppData &ad = m_data.at(i);
    if (name == QStringLiteral("description")) return ad.description;
    else if (name == QStringLiteral("name")) return ad.name;
    else if (name == QStringLiteral("location")) return ad.location;
    else if (name == QStringLiteral("mainFile")) return ad.main;
    else if (name == QStringLiteral("icon")) return ad.icon;
    else if (name == QStringLiteral("priority")) return ad.priority;

    qWarning("ApplicationsModel::query: Asking for bad name %s", qPrintable(name));

    return QVariant();
}
