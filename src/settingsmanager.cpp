/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
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

bool SettingsManager::rotationSelected()
{
    return getValue("rotationSelected", false).toBool();
}

void SettingsManager::setRotationSelected(bool enabled)
{
    if (rotationSelected() == enabled)
        return;
    setValue("rotationSelected", enabled);
    emit rotationSelectedChanged(enabled);
}

bool SettingsManager::demoModeSelected()
{
    return getValue("demoModeSelected", false).toBool();
}

void SettingsManager::setDemoModeSelected(bool enabled)
{
    if (demoModeSelected() == enabled)
        return;
    setValue("demoModeSelected", enabled);
    emit demoModeSelectedChanged(enabled);
}
