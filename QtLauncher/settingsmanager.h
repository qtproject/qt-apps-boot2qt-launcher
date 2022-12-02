// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include "qqmlintegration.h"
#include <QObject>
#include <QSettings>

class SettingsManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool gridSelected READ gridSelected WRITE setGridSelected NOTIFY gridSelectedChanged)
    Q_PROPERTY (bool mouseSelected READ mouseSelected WRITE setMouseSelected NOTIFY mouseSelectedChanged)

    QML_ELEMENT
    QML_SINGLETON
public:
    explicit SettingsManager(QObject *parent = nullptr);
    ~SettingsManager();

    bool gridSelected();
    void setGridSelected(bool enabled);
    bool mouseSelected();
    void setMouseSelected(bool enabled);

    Q_INVOKABLE QVariant getValue(const QString& key, const QVariant &defaultValue);
    Q_INVOKABLE void setValue(const QString& key, const QVariant &value);

signals:
    void gridSelectedChanged(bool enabled);
    void mouseSelectedChanged(bool enabled);

private:
    QSettings m_settings;
};

#endif // SETTINGSMANAGER_H
