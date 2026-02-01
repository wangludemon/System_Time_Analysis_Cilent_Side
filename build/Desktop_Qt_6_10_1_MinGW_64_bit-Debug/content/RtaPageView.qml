import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VirtualMachine
import SystemSimulator 1.0

Page {
    id: root
    title: "时延分析"

    // 外围跟随 iSure 主题
    background: Rectangle { color: Constants.backgroundColor }

    // 中间工作区尽量白底（按你要求最小改动）
    readonly property color workBg: "#FFFFFF"
    readonly property color workBorder: "#D0D3D4"

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

            // 只显示 RTA 页面
            RtaPage { anchors.fill: parent }
        }
    }
}
