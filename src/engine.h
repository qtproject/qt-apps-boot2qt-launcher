#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>
#include <QUrl>

class QQmlEngine;
class QQuickItem;

class Engine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

    Q_PROPERTY(QUrl backgroundImage READ backgroundImage WRITE setBackgroundImage NOTIFY backgroundImageChanged)

    Q_PROPERTY(QQuickItem *activeIcon READ activeIcon NOTIFY activeIconChanged)
    Q_PROPERTY(QUrl applicationUrl READ applicationUrl NOTIFY applicationUrlChanged)

public:
    explicit Engine(QObject *parent = 0);
    
    QString state() const { return m_state; }
    void setState(const QString &state);

    QUrl backgroundImage() const { return m_bgImage; }
    void setBackgroundImage(const QUrl &name);

    QQmlEngine *qmlEngine() const { return m_qmlEngine; }
    void setQmlEngine(QQmlEngine *engine) { m_qmlEngine = engine; }

    QQuickItem *activeIcon() const { return m_activeIcon; }

    QUrl applicationUrl() const { return m_applicationUrl; }

    Q_INVOKABLE int sensibleButtonSize() const;
    Q_INVOKABLE int titleBarSize() const;

protected:

signals:
    void stateChanged(const QString &state);
    void backgroundImageChanged(const QUrl &name);
    void activeIconChanged(QQuickItem *item);
    void applicationUrlChanged(const QUrl &applicationUrl);

public slots:
    void markApplicationsModelReady() { m_apps_ready = true; updateReadyness(); }
    void markIntroAnimationDone() { m_intro_done = true; updateReadyness(); }

    void launchApplication(const QUrl &location, const QString &mainFile, QQuickItem *appIcon);
    void closeApplication();

private:
    void updateReadyness();


    QQmlEngine *m_qmlEngine;

    QString m_state;

    QUrl m_bgImage;


    QQuickItem *m_activeIcon;
    QUrl m_applicationUrl;

    uint m_intro_done : 1;
    uint m_apps_ready : 1;
};

#endif // ENGINE_H
