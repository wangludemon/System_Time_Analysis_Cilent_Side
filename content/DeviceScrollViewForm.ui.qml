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

ScrollView {
    id: root

    clip: true
    contentWidth: availableWidth

    property bool isOneColumn
    property int viewHeight
    property int viewWidth

    background: Rectangle {
        color: Constants.isSmallLayout ? Constants.accentColor : "transparent"
        radius: 12
    }

    GridLayout {
        id: grid

        width: root.width
        height: root.height
        columns: root.isOneColumn ? 1 : 3
        rows: root.isOneColumn ? 10 : 1
        columnSpacing: 24
        rowSpacing: root.isOneColumn ? 12 : 24

        DeviceTablePane {

            Layout.columnSpan: root.isOneColumn ? 1 : 3
            Layout.rowSpan: root.isOneColumn ? 7 : 1
            Layout.preferredHeight: root.viewHeight
            Layout.preferredWidth: root.viewWidth
            Layout.alignment: Qt.AlignHCenter
        }
    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout
            PropertyChanges {
                target: root

                viewHeight: 855
                viewWidth: 1094
            }
        },
        State {
            name: "mobileLayout"
            when: Constants.isMobileLayout
            PropertyChanges {
                target: root

                viewHeight: 794
                viewWidth: 327
            }
        },
        State {
            name: "smallLayout"
            when: Constants.isSmallLayout
            PropertyChanges {
                target: root

                viewHeight: 330
                viewWidth: 400
            }
        }
    ]
}
