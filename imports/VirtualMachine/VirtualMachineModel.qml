// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import QtQuick

ListModel {
    id: vmsListModel

    // 注意：生产环境中应该通过NetworkManager动态加载数据
    // 这里保留少量示例数据以确保UI正常显示和基本功能测试
    ListElement {
        name: qsTr("openEuler")
        floor: qsTr("管理虚拟机")
        iconName: "openEuler.svg"
        active: false
        memoryUsed: 12
        cpuNum: 4
        cpuID: "1,2,3,4"
        memory: "4G"
        supportDevice: "gicV3, clock-controller, virtio"
        vmState: "运行中"
    }
    ListElement {
        name: qsTr("Zephyr")
        floor: qsTr("通用虚拟机")
        iconName: "Zephyr.svg"
        active: true
        memoryUsed: 12
        cpuNum: 1
        cpuID: "5"
        memory: "4G"
        supportDevice: "gicV3, clock-controller, virtio"
        vmState: "运行中"
    }
    ListElement {
        name: qsTr("Ubuntu")
        floor: qsTr("通用虚拟机")
        iconName: "ubuntu.svg"
        active: false
        memoryUsed: 12
        cpuNum: 2
        cpuID: "6,7"
        memory: "4G"
        supportDevice: "gicV3, clock-controller, virtio"
        vmState: "运行中"
    }
    
    // TODO: 在生产环境中，应该通过以下方式动态加载数据：
    // 1. NetworkManager从后端服务获取虚拟机列表
    // 2. 清空当前model: vmsList.clear()
    // 3. 动态添加元素: vmsList.append({name: "...", ...})
}
