SOURCES += src/main.cpp \
    src/engine.cpp

QT += quick
TARGET = boot2qt-launcher

QML_FILES += qml/Main.qml \
             qml/main_nexus7.qml \
             qml/main_desktop.qml \

HEADERS += \
    src/engine.h

qmlfiles.path = $$[INSTALL_ROOT]/boot2qt-launcher
qmlfiles.files = QML_FILES

target.path = $$[INSTALL_ROOT]/boot2qt-launcher

INSTALLS += target qmlfiles

