SOURCES += src/main.cpp \
    src/engine.cpp

QT += quick
TARGET = boot2qt-launcher

QML_FILES += qml

HEADERS += \
    src/engine.h

qmlfiles.path = $$[INSTALL_ROOT]/system/boot2qt-launcher
qmlfiles.files = $$QML_FILES

target.path = $$[INSTALL_ROOT]/system/boot2qt-launcher

INSTALLS += target qmlfiles

RESOURCES += \
    resources.qrc

