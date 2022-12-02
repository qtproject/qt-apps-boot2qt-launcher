cmake_minimum_required(VERSION 3.16)

project(qtlauncher VERSION 1.0 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Qml Quick QuickControls2 WaylandCompositor)
qt_standard_project_setup(REQUIRES 6.5)

if(NOT DEFINED USE_SHARED_BUILD)
    message("Doing STATIC build")
    set(USE_STATIC_BUILD_FLAG TRUE)
    set(BUILD_TYPE_FLAG "STATIC")
else()
    message("Doing SHARED build")
    set(USE_STATIC_BUILD_FLAG FALSE)
    set(BUILD_TYPE_FLAG "SHARED")
endif()

qt_add_executable(${PROJECT_NAME}
    main.cpp
)

if(NOT DEFINED USE_SHARED_BUILD)
    target_compile_definitions(${PROJECT_NAME} PRIVATE USE_STATIC_BUILD_FLAG)
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt6::Gui
    Qt6::Qml
    $<$<BOOL:${USE_STATIC_BUILD_FLAG}>:QtLauncherplugin>
    $<$<BOOL:${USE_STATIC_BUILD_FLAG}>:QtImageProvidersPlugin>
)

add_subdirectory(QtLauncher)

install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
