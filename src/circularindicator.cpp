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
#include "circularindicator.h"

CircularIndicator::CircularIndicator(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , mStartAngle(0)
    , mEndAngle(360)
    , mMinimumValue(0.0)
    , mMaximumValue(360.0)
    , mValue(0.0)
    , mLineWidth(10)
    , mProgressColor(QColor(255, 0, 0))
    , mBackgroundColor(QColor(240, 240, 240))
    , mPadding(1)
{
}

CircularIndicator::~CircularIndicator()
{
}

int CircularIndicator::startAngle() const
{
    return mStartAngle;
}

void CircularIndicator::setStartAngle(int angle)
{
    if (angle == mStartAngle)
        return;

    mStartAngle = angle;
    emit startAngleChanged(mStartAngle);
    update();
}

int CircularIndicator::endAngle() const
{
    return mEndAngle;
}

void CircularIndicator::setEndAngle(int angle)
{
    if (angle == mEndAngle)
        return;

    mEndAngle = angle;
    emit endAngleChanged(mEndAngle);
    update();
}

qreal CircularIndicator::minimumValue() const
{
    return mMinimumValue;
}

void CircularIndicator::setMinimumValue(qreal value)
{
    if (qFuzzyCompare(value, mMinimumValue))
        return;

    if (value > mMaximumValue) {
        qWarning() << this << "\nMinimum value can't exceed maximum value.";
        return;
    }

    mMinimumValue = value;
    emit minimumValueChanged(mMinimumValue);
    update();
}

qreal CircularIndicator::maximumValue() const
{
    return mMaximumValue;
}

void CircularIndicator::setMaximumValue(qreal value)
{
    if (qFuzzyCompare(value, mMaximumValue))
        return;

    if (value < mMinimumValue) {
        qWarning() << this << "\nMaximum value can't be less than minimum value.";
        return;
    }

    mMaximumValue = value;
    emit maximumValueChanged(value);
    update();
}

qreal CircularIndicator::value() const
{
    return mValue;
}

void CircularIndicator::setValue(qreal value)
{
    if (qFuzzyCompare(value, mValue))
        return;

    if (value < mMinimumValue) {
        qWarning() << this << "\nValue can't be less than minimum value.";
        return;
    }

    if (value > mMaximumValue) {
        qWarning() << this << "\nValue can't exceed maximum value.";
        return;
    }

    mValue = value;
    emit valueChanged(mValue);
    update();
}

int CircularIndicator::lineWidth() const
{
    return mLineWidth;
}

void CircularIndicator::setLineWidth(int width)
{
    if (width == mLineWidth)
        return;

    mLineWidth = width;
    emit lineWidthChanged(mLineWidth);
    update();
}

QColor CircularIndicator::progressColor() const
{
    return mProgressColor;
}

void CircularIndicator::setProgressColor(QColor color)
{
    if (color == mProgressColor)
        return;

    mProgressColor = color;
    emit progressColorChanged(mProgressColor);
    update();
}

QColor CircularIndicator::backgroundColor() const
{
    return mBackgroundColor;
}

void CircularIndicator::setBackgroundColor(QColor color)
{
    if (color == mBackgroundColor)
        return;

    mBackgroundColor = color;
    emit backgroundColorChanged(mBackgroundColor);
    update();
}

int CircularIndicator::padding() const
{
    return mPadding;
}

void CircularIndicator::setPadding(int padding)
{
    if (padding == mPadding)
        return;

    mPadding = padding;
    emit paddingChanged(mPadding);
    update();
}

void CircularIndicator::paint(QPainter *painter)
{
    painter->setRenderHint(QPainter::Antialiasing);

    int indicatorSize = qMin(width(), height()) - mPadding * 2 - mLineWidth;

    if (indicatorSize <= 0)
        return;

    QRect indicatorRect(width() / 2 - indicatorSize / 2,
                        height() / 2 - indicatorSize / 2,
                        indicatorSize,
                        indicatorSize);

    QPen pen;
    pen.setCapStyle(Qt::FlatCap);
    pen.setWidth(mLineWidth);
    pen.setColor(mBackgroundColor);
    painter->setPen(pen);

    int endAngle = (qAbs(mEndAngle) > 360) ? mEndAngle % 360 : mEndAngle;

    // See http://doc.qt.io/qt-5/qpainter.html#drawArc for details
    int minimumAngle = (90 - mStartAngle) * 16;
    int maximumAngle = (90 - endAngle) * 16 - minimumAngle;

    painter->drawArc(indicatorRect, 0, 360 * 16);

    if (qFuzzyCompare(mValue, mMinimumValue))
        return;

    pen.setColor(mProgressColor);
    painter->setPen(pen);

    int currentAngle = ((mValue - mMinimumValue) / (mMaximumValue - mMinimumValue)) * maximumAngle;

    painter->drawArc(indicatorRect, minimumAngle, currentAngle);
}
