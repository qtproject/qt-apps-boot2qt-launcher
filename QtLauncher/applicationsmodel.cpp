// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include "applicationsmodel.h"
#include "applicationsmodel_p.h"

#include <QCoreApplication>
#include <QDirIterator>
#include <QEvent>
#include <QThread>
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QXmlStreamReader>

static bool appOrder(const AppData& a, const AppData& b)
{
    if (a.priority != b.priority)
        return a.priority > b.priority;
    return a.name < b.name;
}

void IndexingThread::run()
{
    QList<AppData> results;
    QList<QString> roots = root.split(":");
    foreach (const QString &root, roots) {
        QDirIterator it(root, QDir::Dirs | QDir::NoDotDot);
        while (it.hasNext()) {
            QString path = it.next();
            if (QFile::exists(path + "/demo.xml"))
                parseDemo(path, results);
        }
    }

    std::sort(results.begin(), results.end(), appOrder);

    qDebug() << "Indexer: all done... total:" << results.size();
    emit indexingFinished(results);
}

void IndexingThread::parseDemo(QString path, QList<AppData> &results) {

    QFile file(path + "/demo.xml");

    if (!file.open(QIODevice::ReadOnly))
        return;

    QXmlStreamReader xml(&file);

    AppData data;
    while (!xml.atEnd()) {
        switch (xml.readNext()) {

        case QXmlStreamReader::StartElement:
            if (xml.name().toString().toLower() == "application") {
                data.location = QUrl::fromLocalFile(path);
                data.name = xml.attributes().value("title").toString().trimmed();

                QString fileName = xml.attributes().value("icon").toString();
                if (fileName.isEmpty())
                    fileName = "screenshot.png";

                QString imageName = QString("%1/%2")
                        .arg(path, fileName);

                data.icon = QFile::exists(imageName)
                        ? QUrl::fromLocalFile(imageName)
                        : QUrl::fromLocalFile(imageName.append("_missing"));

                data.priority = xml.attributes().value("priority").toInt();

                data.binary = xml.attributes().value("binary").toString();
                data.arguments = xml.attributes().value("arguments").toString();
                data.scalable = xml.attributes().value("scalable").toInt();

            } else if (xml.name().toString().toLower() == "environment") {

                while (xml.readNextStartElement()) {
                    if (xml.name().toString().toLower() == "variable" &&
                            xml.attributes().hasAttribute("name") &&
                            xml.attributes().hasAttribute("value")) {
                        data.environment.insert(xml.attributes().value("name").toString(), xml.attributes().value("value").toString());
                        xml.skipCurrentElement();
                    } else {
                        xml.skipCurrentElement();
                    }
                }

            } else if (xml.name().toString().toLower() == "description") {
                data.description = xml.readElementText().trimmed();
            }
            break;

        case QXmlStreamReader::EndElement:
            if (xml.name().toString().toLower() == "application")
                results << data;
            break;

        default:
            break;
        }
    }

    if (xml.error() != QXmlStreamReader::NoError)
        qWarning("XML Parser error: %s", qPrintable(xml.errorString()));
}

ApplicationsModel::ApplicationsModel(QObject *parent) :
    QAbstractItemModel(parent)
{
}

QHash<int, QByteArray> ApplicationsModel::roleNames() const
{
    QHash<int, QByteArray> names;
    names[NameRole] = "name";
    names[DescriptionRole] = "description";
    names[LocationRole] = "location";
    names[IconRole] = "icon";
    names[PriorityRole] = "priority";
    names[BinaryRole] = "binary";
    names[ArgumentsRole] = "arguments";
    names[EnvironmentRole] = "environment";
    names[ScalableRole] = "scalable";
    return names;
}

void ApplicationsModel::initialize(const QString &appsRoot)
{
    auto *thread = new IndexingThread;
    thread->root = appsRoot;
    thread->model = this;
    qRegisterMetaType<QList<AppData>>("QList<AppData>");
    connect(thread, &IndexingThread::indexingFinished,
            this, &ApplicationsModel::handleIndexingResult);
    connect(thread, &QThread::finished, thread, &QObject::deleteLater);
    thread->start();
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
    case IconRole: return ad.icon;
    case PriorityRole: return ad.priority;
    case BinaryRole: return ad.binary;
    case ArgumentsRole: return ad.arguments;
    case EnvironmentRole: return ad.environment;
    case ScalableRole: return ad.scalable;

    default: qDebug() << "ApplicationsModel::data: unhandled role" << role;
    }

    return QVariant();
}

QVariant ApplicationsModel::query(int i, const QString &name) const
{
    if (i < 0 || i >= m_data.size()) {
        return QVariant();
    }

    const AppData &ad = m_data.at(i);
    if (name == QStringLiteral("description"))
        return ad.description;
    if (name == QStringLiteral("name"))
        return ad.name;
    if (name == QStringLiteral("location"))
        return ad.location;
    if (name == QStringLiteral("icon"))
        return ad.icon;
    if (name == QStringLiteral("priority"))
        return ad.priority;
    if (name == QStringLiteral("binary"))
        return ad.binary;
    if (name == QStringLiteral("arguments"))
        return ad.arguments;
    if (name == QStringLiteral("environment"))
        return ad.environment;
    if (name == QStringLiteral("scalable"))
        return ad.scalable;

    qWarning("ApplicationsModel::query: Asking for bad name %s", qPrintable(name));

    return QVariant();
}

void ApplicationsModel::handleIndexingResult(QList<AppData> results)
{
    beginResetModel();
    m_data = results;
    endResetModel();
    emit ready();
}
