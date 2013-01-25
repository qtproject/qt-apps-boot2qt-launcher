#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>

class Engine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString yeahBaby READ yeahBaby)

public:
    explicit Engine(QObject *parent = 0);
    
    QString yeahBaby() const { return QStringLiteral("yeah, baby!"); }

signals:
    
public slots:
    
};

#endif // ENGINE_H
