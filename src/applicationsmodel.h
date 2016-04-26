/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
#ifndef APPLICATIONSMODEL_H
#define APPLICATIONSMODEL_H

#include <QAbstractItemModel>
#include <QUrl>


struct AppData {
    QString name;
    QString description;
    QString main;
    QUrl location;
    QUrl icon;
    int priority;
};


class ApplicationsModel : public QAbstractItemModel
{
    Q_OBJECT
public:
    enum {
        NameRole = Qt::UserRole + 1,
        DescriptionRole,
        MainFileRole,
        LocationRole,
        IconRole,
        LargeIconNameRole,
        PriorityRole
    };

    explicit ApplicationsModel(QObject *parent = 0);
    
    Q_INVOKABLE void initialize(const QString &appsRoot);

    QModelIndex index(int r, int c, const QModelIndex &) const { return createIndex(r, c); }
    QModelIndex parent(const QModelIndex&) const { return QModelIndex(); }
    int rowCount(const QModelIndex&) const { return m_data.size(); }
    int columnCount(const QModelIndex&) const { return 1; }
    QVariant data(const QModelIndex &index, int role) const;

    QHash<int, QByteArray> roleNames() const;

    Q_INVOKABLE QString nameAt(int i) const;
    Q_INVOKABLE QString locationAt(int i) const;

    Q_INVOKABLE QVariant query(int i, const QString &name) const;

signals:
    void ready();



protected:
    bool event(QEvent *e);

private:

    QList<AppData> m_data;
};



#endif // APPLICATIONSMODEL_H
