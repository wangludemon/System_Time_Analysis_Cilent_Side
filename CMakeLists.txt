# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

cmake_minimum_required(VERSION 3.16)

project(iSure LANGUAGES CXX)

### MOD-1: 新增开关；默认 OFF（不需要 gRPC 时可直接配置/编译）
option(USE_GRPC "Enable gRPC/protobuf module" OFF)

# 统一静态 CRT（仅对 MSVC 有效；MinGW 不受影响）
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "")

### MOD-2: 调整依赖查找顺序：Qt 始终需要；protobuf/gRPC 仅在 USE_GRPC=ON 时查找
find_package(Qt6 6.5 REQUIRED COMPONENTS Gui Qml Quick QuickControls2 Svg Charts)

### MOD-3: 将 protobuf/gRPC 的 find_package 包进条件；并补充 ZLIB（避免你遇到的 ZLIB::ZLIB target 缺失）
if (USE_GRPC)
    find_package(ZLIB REQUIRED)          # MOD-3a: 启用 gRPC 时才需要 ZLIB::ZLIB
    find_package(protobuf CONFIG REQUIRED)
    find_package(gRPC    CONFIG REQUIRED)
endif()

qt_standard_project_setup(REQUIRES 6.5)

# 2. proto → C++ 生成函数（保持原样；仅在 USE_GRPC=ON 时会被调用）
function(generate_proto SRC_DIR OUT_DIR)
    file(GLOB PROTO_FILES "${SRC_DIR}/*.proto")
    set(OUT_LIST "")                       # 存输出绝对路径
    foreach(proto ${PROTO_FILES})
        get_filename_component(NAME_WE ${proto} NAME_WE)
        set(pb_h  "${OUT_DIR}/${NAME_WE}.pb.h")
        set(pb_cc "${OUT_DIR}/${NAME_WE}.pb.cc")
        set(grpc_h  "${OUT_DIR}/${NAME_WE}.grpc.pb.h")
        set(grpc_cc "${OUT_DIR}/${NAME_WE}.grpc.pb.cc")

        add_custom_command(
            OUTPUT "${pb_h}" "${pb_cc}" "${grpc_h}" "${grpc_cc}"
            COMMAND protobuf::protoc
                --cpp_out "${OUT_DIR}"
                --grpc_out "${OUT_DIR}"
                --plugin=protoc-gen-grpc=$<TARGET_FILE:gRPC::grpc_cpp_plugin>
                -I "${SRC_DIR}"
                "${proto}"
            DEPENDS "${proto}" protobuf::protoc gRPC::grpc_cpp_plugin
            COMMENT "Generating ${NAME_WE}.pb.cc / .grpc.pb.cc"
            VERBATIM
        )
        list(APPEND OUT_LIST "${pb_cc}" "${grpc_cc}")  # 只把源文件挂回去
    endforeach()

    set(Generated_Files ${OUT_LIST} PARENT_SCOPE)
endfunction()

# 3. 仅在 USE_GRPC=ON 时生成 proto 源文件
set(PROTO_DIR "${CMAKE_CURRENT_SOURCE_DIR}/proto")
set(GEN_DIR   "${CMAKE_CURRENT_BINARY_DIR}/gen")

### MOD-4: 生成的 proto 源文件列表默认置空，避免关闭 gRPC 时仍然触发生成/编译
set(GenSrcs "")

### MOD-5: 仅在启用 gRPC 时才执行 proto 生成（避免本机没有 gRPC/protoc 时配置失败）
if (USE_GRPC)
    file(MAKE_DIRECTORY ${GEN_DIR})
    generate_proto(${PROTO_DIR} ${GEN_DIR})
    message(STATUS ">>> PARENT_SCOPE Generated_Files: ${Generated_Files}")

    set(GenSrcs ${Generated_Files})
endif()

# 4. 定义可执行目标（proto 生成文件仅在启用 gRPC 时加入）
qt_add_executable(iSure
    src/main.cpp
    src/NetworkManager.h
    src/NetworkManager.cpp

    ### MOD-6: 只有 USE_GRPC=ON 时 GenSrcs 才非空；OFF 时不会把生成文件加入编译
    ${GenSrcs}

    src/RustShyperInfo.h
    src/DeviceInfo.h
    src/VirtualMachineInfo.h          # ★这里必须出现具体文件
)

qt_add_resources(iSure "configuration"
    PREFIX "/"
    FILES
        qtquickcontrols2.conf
)

include(qmlmodules)

### MOD-7: 仅在启用 gRPC 时才添加 gen 目录到 include path（OFF 时不需要）
if (USE_GRPC)
    target_include_directories(iSure PRIVATE ${GEN_DIR})
endif()

### MOD-8: 将 Qt 基础库链接保持不变；把 gRPC/protobuf 链接拆分到条件中
target_link_libraries(iSure PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
    Qt6::Svg
    Qt6::Charts
    Qt6::QuickControls2
)

### MOD-9: 仅在 USE_GRPC=ON 时链接 protobuf/gRPC/ZLIB，并定义宏；OFF 时定义 USE_GRPC=0
if (USE_GRPC)
    target_link_libraries(iSure PRIVATE
        protobuf::libprotobuf
        gRPC::grpc++
        ZLIB::ZLIB
    )
    target_compile_definitions(iSure PRIVATE USE_GRPC=1)
else()
    target_compile_definitions(iSure PRIVATE USE_GRPC=0)
endif()

install(TARGETS iSure
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

qt_generate_deploy_qml_app_script(
    TARGET iSure
    OUTPUT_SCRIPT deploy_script
    MACOS_BUNDLE_POST_BUILD
    NO_UNSUPPORTED_PLATFORM_ERROR
    DEPLOY_USER_QML_MODULES_ON_UNSUPPORTED_PLATFORM
)
install(SCRIPT ${deploy_script})
