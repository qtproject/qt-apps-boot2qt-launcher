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
    
    void initialize(const QString &appsRoot);

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
