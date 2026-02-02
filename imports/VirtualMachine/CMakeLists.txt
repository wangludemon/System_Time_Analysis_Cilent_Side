# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

set_source_files_properties(Constants.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE true
)

set_source_files_properties(AppSettings.qml
    PROPERTIES
        QT_QML_SINGLETON_TYPE true
)

qt_add_library(VirtualMachine STATIC)
qt_add_qml_module(VirtualMachine
    URI "VirtualMachine"
    VERSION 1.0
    QML_FILES
        AppSettings.qml
        Constants.qml
        VirtualMachineModel.qml
)
