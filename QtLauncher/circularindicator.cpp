// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include "circularindicator.h"

CircularIndicator::CircularIndicator(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_startAngle(0)
    , m_spanAngle(360)
    , m_lineWidth(10)
    , m_progressColor(QColor(255, 0, 0))
    , m_backgroundColor(QColor(240, 240, 240))
    , m_padding(1)
{
}

int CircularIndicator::startAngle() const
{
    return m_startAngle;
}

void CircularIndicator::setStartAngle(int angle)
{
    if (angle == m_startAngle)
        return;

    m_startAngle = angle;
    emit startAngleChanged(m_startAngle);
    update();
}

int CircularIndicator::spanAngle() const
{
    return m_spanAngle;
}

void CircularIndicator::setSpanAngle(int angle)
{
    if (angle == m_spanAngle)
        return;

    m_spanAngle = angle;
    emit spanAngleChanged(m_spanAngle);
    update();
}

int CircularIndicator::lineWidth() const
{
    return m_lineWidth;
}

void CircularIndicator::setLineWidth(int width)
{
    if (width == m_lineWidth)
        return;

    m_lineWidth = width;
    emit lineWidthChanged(m_lineWidth);
    update();
}

QColor CircularIndicator::progressColor() const
{
    return m_progressColor;
}

void CircularIndicator::setProgressColor(const QColor &color)
{
    if (color == m_progressColor)
        return;

    m_progressColor = color;
    emit progressColorChanged(m_progressColor);
    update();
}

QColor CircularIndicator::backgroundColor() const
{
    return m_backgroundColor;
}

void CircularIndicator::setBackgroundColor(const QColor &color)
{
    if (color == m_backgroundColor)
        return;

    m_backgroundColor = color;
    emit backgroundColorChanged(m_backgroundColor);
    update();
}

int CircularIndicator::padding() const
{
    return m_padding;
}

void CircularIndicator::setPadding(int padding)
{
    if (padding == m_padding)
        return;

    m_padding = padding;
    emit paddingChanged(m_padding);
    update();
}

void CircularIndicator::paint(QPainter *painter)
{
    painter->setRenderHint(QPainter::Antialiasing);

    const int indicatorSize = qMin(width(), height()) - m_padding * 2 - m_lineWidth;

    if (indicatorSize <= 0)
        return;

    QRect indicatorRect(width() / 2 - indicatorSize / 2,
                        height() / 2 - indicatorSize / 2,
                        indicatorSize,
                        indicatorSize);

    QPen pen;
    pen.setCapStyle(Qt::RoundCap);
    pen.setWidth(m_lineWidth);

    // Draw the background
    pen.setColor(m_backgroundColor);
    painter->setPen(pen);
    painter->drawArc(indicatorRect, 0, 360 * 16);

    if (m_startAngle == m_spanAngle)
        return;

    // Draw the foreground
    pen.setColor(m_progressColor);
    painter->setPen(pen);
    painter->drawArc(indicatorRect, (90 - m_startAngle) * 16, -m_spanAngle * 16);
}
