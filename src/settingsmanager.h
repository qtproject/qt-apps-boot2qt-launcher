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
#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject
{
    Q_OBJECT
public:
    explicit SettingsManager(QObject *parent = nullptr);
    ~SettingsManager();

    Q_INVOKABLE QVariant getValue(const QString& key, const QVariant &defaultValue);
    Q_INVOKABLE void setValue(const QString& key, const QVariant &value);

    Q_PROPERTY(bool gridSelected READ gridSelected WRITE setGridSelected NOTIFY gridSelectedChanged)

    bool gridSelected();
    void setGridSelected(bool enabled);

    Q_PROPERTY (bool mouseSelected READ mouseSelected WRITE setMouseSelected NOTIFY mouseSelectedChanged)

    bool mouseSelected();
    void setMouseSelected(bool enabled);

    Q_PROPERTY (bool rotationSelected READ rotationSelected WRITE setRotationSelected NOTIFY rotationSelectedChanged)
    Q_PROPERTY (bool demoModeSelected READ demoModeSelected WRITE setDemoModeSelected NOTIFY demoModeSelectedChanged)
    Q_PROPERTY (int demoModeStartupTime READ demoModeStartupTime WRITE setDemoModeStartupTime NOTIFY demoModeStartupTimeChanged)

    bool rotationSelected();
    void setRotationSelected(bool enabled);
    bool demoModeSelected();
    void setDemoModeSelected(bool enabled);
    int demoModeStartupTime();
    void setDemoModeStartupTime(int startupTime);

signals:
    void gridSelectedChanged(bool enabled);
    void mouseSelectedChanged(bool enabled);
    void rotationSelectedChanged(bool enabled);
    void demoModeSelectedChanged(bool enabled);
    void demoModeStartupTimeChanged(int startupTime);

private:
    QSettings m_settings;
};

#endif // SETTINGSMANAGER_H
