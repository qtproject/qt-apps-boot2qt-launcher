// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

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

    if (idd.endsWith("_missing"))
        idd = ":/qt/qml/QtLauncher/QtImageProviders/thumbnail.png";

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

    if (idd.endsWith("_missing"))
        idd = ":/qt/qml/QtLauncher/QtImageProviders/thumbnail.png";

    QImage image(idd);

    if (!image.isNull()) {
        const int min = qMin(image.width(), image.height());

        image = image.copy(image.width() / 2 + BORDERSIZE - min / 2, image.height() / 2 + BORDERSIZE - min / 2,  min - BORDERSIZE * 2, min - BORDERSIZE * 2)
                .scaled(requestedSize.width(), requestedSize.height())
                .convertToFormat(QImage::Format_ARGB32);

        if (id.contains("gradient")) {
            QPainter p(&image);
            QRect r = image.rect();
            QLinearGradient gradient(r.topLeft(), r.bottomLeft());
            gradient.setColorAt(0, QColor(0xff, 0xff, 0xff, 0x99));
            gradient.setColorAt(0.5, Qt::transparent);
            gradient.setColorAt(1, QColor(0x0, 0x41, 0x4a, 0x88));
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
        QColor color(44,222,133, 200);
        p.fillRect(r, color);
    }

    cutEdges(image, CORNER_CUTSIZE);
    drawBorders(p, image.width(), image.height(), CORNER_CUTSIZE, QColor(0x2c, 0xde, 0x85));
    return QPixmap::fromImage(image);
}

QtButtonImageProvider::QtButtonImageProvider() : QQuickImageProvider(QQuickImageProvider::Pixmap)
{
}

QPixmap QtButtonImageProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    bool ok = false;

    QStringList params = id.split("/");

    int cutSize = params.at(0).toInt(&ok);

    if (!ok)
        cutSize = 10;

    QColor fillColor;
    QColor borderColor;

    if (params.length() > 1) {
        fillColor = QColor(params.at(1));
    }

    if (params.length() > 2)
        borderColor = QColor(params.at(2));

    if (!fillColor.isValid())
        fillColor = QColor(0x41, 0xcd, 0x52);

    if (!borderColor.isValid())
        borderColor ="white";

    int width = 100;
    int height = 50;

    if (size)
        *size = QSize(requestedSize.width(), requestedSize.height());

    QPixmap pixmap(requestedSize.width() > 0 ? requestedSize.width() : width,
                   requestedSize.height() > 0 ? requestedSize.height() : height);
    pixmap.fill(Qt::transparent);

    QPainter painter(&pixmap);
    const qreal borderPenWidth = 2;
    QPen borderPen(QBrush(borderColor), borderPenWidth);
    borderPen.setJoinStyle(Qt::MiterJoin);
    painter.setRenderHint(QPainter::Antialiasing, true);
    painter.setPen(borderPen);
    painter.setBrush(fillColor);

    QPainterPath path;
    qreal top = borderPenWidth - 1;
    qreal left = borderPenWidth - 1;
    qreal bottom = pixmap.height() - borderPenWidth;
    qreal right = pixmap.width() - borderPenWidth;
    path.moveTo(left + cutSize, top);
    path.lineTo(right, top);
    path.lineTo(right, bottom - cutSize);
    path.lineTo(right - cutSize, bottom);
    path.lineTo(left, bottom);
    path.lineTo(left, top + cutSize);
    path.lineTo(left + cutSize, top);
    painter.drawPath(path);

    return pixmap;
}
