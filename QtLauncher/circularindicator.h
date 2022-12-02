// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#ifndef CIRCULARINDICATOR_H
#define CIRCULARINDICATOR_H

#include <QQuickPaintedItem>
#include <QPainter>

class CircularIndicator : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(int startAngle READ startAngle WRITE setStartAngle NOTIFY startAngleChanged)
    Q_PROPERTY(int spanAngle READ spanAngle WRITE setSpanAngle NOTIFY spanAngleChanged)
    Q_PROPERTY(int lineWidth READ lineWidth WRITE setLineWidth NOTIFY lineWidthChanged)
    Q_PROPERTY(QColor progressColor READ progressColor WRITE setProgressColor NOTIFY progressColorChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(int padding READ padding WRITE setPadding NOTIFY paddingChanged)
    QML_ELEMENT

public:
    CircularIndicator(QQuickItem *parent = 0);
    ~CircularIndicator() = default;

    int startAngle() const;
    int spanAngle() const;
    int lineWidth() const;
    QColor progressColor() const;
    QColor backgroundColor() const;
    int padding() const;

    void setStartAngle(int angle);
    void setSpanAngle(int angle);
    void setLineWidth(int width);
    void setProgressColor(const QColor &color);
    void setBackgroundColor(const QColor &color);
    void setPadding(int padding);

signals:
    void startAngleChanged(int);
    void spanAngleChanged(int);
    void lineWidthChanged(int);
    void progressColorChanged(QColor);
    void backgroundColorChanged(QColor);
    void paddingChanged(int);

protected:
    void paint(QPainter *painter);

private:
    int m_startAngle;
    int m_spanAngle;
    int m_lineWidth;
    QColor m_progressColor;
    QColor m_backgroundColor;
    int m_padding;
};

#endif // CIRCULARINDICATOR_H
