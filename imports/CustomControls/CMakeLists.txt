# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

qt_add_library(CustomControls STATIC)
qt_add_qml_module(CustomControls
    URI "CustomControls"
    VERSION 1.0
    QML_FILES
        CustomRoundButton.qml
        CustomSwitch.qml
)
