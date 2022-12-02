// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <imageproviders.h>
#include <QtQml/qqmlextensionplugin.h>

void qml_register_types_QtLauncher_QtImageProviders();

class QtImageProvidersPlugin : public QQmlEngineExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)
public:
    void initializeEngine(QQmlEngine *engine, const char *uri) final
    {
        volatile auto registration = &qml_register_types_QtLauncher_QtImageProviders;
        Q_UNUSED(registration);
        Q_UNUSED(uri);

        engine->addImageProvider("QtSquareImage", new QtSquareImageProvider);
        engine->addImageProvider("QtImageMask", new QtImageMaskProvider);
        engine->addImageProvider("QtButtonImage", new QtButtonImageProvider);
    }
};
#include "plugin.moc"
