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
import QtQuick.Effects
import CustomControls
import VirtualMachine

Pane {
    id: root

    property alias isEnabled: toggle.checked
    property alias toggle: toggle

    required property bool isMVM
    required property int vmId
    required property string name
    required property string floor
    required property string iconName
    //required property int temp
    //required property int humidity
    //required property int energy
    required property bool active
    required property var model
    required property int cpuNum
    required property string cpuID
    required property string memory
    required property string supportDevice
    required property string vmState

    width: internal.width
    height: internal.height

    topPadding: 12
    leftPadding: internal.leftPadding
    bottomPadding: 0
    rightPadding: 16

    background: Rectangle {
        radius: 12
        color: Constants.accentColor
    }

    RowLayout {
        id: header

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: internal.switchMargin
        spacing: 16

        Item {
            Layout.preferredWidth: internal.iconSize
            Layout.preferredHeight: internal.iconSize
            Layout.alignment: Qt.AlignTop

            Image {
                id: icon

                source: "images/" + root.iconName
                sourceSize.width: internal.iconSize
                sourceSize.height: internal.iconSize
            }

            MultiEffect {
                anchors.fill: icon
                source: icon
                colorization: 1
                colorizationColor: Constants.iconColor
            }
        }

        Column {
            id: title

            Layout.fillWidth: true
            spacing: internal.titleSpacing

            Label {
                text: root.name
                font.pixelSize: 24
                font.weight: 600
                font.family: "Titillium Web"
                color: Constants.primaryTextColor
            }

            Label {
                text: root.floor
                font.pixelSize: 10
                font.weight: 400
                font.family: "Titillium Web"
                color: Constants.accentTextColor
            }
        }

        CustomSwitch {
            id: toggle
            checked: isMVM ? false: root.active
            isMVM: root.isMVM
            onCheckedChanged: isMVM ?(model.active = model.active) : (model.active = toggle.checked)
        }
    }

    Column {
        id: column

        spacing: internal.spacing
        anchors.left: parent.left
        anchors.leftMargin: internal.columnMargin
        anchors.top: header.bottom
        anchors.topMargin: 10

        Repeater {
            model: [qsTr("CPU数量: %1".arg(root.cpuNum)),
                qsTr("CPU bitmap(标识使用了哪些CPU核): %1".arg(root.cpuID)),
                qsTr("内存: %1".arg(root.memory)),
                qsTr("支持设备: %1".arg(root.supportDevice)),
                qsTr("状态: %1".arg(root.vmState))]

            Label {
                text: modelData
                font.pixelSize: 14
                font.weight: 400
                font.family: "Titillium Web"
                color: toggle.checked ? Constants.primaryTextColor : "#898989"
            }
        }
    }



    Rectangle {
        id: separator

        anchors.bottom: menu.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#DCDCDC"
    }

    /*
    ListModel {
        id: roomOptions
        ListElement {
            name: "Cool"
        }
        ListElement {
            name: "Heat"
        }
        ListElement {
            name: "Dry"
        }
        ListElement {
            name: "Fan"
        }
        ListElement {
            name: "Eco"
        }
        ListElement {
            name: "Auto"
        }
    }
    */

    ListModel {
        id: roomOptions
        ListElement {
            name: "start"
        }
        ListElement {
            name: "remove"
        }
    }

    RowLayout {
        id: menu

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 24

        Repeater {
            model: roomOptions

            VirtualMachineOption {
                id: roomOption

                Layout.fillWidth: true
                Layout.fillHeight: true

                isEnabled: root.isEnabled

                isActive: isMVM ? false: (root.model.mode === roomOption.name)
                vmName: root.name
                vmId: root.vmId
                isMVM: root.isMVM

                Connections {
                    function onClicked() {
                        if (!isMVM) {
                            root.model.mode = roomOption.name;
                        }
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 30
        }

        Item {
            Layout.preferredWidth: 24
            Layout.preferredHeight: 24
            Layout.alignment: Qt.AlignBottom
            Layout.bottomMargin: 19

            Image {
                id: icon2

                source: "images/more.svg"
                sourceSize.width: 24
            }

            MultiEffect {
                anchors.fill: icon2
                source: icon2
                colorization: 1
                colorizationColor: root.isEnabled ? Constants.accentTextColor : "#898989"
            }
        }

    }

    Connections {
        target: networkManager
        function onVmOperateSuccess(origVmId, newVmId, operateType) {
            if (root.vmId != origVmId) {
                return;
            }
            console.log("onVmOperateSuccess, ", origVmId);
            root.vmId = newVmId;
            if(operateType === "start") {
                root.vmState = "running";
            } else if (operateType === "remove") {
                root.vmState = "removed";
            } else {
                console.log("onVmOperateSuccess, unknow operateType:", operateType);
            }
        }

        function onVmOperateFailed(origVmId, newVmId, operateType) {
            if (root.vmId != origVmId) {
                return;
            }
            console.log("onVmOperateFailed, ", origVmId, operateType);
            if(operateType === "start") {
                root.model.mode = "remove";
            } else if (operateType === "remove") {
                root.model.mode = "start";
            } else {
                console.log("onVmOperateFailed, unknow operateType:", operateType);
            }
        }
    }

    QtObject {
        id: internal

        property int width: 530
        property int height: 330
        property int rightMargin: 60
        property int leftPadding: 16
        property int titleSpacing: 8
        property int spacing: 16
        property int columnMargin: 7
        property int iconSize: 34
        property int switchMargin: 9
    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout

            PropertyChanges {
                target: internal
                width: 530
                height: 330
                rightMargin: 53
                leftPadding: 16
                spacing: 16
                titleSpacing: 8
                columnMargin: 7
                iconSize: 34
                switchMargin: 9
            }
        }
    ]
}