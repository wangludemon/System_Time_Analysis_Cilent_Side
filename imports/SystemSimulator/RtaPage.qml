import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

// ✅ 关键：引入 VirtualMachine 模块，才能用 Constants / AppSettings
import VirtualMachine

Item {
    id: root
    anchors.fill: parent

    // ✅ 绑定 iSure 的暗黑开关（和你贴的虚拟机界面一致）
    property bool isDark: AppSettings.isDarkTheme

    // 页面“最小内容尺寸”：窗口更小 -> 出滚动条，不挤压控件
    readonly property int minContentW: 1200
    readonly property int minContentH: 800

    // ✅ 固定绿色：对齐“创建虚拟机”按钮（你的 .ui.qml 里就是这俩色）
    readonly property color greenNormal:  "#4CAF50"
    readonly property color greenChecked: "#2CDE85"

    // ✅ 主题色：优先从 Constants 来（对齐 iSure 体系）
    // 背景/文字直接用 Constants；面板用在背景基础上略微提亮/压暗
    readonly property color pageBg:     Constants.backgroundColor
    readonly property color textNormal: Constants.primaryTextColor

    // 这些 Constants 里不一定有（不同项目命名不一样），所以我保留一个安全 fallback
    readonly property color textHint:   isDark ? "#BFBFBF" : "#606266"
    readonly property color panelBg:    isDark ? Qt.darker(Constants.backgroundColor, 1.15)
                                              : Qt.lighter(Constants.backgroundColor, 1.05)
    readonly property color panelBorder: isDark ? "#3A3A3A" : "#D0D3D4"

    // 未选中 Tab 外观：暗黑时用更深一点的底色
    readonly property color tabIdleBg:     isDark ? Qt.darker(Constants.backgroundColor, 1.25) : "#FFFFFF"
    readonly property color tabIdleBorder: isDark ? "#4A4A4A" : "#E4E7ED"

    // ======= 绿色TabButton（文字居中 + 固定宽高）=======
    component GreenTabButton: TabButton {
        id: btn
        property int btnW: 240
        property int btnH: 36

        implicitWidth: btnW
        implicitHeight: btnH

        background: Rectangle {
            radius: 10
            color: btn.checked
                   ? greenChecked
                   : (btn.hovered
                        ? Qt.rgba(tabIdleBg.r, tabIdleBg.g, tabIdleBg.b, 0.85)
                        : tabIdleBg)

            border.width: btn.checked ? 0 : 1
            border.color: btn.checked ? "transparent" : tabIdleBorder
        }

        contentItem: Text {
            text: btn.text
            anchors.centerIn: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight

            font.pixelSize: 14
            font.bold: true
            color: btn.checked ? "white" : textNormal
        }
    }

    // 外层：页面滚动（防止整体被压扁）
    ScrollView {
        id: pageScroll
        anchors.fill: parent
        clip: true

        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        background: Rectangle { color: pageBg }

        // 内容尺寸至少 minContentW/minContentH
        contentWidth: Math.max(root.minContentW, width)
        contentHeight: Math.max(root.minContentH, height)

        Item {
            width: pageScroll.contentWidth
            height: pageScroll.contentHeight

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                // 顶部Tab条（横向可滚动，不挤压）
                Rectangle {
                    Layout.fillWidth: true
                    height: 52
                    radius: 10
                    color: panelBg
                    border.width: 1
                    border.color: panelBorder

                    Flickable {
                        anchors.fill: parent
                        anchors.margins: 8
                        clip: true

                        contentWidth: tabRow.implicitWidth
                        contentHeight: tabRow.implicitHeight

                        ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }

                        Row {
                            id: tabRow
                            spacing: 12
                            height: parent.height

                            TabBar {
                                id: rtaTabs
                                height: 36
                                spacing: 8
                                background: Item { } // 外层 Rectangle 控背景

                                GreenTabButton { text: "系统参数设置"; btnW: 220; btnH: 36 }
                                GreenTabButton { text: "响应时间分析"; btnW: 220; btnH: 36 }
                            }

                            Item { width: 1; height: 1 }
                        }
                    }
                }

                // 内容区（跟随Tab切换）
                StackLayout {
                    id: rtaStack
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    currentIndex: rtaTabs.currentIndex

                    RtaParamPage { }
                    RtaAnalysisPage { }
                }
            }
        }
    }
}
