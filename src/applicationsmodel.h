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

private slots:
    void handleIndexingResult(QList<AppData> results);

private:

    QList<AppData> m_data;
};



#endif // APPLICATIONSMODEL_H
