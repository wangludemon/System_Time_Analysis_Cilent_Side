// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import VirtualMachine

Dialog {
    id: root
    
    modal: true
    title: "创建虚拟机"
    
    width: 500
    height: 500
    
    // 使对话框在点击背景时不会关闭
    closePolicy: Dialog.CloseOnEscape
    
    // 自定义按钮样式，不使用标准按钮
    standardButtons: Dialog.NoButton
    
    // 设置对话框背景色
    background: Rectangle {
        color: Constants.backgroundColor
        border.color: AppSettings.isDarkTheme ? "#333333" : "#D9D9D9"
        border.width: 1
        radius: 8
    }
    
    // 设置标题栏样式
    header: Rectangle {
        color: AppSettings.isDarkTheme ? "#1E3A5F" : "#F0F4F8"
        height: 40
        
        // 使整个标题栏区域可以拖拽
        MouseArea {
            id: dragArea
            anchors.fill: parent
            acceptedButtons: Qt.LeftButton
            
            property point globalPressPos: Qt.point(0, 0)
            property point windowStartPos: Qt.point(0, 0)
            
            onPressed: {
                globalPressPos = mapToGlobal(mouse.x, mouse.y)
                windowStartPos = Qt.point(root.x, root.y)
            }
            
            onPositionChanged: {
                if (pressed) {
                    var currentGlobalPos = mapToGlobal(mouse.x, mouse.y)
                    var deltaX = currentGlobalPos.x - globalPressPos.x
                    var deltaY = currentGlobalPos.y - globalPressPos.y
                    
                    var newX = windowStartPos.x + deltaX
                    var newY = windowStartPos.y + deltaY
                    
                    // 限制在主窗口范围内
                    var mainWindow = root.parent
                    if (mainWindow) {
                        var maxX = mainWindow.width - root.width
                        var maxY = mainWindow.height - root.height
                        
                        newX = Math.max(0, Math.min(newX, maxX))
                        newY = Math.max(0, Math.min(newY, maxY))
                    }
                    
                    root.x = newX
                    root.y = newY
                }
            }
        }
        
        Label {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 20
            text: "创建虚拟机"
            font.pointSize: 14
            font.weight: Font.Medium
            color: Constants.primaryTextColor
        }
        
        // 关闭按钮
        Button {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
            width: 30
            height: 30
            
            background: Rectangle {
                color: parent.hovered ? (AppSettings.isDarkTheme ? "#FF5252" : "#E53935") : "transparent"
                radius: 4
                
                // 绘制叉号
                Text {
                    anchors.centerIn: parent
                    text: "✕"
                    font.pointSize: 16
                    font.bold: true
                    color: parent.parent.hovered ? "white" : Constants.accentTextColor
                }
            }
            
            onClicked: root.close()
            
            hoverEnabled: true
        }
    }
    
    property string vmName: ""
    property string selectedOsType: ""
    property int cpuCores: 1
    property int memorySize: 1024 // MB
    property string memoryUnit: "MB"
    property string errorMessage: ""
    
    property var availableOsTypes: ["Ubuntu", "openEuler", "Zephyr", "Sylix"]
    property int maxCpuCores: 8
    property int availableCpuCores: 8
    property int totalMemory: 8192 // MB
    property int availableMemory: 4096 // MB
    
    signal configUpdated(string vmName, string osType, int cpuCores, int memorySize)
    
    function validateForm() {
        if (vmName.trim() === "") {
            errorMessage = "请输入虚拟机名称"
            return false
        }
        
        if (selectedOsType === "") {
            errorMessage = "请选择操作系统类型"
            return false
        }
        
        // 检查CPU资源是否足够
        if (availableCpuCores <= 0) {
            errorMessage = "系统物理CPU资源已耗尽，请先为其他虚拟机释放或重新分配虚拟CPU"
            return false
        }
        
        if (cpuCores < 1) {
            errorMessage = "CPU核心数至少为1核"
            return false
        }
        
        // 如果选择的CPU核心数超过可用物理CPU，显示警告但不阻止创建
        if (cpuCores > availableCpuCores) {
            // 这里不返回false，让用户可以继续创建虚拟机
            // 具体的警告信息已经在ComboBox中显示
        }
        
        // 内存可以随意设置，只检查是否超过可用内存
        var memoryInMB = getMemoryInMB()
        if (availableMemory > 0 && memoryInMB > availableMemory) {
            errorMessage = `内存大小不能超过可用内存${formatMemory(availableMemory)}`
            return false
        }
        
        errorMessage = ""
        return true
    }
    

    
    onOpened: {
        errorMessage = ""
        // 基于现有数据计算可用资源
        calculateAvailableResources()
    }
    
    function calculateAvailableResources() {
        // 从networkManager的rustShyperInfo获取系统信息
        var hypervisorInfo = networkManager.rustShyperInfo
        var vmList = hypervisorInfo.virtualMachineInfoList
        
        // 计算总CPU核心数（从hypervisorInfo.phys_cpu_num）
        var totalCpuCores = hypervisorInfo.phys_cpu_num || 8
        
        // 计算已使用的CPU核心数
        var usedCpuCores = 0
        for (var i = 0; i < vmList.length; i++) {
            usedCpuCores += vmList[i].cpuNum || 0
        }
        
        // 计算总内存（从hypervisorInfo.memoryInfo解析）
        var totalMemoryText = hypervisorInfo.memoryInfo || "8 GB"
        var totalMemoryMB = parseMemoryText(totalMemoryText)
        
        // 计算已使用的内存
        var usedMemoryMB = 0
        for (var i = 0; i < vmList.length; i++) {
            usedMemoryMB += parseMemoryText(vmList[i].memory || "0 MB")
        }
        
        // 计算可用资源
        root.maxCpuCores = totalCpuCores
        root.totalMemory = totalMemoryMB
        root.availableMemory = Math.max(0, totalMemoryMB - usedMemoryMB)
        root.availableCpuCores = Math.max(0, totalCpuCores - usedCpuCores)
        
        // 设置默认值
        if (root.availableOsTypes.length > 0 && root.selectedOsType === "") {
            root.selectedOsType = root.availableOsTypes[0]
        }
        
        // 内存可以随意设置，不受最小值限制
        var memoryInMB = getMemoryInMB()
        if (root.availableMemory > 0 && memoryInMB > root.availableMemory) {
            // 设置为可用内存的合理值
            var defaultValue = root.availableMemory > 1024 ? 1024 : Math.min(root.availableMemory, 512)
            memoryValueField.text = defaultValue.toString()
            root.memoryUnit = "MB"
            root.memorySize = defaultValue
        }
        
        // CPU至少分配一个核心
        if (root.availableCpuCores > 0) {
            if (root.cpuCores > root.availableCpuCores) {
                root.cpuCores = root.availableCpuCores
            }
            if (root.cpuCores < 1) {
                root.cpuCores = 1
            }
        } else {
            root.cpuCores = 0
        }
    }
    
    function parseMemoryText(memoryText) {
        // 解析内存文本，如 "8 GB" 或 "8192 MB"
        // 首先提取数字部分
        var numberPart = memoryText.replace(/[^0-9.]/g, '')
        var value = parseFloat(numberPart)
        
        if (isNaN(value)) {
            return 0
        }
        
        // 根据单位进行转换
        if (memoryText.indexOf("GB") !== -1) {
            return value * 1024 // 转换为MB
        } else if (memoryText.indexOf("MB") !== -1) {
            return value
        }
        return 0
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 15
        
        // 错误信息显示
        Label {
            id: errorLabel
            Layout.fillWidth: true
            visible: errorMessage !== ""
            text: errorMessage
            color: errorMessage.includes("注意") ? "#FF9800" : "#FF5252"
            font.pointSize: 10
            wrapMode: Text.Wrap
        }
        
        // 虚拟机名称
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: "虚拟机名称："
                font.pointSize: 12
                color: Constants.primaryTextColor
                Layout.preferredWidth: 100
            }
            
            TextField {
                id: vmNameField
                Layout.fillWidth: true
                placeholderText: "请输入虚拟机名称"
                text: root.vmName
                onTextChanged: root.vmName = text
                
                background: Rectangle {
                    color: Constants.accentColor
                    border.color: AppSettings.isDarkTheme ? "#555555" : "#CCCCCC"
                    border.width: 1
                    radius: 4
                }
                
                color: Constants.primaryTextColor
            }
        }
        
        // 操作系统类型
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: "操作系统："
                font.pointSize: 12
                color: Constants.primaryTextColor
                Layout.preferredWidth: 100
            }
            
            ComboBox {
                id: osTypeCombo
                Layout.fillWidth: true
                model: root.availableOsTypes
                currentIndex: root.availableOsTypes.indexOf(root.selectedOsType)
                onCurrentValueChanged: root.selectedOsType = currentValue
                
                background: Rectangle {
                    color: Constants.accentColor
                    border.color: AppSettings.isDarkTheme ? "#555555" : "#CCCCCC"
                    border.width: 1
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.currentValue || ""
                    color: Constants.primaryTextColor
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        
        // CPU核心数
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: "CPU核心数："
                font.pointSize: 12
                color: Constants.primaryTextColor
                Layout.preferredWidth: 100
            }
            
            ComboBox {
                id: cpuCombo
                Layout.fillWidth: true
                property var cpuOptions: []
                
                // 动态生成CPU核心数选项
                Component.onCompleted: {
                    cpuOptions = []
                    for (var i = 1; i <= root.maxCpuCores; i++) {
                        cpuOptions.push(i + " 核")
                    }
                    model = cpuOptions
                    
                    // 设置当前选中值
                    var currentIndex = root.cpuCores - 1
                    if (currentIndex >= 0 && currentIndex < cpuOptions.length) {
                        currentIndex = currentIndex
                    }
                }
                
                onCurrentValueChanged: {
                    if (currentValueChanged !== undefined) {
                        var coreNum = parseInt(currentValue) || 1
                        root.cpuCores = coreNum
                        
                        // 检查是否超过可用CPU核心数
                        if (coreNum > root.availableCpuCores) {
                            root.errorMessage = `注意：您选择了${coreNum}核，但可用物理CPU仅${root.availableCpuCores}核。超过部分将使用虚拟CPU（vCPU）。`
                        } else {
                            root.errorMessage = ""
                        }
                    }
                }
                
                background: Rectangle {
                    color: Constants.accentColor
                    border.color: AppSettings.isDarkTheme ? "#555555" : "#CCCCCC"
                    border.width: 1
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.currentValue || (root.cpuCores + " 核")
                    color: Constants.primaryTextColor
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
        
        // 内存大小
        RowLayout {
            Layout.fillWidth: true
            
            Label {
                text: "内存大小："
                font.pointSize: 12
                color: Constants.primaryTextColor
                Layout.preferredWidth: 100
            }
            
            TextField {
                id: memoryValueField
                Layout.fillWidth: true
                Layout.preferredWidth: 120
                placeholderText: "请输入内存大小"
                text: "1024"
                validator: DoubleValidator {
                    bottom: 0.1
                    top: 999999
                }
                onTextChanged: {
                    var value = parseFloat(text) || 0
                    root.memorySize = value
                }
                
                background: Rectangle {
                    color: Constants.accentColor
                    border.color: AppSettings.isDarkTheme ? "#555555" : "#CCCCCC"
                    border.width: 1
                    radius: 4
                }
                
                color: Constants.primaryTextColor
            }
            
            ComboBox {
                id: memoryUnitCombo
                Layout.preferredWidth: 80
                model: ["MB", "GB"]
                currentIndex: root.memoryUnit === "GB" ? 1 : 0
                onCurrentValueChanged: {
                    root.memoryUnit = currentValue
                    updateMemorySize()
                }
                
                background: Rectangle {
                    color: Constants.accentColor
                    border.color: AppSettings.isDarkTheme ? "#555555" : "#CCCCCC"
                    border.width: 1
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.currentValue || ""
                    color: Constants.primaryTextColor
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                }
            }
            

        }
        
        // 系统资源信息
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Constants.accentColor
            radius: 5
            border.color: AppSettings.isDarkTheme ? "#333333" : "#D9D9D9"
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 5
                
                Label {
                    text: "系统资源信息"
                    font.bold: true
                    font.pointSize: 11
                    color: Constants.primaryTextColor
                }
                
                Label {
                    text: `总CPU核心数：${root.maxCpuCores}，可用：${root.availableCpuCores}`
                    font.pointSize: 10
                    color: Constants.accentTextColor
                }
                
                Label {
                    text: `总内存：${formatMemory(root.totalMemory)}，可用：${formatMemory(root.availableMemory)}`
                    font.pointSize: 10
                    color: Constants.accentTextColor
                }
            }
        }
        
        // 按钮区域
        RowLayout {
            Layout.fillWidth: true
            Layout.topMargin: 10
            
            Item { Layout.fillWidth: true }
            
            Button {
                text: "取消"
                Layout.preferredWidth: 80
                Layout.preferredHeight: 35
                
                background: Rectangle {
                    color: parent.down ? "#F44336" : "#FF5252"
                    border.color: "transparent"
                    border.width: 0
                    radius: 4
                }
                
                contentItem: Text {
                    text: parent.text
                    font.pixelSize: 12
                    font.weight: Font.Medium
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                
                onClicked: root.close()
            }
            
            Button {
                text: "确定"
                Layout.preferredWidth: 80
                Layout.preferredHeight: 35
                Layout.leftMargin: 10
                
                background: Rectangle {
                    color: parent.down ? "#2CDE85" : "#4CAF50"
                    radius: 4
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
        if (validateForm()) {
            configUpdated(vmName, selectedOsType, cpuCores, getMemoryInMB() * 1024 * 1024)
            root.close()
        }
                }
            }
        }
    }
    
    function formatMemory(mb) {
        if (mb >= 1024) {
            return (mb / 1024).toFixed(1) + " GB"
        } else {
            return mb + " MB"
        }
    }
    
    function getMemoryInMB() {
        var value = parseFloat(memoryValueField.text) || 0
        if (root.memoryUnit === "GB") {
            return value * 1024
        } else {
            return value
        }
    }
    
    function updateMemorySize() {
        // 当单位改变时，更新内存大小显示
        var value = parseFloat(memoryValueField.text) || 0
        root.memorySize = value
    }
}