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
#ifndef ENGINE_H
#define ENGINE_H

#include <QQuickItem>
#include <QUrl>
#include <QSize>

#include <QColor>

class QQmlEngine;
class FpsCounter;
class QQuickWindow;

class Engine : public QQuickItem
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

    Q_PROPERTY(QUrl applicationMain READ applicationMain NOTIFY applicationMainChanged)
    Q_PROPERTY(QString applicationName READ applicationName NOTIFY applicationNameChanged)
    Q_PROPERTY(QString applicationDescription READ applicationDescription NOTIFY applicationDescriptionChanged)

    Q_PROPERTY(bool fpsEnabled READ isFpsEnabled WRITE setFpsEnabled NOTIFY fpsEnabledChanged)
    Q_PROPERTY(qreal fps READ fps NOTIFY fpsChanged)

    Q_PROPERTY(const QString qtVersion READ qtVersion CONSTANT)

public:
    explicit Engine(QQuickItem *parent = nullptr);
    
    QString state() const { return m_state; }
    void setState(const QString &state);

    bool isFpsEnabled() const { return m_fps_enabled; }
    void setFpsEnabled(bool enabled);

    qreal fps() const { return m_fps; }

    QString qtVersion() const { return QT_VERSION_STR; }

    QUrl applicationMain() const { return m_applicationMain; }
    QString applicationName() const { return m_applicationName; }
    QString applicationDescription() const { return m_applicationDescription; }

    static bool checkForGlAvailability();

    Q_INVOKABLE int titleFontSize() const { return qMax<int>(m_dpcm * 0.9, 20); }
    Q_INVOKABLE int centimeter(int val = 1) const { return (m_dpcm * val); }
    Q_INVOKABLE int mm(int val) const { return (int)(m_dpcm * val * 0.1); }

protected:

signals:
    void stateChanged(const QString &state);
    void activeIconChanged(QQuickItem *item);
    void applicationMainChanged(const QUrl &applicationMain);
    void applicationNameChanged(const QString &applicationName);
    void applicationDescriptionChanged(const QString &applicationName);
    void fpsChanged(qreal fps);
    void fpsEnabledChanged(bool enabled);

public slots:
    void markApplicationsModelReady() { m_apps_ready = true; updateReadyness(); }
    void markIntroAnimationDone() { m_intro_done = true; updateReadyness(); }

    void launchApplication(const QUrl &location, const QString &mainFile, const QString &name, const QString &desc);
    void closeApplication();

    void setFps(qreal fps);

    bool fileExists(const QUrl &fileName);

private slots:
    void windowChanged(QQuickWindow *window);

private:
    void updateReadyness();
    void updateFPSCounter();

    QString m_state;

    QUrl m_applicationMain;
    QString m_applicationName;
    QString m_applicationDescription;

    QSize m_screenSize;
    qreal m_dpcm;

    FpsCounter *m_fpsCounter;
    qreal m_fps;

    uint m_intro_done : 1;
    uint m_apps_ready : 1;
    uint m_fps_enabled : 1;
};

#endif // ENGINE_H
