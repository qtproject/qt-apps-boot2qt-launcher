// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#ifndef IMAGEPROVIDERS_H
#define IMAGEPROVIDERS_H

#include <QQuickImageProvider>

class QtImageProvider : public QQuickImageProvider
{
public:
    QtImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
};

class QtSquareImageProvider : public QQuickImageProvider
{
public:
    QtSquareImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
};

class QtImageMaskProvider : public QQuickImageProvider
{
public:
    QtImageMaskProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
};

class QtButtonImageProvider : public QQuickImageProvider
{
public:
    QtButtonImageProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
};

#endif // IMAGEPROVIDERS_H
