// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import VirtualMachine

Rectangle {
    id: root
    
    property int cpuUsage: 0
    property int memoryUsage: 0
    
    // 添加硬件概况信息属性
    property string boardName: ""
    property string cpuInfo: ""
    property string memoryInfo: ""
    
    // 添加连接状态属性
    property string buttonStatus: "default" // 状态可以是: "default", "success", "failure"
    
    width: parent.width
    height: 320
    radius: 8
    color: Constants.accentColor
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 8
        
        // IP 连接区域
        RowLayout {
            Layout.fillWidth: true
            Layout.preferredWidth: 300
            spacing: 8
            
            // IP 地址输入框
            TextField {
                id: ipInput
                Layout.fillWidth: true
                placeholderText: "Enter IP Address (e.g., 192.168.1.1)"
                text: "192.168.1.14"
                focus: true
                validator: RegularExpressionValidator {
                    // 简单的IP地址格式验证
                    regularExpression: /^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
                }
                onAccepted: connectButton.clicked() // 按回车键触发连接
            }
            
            // 连接按钮
            Button {
                id: connectButton
                Layout.preferredWidth: 80
                text: "Connect"
                
                background: Rectangle {
                    radius: 5
                    color: getButtonColor()
                    border.color: "#cccccc"
                    
                    function getButtonColor() {
                        switch (root.buttonStatus) {
                            case "success": return "#27ae60"; // 成功绿色
                            case "failure": return "#e74c3c"; // 失败红色
                            case "processing": return "#f39c12"; // 处理中橙色
                            default: return "#3498db"; // 默认蓝色
                        }
                    }
                }
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: {
                    if (ipInput.acceptableInput) {
                        root.buttonStatus = "processing";
                        networkManager.connectToServer(ipInput.text);
                    } else {
                        showErrorDialog("请输入有效的IP地址！");
                    }
                }
            }
        }
        
        // 分隔线
        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: 5
            height: 1
            color: Constants.accentTextColor
            opacity: 0.3
        }
        
        // CPU 使用率
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            
            Label {
                text: "CPU利用率: " + root.cpuUsage + "%"
                font.pixelSize: 16
                font.weight: Font.Medium
                color: Constants.primaryTextColor
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 300
                Layout.maximumWidth: 300
                height: 6
                radius: 3
                color: "#E0E0E0"
                
                Rectangle {
                    width: parent.width * (root.cpuUsage / 100)
                    height: parent.height
                    radius: parent.radius
                    
                    color: {
                        if (root.cpuUsage >= 80) "#FF6B6B"      // 红色
                        else if (root.cpuUsage >= 60) "#FFD93D" // 黄色
                        else "#6BCF7F"                          // 蓝色
                    }
                    
                    Behavior on width {
                        NumberAnimation { duration: 300 }
                    }
                }
            }
        }
        
        // 内存使用率
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4
            
            Label {
                text: "内存占用率: " + root.memoryUsage + "%"
                font.pixelSize: 16
                font.weight: Font.Medium
                color: Constants.primaryTextColor
            }
            
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredWidth: 300
                Layout.maximumWidth: 300
                height: 6
                radius: 3
                color: "#E0E0E0"
                
                Rectangle {
                    width: parent.width * (root.memoryUsage / 100)
                    height: parent.height
                    radius: parent.radius
                    
                    color: {
                        if (root.memoryUsage >= 80) "#FF6B6B"      // 红色
                        else if (root.memoryUsage >= 60) "#FFD93D" // 黄色
                        else "#6BCF7F"                          // 蓝色
                    }
                    
                    Behavior on width {
                        NumberAnimation { duration: 300 }
                    }
                }
            }
        }
        
        // 分隔线
        Rectangle {
            Layout.fillWidth: true
            Layout.topMargin: 15
            height: 1
            color: Constants.accentTextColor
            opacity: 0.3
        }
        
        // 硬件概况信息
        ColumnLayout {
            Layout.fillWidth: true
            Layout.topMargin: 5
            spacing: 4
            
            Label {
                text: "硬件概况"
                font.pixelSize: 18
                font.weight: Font.Bold
                color: Constants.primaryTextColor
            }
            
            Label {
                text: boardName || "开发板：--"
                font.pixelSize: 16
                font.weight: Font.Medium
                color: Constants.primaryTextColor
                Layout.topMargin: 8
            }
            
            Label {
                text: cpuInfo || "CPU核心数：--"
                font.pixelSize: 16
                font.weight: Font.Medium
                color: Constants.primaryTextColor
                Layout.topMargin: 6
            }
            
            Label {
                text: memoryInfo || "总内存：--"
                font.pixelSize: 16
                font.weight: Font.Medium
                color: Constants.primaryTextColor
                Layout.topMargin: 6
            }
        }
    }
    
    // 显示错误对话框的函数 - 使用全局错误处理或从父组件传递
    function showErrorDialog(message) {
        console.log("Error:", message)
        // 这里可以调用全局错误处理函数，或者通过信号传递给父组件处理
        // 暂时使用简单的console输出，避免重复的错误对话框代码
    }
    
    // 监听网络管理器信号
    Connections {
        target: networkManager
        
        function onConnectionSuccess() {
            root.buttonStatus = "success";
            // 可以添加成功提示
        }
        
        function onConnectionFailed(errorMessage) {
            root.buttonStatus = "failure";
            showErrorDialog("连接失败：" + errorMessage);
        }
        
        function onRustShyperInfoUpdate(rustShyperInfo) {
            if (rustShyperInfo) {
                root.cpuUsage = rustShyperInfo.cpuUtilizationRate
                root.memoryUsage = rustShyperInfo.memUtilizationRate
                
                // 更新硬件概况信息
                root.boardName = rustShyperInfo.board || ""
                root.cpuInfo = rustShyperInfo.cpuInfo || ""
                root.memoryInfo = rustShyperInfo.memoryInfo || ""
            }
        }
    }
}