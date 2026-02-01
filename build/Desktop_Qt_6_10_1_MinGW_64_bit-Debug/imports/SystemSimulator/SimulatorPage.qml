import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes 1.15
import SystemSimulator 1.0
import VirtualMachine   // ✅ 为了直接用 AppSettings.isDarkTheme

Item {
    id: root
    anchors.fill: parent

    // =========================
    // 主题：跟随 iSure 的设置
    // =========================
    property bool isDark: AppSettings.isDarkTheme

    // =========================
    // “最小内容尺寸”：窗口更小 -> 出滚动条，不挤压
    // 窗口更大 -> 可跟着一起变大
    // =========================
    readonly property int minContentW: 2400
    readonly property int minContentH: 1400

    // =========================
    // 颜色：只让“空白背景”随主题变化
    // 面板(左/右)保持白色背景
    // 甘特图区保持原来的浅灰外框 + 白底
    // =========================
    readonly property color pageBg:        isDark ? "#2B2F36" : "#F5F7FA"     // ✅ 空白背景随主题
    readonly property color panelBg:       "#FFFFFF"                          // ✅ 左右面板保持白底
    readonly property color panelBorder:   "#D0D3D4"
    readonly property color ganttFrameBg:  "#F3F3F3"                          // ✅ 甘特图区域外框浅灰
    readonly property color ganttBorder:   "#D0D3D4"

    // 你原来就用这个做边框/部分文字，我保留
    readonly property color borderColor: "#D0D3D4"

    // 1. C++ 后端实例
    SimulationClient {
        id: client
        onErrorOccurred: (msg) => console.error("Backend Error: " + msg)
    }

    // 2. 配置参数弹窗
    ConfigDialog {
        id: configDialog
        simulationClient: client
    }

    // --- 数据模型定义（保持不变） ---
    property var currentCpuData: client.cpuGanttData.length > 0 ? client.cpuGanttData : [
        { "timeAxisLength": 30, "eventInformations": [] },
        { "timeAxisLength": 30, "eventInformations": [] }
    ]

    property var currentTaskTableData: client.taskTableData.length > 0 ? client.taskTableData : [
        { "staticPid": 1, "allocation": "Core 0", "priority": 998, "criticality": 1, "wcctlow": 10, "wccthigh": 20, "utilization": 0.25, "period": 100, "totalTime": 500 }
    ]

    property var currentTaskGanttData: client.taskGanttData.length > 0 ? client.taskGanttData : [
        { "taskGanttInformation": { "timeAxisLength": 30, "eventInformations": [], "eventTimePoints": [] } }
    ]

    property var currentResourceData: client.resourceTableData.length > 0 ? client.resourceTableData : [
        { "resourceId": 0, "c_low": 10, "c_high": 15, "isGlobal": false }
    ]

    property var legendData: [
        { "label": "Executing without Locks", "state": "normal-execution" },
        { "label": "Direct Spinning", "state": "direct-spinning" },
        { "label": "Indirect Spinning", "state": "indirect-spinning" },
        { "label": "Arrival Blocking", "state": "arrival-blocking" },
        { "label": "Access Resource", "state": "access-resource" },
        { "label": "Help task to access resource", "state": "help-direct-spinning" },
        { "label": "Access Resource(Immigrate)", "state": "help-access-resource" },
        { "label": "Get a resource", "symbol": "locked" },
        { "label": "Wait for a resource", "symbol": "locked-attempt" },
        { "label": "Withdraw of application", "symbol": "withdraw" },
        { "label": "Release a resource", "symbol": "unlocked" },
        { "label": "Release a task", "symbol": "release" },
        { "label": "Complete a task", "symbol": "completion" },
        { "label": "Switch task", "symbol": "switch-task" },
        { "label": "Shut Down a task", "symbol": "killed" },
        { "label": "System Criticality Switch", "symbol": "criticality-switch" }
    ]

    // =========================
    // 外层滚动：窗口小就滚动，不挤压
    // =========================
    ScrollView {
        anchors.fill: parent
        clip: true

        ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn

        // ✅ 空白背景随主题变化
        background: Rectangle { color: pageBg }

        // ✅ 最小内容尺寸 + 可随窗口放大
        contentWidth:  Math.max(minContentW, width)
        contentHeight: Math.max(minContentH, height)

        Item {
            width:  contentWidth
            height: contentHeight

            Row {
                anchors.margins: 20
                x: 20
                y: 20
                spacing: 25

                // =====================================================
                // 左侧面板（保持白底 + 边框）
                // =====================================================
                Column {
                    width: 487
                    spacing: 20

                    // A. 协议状态
                    Rectangle {
                        width: 487
                        height: 180
                        color: panelBg
                        border.width: 2
                        border.color: panelBorder
                        radius: 6

                        Column {
                            anchors.centerIn: parent
                            spacing: 10

                            Repeater {
                                model: [
                                    {name: "MSRP", status: client.msrpResult},
                                    {name: "MRSP", status: client.mrspResult},
                                    {name: "PWLP", status: client.pwlpResult}
                                ]
                                Row {
                                    spacing: 10
                                    Text {
                                        text: modelData.name + " 协议调度情况"
                                        color: "#6E6E6E"
                                        font.pixelSize: 19
                                        font.bold: true
                                        width: 200
                                        height: 50
                                        verticalAlignment: Text.AlignVCenter
                                    }
                                    Item {
                                        width: 50
                                        height: 50
                                        Rectangle { anchors.fill: parent; color: modelData.status ? "#caf9a0" : "red" }
                                        Shape {
                                            anchors.fill: parent
                                            ShapePath { strokeColor: modelData.status ? "black" : "transparent"; strokeWidth: 3; fillColor: "transparent"; startX: 12; startY: 25; PathLine { x: 25; y: 45 } PathLine { x: 45; y: 5 } }
                                            ShapePath { strokeColor: !modelData.status ? "black" : "transparent"; strokeWidth: 3; fillColor: "transparent"; startX: 5; startY: 5; PathLine { x: 45; y: 45 } }
                                            ShapePath { strokeColor: !modelData.status ? "black" : "transparent"; strokeWidth: 3; fillColor: "transparent"; startX: 5; startY: 45; PathLine { x: 45; y: 5 } }
                                        }
                                    }
                                    StyledButton {
                                        text: "查看调度信息"
                                        width: 160
                                        height: 50
                                        visible: modelData.status
                                        onClicked: {
                                            console.log("Requesting: " + modelData.name)
                                            client.getProtocolData(modelData.name)
                                        }
                                    }
                                }
                            }
                        }
                    }

                    // B. 任务表
                    Rectangle {
                        width: 485
                        height: 300
                        color: panelBg
                        border.width: 2
                        border.color: panelBorder
                        radius: 6

                        ScrollView {
                            anchors.fill: parent
                            clip: true
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                            Column {
                                width: 1195
                                Row {
                                    height: 40
                                    GridCell { width: 122.5; height: 40; text: "Task id" }
                                    GridCell { width: 122.5; height: 40; text: "Allocation" }
                                    GridCell { width: 120; height: 40; text: "Priority" }
                                    GridCell { width: 120; height: 40; text: "Criticality" }
                                    GridCell { width: 155; height: 40; text: "WCCT_low" }
                                    GridCell { width: 155; height: 40; text: "WCCT_high" }
                                    GridCell { width: 155; height: 40; text: "Utilization" }
                                    GridCell { width: 122.5; height: 40; text: "Period" }
                                    GridCell { width: 122.5; height: 40; text: "Total time" }
                                }

                                Repeater {
                                    model: currentTaskTableData
                                    Row {
                                        height: 40
                                        GridCell { width: 122.5; height: 40; text: modelData.staticPid }
                                        GridCell {
                                            width: 122.5; height: 40
                                            text: (modelData.allocation !== undefined && modelData.allocation !== null) ? modelData.allocation :
                                                  ((modelData.runningCPUCore !== undefined) ? ("Core " + modelData.runningCPUCore) : "?")
                                        }
                                        GridCell { width: 120; height: 40; text: modelData.priority }
                                        GridCell { width: 120; height: 40; text: modelData.criticality }
                                        GridCell { width: 155; height: 40; text: modelData.wcctlow }
                                        GridCell { width: 155; height: 40; text: modelData.wccthigh }
                                        GridCell { width: 155; height: 40; text: modelData.utilization }
                                        GridCell { width: 122.5; height: 40; text: modelData.period }
                                        GridCell { width: 122.5; height: 40; text: modelData.totalTime }
                                    }
                                }
                            }
                        }
                    }

                    // C. 资源表
                    Rectangle {
                        width: 485
                        height: 200
                        color: panelBg
                        border.width: 2
                        border.color: panelBorder
                        radius: 6

                        ScrollView {
                            anchors.fill: parent
                            clip: true
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOn
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

                            Column {
                                width: 685
                                Row {
                                    height: 40
                                    GridCell { width: 200; height: 40; text: "Resource id" }
                                    GridCell { width: 142.5; height: 40; text: "c_low" }
                                    GridCell { width: 142.5; height: 40; text: "c_high" }
                                    GridCell { width: 200; height: 40; text: "Global Resource" }
                                }
                                Repeater {
                                    model: currentResourceData
                                    Row {
                                        height: 40
                                        GridCell { width: 200; height: 40; text: (modelData.resourceId !== undefined) ? modelData.resourceId : "N/A" }
                                        GridCell { width: 142.5; height: 40; text: (modelData.c_low !== undefined) ? modelData.c_low : "0" }
                                        GridCell { width: 142.5; height: 40; text: (modelData.c_high !== undefined) ? modelData.c_high : "0" }
                                        GridCell { width: 200; height: 40; text: (modelData.isGlobal !== undefined) ? modelData.isGlobal.toString() : "false" }
                                    }
                                }
                            }
                        }
                    }

                    // --- 按钮区域 ---
                    StyledButton {
                        text: "配置工具运行参数"
                        width: 250
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: configDialog.open()
                    }

                    StyledButton {
                        text: "开始运行"
                        width: 250
                        height: 50
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: {
                            console.log("Start Simulation with params");
                            client.sendSimulationRequest();
                        }
                    }
                }

                // =====================================================
                // 中间：甘特图（保持浅灰框 + 内部原样）
                // =====================================================
                Column {
                    width: 1380
                    spacing: 20

                    // 1) CPU Gantt 外框
                    Rectangle {
                        width: parent.width
                        height: 300
                        radius: 6
                        color: ganttFrameBg
                        border.width: 2
                        border.color: ganttBorder

                        ScrollView {
                            anchors.fill: parent
                            anchors.margins: 8
                            clip: true
                            contentWidth: Math.max(1500, cpuGantt.contentWidth + 150)

                            Row {
                                Column {
                                    width: 120
                                    GridCell { width: 120; height: 40 }
                                    Repeater { model: currentCpuData.length; GridCell { width: 120; height: 80; text: "CPU ID : " + index } }
                                }
                                GanttPainter {
                                    id: cpuGantt
                                    width: Math.max(1380, contentWidth)
                                    height: 40 + currentCpuData.length * 80
                                    taskList: currentCpuData
                                    showLabels: true
                                }
                            }
                        }
                    }

                    // 2) Task Gantt 外框
                    Rectangle {
                        width: parent.width
                        height: 500
                        radius: 6
                        color: ganttFrameBg
                        border.width: 2
                        border.color: ganttBorder

                        ScrollView {
                            anchors.fill: parent
                            anchors.margins: 8
                            clip: true
                            contentWidth: Math.max(1500, taskGantt.contentWidth + 470)

                            Row {
                                Column {
                                    width: 440
                                    Row {
                                        height: 40
                                        GridCell { width: 140; height: 40; text: "Task id" }
                                        GridCell { width: 140; height: 40; text: "Job id" }
                                        GridCell { width: 160; height: 40; text: "Allocation" }
                                    }
                                    Repeater {
                                        model: currentTaskGanttData
                                        Row {
                                            GridCell { width: 140; height: 80; text: modelData.staticPid }
                                            GridCell { width: 140; height: 80; text: (modelData.dynamicPid !== undefined && modelData.dynamicPid !== -1) ? modelData.dynamicPid : "-" }
                                            GridCell {
                                                width: 160; height: 80
                                                text: (modelData.allocation !== undefined && modelData.allocation !== null) ? modelData.allocation :
                                                      ((modelData.runningCPUCore !== undefined) ? ("Core " + modelData.runningCPUCore) : "?")
                                            }
                                        }
                                    }
                                }
                                GanttPainter {
                                    id: taskGantt
                                    width: Math.max(1380, contentWidth)
                                    height: 40 + currentTaskGanttData.length * 80
                                    taskList: currentTaskGanttData
                                    showLabels: false
                                }
                            }
                        }
                    }
                }

                // =====================================================
                // 右侧：图例（白底 + 边框；文字颜色别用 borderColor 了）
                // =====================================================
                Rectangle {
                    width: 400
                    height: 1400
                    radius: 6
                    color: panelBg
                    border.width: 2
                    border.color: panelBorder

                    ListView {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 15
                        model: legendData

                        delegate: Row {
                            spacing: 20
                            Item {
                                width: 80
                                height: (modelData.symbol !== undefined) ? 80 : 40

                                Rectangle {
                                    visible: !modelData.symbol
                                    width: 80
                                    height: 40
                                    border.width: 2
                                    border.color: "black"
                                    color: (modelData.state === "help-direct-spinning" || modelData.state === "help-access-resource") ? "#caf9a0" : "white"

                                    Shape {
                                        visible: modelData.state === "access-resource" || modelData.state === "help-access-resource"
                                        anchors.fill: parent
                                        ShapePath { strokeColor: "black"; startX: 0; startY: 0; PathLine { x: 80; y: 40 } }
                                    }

                                    Shape {
                                        visible: modelData.state === "direct-spinning" || modelData.state === "help-direct-spinning"
                                        anchors.fill: parent
                                        ShapePath {
                                            strokeColor: "black"
                                            strokeWidth: 1
                                            fillColor: "transparent"
                                            startX: 0; startY: 40; PathLine { x: 40; y: 0 }
                                            PathMove { x: 20; y: 40 } PathLine { x: 60; y: 0 }
                                            PathMove { x: 40; y: 40 } PathLine { x: 80; y: 0 }
                                            PathMove { x: 60; y: 40 } PathLine { x: 80; y: 20 }
                                            PathMove { x: 0; y: 20 } PathLine { x: 20; y: 0 }
                                        }
                                    }

                                    Shape {
                                        visible: modelData.state === "indirect-spinning"
                                        anchors.fill: parent
                                        ShapePath { strokeColor: "black"; fillColor: "transparent"; startX: 10; startY: 0; PathLine { x: 10; y: 40 }
                                            PathMove { x: 20; y: 0 } PathLine { x: 20; y: 40 }
                                            PathMove { x: 30; y: 0 } PathLine { x: 30; y: 40 }
                                            PathMove { x: 40; y: 0 } PathLine { x: 40; y: 40 }
                                            PathMove { x: 50; y: 0 } PathLine { x: 50; y: 40 }
                                            PathMove { x: 60; y: 0 } PathLine { x: 60; y: 40 }
                                            PathMove { x: 70; y: 0 } PathLine { x: 70; y: 40 }
                                        }
                                    }

                                    Shape {
                                        visible: modelData.state === "arrival-blocking"
                                        anchors.fill: parent
                                        ShapePath { strokeColor: "black"; fillColor: "transparent"; startX: 0; startY: 10; PathLine { x: 80; y: 10 }
                                            PathMove { x: 0; y: 20 } PathLine { x: 80; y: 20 }
                                            PathMove { x: 0; y: 30 } PathLine { x: 80; y: 30 }
                                        }
                                    }
                                }

                                Item {
                                    visible: modelData.symbol !== undefined
                                    width: 80
                                    height: 80

                                    Shape { visible: modelData.symbol === "locked"; ShapePath{strokeColor:"black";strokeWidth:3;fillColor:"black";startX:40;startY:15; PathArc{x:40;y:35;radiusX:10;radiusY:10;useLargeArc:true} PathArc{x:40;y:15;radiusX:10;radiusY:10}} ShapePath{strokeColor:"black";strokeWidth:3;startX:40;startY:35;PathLine{x:40;y:60}} }
                                    Shape { visible: modelData.symbol === "locked-attempt"; ShapePath{strokeColor:"black";strokeWidth:3;fillColor:"black";startX:40;startY:25; PathArc{x:40;y:5;radiusX:10;radiusY:10;direction:PathArc.CounterClockwise} PathLine{x:40;y:25}} ShapePath{strokeColor:"black";strokeWidth:3;fillColor:"transparent";startX:40;startY:5; PathArc{x:40;y:25;radiusX:10;radiusY:10;direction:PathArc.CounterClockwise}} ShapePath{strokeColor:"black";strokeWidth:3;startX:40;startY:25;PathLine{x:40;y:60}} }
                                    Shape { visible: modelData.symbol === "withdraw"; ShapePath{strokeColor:"#00a3ff";strokeWidth:3;fillColor:"#00a3ff";startX:40;startY:15; PathArc{x:40;y:35;radiusX:10;radiusY:10;useLargeArc:true} PathArc{x:40;y:15;radiusX:10;radiusY:10}} ShapePath{strokeColor:"black";strokeWidth:3;startX:40;startY:35;PathLine{x:40;y:60}} }
                                    Shape { visible: modelData.symbol === "unlocked"; ShapePath{strokeColor:"black";strokeWidth:3;fillColor:"transparent";startX:40;startY:15; PathArc{x:40;y:35;radiusX:10;radiusY:10;useLargeArc:true} PathArc{x:40;y:15;radiusX:10;radiusY:10}} ShapePath{strokeColor:"black";strokeWidth:3;startX:40;startY:35;PathLine{x:40;y:60}} }
                                    Shape { visible: modelData.symbol === "release"; ShapePath { strokeColor: "black"; strokeWidth: 3; startX: 40; startY: 20; PathLine { x: 40; y: 60 } } ShapePath { strokeColor: "black"; strokeWidth: 3; fillColor: "black"; startX: 40; startY: 10; PathLine { x: 25; y: 30 } PathLine { x: 55; y: 30 } PathLine { x: 40; y: 10 } } }
                                    Shape { visible: modelData.symbol === "completion"; ShapePath{strokeColor:"black";strokeWidth:3;startX:40;startY:15;PathLine{x:40;y:60}} ShapePath{strokeColor:"black";strokeWidth:3;startX:25;startY:15;PathLine{x:55;y:15}} }
                                    Shape { visible: modelData.symbol === "switch-task"; ShapePath{strokeColor:"#00B9FF";strokeWidth:3;startX:40;startY:0;PathLine{x:40;y:60}} }
                                    Shape { visible: modelData.symbol === "killed"; ShapePath{strokeColor:"#FFD000";strokeWidth:4;startX:40;startY:20;PathLine{x:40;y:60}} ShapePath{strokeColor:"#FFD000";strokeWidth:4;startX:30;startY:10;PathLine{x:50;y:30}} ShapePath{strokeColor:"#FFD000";strokeWidth:4;startX:30;startY:30;PathLine{x:50;y:10}} }
                                    Shape { visible: modelData.symbol === "criticality-switch"; ShapePath{strokeColor:"red";strokeWidth:4;fillColor:"red";startX:40;startY:30; PathArc{x:40;y:50;radiusX:10;radiusY:10;useLargeArc:true} PathArc{x:40;y:30;radiusX:10;radiusY:10}} }
                                }
                            }

                            Text {
                                text: modelData.label
                                font.pixelSize: 18
                                font.bold: true
                                color: "#303133"   // ✅ 不再用 borderColor（太浅了）
                                verticalAlignment: Text.AlignVCenter
                                height: (modelData.symbol !== undefined) ? 80 : 40
                            }
                        }
                    }
                }
            }
        }
    }
}
