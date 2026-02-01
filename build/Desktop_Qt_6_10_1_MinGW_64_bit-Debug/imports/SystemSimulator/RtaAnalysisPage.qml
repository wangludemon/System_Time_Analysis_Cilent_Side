import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SystemSimulator 1.0
import VirtualMachine

Item {
    id: page
    anchors.fill: parent

    readonly property int minContentWidth: 1600
    readonly property int minContentHeight: 850

    readonly property bool dark: AppSettings.isDarkTheme
    readonly property color primaryColor: "#4CAF50"
    readonly property color primaryDown: "#2CDE85"

    readonly property color pageBg: Constants.backgroundColor
    readonly property color panelBg: Constants.accentColor
    readonly property color borderColor: dark ? "#1C3A3E" : "#DCDFE6"
    readonly property color headerBg: dark ? "#013038" : "#F5F7FA"
    readonly property color textColor: dark ? "#D9D9D9" : "#606266"
    readonly property color titleColor: Constants.primaryTextColor
    readonly property color rowAltBg: dark ? "#012A30" : "#FAFAFA"

    readonly property font mainFont: Qt.font({ family: "Microsoft YaHei", pixelSize: 13 })

    // Backend
    RtaClient {
        id: client
        onAnalysisFinished: (success, msg) => {
            analyzing = false
            console.log("Analyze finished:", success, msg)
        }
    }

    property bool analyzing: false
    property string selectedMethod: "MSRP"
    property string selectedMode: "LO"

    Rectangle { anchors.fill: parent; color: pageBg }

    ScrollView {
        id: scroll
        anchors.fill: parent
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        contentWidth: Math.max(minContentWidth, width)
        contentHeight: Math.max(minContentHeight, height)

        Item {
            width: scroll.contentWidth
            height: scroll.contentHeight

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                // ======= Top controls =======
                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60
                    radius: 8
                    color: panelBg
                    border.color: borderColor
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 12

                        Label {
                            text: "响应时间分析"
                            font.bold: true
                            font.pixelSize: 16
                            color: titleColor
                            Layout.preferredWidth: 180
                        }

                        Label { text: "方法"; color: textColor; font: mainFont }
                        ComboBox {
                            id: methodBox
                            model: ["MSRP", "MSRP_NEW"]
                            currentIndex: model.indexOf(selectedMethod) >= 0 ? model.indexOf(selectedMethod) : 0
                            Layout.preferredWidth: 180
                            onCurrentTextChanged: selectedMethod = currentText

                            contentItem: Text {
                                text: parent.displayText
                                color: titleColor
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                leftPadding: 10
                                rightPadding: 28
                                font: parent.font
                            }
                            background: Rectangle {
                                color: dark ? "#012B31" : "white"
                                radius: 4
                                border.color: borderColor
                                border.width: 1
                            }
                        }

                        Label { text: "模式"; color: textColor; font: mainFont }
                        ComboBox {
                            model: ["LO", "HI", "ModeSwitch"]
                            currentIndex: 0
                            Layout.preferredWidth: 160
                            onCurrentTextChanged: selectedMode = currentText

                            contentItem: Text {
                                text: parent.displayText
                                color: titleColor
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                                leftPadding: 10
                                rightPadding: 28
                                font: parent.font
                            }
                            background: Rectangle {
                                color: dark ? "#012B31" : "white"
                                radius: 4
                                border.color: borderColor
                                border.width: 1
                            }
                        }

                        Item { Layout.fillWidth: true }

                        Button {
                            text: analyzing ? "分析中..." : "开始分析"
                            enabled: !analyzing
                            Layout.preferredWidth: 130
                            Layout.preferredHeight: 36
                            background: Rectangle { radius: 6; color: parent.down ? primaryDown : primaryColor }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: {
                                analyzing = true
                                client.analyze(selectedMethod, selectedMode)
                            }
                        }

                        Rectangle {
                            radius: 6
                            color: dark ? "#3B4A4D" : "#909399"
                            Layout.preferredWidth: 170
                            Layout.preferredHeight: 36
                            Text {
                                anchors.centerIn: parent
                                text: "系统模式: " + (client.analysisSystemMode ? client.analysisSystemMode : "-")
                                color: "white"
                                font.bold: true
                                elide: Text.ElideRight
                            }
                        }

                        Rectangle {
                            radius: 6
                            color: client.analysisSchedulable ? "#67C23A" : "#F56C6C"
                            Layout.preferredWidth: 180
                            Layout.preferredHeight: 36
                            Text {
                                anchors.centerIn: parent
                                text: "可调度: " + (client.analysisSchedulable ? "是" : "否")
                                color: "white"
                                font.bold: true
                            }
                        }

                        Rectangle {
                            visible: client.analysisReason && client.analysisReason.length > 0
                            radius: 6
                            color: dark ? "#2A2416" : "#FFF7E6"
                            border.color: "#E6A23C"
                            border.width: 1
                            Layout.fillWidth: true
                            Layout.preferredHeight: 36
                            Text {
                                anchors.centerIn: parent
                                text: client.analysisReason
                                color: "#E6A23C"
                                font.bold: true
                                elide: Text.ElideRight
                            }
                        }
                    }
                }

                // ======= Table =======
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 8
                    color: panelBg
                    border.color: borderColor
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0

                        Rectangle {
                            Layout.fillWidth: true
                            height: 40
                            color: headerBg

                            RowLayout {
                                anchors.fill: parent
                                spacing: 0

                                HeaderCell { text: "任务"; w: 0.7 }
                                HeaderCell { text: "所在核心"; w: 0.6 }
                                HeaderCell { text: "关键级"; w: 0.8 }
                                HeaderCell { text: "截止时间"; w: 1.0 }
                                HeaderCell { text: "Ri"; w: 1.0 }
                                HeaderCell { text: "WCET"; w: 0.9 }
                                HeaderCell { text: "资源执行"; w: 1.2 }
                                HeaderCell { text: "直接自旋"; w: 0.9 }
                                HeaderCell { text: "高优先级干扰"; w: 0.9 }
                                HeaderCell { text: "间接自旋"; w: 1.1 }
                                HeaderCell { text: "到达阻塞"; w: 1.1 }
                                HeaderCell { text: "重试成本"; w: 0.9 }
                            }
                        }

                        Rectangle { height: 1; Layout.fillWidth: true; color: borderColor }

                        ListView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            model: client.analysisResults

                            delegate: Rectangle {
                                width: parent.width
                                height: 36
                                property bool missDeadline: Number(modelData.Ri) > Number(modelData.deadline)

                                color: missDeadline ? "#FDE2E2" : ((index % 2 === 0) ? panelBg : rowAltBg)
                                border.color: missDeadline ? "#F56C6C" : "transparent"
                                border.width: missDeadline ? 1 : 0

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0

                                    BodyCell { text: "T" + modelData.taskId; w: 0.7 }
                                    BodyCell { text: modelData.partition; w: 0.6 }
                                    BodyCell { text: modelData.critical; w: 0.8 }
                                    BodyCell { text: modelData.deadline; w: 1.0 }
                                    BodyCell { text: modelData.Ri; w: 1.0 }
                                    BodyCell { text: modelData.WCET; w: 0.9 }
                                    BodyCell { text: modelData.pure_resource_execution_time; w: 1.2 }
                                    BodyCell { text: modelData.spin; w: 0.9 }
                                    BodyCell { text: modelData.interference; w: 0.9 }
                                    BodyCell { text: modelData.indirectSpin; w: 1.1 }
                                    BodyCell { text: modelData.arrivalBlocking; w: 1.1 }
                                    BodyCell { text: modelData.retryCost; w: 0.9 }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Busy overlay
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: analyzing ? 0.15 : 0
        visible: analyzing
    }
    BusyIndicator {
        anchors.centerIn: parent
        running: analyzing
        visible: analyzing
    }

    // ===== Components：用 contentWidth 算列宽，避免缩小时挤压 =====
    component HeaderCell: Item {
        property string text
        property real w: 1.0
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: (scroll.contentWidth - 32) * (w / 12.7)

        Text {
            anchors.centerIn: parent
            text: parent.text
            font.bold: true
            color: dark ? "#9FB2B6" : "#909399"
            font.pixelSize: 13
        }
    }

    component BodyCell: Item {
        property var text
        property real w: 1.0
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: (scroll.contentWidth - 32) * (w / 12.7)

        Text {
            anchors.centerIn: parent
            text: parent.text
            color: titleColor
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
