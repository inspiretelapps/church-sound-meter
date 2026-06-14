cmake_minimum_required(VERSION 3.16)
project(OpenSoundMeter
    VERSION 1.5.2
    DESCRIPTION "Open Sound Meter - FFT based application for tuning sound systems"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC OFF)
set(CMAKE_AUTORCC ON)

# ---- Find Qt ----
find_package(QT NAMES Qt6 Qt5 REQUIRED COMPONENTS
    Core Gui Widgets Qml Quick QuickControls2 OpenGL Network
)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS
    Core Gui Widgets Qml Quick QuickControls2 OpenGL Network
)
message(STATUS "Building with Qt ${QT_VERSION}")

# ---- Git version ----
execute_process(
    COMMAND git describe --tags
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    OUTPUT_VARIABLE APP_GIT_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
    ERROR_QUIET
)
if(NOT APP_GIT_VERSION)
    set(APP_GIT_VERSION "v${PROJECT_VERSION}")
endif()

# ---- Resource files ----
set(QRC_FILES
    ${CMAKE_SOURCE_DIR}/qml.qrc
    ${CMAKE_SOURCE_DIR}/audio/noises.qrc
    ${CMAKE_SOURCE_DIR}/fonts/fonts.qrc
    ${CMAKE_SOURCE_DIR}/images.qrc
    ${CMAKE_SOURCE_DIR}/shaders/shaders.qrc
)

# ---- Core sources (cross-platform) ----
set(CORE_SOURCES
    src/main.cpp
    src/abstract/data.cpp
    src/abstract/levelsdata.cpp
    src/abstract/source.cpp
    src/audio/client.cpp
    src/audio/deviceinfo.cpp
    src/audio/devicemodel.cpp
    src/audio/format.cpp
    src/audio/plugin.cpp
    src/audio/stream.cpp
    src/chart/crestfactorplot.cpp
    src/chart/cursorhelper.cpp
    src/chart/frequencybasedplot.cpp
    src/chart/frequencybasedserieshelper.cpp
    src/chart/groupdelayplot.cpp
    src/chart/levelobject.cpp
    src/chart/levelplot.cpp
    src/chart/meterplot.cpp
    src/chart/nyquistplot.cpp
    src/chart/palette.cpp
    src/chart/phasedelayplot.cpp
    src/chart/seriesesitem.cpp
    src/chart/spectrogramplot.cpp
    src/chart/stepplot.cpp
    src/chart/coherenceplot.cpp
    src/chart/axis.cpp
    src/chart/painteditem.cpp
    src/chart/variablechart.cpp
    src/chart/plot.cpp
    src/chart/rtaplot.cpp
    src/chart/impulseplot.cpp
    src/chart/phaseplot.cpp
    src/chart/magnitudeplot.cpp
    src/chart/xyplot.cpp
    src/common/autosaver.cpp
    src/common/recentfilesmodel.cpp
    src/common/wavfile.cpp
    src/common/workingfolder.cpp
    src/common/appearance.cpp
    src/common/logger.cpp
    src/common/notifier.cpp
    src/common/profiler.cpp
    src/common/settings.cpp
    src/filesystem/dialog.cpp
    src/filesystem/dialogPlugin.cpp
    src/filesystem/plugins/widgetdialogplugin.cpp
    src/generator/generator.cpp
    src/generator/generatorthread.cpp
    src/generator/pinknoise.cpp
    src/generator/outputdevice.cpp
    src/generator/whitenoise.cpp
    src/generator/sinnoise.cpp
    src/generator/sinsweep.cpp
    src/generator/brownnoise.cpp
    src/generator/burstnoise.cpp
    src/generator/channelmodel.cpp
    src/generator/mlsplus.cpp
    src/generator/musicnoise.cpp
    src/generator/sinburst.cpp
    src/generator/wav.cpp
    src/generator/mnoise.cpp
    src/inputdevice.cpp
    src/meta/metaequalizer.cpp
    src/meta/metabase.cpp
    src/meta/metafilter.cpp
    src/meta/metameasurement.cpp
    src/meta/metastored.cpp
    src/meta/metawindowing.cpp
    src/model/metertablemodel.cpp
    src/model/sourcemodel.cpp
    src/remote/generatorremote.cpp
    src/remote/item.cpp
    src/remote/items/groupitem.cpp
    src/remote/items/measurementitem.cpp
    src/remote/items/storeditem.cpp
    src/remote/network.cpp
    src/remote/remoteclient.cpp
    src/remote/server.cpp
    src/remote/tcpreciever.cpp
    src/shared/sourcelist_shared.cpp
    src/shared/source_shared.cpp
    src/source/equalizer.cpp
    src/source/filtersource.cpp
    src/source/group.cpp
    src/source/sourcewindowing.cpp
    src/source/standardline.cpp
    src/source/union.cpp
    src/source/stored.cpp
    src/source/measurement.cpp
    src/sourcelist.cpp
    src/targettrace.cpp
    src/math/bandpass.cpp
    src/math/biquad.cpp
    src/math/equalloudnesscontour.cpp
    src/math/integration_tree.cpp
    src/math/leq.cpp
    src/math/lowpassfilter.cpp
    src/math/notch.cpp
    src/math/weighting.cpp
    src/math/meter.cpp
    src/math/coherence.cpp
    src/math/averaging.cpp
    src/math/complex.cpp
    src/math/fouriertransform.cpp
    src/math/windowfunction.cpp
    src/math/deconvolution.cpp
)

