// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#ifndef ENGINE_H
#define ENGINE_H

#include <QQuickItem>
#include <QProcess>

class Engine : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(QString state READ state WRITE setState NOTIFY engineStateChanged)
    Q_PROPERTY(const QString qtVersion READ qtVersion CONSTANT)
    QML_ELEMENT

public:
    explicit Engine(QQuickItem *parent = nullptr);

    QString state() const { return m_state; }
    void setState(const QString &state);
    QString qtVersion() const { return QT_VERSION_STR; }

signals:
    void engineStateChanged(const QString &state);

public slots:
    void markApplicationsModelReady();
    void launchApplication(const QString &binary, const QString &arguments = "", const QVariantMap &env = QVariantMap());
    void closeApplication();

private:
    QString m_state;
    QProcess m_process;
};

#endif // ENGINE_H
