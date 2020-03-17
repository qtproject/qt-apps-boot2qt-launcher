/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
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
#include "imageproviders.h"

#include <QImage>
#include <QPixmap>
#include <QPen>
#include <QBrush>
#include <QPainter>
#include <QPainterPath>
#include <QLinearGradient>

static const int CORNER_CUTSIZE = 20;
static const int BORDERSIZE = 3;

void cutEdges(QImage &image, int cutSize)
{
    if (!image.isNull()) {
        const int w = image.width()-1;
        const int h = image.height()-1;
        if (w >= cutSize && h >= cutSize) {
            for (int y=0; y <= cutSize; y++) {
                for (int x=0; x <= (cutSize - y); x++) {
                    image.setPixelColor(x, y, QColor(Qt::transparent));
                    image.setPixelColor(w - x, h - y, QColor(Qt::transparent));
                }
            }
        }
    }
}

void drawBorders(QPainter& painter, int w, int h, int cutSize, const QColor &color)
{
    QPen pen;
    pen.setCosmetic(true);
    pen.setWidth(3);
    pen.setColor(color);

    painter.setPen(pen);
    painter.setBrush(Qt::NoBrush);

    QPainterPath path;
    path.moveTo(cutSize + 1, 1);
    path.lineTo(w - 1, 1);
    path.lineTo(w - 1, h - cutSize - 1);
    path.lineTo(w - cutSize - 1, h - 1);
    path.lineTo(1, h - 1);
    path.lineTo(1, cutSize + 1);
    path.lineTo(cutSize + 1, 1);
    path.closeSubpath();
    painter.drawPath(path);
}

QtImageProvider::QtImageProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap)
{
}

QPixmap QtImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(size);
    Q_UNUSED(requestedSize);

    QString idd = id;
    idd.remove("file://");

    QImage image(idd);
    if (!image.isNull()) {
        image = image.copy(BORDERSIZE, BORDERSIZE, image.width() - BORDERSIZE * 2, image.height() - BORDERSIZE * 2)
                .convertToFormat(QImage::Format_ARGB32);
        cutEdges(image, CORNER_CUTSIZE);
    }

    return QPixmap::fromImage(image);
}

QtSquareImageProvider::QtSquareImageProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap)
{
}

QPixmap QtSquareImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(size);
    Q_UNUSED(requestedSize);

    QString idd = id;
    idd.remove("file://");
    idd.remove("gradient/");

    QImage image(idd);
    if (!image.isNull()) {
        const int min = qMin(image.width(), image.height());
        image = image.copy(BORDERSIZE, BORDERSIZE, min - BORDERSIZE * 2, min - BORDERSIZE * 2)
                .scaled(requestedSize.width(), requestedSize.height())
                .convertToFormat(QImage::Format_ARGB32);

        if (id.contains("gradient")) {
            QPainter p(&image);
            QRect r = image.rect();
            QLinearGradient gradient(r.topLeft(), r.bottomLeft());
            gradient.setColorAt(0, QColor("#99FFFFFF"));
            gradient.setColorAt(0.25, Qt::transparent);
            p.fillRect(r, gradient);
        }

        cutEdges(image, CORNER_CUTSIZE);
    }

    return QPixmap::fromImage(image);
}

QtImageMaskProvider::QtImageMaskProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap)
{
}

QPixmap QtImageMaskProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(size);

    if (requestedSize.width() <= 0)
        return QPixmap(1, 1);

    QImage image(requestedSize.width(), requestedSize.height(), QImage::Format_ARGB32);
    image.fill(Qt::transparent);

    QPainter p(&image);

    if (id.contains("hover")) {
        QRect r = image.rect().adjusted(1, 1, -1, -1);
        QLinearGradient gradient(r.topLeft(), r.bottomRight());
        gradient.setColorAt(0, QColor("#99000000"));
        gradient.setColorAt(1, QColor("#9941cd52"));
        p.fillRect(r, gradient);
    }

    if (id.contains("namebox"))
        p.fillRect(QRectF(0, image.height() * 0.65, image.width(), image.height() * 0.35), QBrush(QColor("#99000000")));

    cutEdges(image, CORNER_CUTSIZE);
    drawBorders(p, image.width(), image.height(), CORNER_CUTSIZE, QColor("#41cd52"));
    return QPixmap::fromImage(image);
}
