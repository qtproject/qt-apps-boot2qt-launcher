/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
**
****************************************************************************/
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
        LargeIconNameRole
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
