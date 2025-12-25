# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

cmake_minimum_required(VERSION 3.16)

project(iSure LANGUAGES CXX)

# 统一静态 CRT
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>" CACHE STRING "")

# 1. 依赖查找（顺序不变）
find_package(protobuf CONFIG REQUIRED)
find_package(gRPC    CONFIG REQUIRED)
find_package(Qt6 6.5 REQUIRED COMPONENTS Gui Qml Quick QuickControls2 Svg Charts)

qt_standard_project_setup(REQUIRES 6.5)

# 2. proto → C++ 生成函数（保持原样）
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

# 3. 先生成文件，再定义可执行目标
set(PROTO_DIR "${CMAKE_CURRENT_SOURCE_DIR}/proto")
set(GEN_DIR   "${CMAKE_CURRENT_BINARY_DIR}/gen")
file(MAKE_DIRECTORY ${GEN_DIR})
generate_proto(${PROTO_DIR} ${GEN_DIR})
message(STATUS ">>> PARENT_SCOPE Generated_Files: ${Generated_Files}")

# 确保生成物非空
set(GenSrcs ${Generated_Files})

qt_add_executable(iSure src/main.cpp
    src/NetworkManager.h
    src/NetworkManager.cpp
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

target_include_directories(iSure PRIVATE ${GEN_DIR})

target_link_libraries(iSure PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
    Qt6::Svg
    Qt6::Charts
    Qt6::QuickControls2
    protobuf::libprotobuf
    gRPC::grpc++
)

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
