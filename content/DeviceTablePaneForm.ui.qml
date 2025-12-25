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
import QtQuick.Effects
import QtQuick.Layouts
import Qt.labs.qmlmodels
import CustomControls
import VirtualMachine

Pane {
    id: root

    property alias buttonGroup: buttonGroup

    property int cpuUtilizationRate: 0
    property int memUtilizationRate: 0
    property string board: ""

    property bool isActive: false

    padding: 0

    background: Rectangle {
        color: Constants.accentColor
        radius: 12
    }

    Connections {
        target: networkManager // 这是你在main.cpp中注册的context property
    }

    DeviceTable {
        id: deviceTable
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    ButtonGroup {
        id: buttonGroup
    }

    QtObject {
        id: internal

        property int buttonWidth: 130
        property int buttonHeight: 66
        property int radius: 20
        property int leftMargin: 20
        property int topMargin: 16
        property int iconSize: 34
        property int optionIconSize: 42
        property int headerSpacing: 24
        property int headerSize: 24
    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout
            PropertyChanges {
                target: internal
                buttonHeight: 66
                buttonWidth: 130
                radius: 20
                leftMargin: 20
                topMargin: 16
                iconSize: 34
                optionIconSize: 42
                headerSpacing: 24
                headerSize: 24
            }
        },
        State {
            name: "mobileLayout"
            when: Constants.isMobileLayout
            PropertyChanges {
                target: internal
                buttonHeight: 50
                buttonWidth: 110
                radius: 12
                leftMargin: 16
                topMargin: 16
                iconSize: 24
                optionIconSize: 30
                headerSpacing: 16
                headerSize: 18
            }
        },
        State {
            name: "smallLayout"
            when: Constants.isSmallLayout
            PropertyChanges {
                target: internal
                buttonHeight: 42
                buttonWidth: 42
                radius: 21
                leftMargin: 14
                topMargin: 11
                iconSize: 24
                optionIconSize: 24
                headerSpacing: 12
                headerSize: 18
            }
        }
    ]
}
