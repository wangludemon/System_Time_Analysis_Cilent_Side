// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause


/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import VirtualMachine

Page {
    id: root

    header: ToolBar {
        id: toolBar
        height: 40
        // 定义一个属性来管理按钮状态

        background: Rectangle {
            color: Constants.accentColor
        }

        RowLayout {
            anchors.fill: parent

            Item {
                Layout.fillWidth: true
            }

            Image {
                id: themeTapButton

                source: "images/theme.svg"
                sourceSize.height: 20
                sourceSize.width: 20
                Layout.rightMargin: 19
                visible: false

                TapHandler {
                    onTapped: AppSettings.isDarkTheme = !AppSettings.isDarkTheme
                }
            }
        }
    }

    background: Rectangle {
        color: Constants.accentColor
    }

    StackView {
        id: stackView

        anchors.left: sideMenu.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 5

        initialItem: VirtualMachineView {
        }
    }

    SideBar {
        id: sideMenu

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.topMargin: 30
        height: parent.height

        menuOptions: menuItems
    }

    BottomBar {
        id: bottomMenu

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: parent.width

        visible: false
        position: TabBar.Footer
        menuOptions: menuItems
    }

    ListModel {
        id: menuItems

        ListElement {
            name: qsTr("虚拟机概况")
            view: "VirtualMachineView"
            iconSource: "home.svg"
        }
        ListElement {
            name: qsTr("外设使用概况")
            view: "DeviceManagementView"
            iconSource: "device.svg"
        }

        ListElement {
            name: qsTr("系统模拟")
            view: "SystemSimulatorView"
            iconSource: "home.svg"
        }
        ListElement {
            name: qsTr("时延分析")
            view: "RtaPageView"
            iconSource: "device.svg"
        }

        ListElement {
            name: qsTr("Settings")
            view: "SettingsView"
            iconSource: "settings.svg"
        }

    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout

            PropertyChanges {
                target: sideMenu
                visible: true
                anchors.topMargin: 30
            }
            PropertyChanges {
                target: bottomMenu
                visible: false
            }
            PropertyChanges {
                target: stackView
                anchors.leftMargin: 5
            }

            PropertyChanges {
                target: toolBar
                height: 40
            }
            AnchorChanges {
                target: stackView
                anchors.left: sideMenu.right
                anchors.bottom: parent.bottom
            }
        }
    ]
}
