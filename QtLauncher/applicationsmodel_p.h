// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#ifndef APPLICATIONSMODEL_P_H
#define APPLICATIONSMODEL_P_H

#include "applicationsmodel.h"

#include <QThread>

class IndexingThread : public QThread
{
    Q_OBJECT
public:
    virtual ~IndexingThread() = default;
    void run() final;

private:
    void parseDemo(QString path, QList<AppData> &results);

signals:
    void indexingFinished(QList<AppData> results);

public:
    QString root;
    ApplicationsModel *model = nullptr;
};

#endif // APPLICATIONSMODEL_P_H
