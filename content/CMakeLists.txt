# Copyright (C) 2023 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

qt_add_library(isureContent STATIC)
qt_add_qml_module(isureContent
    URI "content"
    VERSION 1.0
    QML_FILES
        App.qml
        BottomBar.qml
        BottomBarForm.ui.qml

        HomePage.qml
        HomePageForm.ui.qml

        SystemSimulatorView.qml
        RtaPageView.qml

        VirtualMachineItem.qml
        VirtualMachineItemForm.ui.qml
        VirtualMachineOption.qml
        VirtualMachineOptionForm.ui.qml
        VirtualMachineScrollView.qml
        VirtualMachineScrollViewForm.ui.qml
        VirtualMachineSwipeView.qml
        VirtualMachineSwipeViewForm.ui.qml
        VirtualMachineView.qml
        VirtualMachineViewForm.ui.qml

        SideBar.qml
        SideBarForm.ui.qml
        HostResourceInfo.qml
        CreateVmDialog.qml



        DeviceScrollView.qml
        DeviceScrollViewForm.ui.qml
        DeviceTablePane.qml
        DeviceTablePaneForm.ui.qml
        DeviceManagementView.qml
        DeviceManagementViewForm.ui.qml

    RESOURCES
        images/arrow.svg
        images/circle.svg
        images/home.svg

        images/logo.png
        images/more.svg
        images/settings.svg
        images/stats.svg

        images/theme.svg
        images/device.svg

        RESOURCES images/openEuler.svg
        RESOURCES images/Zephyr.svg
        RESOURCES images/ubuntu.svg
        RESOURCES images/sylix.svg
        RESOURCES images/ArceOS.svg
        RESOURCES images/linux.svg
        RESOURCES images/start.svg
        QML_FILES DeviceTable.qml
        QML_FILES DeviceTableForm.ui.qml

        QML_FILES SettingsView.qml SettingsViewForm.ui.qml
        RESOURCES images/remove.svg
        RESOURCES images/openEuler.svg
        QML_FILES SystemSimulatorView.qml
        QML_FILES RtaPageView.qml
)
