/****************************************************************************
**
** Copyright (C) 2014 Digia Plc
** All rights reserved.
** For any questions to Digia, please use contact form at http://www.qt.io
**
** This file is part of Qt Enterprise Embedded.
**
** Licensees holding valid Qt Enterprise licenses may use this file in
** accordance with the Qt Enterprise License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.
**
** If you have questions regarding the use of this file, please use
** contact form at http://www.qt.io
**
****************************************************************************/

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
