import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VirtualMachine
import SystemSimulator 1.0

Page {
    id: root
    title: "系统模拟工具"

    // 外围跟随 iSure 主题
    background: Rectangle { color: Constants.backgroundColor }

    // 工作区：light 白；dark 浅灰（你要的最小变化）
    readonly property color workBg: AppSettings.isDarkTheme ? "#F3F3F3" : "#FFFFFF"
    readonly property color workBorder: AppSettings.isDarkTheme ? Qt.rgba(1,1,1,0.14) : "#D0D3D4"

    Rectangle {
        anchors.fill: parent
        anchors.margins: 16
        radius: 12
        color: workBg
        border.color: workBorder
        border.width: 1
        clip: true

        Item {
            anchors.fill: parent
            anchors.margins: 10

            SimulatorPage { anchors.fill: parent }
        }
    }
}