# ---- Architecture-specific math ----
if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|ARM64|arm64")
    message(STATUS "Building for ARM — ARM math (header-only)")
else()
    message(STATUS "Building for x86_64 — SSE math")
    list(APPEND CORE_SOURCES src/math/ssemath.cpp)
endif()

# ---- MOC headers (non-recursive; platform-filtered) ----
file(GLOB CORE_HEADERS
    ${CMAKE_SOURCE_DIR}/src/*.h
    ${CMAKE_SOURCE_DIR}/src/abstract/*.h
    ${CMAKE_SOURCE_DIR}/src/audio/*.h
    ${CMAKE_SOURCE_DIR}/src/chart/*.h
    ${CMAKE_SOURCE_DIR}/src/common/*.h
    ${CMAKE_SOURCE_DIR}/src/container/*.h
    ${CMAKE_SOURCE_DIR}/src/filesystem/*.h
    ${CMAKE_SOURCE_DIR}/src/filesystem/plugins/widgetdialogplugin.h
    ${CMAKE_SOURCE_DIR}/src/generator/*.h
    ${CMAKE_SOURCE_DIR}/src/math/*.h
    ${CMAKE_SOURCE_DIR}/src/meta/*.h
    ${CMAKE_SOURCE_DIR}/src/model/*.h
    ${CMAKE_SOURCE_DIR}/src/remote/*.h
    ${CMAKE_SOURCE_DIR}/src/remote/items/*.h
    ${CMAKE_SOURCE_DIR}/src/shared/*.h
    ${CMAKE_SOURCE_DIR}/src/source/*.h
)

# Platform audio plugins — add only the one for this platform
if(APPLE)
    list(APPEND CORE_HEADERS ${CMAKE_SOURCE_DIR}/src/audio/plugins/coreaudio.h)
    if(IOS)
        list(APPEND CORE_HEADERS
            ${CMAKE_SOURCE_DIR}/src/audio/plugins/audiosession.h
            ${CMAKE_SOURCE_DIR}/src/filesystem/plugins/iosdialogplugin.h
        )
    endif()
elseif(WIN32)
    list(APPEND CORE_HEADERS ${CMAKE_SOURCE_DIR}/src/audio/plugins/wasapi.h)
    if(EXISTS "${CMAKE_SOURCE_DIR}/../asiosdk")
        list(APPEND CORE_HEADERS ${CMAKE_SOURCE_DIR}/src/audio/plugins/asioplugin.h)
    endif()
elseif(UNIX AND NOT APPLE)
    list(APPEND CORE_HEADERS ${CMAKE_SOURCE_DIR}/src/audio/plugins/alsa.h)
endif()

# Needed by MOC when processing measurement.h
add_compile_definitions(NO_API_REVISION=1)

# Individual MOC files (not combined, to prevent include leaking between namespaces)
qt_wrap_cpp(MOC_SOURCES ${CORE_HEADERS})

# ---- Create executable ----
add_executable(${PROJECT_NAME}
    ${CORE_SOURCES}
    ${MOC_SOURCES}
    ${QRC_FILES}
)

# ---- Defines ----
target_compile_definitions(${PROJECT_NAME} PRIVATE
    QT_DEPRECATED_WARNINGS
    QT_MESSAGELOGCONTEXT
    APP_GIT_VERSION="${APP_GIT_VERSION}"
    NO_API_REVISION=1
)

# ---- Include paths ----
target_include_directories(${PROJECT_NAME} PRIVATE
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_SOURCE_DIR}/src/meta
    ${CMAKE_SOURCE_DIR}/src/chart
    ${CMAKE_SOURCE_DIR}/src/common
    ${CMAKE_SOURCE_DIR}/src/remote
    ${CMAKE_SOURCE_DIR}/src/generator
    ${CMAKE_SOURCE_DIR}/src/source
    ${CMAKE_SOURCE_DIR}/src/model
    ${CMAKE_SOURCE_DIR}/src/container
    ${CMAKE_SOURCE_DIR}/src/math
)

# ---- Link Qt libraries ----
target_link_libraries(${PROJECT_NAME} PRIVATE
    Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Gui
    Qt${QT_VERSION_MAJOR}::Widgets
    Qt${QT_VERSION_MAJOR}::Qml
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::QuickControls2
    Qt${QT_VERSION_MAJOR}::OpenGL
    Qt${QT_VERSION_MAJOR}::Network
)

# ---- Platform audio backends ----
if(APPLE)
    target_sources(${PROJECT_NAME} PRIVATE src/audio/plugins/coreaudio.cpp)
    target_link_libraries(${PROJECT_NAME} PRIVATE
        "-framework CoreAudio"
        "-framework AudioToolbox"
        "-framework CoreFoundation"
    )
    if(IOS)
        target_sources(${PROJECT_NAME} PRIVATE
            src/audio/plugins/audiosession.mm
            src/filesystem/plugins/iosdialogplugin.mm
        )
        target_link_libraries(${PROJECT_NAME} PRIVATE "-framework AVFoundation")
        target_compile_definitions(${PROJECT_NAME} PRIVATE SUPPORT_64_BIT_IOS)
    endif()
elseif(WIN32)
    target_sources(${PROJECT_NAME} PRIVATE src/audio/plugins/wasapi.cpp)
    target_link_libraries(${PROJECT_NAME} PRIVATE ole32)
    if(EXISTS "${CMAKE_SOURCE_DIR}/../asiosdk")
        message(STATUS "ASIO SDK found — enabling ASIO")
        target_compile_definitions(${PROJECT_NAME} PRIVATE USE_ASIO)
        target_sources(${PROJECT_NAME} PRIVATE src/audio/plugins/asioplugin.cpp)
        target_include_directories(${PROJECT_NAME} PRIVATE
            ${CMAKE_SOURCE_DIR}/../asiosdk/common
            ${CMAKE_SOURCE_DIR}/../asiosdk/host
            ${CMAKE_SOURCE_DIR}/../asiosdk/host/pc
        )
        target_link_libraries(${PROJECT_NAME} PRIVATE Advapi32)
    endif()
elseif(UNIX AND NOT APPLE)
    target_sources(${PROJECT_NAME} PRIVATE src/audio/plugins/alsa.cpp)
    find_package(ALSA REQUIRED)
    target_link_libraries(${PROJECT_NAME} PRIVATE ALSA::ALSA)
endif()

# ---- Graphics backend: Metal or OpenGL ----
if(NOT DEFINED GRAPH_BACKEND)
    if(APPLE)
        set(GRAPH_BACKEND "METAL")
    else()
        set(GRAPH_BACKEND "OPENGL")
    endif()
endif()

if(GRAPH_BACKEND STREQUAL "METAL" AND APPLE)
    message(STATUS "Graphics backend: Metal")
    target_compile_definitions(${PROJECT_NAME} PRIVATE GRAPH_METAL)
    target_include_directories(${PROJECT_NAME} PRIVATE src/chart/metal)
    file(GLOB METAL_HEADERS ${CMAKE_SOURCE_DIR}/src/chart/metal/*.h)
    qt_wrap_cpp(METAL_MOC ${METAL_HEADERS})
    target_sources(${PROJECT_NAME} PRIVATE ${METAL_MOC}
        # Metal backend sources:
        src/chart/metal/rtaseriesnode.mm
        src/chart/metal/coherenceseriesnode.mm
        src/chart/metal/groupdelayseriesnode.mm
        src/chart/metal/phasedelayseriesnode.mm
        src/chart/metal/impulseseriesnode.mm
        src/chart/metal/magnitudeseriesnode.mm
        src/chart/metal/phaseseriesnode.mm
        src/chart/metal/seriesnode.mm
        src/chart/metal/spectrogramseriesnode.mm
        src/chart/metal/crestfactorseriesnode.mm
        src/chart/metal/levelseriesnode.mm
        src/chart/metal/nyquistseriesnode.mm
        src/chart/metal/stepseriesnode.mm
        src/chart/metal/xyseriesnode.mm
        src/chart/metal/seriesitem.cpp
        src/chart/metal/plotseriescreator.cpp
    )
    target_link_libraries(${PROJECT_NAME} PRIVATE "-framework Metal")
    # Metal shader compile
    set(METALLIB "${CMAKE_BINARY_DIR}/lib.metallib")
    if(IOS)
        set(METAL_ARGS -sdk iphoneos -std=ios-metal1.0)
    else()
        set(METAL_ARGS -sdk macosx -std=macos-metal1.0)
    endif()
    add_custom_command(
        OUTPUT ${METALLIB}
        COMMAND xcrun ${METAL_ARGS} -c
            ${CMAKE_SOURCE_DIR}/src/chart/metal/shaders.metal
            -o ${CMAKE_BINARY_DIR}/shaders.air
        COMMAND xcrun -sdk macosx metallib
            ${CMAKE_BINARY_DIR}/shaders.air -o ${METALLIB}
        DEPENDS ${CMAKE_SOURCE_DIR}/src/chart/metal/shaders.metal
    )
else()
    message(STATUS "Graphics backend: OpenGL")
    target_compile_definitions(${PROJECT_NAME} PRIVATE GRAPH_OPENGL)
    target_include_directories(${PROJECT_NAME} PRIVATE src/chart/opengl)
    file(GLOB OPENGL_HEADERS ${CMAKE_SOURCE_DIR}/src/chart/opengl/*.h)
    qt_wrap_cpp(OPENGL_MOC ${OPENGL_HEADERS})
    target_sources(${PROJECT_NAME} PRIVATE ${OPENGL_MOC}
        # OpenGL renderer sources:
        src/chart/opengl/plotseriescreator.cpp
        src/chart/opengl/seriesfbo.cpp
        src/chart/opengl/rtaseriesrenderer.cpp
        src/chart/opengl/seriesrenderer.cpp
        src/chart/opengl/impulseseriesrenderer.cpp
        src/chart/opengl/phaseseriesrenderer.cpp
        src/chart/opengl/magnitudeseriesrenderer.cpp
        src/chart/opengl/frequencybasedseriesrenderer.cpp
        src/chart/opengl/xyseriesrenderer.cpp
        src/chart/opengl/coherenceseriesrenderer.cpp
        src/chart/opengl/groupdelayseriesrenderer.cpp
        src/chart/opengl/phasedelayseriesrenderer.cpp
        src/chart/opengl/spectrogramseriesrenderer.cpp
        src/chart/opengl/crestfactorseriesrenderer.cpp
        src/chart/opengl/nyquistseriesrenderer.cpp
        src/chart/opengl/levelseriesrenderer.cpp
        src/chart/opengl/stepseriesrenderer.cpp
    )
    find_package(OpenGL REQUIRED)
    target_link_libraries(${PROJECT_NAME} PRIVATE OpenGL::GL)
endif()

# ---- macOS bundle ----
if(APPLE AND NOT IOS)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        MACOSX_BUNDLE TRUE
        MACOSX_BUNDLE_BUNDLE_NAME "OpenSoundMeter"
        MACOSX_BUNDLE_BUNDLE_VERSION "${PROJECT_VERSION}"
        MACOSX_BUNDLE_SHORT_VERSION_STRING "${PROJECT_VERSION}"
        MACOSX_BUNDLE_GUI_IDENTIFIER "com.opensoundmeter.OpenSoundMeter"
        MACOSX_BUNDLE_INFO_PLIST "${CMAKE_SOURCE_DIR}/Info.plist"
        MACOSX_BUNDLE_ICON_FILE "white.icns"
    )
    set_target_properties(${PROJECT_NAME} PROPERTIES
        XCODE_ATTRIBUTE_CODE_SIGN_ENTITLEMENTS "${CMAKE_SOURCE_DIR}/info.entitlements"
    )
    if(GRAPH_BACKEND STREQUAL "METAL")
        add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                ${METALLIB}
                "$<TARGET_BUNDLE_CONTENT_DIR:${PROJECT_NAME}>/Resources/lib.metallib"
            DEPENDS ${METALLIB}
        )
    endif()
    add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND plutil -replace NSMicrophoneUsageDescription
            -string "Audio measurement"
            "$<TARGET_BUNDLE_DIR:${PROJECT_NAME}>/Contents/Info.plist"
    )
    install(TARGETS ${PROJECT_NAME} BUNDLE DESTINATION .)
elseif(IOS)
    set_target_properties(${PROJECT_NAME} PROPERTIES
        XCODE_ATTRIBUTE_TARGETED_DEVICE_FAMILY "1,2"
        XCODE_ATTRIBUTE_IPHONEOS_DEPLOYMENT_TARGET "12.0"
    )
elseif(WIN32)
    set_target_properties(${PROJECT_NAME} PROPERTIES WIN32_EXECUTABLE TRUE)
elseif(UNIX AND NOT APPLE)
    install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
    install(FILES ${CMAKE_SOURCE_DIR}/OpenSoundMeter.desktop DESTINATION share/applications)
    install(FILES ${CMAKE_SOURCE_DIR}/icons/white.png DESTINATION share/pixmaps)
endif()

message(STATUS "")
message(STATUS "OpenSoundMeter ${APP_GIT_VERSION}")
message(STATUS "  Qt:       ${QT_VERSION}")
message(STATUS "  Backend:  ${GRAPH_BACKEND}")
message(STATUS "  Platform: ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "")
