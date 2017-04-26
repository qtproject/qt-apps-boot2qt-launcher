QT += quick widgets
TARGET = qtlauncher

qtHaveModule(webengine) {
    DEFINES += USE_QTWEBENGINE
    QT += webengine
}

HEADERS += \
    src/engine.h \
    src/applicationsmodel.h \
    src/fpscounter.h \
    src/applicationsettings.h

SOURCES += src/main.cpp \
    src/engine.cpp \
    src/applicationsmodel.cpp \
    src/fpscounter.cpp \
    src/applicationsettings.cpp

OTHER_FILES += \
    qml/LaunchScreen.qml \
    qml/main_landscape.qml \
    qml/HighlightShader.qml \
    qml/Main.qml \
    qml/ApplicationIcon.qml \
    qml/GlimmeringQtLogo.qml \
    qml/BootScreen.qml \
    qml/BusyIndicator.qml

target.path = $$[INSTALL_ROOT]/usr/bin

INSTALLS += target

RESOURCES += \
    resources.qrc
