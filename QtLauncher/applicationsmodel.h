// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#ifndef APPLICATIONSMODEL_H
#define APPLICATIONSMODEL_H

#include "qqmlintegration.h"
#include <QAbstractItemModel>
#include <QUrl>

struct AppData {
    QString name;
    QString description;
    QUrl location;
    QUrl icon;
    int priority;
    QString binary;
    QString arguments;
    QMap<QString, QVariant> environment;
    bool scalable;
};

class ApplicationsModel : public QAbstractItemModel
{
    Q_OBJECT
    QML_ELEMENT

public:
    enum {
        NameRole = Qt::UserRole + 1,
        DescriptionRole,
        LocationRole,
        IconRole,
        PriorityRole,
        BinaryRole,
        ArgumentsRole,
        EnvironmentRole,
        ScalableRole
    };

    explicit ApplicationsModel(QObject *parent = 0);

    Q_INVOKABLE void initialize(const QString &appsRoot);

    QModelIndex index(int r, int c, const QModelIndex &) const { return createIndex(r, c); }
    QModelIndex parent(const QModelIndex&) const { return QModelIndex(); }
    int rowCount(const QModelIndex&) const { return m_data.size(); }
    int columnCount(const QModelIndex&) const { return 1; }
    QVariant data(const QModelIndex &index, int role) const;

    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QVariant query(int i, const QString &name) const;

signals:
    void ready();

private slots:
    void handleIndexingResult(QList<AppData> results);

private:

    QList<AppData> m_data;
};

#endif // APPLICATIONSMODEL_H
