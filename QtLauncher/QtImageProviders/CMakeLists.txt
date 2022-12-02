cmake_minimum_required(VERSION 3.16)
project(QtImageProviders LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Qml Quick)
qt_standard_project_setup(REQUIRES 6.5)

qt_add_qml_module(${PROJECT_NAME}Plugin
    URI QtLauncher.QtImageProviders
    VERSION 1.0
    ${BUILD_TYPE_FLAG}
    PLUGIN_TARGET ${PROJECT_NAME}Plugin
    NO_PLUGIN_OPTIONAL
    NO_GENERATE_PLUGIN_SOURCE
    CLASS_NAME ${PROJECT_NAME}Plugin
    SOURCES
        imageproviders.cpp imageproviders.h
        plugin.cpp
    RESOURCES
        thumbnail.png
)

target_link_libraries(${PROJECT_NAME}Plugin PRIVATE Qt::Quick)

if(NOT ${USE_STATIC_BUILD_FLAG})
    install(TARGETS ${PROJECT_NAME}Plugin
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/qml/QtLauncher/${PROJECT_NAME}"
    )
    install(FILES $<TARGET_FILE_DIR:${PROJECT_NAME}Plugin>/qmldir
        DESTINATION "${CMAKE_INSTALL_LIBDIR}/qml/QtLauncher/${PROJECT_NAME}"
    )
endif()
