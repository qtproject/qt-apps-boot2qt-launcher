#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>
#include <QUrl>

#include <QColor>

class QQmlEngine;
class QQuickItem;
class FpsCounter;
class QQuickWindow;

class Engine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

    Q_PROPERTY(bool bootAnimationEnabled READ isBootAnimationEnabled WRITE setBootAnimationEnabled NOTIFY bootAnimationEnabledChanged)
    Q_PROPERTY(QString backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(QUrl backgroundImage READ backgroundImage WRITE setBackgroundImage NOTIFY backgroundImageChanged)

    Q_PROPERTY(QQuickItem *activeIcon READ activeIcon NOTIFY activeIconChanged)
    Q_PROPERTY(QUrl applicationMain READ applicationMain NOTIFY applicationMainChanged)
    Q_PROPERTY(QUrl applicationUrl READ applicationUrl NOTIFY applicationUrlChanged)

    Q_PROPERTY(bool fpsEnabled READ isFpsEnabled WRITE setFpsEnabled NOTIFY fpsEnabledChanged)
    Q_PROPERTY(qreal fps READ fps NOTIFY fpsChanged)

    Q_PROPERTY(const QString qtVersion READ qtVersion)

public:
    explicit Engine(QObject *parent = 0);
    
    QString state() const { return m_state; }
    void setState(const QString &state);

    QUrl backgroundImage() const { return m_bgImage; }
    void setBackgroundImage(const QUrl &name);

    QString backgroundColor() const { return m_bgColor; }
    void setBackgroundColor(const QString &color);

    bool isFpsEnabled() const { return m_fps_enabled; }
    void setFpsEnabled(bool enabled);

    qreal fps() const { return m_fps; }

    QQmlEngine *qmlEngine() const { return m_qmlEngine; }
    void setQmlEngine(QQmlEngine *engine) { m_qmlEngine = engine; }

    bool isBootAnimationEnabled() const { return m_bootAnimationEnabled; }
    void setBootAnimationEnabled(bool enabled);

    QQuickItem *activeIcon() const { return m_activeIcon; }

    QString qtVersion() const { return QT_VERSION_STR; }

    QUrl applicationUrl() const { return m_applicationUrl; }
    QUrl applicationMain() const { return m_applicationMain; }

    void setWindow(QQuickWindow *window) { m_window = window; }

    Q_INVOKABLE int sensibleButtonSize() const;
    Q_INVOKABLE int titleBarSize() const;
    Q_INVOKABLE int fontSize() const { return sensibleButtonSize() * 0.2; }
    Q_INVOKABLE int titleFontSize() const { return sensibleButtonSize() * 0.25; }

protected:

signals:
    void stateChanged(const QString &state);
    void backgroundImageChanged(const QUrl &name);
    void backgroundColorChanged(const QString &color);
    void activeIconChanged(QQuickItem *item);
    void applicationUrlChanged(const QUrl &applicationUrl);
    void applicationMainChanged(const QUrl &applicationMain);
    void bootAnimationEnabledChanged(bool enabled);
    void fpsChanged(qreal fps);
    void fpsEnabledChanged(bool enabled);

public slots:
    void markApplicationsModelReady() { m_apps_ready = true; updateReadyness(); }
    void markIntroAnimationDone() { m_intro_done = true; updateReadyness(); }

    void launchApplication(const QUrl &location, const QString &mainFile, QQuickItem *appIcon);
    void closeApplication();

    void setFps(qreal fps);

private:
    void updateReadyness();

    QQuickWindow *m_window;
    QQmlEngine *m_qmlEngine;

    QString m_state;

    QUrl m_bgImage;
    QString m_bgColor;

    QQuickItem *m_activeIcon;
    QUrl m_applicationUrl;
    QUrl m_applicationMain;

    FpsCounter *m_fpsCounter;
    qreal m_fps;

    uint m_intro_done : 1;
    uint m_apps_ready : 1;
    uint m_fps_enabled : 1;

    uint m_bootAnimationEnabled;
};

#endif // ENGINE_H
