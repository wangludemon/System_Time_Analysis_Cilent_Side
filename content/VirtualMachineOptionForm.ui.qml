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
import VirtualMachine

Button {
    id: root

    required property string name
    required property int vmId
    required property string vmName
    required property bool isEnabled
    required property bool isActive
    required property bool isMVM

    leftPadding: 0
    rightPadding: 0
    topPadding: 12
    bottomPadding: 20
    spacing: 10

    enabled: root.isEnabled
    checked: root.isActive && root.isEnabled
    checkable: isMVM ? false : true
    flat: true
    autoExclusive: true
    display: AbstractButton.TextUnderIcon

    text: root.name
    icon.source: "images/" + root.name + ".svg"
    icon.width: 32
    icon.height: 32

    palette.brightText: "#2CDE85"
    palette.dark: "transparent"
    palette.windowText: root.isEnabled ? Constants.accentTextColor : "#898989"

    font.family: "Titillium Web"
    font.pixelSize: 12
    font.weight: 600

    Image {
        anchors.topMargin: 2
        anchors.top: root.top
        anchors.horizontalCenter: root.horizontalCenter
        source: "images/circle.svg"
        visible: root.down || root.checked
    }

    Connections {
        target: networkManager
    }

    onClicked: {
        if (!isMVM) {
            networkManager.vmOperate(root.vmId,root.name);
            console.log("on VirtualMachineOption onClicked, vmId :", root.vmId, " booton name :", root.name);
        }
    }
}