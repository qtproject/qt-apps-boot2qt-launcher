/******************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:COMM$
**
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** $QT_END_LICENSE$
**
******************************************************************************/
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

    Q_PROPERTY(bool bootAnimationEnabled READ isBootAnimationEnabled WRITE setBootAnimationEnabled NOTIFY bootAnimationEnabledChanged)

    Q_PROPERTY(QUrl applicationMain READ applicationMain NOTIFY applicationMainChanged)
    Q_PROPERTY(QUrl applicationUrl READ applicationUrl NOTIFY applicationUrlChanged)
    Q_PROPERTY(QString applicationName READ applicationName NOTIFY applicationNameChanged)

    Q_PROPERTY(bool fpsEnabled READ isFpsEnabled WRITE setFpsEnabled NOTIFY fpsEnabledChanged)
    Q_PROPERTY(qreal fps READ fps NOTIFY fpsChanged)

    Q_PROPERTY(const QString qtVersion READ qtVersion)

    Q_PROPERTY(bool glAvailable READ glAvailable NOTIFY glAvailableChanged)

public:
    explicit Engine(QQuickItem *parent = 0);
    
    QString state() const { return m_state; }
    void setState(const QString &state);

    bool isFpsEnabled() const { return m_fps_enabled; }
    void setFpsEnabled(bool enabled);

    qreal fps() const { return m_fps; }

    bool isBootAnimationEnabled() const { return m_bootAnimationEnabled; }
    void setBootAnimationEnabled(bool enabled);

    QString qtVersion() const { return QT_VERSION_STR; }

    QUrl applicationUrl() const { return m_applicationUrl; }
    QUrl applicationMain() const { return m_applicationMain; }
    QString applicationName() const { return m_applicationName; }

    Q_INVOKABLE QUrl fromUserInput(const QString& userInput) { return QUrl::fromUserInput(userInput); }
    Q_INVOKABLE int sensibleButtonSize() const;
    Q_INVOKABLE int titleBarSize() const;
    Q_INVOKABLE int smallFontSize() const { return qMax<int>(m_dpcm * 0.4, 10); }
    Q_INVOKABLE int fontSize() const { return qMax<int>(m_dpcm * 0.6, 14); }
    Q_INVOKABLE int titleFontSize() const { return qMax<int>(m_dpcm * 0.9, 20); }
    Q_INVOKABLE int centimeter(int val = 1) const { return (m_dpcm * val); }
    Q_INVOKABLE int mm(int val) const { return (int)(m_dpcm * val * 0.1); }
    Q_INVOKABLE int screenWidth() const { return m_screenWidth; }
    Q_INVOKABLE int screenHeight() const { return m_screenHeight; }
    Q_INVOKABLE bool glAvailable() const { return m_glAvailable; }

protected:

signals:
    void stateChanged(const QString &state);
    void activeIconChanged(QQuickItem *item);
    void applicationUrlChanged(const QUrl &applicationUrl);
    void applicationMainChanged(const QUrl &applicationMain);
    void applicationNameChanged(const QString &applicationName);
    void bootAnimationEnabledChanged(bool enabled);
    void fpsChanged(qreal fps);
    void fpsEnabledChanged(bool enabled);
    void glAvailableChanged(bool available);

public slots:
    void markApplicationsModelReady() { m_apps_ready = true; updateReadyness(); }
    void markIntroAnimationDone() { m_intro_done = true; updateReadyness(); }

    void launchApplication(const QUrl &location, const QString &mainFile, const QString &name);
    void closeApplication();

    void setFps(qreal fps);

    bool fileExists(const QUrl &fileName);

private slots:
    void windowChanged(QQuickWindow *window);

private:
    void updateReadyness();
    void updateFPSCounter();

    QString m_state;

    QUrl m_applicationUrl;
    QUrl m_applicationMain;
    QString m_applicationName;

    QSize m_screenSize;
    qreal m_dpcm;
    int m_screenWidth, m_screenHeight;

    FpsCounter *m_fpsCounter;
    qreal m_fps;

    uint m_intro_done : 1;
    uint m_apps_ready : 1;
    uint m_fps_enabled : 1;
    uint m_bootAnimationEnabled : 1;
    bool m_glAvailable;
};

#endif // ENGINE_H
