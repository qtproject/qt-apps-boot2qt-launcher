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

