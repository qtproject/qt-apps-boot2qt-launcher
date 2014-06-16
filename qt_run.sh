#!/system/bin/sh

export QT_QPA_EGLFS_NO_SURFACEFLINGER=1
export QT_QPA_EGLFS_HIDECURSOR=1

export QMLSCENE_DEVICE=customcontext
export CUSTOMCONTEXT_NO_MULTISAMPLE=1

/system/bin/qtlauncher -plugin evdevtouch:/dev/input/event0 --logcat --single-process --ignore-gpu-blacklist
