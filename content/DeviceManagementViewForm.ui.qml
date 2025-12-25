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
import VirtualMachine
import CustomControls

Pane {
    id: root

    leftPadding: 20
    rightPadding: 20
    bottomPadding: 15

    property int currentRoomIndex: 0

    background: Rectangle {
        color: Constants.backgroundColor
    }

    QtObject {
        id: internal

        readonly property int contentHeight: root.height - title.height
                                             - root.topPadding - root.bottomPadding
        readonly property int contentWidth: root.width - root.rightPadding - root.leftPadding
        readonly property bool isOneColumn: contentWidth < 900
    }

    Column {
        id: title

        width: parent.width
        Label {
            id: header

            text: qsTr("外设使用概况")
            font.pixelSize: 48
            font.weight: 600
            font.family: "Titillium Web"
            color: Constants.primaryTextColor
            elide: Text.ElideRight
        }
    }
    
    // 添加间距
    Item {
        width: parent.width
        height: 20
        anchors.top: title.bottom
    }
    
    DeviceScrollView {
        width: internal.contentWidth
        height: internal.contentHeight - 20 // 减去间距的高度
        isOneColumn: internal.isOneColumn
        anchors.top: title.bottom
        anchors.topMargin: 20
    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout
            PropertyChanges {
                target: header
                font.pixelSize: 48
                font.weight: 600
                font.family: "Titillium Web"
            }
            PropertyChanges {
                target: root
                leftPadding: 20
            }
            PropertyChanges {
                target: scrollView
                visible: true
            }
        },
        State {
            name: "mobileLayout"
            when: Constants.isMobileLayout
            PropertyChanges {
                target: header
                font.pixelSize: 24
                font.weight: 600
                font.family: "Titillium Web"
            }
            PropertyChanges {
                target: root
                leftPadding: 16
                rightPadding: 16
            }
            PropertyChanges {
                target: scrollView
                visible: false
            }
            PropertyChanges {
                target: swipeView
                visible: true
            }
        },
        State {
            name: "smallLayout"
            when: Constants.isSmallLayout
            PropertyChanges {
                target: header
                visible: false
            }
            PropertyChanges {
                target: root
                leftPadding: 15
                rightPadding: 15
            }
            PropertyChanges {
                target: scrollView
                visible: false
            }
            PropertyChanges {
                target: swipeView
                visible: true
            }
        }
    ]
}
