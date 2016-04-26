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

#ifndef APPLICATIONSETTINGS_H
#define APPLICATIONSETTINGS_H

#include <QObject>
#include <QUrl>

class ApplicationSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl mainFile READ mainFile NOTIFY mainFileChanged)
    Q_PROPERTY(QString appsRoot READ appsRoot NOTIFY appsRootChanged)
    Q_PROPERTY(bool isLogcatEnabled READ isLogcatEnable NOTIFY isLogcatEnabledChanged)
    Q_PROPERTY(bool isBootAnimationEnabled READ isBootAnimationEnabled NOTIFY isBootAnimationEnabledChanged)
    Q_PROPERTY(bool isShowFPSEnabled READ isShowFPSEnabled NOTIFY isShowFPSEnabledChanged)
public:
    explicit ApplicationSettings(QObject *parent = 0);

    QUrl mainFile() const;
    QString appsRoot() const;
    bool isLogcatEnable() const;
    bool isBootAnimationEnabled() const;
    bool isShowFPSEnabled() const;

    bool parseCommandLineArguments();



signals:
    void mainFileChanged(QUrl newFile);
    void appsRootChanged(QString appRoot);
    void isLogcatEnabledChanged(bool isEnabled);
    void isBootAnimationEnabledChanged(bool isEnabled);
    void isShowFPSEnabledChanged(bool isEnabled);

private:
    QUrl m_mainFile;
    QString m_appsRoot;
    bool m_isLogcatEnabled;
    bool m_isBootAnimationEnabled;
    bool m_isShowFPSEnabled;

};

#endif // APPLICATIONSETTINGS_H
