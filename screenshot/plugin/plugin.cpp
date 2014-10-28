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
#include <QtQml/QQmlExtensionPlugin>

#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickWindow>

#include <QtGui/QImageWriter>

class ScreenShot : public QQuickItem
{
    Q_OBJECT

public slots:
    bool grab(const QString &name, const QSize &size = QSize()) {
        if (window()) {
            QImage image = window()->grabWindow();
            if (size.width() > 0 && size.height() > 0)
                image = image.scaled(size, Qt::IgnoreAspectRatio, Qt::SmoothTransformation);

            QImageWriter writer(name);
            writer.setQuality(95);
            bool ok = writer.write(image);
            if (ok)
                qDebug("ScreenShot::grab: saved '%s'", qPrintable(name));
            else
                qDebug("ScreenShot::grab: Failed to save '%s'", qPrintable(name));
            return ok;
        } else {
            qWarning("ScreenShot::grab: no window to grab !!");
        }
        return false;
    }
};

QML_DECLARE_TYPE(ScreenShot)

class ScreenShotPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface/1.0")

public:
    virtual void registerTypes(const char *uri)
    {
        qmlRegisterType<ScreenShot>(uri, 1, 0, "ScreenShot");
    }
};

#include "plugin.moc"

