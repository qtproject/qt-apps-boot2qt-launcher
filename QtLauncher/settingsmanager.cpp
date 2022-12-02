// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include "settingsmanager.h"

SettingsManager::SettingsManager(QObject *parent) :
    QObject(parent),
    m_settings("The Qt Company", "Qt Demo Launcher")
{
}

SettingsManager::~SettingsManager()
{
    m_settings.sync();
}

QVariant SettingsManager::getValue(const QString &key, const QVariant &defaultValue)
{
    return m_settings.value(key, defaultValue);
}

void SettingsManager::setValue(const QString &key, const QVariant &value)
{
    m_settings.setValue(key, value);
    m_settings.sync();
}

bool SettingsManager::gridSelected()
{
    return getValue("gridSelected", false).toBool();
}

void SettingsManager::setGridSelected(bool enabled)
{
    if (gridSelected() == enabled)
        return;

    setValue("gridSelected", enabled);
    emit gridSelectedChanged(enabled);
}

bool SettingsManager::mouseSelected()
{
    return getValue("mouseSelected", false).toBool();
}

void SettingsManager::setMouseSelected(bool enabled)
{
    if (mouseSelected() == enabled)
        return;

    setValue("mouseSelected", enabled);
    emit mouseSelectedChanged(enabled);
}
