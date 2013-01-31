SOURCES += src/main.cpp \
    src/engine.cpp \
    src/applicationsmodel.cpp \
    src/logmanager.cpp

QT += quick
TARGET = qtlauncher

QML_FILES += qml

HEADERS += \
    src/engine.h \
    src/applicationsmodel.h \
    src/logmanager.h

target.path = $$[INSTALL_ROOT]/system/bin

INSTALLS += target

RESOURCES += \
    resources.qrc

OTHER_FILES += \
    test/dummyapps/basicapp/info.json \
    test/dummyapps/basicapp/main.qml

