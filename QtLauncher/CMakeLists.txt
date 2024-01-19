cmake_minimum_required(VERSION 3.16)

project(QtLauncher VERSION 1.0 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 WaylandCompositor)
qt_standard_project_setup(REQUIRES 6.5)

set_source_files_properties("ViewSettings.qml" PROPERTIES
    QT_QML_SINGLETON_TYPE TRUE
)

set(qml_files
    "Main.qml"
    "BootScreen.qml"
    "BusyIndicator.qml"
    "Keyboard.qml"
    "MainWindow.qml"
    "DemoHeader.qml"
    "DetailView.qml"
    "Header.qml"
    "LaunchScreen.qml"
    "LauncherCompositor.qml"
    "Background.qml"
    "DemoInfoPopup.qml"
    "DemoSurface.qml"
    "GridViewIcon.qml"
    "FlickSlider.qml"
    "ApplicationIcon.qml"
    "DetailViewIcon.qml"
    "SettingsButton.qml"
    "ViewSettings.qml"
    "CornerFrameImage.qml"
)

set(images
    "images/backImg.jpg"
    "images/QtCorner.png"
    "images/glow.png"
    "images/glow_border.png"
    "images/glow_border2.png"
    "images/glow_corner.png"
)

set(icons
    "icons/close_icon.svg"
    "icons/Built_with_Qt_RGB_logo_white.svg"
    "icons/header_toggle_icon.svg"
    "icons/info_icon.svg"
    "icons/qt_logo_green_rgb.svg"
    "icons/mouse_icon.svg"
    "icons/detail_icon.svg"
    "icons/settings_icon.svg"
    "icons/grid_icon.svg"
    "icons/touch_icon.svg"
)

add_subdirectory(QtImageProviders)

qt_add_qml_module(${PROJECT_NAME}
    URI QtLauncher
    VERSION 1.0
    ${BUILD_TYPE_FLAG}
    DEPENDENCIES
        QtQml
        QtQuick
    QML_FILES
        ${qml_files}
    RESOURCES
        ${images}
        ${icons}
    SOURCES
        engine.cpp engine.h
        applicationsmodel.cpp applicationsmodel.h
        settingsmanager.cpp settingsmanager.h
        circularindicator.cpp circularindicator.h
)

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Quick
)

if(NOT ${USE_STATIC_BUILD_FLAG})
    install(TARGETS ${PROJECT_NAME}
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    )

    install(TARGETS ${PROJECT_NAME}plugin
        LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}/qml/${PROJECT_NAME}"
    )

    install(FILES $<TARGET_FILE_DIR:${PROJECT_NAME}plugin>/qmldir
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/qml/${PROJECT_NAME}"
    )
endif()
