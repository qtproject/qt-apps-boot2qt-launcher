SOURCES += src/main.cpp \
    src/engine.cpp \
    src/applicationsmodel.cpp \
    src/logmanager.cpp \
    src/fpscounter.cpp

QT += quick widgets
TARGET = qtlauncher

QML_FILES += qml

qtHaveModule(webengine) {
    DEFINES += USE_QTWEBENGINE
    QT += webengine
}

HEADERS += \
    src/engine.h \
    src/applicationsmodel.h \
    src/logmanager.h \
    src/fpscounter.h

#script.files = qt_run.sh
#script.path = $$[INSTALL_ROOT]/system/bin

#include(open-sans/fonts.pri)

android {
    target.path = $$[INSTALL_ROOT]/system/bin
} else {
    target.path = $$[INSTALL_ROOT]/usr/bin
}

INSTALLS += target

RESOURCES += \
    resources.qrc

OTHER_FILES += \
    qml/GridViewWithInertia.qml \
    qml/NoisyGradient.qml \
    qml/Main.qml \
    qml/main_landscape.qml \
    qml/ApplicationIcon.qml \
    qml/LaunchScreen.qml \
    qml/TitleBar.qml \
    qml/BootScreen.qml \
    qml/Background.qml \
    qml/SettingsScreen.qml \
    qml/Section.qml \
    qml/ListViewWithInertia.qml \
    qml/SettingsRow.qml \
    qml/CheckBox.qml \
    qml/DeviceSettings.qml \
    qml/Button.qml \
    qml/Slider.qml \
    open-sans/fonts.pri \
    qml/GlimmeringQtLogo.qml \
    qml/HighlightShader.qml \
    screenshot/Main.qml \
    screenshot/Button.qml

