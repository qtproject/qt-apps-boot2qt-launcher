FONTFILES += \
    $$PWD/OpenSans-BoldItalic.ttf \
    $$PWD/OpenSans-ExtraBold.ttf \
    $$PWD/OpenSans-ExtraBoldItalic.ttf \
    $$PWD/OpenSans-Italic.ttf \
    $$PWD/OpenSans-Light.ttf \
    $$PWD/OpenSans-LightItalic.ttf \
    $$PWD/OpenSans-Regular.ttf \
    $$PWD/OpenSans-Semibold.ttf \
    $$PWD/OpenSans-SemiboldItalic.ttf

fontfiles.files = $$FONTFILES
fontfiles.path = $$[QT_INSTALL_LIBS]/fonts

INSTALLS += fontfiles

