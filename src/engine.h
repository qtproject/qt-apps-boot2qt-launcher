#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>
#include <QUrl>

class Engine : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString state READ state NOTIFY stateChanged)

    Q_PROPERTY(QUrl backgroundImage READ backgroundImage WRITE setBackgroundImage NOTIFY backgroundImageChanged)

public:
    explicit Engine(QObject *parent = 0);
    
    QString state() const { return m_state; }

    QUrl backgroundImage() const { return m_bgImage; }
    void setBackgroundImage(const QUrl &name);

    Q_INVOKABLE int sensibleButtonSize() const;
    Q_INVOKABLE int titleBarSize() const;

protected:

signals:
    void stateChanged(const QString &state);
    void backgroundImageChanged(const QUrl &name);
    
public slots:
    void initialize();

    void markApplicationsModelReady() { m_apps_ready = true; updateReadyness(); }
    void markIntroAnimationDone() { m_intro_done = true; updateReadyness(); }

private:
    void updateReadyness();

    QString m_state;

    QUrl m_bgImage;

    uint m_intro_done : 1;
    uint m_apps_ready : 1;
};

#endif // ENGINE_H
