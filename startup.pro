QT += quick widgets
TARGET = qtlauncher

qtHaveModule(webengine) {
    DEFINES += USE_QTWEBENGINE
    QT += webengine
}

HEADERS += \
    src/engine.h \
    src/applicationsmodel.h \
    src/logmanager.h \
    src/fpscounter.h \
    src/applicationsettings.h

SOURCES += src/main.cpp \
    src/engine.cpp \
    src/applicationsmodel.cpp \
    src/logmanager.cpp \
    src/fpscounter.cpp \
    src/applicationsettings.cpp

OTHER_FILES += \
    qml/LaunchScreen.qml \
    qml/main_landscape.qml \
    qml/HighlightShader.qml \
    qml/Main.qml \
    qml/ApplicationIcon.qml \
    qml/GlimmeringQtLogo.qml \
    qml/BootScreen.qml

android {
    target.path = $$[INSTALL_ROOT]/system/bin
} else {
    target.path = $$[INSTALL_ROOT]/usr/bin
}

INSTALLS += target

RESOURCES += \
    resources.qrc
