QT += qml quick widgets
TARGET = qtlauncher

DEFINES += APPLICATION_VERSION=\\\"2.0.1\\\"

qtHaveModule(webengine) {
    DEFINES += USE_QTWEBENGINE
    QT += webengine
}

HEADERS += \
    src/engine.h \
    src/applicationsmodel.h \
    src/fpscounter.h \
    src/applicationsettings.h \
    src/settingsmanager.h \
    src/imageproviders.h \
    src/circularindicator.h

SOURCES += src/main.cpp \
    src/engine.cpp \
    src/applicationsmodel.cpp \
    src/fpscounter.cpp \
    src/applicationsettings.cpp \
    src/settingsmanager.cpp \
    src/imageproviders.cpp \
    src/circularindicator.cpp

target.path = $$[INSTALL_ROOT]/usr/bin

INSTALLS += target

RESOURCES += \
    icons.qrc \
    images.qrc \
    fonts.qrc \
    qml.qrc
