#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>
#include <QUrl>

#include <QColor>

class QQmlEngine;
class QQuickItem;

class Engine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)

    Q_PROPERTY(QUrl backgroundImage READ backgroundImage WRITE setBackgroundImage NOTIFY backgroundImageChanged)

    Q_PROPERTY(QQuickItem *activeIcon READ activeIcon NOTIFY activeIconChanged)
    Q_PROPERTY(QUrl applicationUrl READ applicationUrl NOTIFY applicationUrlChanged)
    Q_PROPERTY(QString backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)

    Q_PROPERTY(bool hasIconShadows READ hasIconShadows WRITE setHasIconShadows NOTIFY hasIconShadowsChanged)

public:
    explicit Engine(QObject *parent = 0);
    
    QString state() const { return m_state; }
    void setState(const QString &state);

    QUrl backgroundImage() const { return m_bgImage; }
    void setBackgroundImage(const QUrl &name);

    QString backgroundColor() const { return m_bgColor; }
    void setBackgroundColor(const QString &color);

    QQmlEngine *qmlEngine() const { return m_qmlEngine; }
    void setQmlEngine(QQmlEngine *engine) { m_qmlEngine = engine; }

    QQuickItem *activeIcon() const { return m_activeIcon; }

    QUrl applicationUrl() const { return m_applicationUrl; }

    void setHasIconShadows(bool shadows);
    bool hasIconShadows() const { return m_hasIconShadows; }

    Q_INVOKABLE int sensibleButtonSize() const;
    Q_INVOKABLE int titleBarSize() const;

protected:

signals:
    void stateChanged(const QString &state);
    void backgroundImageChanged(const QUrl &name);
    void backgroundColorChanged(const QString &color);
    void activeIconChanged(QQuickItem *item);
    void applicationUrlChanged(const QUrl &applicationUrl);
    void hasIconShadowsChanged(bool shadows);

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
    QString m_bgColor;

    QQuickItem *m_activeIcon;
    QUrl m_applicationUrl;

    uint m_intro_done : 1;
    uint m_apps_ready : 1;

    uint m_hasIconShadows;
};

#endif // ENGINE_H
