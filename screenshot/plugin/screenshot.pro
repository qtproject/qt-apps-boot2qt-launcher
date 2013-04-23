TEMPLATE = lib
TARGET = screenshotplugin
QT += quick
CONFIG += qt plugin

TARGETPATH=Qt/labs/screenshot

SOURCES += plugin.cpp

OTHER_FILES = qmldir

target.path = $$[QT_INSTALL_QML]/$$TARGETPATH

qmldir.files = qmldir
qmldir.path = $$[QT_INSTALL_QML]/$$TARGETPATH

INSTALLS = target qmldir
