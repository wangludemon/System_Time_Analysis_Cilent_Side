import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import VirtualMachine
import SystemSimulator 1.0

Page {
    id: root
    title: "系统仿真 / RTA"

    // 外围跟随主题
    background: Rectangle {
        color: Constants.backgroundColor
    }

    // 中间“工作区”保持你原 SystemSimulator 风格（浅色固定）
    readonly property color cardBg: "#FFFFFF"
    readonly property color cardBorder: "#D0D3D4"

    ColumnLayout {
        anchors.fill: parent
        spacing: 12
        leftMargin: 16
        rightMargin: 16
        topMargin: 16
        bottomMargin: 16

        TabBar {
            id: tabs
            Layout.fillWidth: true
            TabButton { text: "Simulator" }
            TabButton { text: "RTA" }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            radius: 12
            color: cardBg
            border.color: cardBorder
            border.width: 1
            clip: true

            Item {
                anchors.fill: parent
                anchors.margins: 10

                StackLayout {
                    anchors.fill: parent
                    currentIndex: tabs.currentIndex

                    SimulatorPage { }
                    RtaPage { }
                }
            }
        }
    }
}
