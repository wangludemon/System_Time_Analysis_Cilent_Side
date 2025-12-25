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



Pane {
    id: root

    topPadding: 4
    leftPadding: 27
    rightPadding: 27
    bottomPadding: 13

    property var virtualMachineInfoList: []

    // 定义本地虚拟机列表模型
    ListModel {
        id: vmsList
    }

    background: Rectangle {
        anchors.fill: parent
        color: Constants.backgroundColor
    }

    Column {
        id: title

        width: internal.contentWidth

        RowLayout {
            width: parent.width
            
            Label {
                id: heading
                text: qsTr("虚拟机概况")
                font: Constants.desktopTitleFont
                color: Constants.primaryTextColor
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Button {
                id: createVmButton
                text: "创建虚拟机"
                font.pixelSize: 16
                font.weight: 600
                Layout.preferredWidth: 120
                Layout.preferredHeight: 40
                
                background: Rectangle {
                    color: parent.down ? "#2CDE85" : "#4CAF50"
                    radius: 5
                }
                
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    console.log("点击创建虚拟机按钮")
                    createVmDialog.open()
                }
            }
        }
    }

    VirtualMachineScrollView {
        id: scrollView

        anchors.top: title.bottom
        anchors.topMargin: 10

        width: internal.contentWidth
        height: internal.contentHeight
        gridWidth: internal.contentWidth
        gridHeight: internal.contentHeight

        delegatePreferredWidth: internal.delegatePreferredWidth
        delegatePreferredHeight: internal.delegatePreferredHeight

        columns: root.width < 1140 ? 1 : 2
        model: vmsList
    }

    VirtualMachineSwipeView {
        id: swipeView

        anchors.top: title.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.right: parent.right

        width: internal.contentWidth
        height: internal.contentHeight
        delegatePreferredHeight: internal.delegatePreferredHeight
        delegatePreferredWidth: internal.delegatePreferredWidth

        model: vmsList
        visible: false
    }

    // 虚拟机列表模型，数据通过updateVirtualMachinesModelData()函数动态加载

    function updateTableModelData() {
        vmsList.clear();
        if (root.virtualMachineInfoList && root.virtualMachineInfoList.length>0) {
            for(var i = 0; i < root.virtualMachineInfoList.length; i++) {
                var vmInfo = root.virtualMachineInfoList[i];
                vmsList.append({
                                   "isMVM": i == 0 ? true: false,
                                   "vmId": vmInfo.id,
                                   "name": vmInfo.name,
                                   "floor": vmInfo.floor,
                                   "iconName": vmInfo.iconName,
                                   "active": vmInfo.active === 1 ? true: false,
                                   "cpuNum": vmInfo.cpuNum,
                                   "cpuID": vmInfo.cpuID,
                                   "memory": vmInfo.memory,
                                   "supportDevice": vmInfo.supportDevice,
                                   "type": vmInfo.type,
                                   "vmState": vmInfo.vmState,
                                   "belongOS": vmInfo.belongOS,
                                   "mode": "start"
                               });
            }

            console.log("成功加载", vmsList.count, "条vmInfo数据到表格。");
        } else {
            console.log("virtualMachineInfoList为空或未定义。");
        }
    }

    Connections {
        target: networkManager

        function onRustShyperInfoUpdate(rustShyperInfo) {
            if (rustShyperInfo) {
                root.virtualMachineInfoList = networkManager.rustShyperInfo.virtualMachineInfoList;
                updateTableModelData();
            } else {
                console.log("DeviceTableForm onRustShyperInfoUpdate, Received rustShyperInfo is undefined!");
            }
        }
    }

    // 当页面加载完成时执行初始化操作
    Component.onCompleted: {
        console.log("on Component.onCompleted:\r\n rustShyperInfo.cpuUtilizationRate:", networkManager.rustShyperInfo.cpuUtilizationRate);
        root.virtualMachineInfoList = networkManager.rustShyperInfo.virtualMachineInfoList;
        updateTableModelData();
        console.log("初始化数据读取完毕。root.virtualMachineInfoList:", root.virtualMachineInfoList);
    }

    // 创建虚拟机对话框
    CreateVmDialog {
        id: createVmDialog
        parent: root  // 设置父级为当前页面
        anchors.centerIn: root  // 在页面中居中显示
        
        onConfigUpdated: function(vmName, osType, cpuCores, memorySize) {
            console.log("创建虚拟机配置：", vmName, osType, cpuCores, memorySize)
            networkManager.createVm(vmName, osType, cpuCores, memorySize)
        }
    }
    
    Connections {
        target: networkManager
        
        function onCreateVmSuccess(vmInfo) {
            console.log("虚拟机创建成功，ID：", vmInfo.id)
            // 直接将新创建的虚拟机添加到列表中
            if (vmInfo && root.virtualMachineInfoList) {
                root.virtualMachineInfoList.push(vmInfo)
                updateTableModelData()
            }
            createVmDialog.close()
        }
        
        function onCreateVmFailed(errorMessage) {
            console.log("虚拟机创建失败：", errorMessage)
            showErrorDialog("虚拟机创建失败：" + errorMessage)
        }
    }
    
    // 错误提示对话框（与HostResourceInfo保持一致）
    Dialog {
        id: errorDialog
        title: "提示"
        modal: true
        parent: root  // 设置父级为当前页面
        anchors.centerIn: root  // 在页面中居中显示
        
        // 自定义背景
        background: Rectangle {
            color: Constants.accentColor
            radius: 8
            border.color: Constants.accentTextColor
            border.width: 1
        }

        contentItem: ColumnLayout {
            spacing: 15
            
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                
                // 使用系统主题图标或自定义图片
                Label {
                    text: "⚠️" // 简单使用Emoji或Unicode符号作为图标
                    font.pointSize: 24
                    color: "#FF5252" // 红色警告图标
                }
                
                Label {
                    id: errorMessageLabel
                    text: ""
                    font.bold: true
                    font.pixelSize: 14
                    color: Constants.primaryTextColor
                    wrapMode: Text.WordWrap
                    Layout.maximumWidth: 300
                }
            }
            
            // 将按钮放在内容区域内，作为最后一行
            Button {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                text: "确定"
                
                background: Rectangle {
                    color: parent.down ? "#2196F3" : (parent.hovered ? "#2196F3" : "#3498db")
                    radius: 4
                    border.color: "#1976D2"
                    border.width: 1
                    
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.pixelSize: 14
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                hoverEnabled: true
                
                onClicked: errorDialog.close()
            }
        }
        
        // 自定义标题栏样式
        header: Label {
            text: errorDialog.title
            font.pixelSize: 16
            font.bold: true
            color: Constants.primaryTextColor
            padding: 12
            background: Rectangle {
                color: AppSettings.isDarkTheme ? "#2C3E50" : "#ECF0F1"
                radius: 6
            }
        }
    }
    
    // 显示错误对话框的函数
    function showErrorDialog(message) {
        errorMessageLabel.text = message
        errorDialog.open()
    }

    QtObject {
        id: internal

        readonly property int contentHeight: root.height - title.height
                                             - root.topPadding - root.bottomPadding
        readonly property int contentWidth: root.width - root.rightPadding - root.leftPadding
        property int delegatePreferredHeight: 330
        property int delegatePreferredWidth: 530
    }

    states: [
        State {
            name: "desktopLayout"
            when: Constants.isBigDesktopLayout || Constants.isSmallDesktopLayout
            PropertyChanges {
                target: heading
                text: qsTr("虚拟机概况")
                font: Constants.desktopTitleFont
            }
            PropertyChanges {
                target: scrollView
                visible: true
            }
            PropertyChanges {
                target: swipeView
                visible: false
            }
            PropertyChanges {
                target: internal
                delegatePreferredHeight: 330
                delegatePreferredWidth: 530
            }
            PropertyChanges {
                target: root
                leftPadding: 27
            }
        },
        State {
            name: "mobileLayout"
            when: Constants.isMobileLayout
            PropertyChanges {
                target: heading
                text: qsTr("虚拟机概况")
                font: Constants.mobileTitleFont
            }
            PropertyChanges {
                target: scrollView
                visible: true
            }
            PropertyChanges {
                target: swipeView
                visible: false
            }
            PropertyChanges {
                target: internal
                delegatePreferredHeight: 215
                delegatePreferredWidth: 306
            }
            PropertyChanges {
                target: root
                leftPadding: 27
            }
        },
        State {
            name: "smallLayout"
            when: Constants.isSmallLayout
            PropertyChanges {
                target: heading
                text: qsTr("虚拟机概况")
                font: Constants.smallTitleFont
            }
            PropertyChanges {
                target: heading2
                visible: false
            }
            PropertyChanges {
                target: scrollView
                visible: false
            }
            PropertyChanges {
                target: swipeView
                visible: true
            }
            PropertyChanges {
                target: internal
                delegatePreferredHeight: 215
                delegatePreferredWidth: 340
            }
            PropertyChanges {
                target: root
                leftPadding: 11
            }
        }
    ]
}
