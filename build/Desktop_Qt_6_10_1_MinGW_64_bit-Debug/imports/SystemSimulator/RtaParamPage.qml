import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import SystemSimulator 1.0
import VirtualMachine

Item {
    id: paramPage

    // ========= 最小内容尺寸：小于这个就出滚动条，不挤压 =========
    readonly property int minContentWidth: 1500
    readonly property int minContentHeight: 900

    // Theme
    readonly property bool dark: AppSettings.isDarkTheme

    // 固定绿色（对齐“创建虚拟机”按钮风格）
    readonly property color primaryColor: "#4CAF50"
    readonly property color primaryDown: "#2CDE85"

    // 跟随主题
    readonly property color pageBg: Constants.backgroundColor
    readonly property color panelBg: Constants.accentColor
    readonly property color borderColor: dark ? "#1C3A3E" : "#DCDFE6"
    readonly property color headerBg: dark ? "#013038" : "#F5F7FA"
    readonly property color textColor: dark ? "#D9D9D9" : "#606266"
    readonly property color titleColor: Constants.primaryTextColor
    readonly property color rowAltBg: dark ? "#012A30" : "#FAFAFA"
    readonly property color highlightBg: dark ? "#044A53" : "#E0F7FA"
    readonly property color inputBg: dark ? "#012B31" : "white"

    readonly property font  mainFont: Qt.font({ family: "Microsoft YaHei", pixelSize: 13 })
    readonly property int   inputHeight: 38

    // Backend
    RtaClient {
        id: client
        onRequestFinished: (success, msg) => {
            generating = false
            if (success) {
                console.log("System Generated. Tasks:", client.tasks.length, "Resources:", client.resources.length)
                resetHighlights()
            } else {
                console.error("Generation Failed:", msg)
            }
        }
    }

    // Busy UI
    property bool generating: false

    // ==========================================
    // State Management: Unidirectional (Task -> Resource/Core)
    // ==========================================
    property int currentViewedTaskID: -1
    property var highlightedResourceIDs: []     // [1,2,3]
    property var highlightedPartitions: []      // [0]
    property var resourceRequestMap: ({})       // { "1":2, "2":1, "3":2 }

    function resetHighlights() {
        currentViewedTaskID = -1
        highlightedResourceIDs = []
        highlightedPartitions = []
        resourceRequestMap = ({})
    }

    function toNum(x) {
        var n = Number(x)
        return isNaN(n) ? -1 : n
    }

    function asJs(v) {
        try { return JSON.parse(JSON.stringify(v)) } catch (e) { return null }
    }

    function handleTaskView(taskData) {
        currentViewedTaskID = toNum(taskData.id)
        highlightedPartitions = [ toNum(taskData.partition) ]

        var newHiRes = []
        var newMap = ({})

        var resIndices = asJs(taskData.resourceRequiredIndex)
        var counts     = asJs(taskData.accessCount)
        var resArr      = asJs(client.resources)

        if (!resIndices || !counts || !resArr) {
            highlightedResourceIDs = []
            resourceRequestMap = ({})
            return
        }

        var n = Math.min(resIndices.length, counts.length)
        for (var i = 0; i < n; i++) {
            var idx = toNum(resIndices[i])
            var c   = toNum(counts[i])

            if (idx < 0 || idx >= resArr.length) continue
            var realResId = toNum(resArr[idx].id)
            if (realResId === -1) continue

            if (newHiRes.indexOf(realResId) === -1)
                newHiRes.push(realResId)

            newMap[realResId] = c
        }

        highlightedResourceIDs = newHiRes
        resourceRequestMap = newMap
    }

    // ========= 背景（随主题）=========
    Rectangle {
        anchors.fill: parent
        color: pageBg
    }

    // ========= 关键：ScrollView 固定最小内容尺寸，小了就滚动 =========
    ScrollView {
        id: rootScroll
        anchors.fill: parent
        clip: true

        ScrollBar.horizontal.policy: ScrollBar.AsNeeded
        ScrollBar.vertical.policy: ScrollBar.AsNeeded

        contentWidth: Math.max(minContentWidth, width)
        contentHeight: Math.max(minContentHeight, height)

        Item {
            width: rootScroll.contentWidth
            height: rootScroll.contentHeight

            RowLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 20

                // ==========================================
                // 1) Left Side: Parameter Settings
                // ==========================================
                Rectangle {
                    Layout.preferredWidth: 420
                    Layout.minimumWidth: 420      // ✅ 不允许再小，避免 SpinBox 的 +/- 挤没
                    Layout.fillHeight: true
                    radius: 8
                    color: panelBg
                    border.color: borderColor
                    border.width: 1

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 20
                        spacing: 15

                        Label {
                            text: "参数设置"
                            font.bold: true
                            font.pixelSize: 18
                            color: titleColor
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Rectangle { height: 1; Layout.fillWidth: true; color: borderColor }

                        ScrollView {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            ScrollBar.vertical.policy: ScrollBar.AsNeeded
                            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
                            contentWidth: width

                            ColumnLayout {
                                width: parent.width
                                spacing: 15

                                InputRow { label: "核数"; value: client.coreCount; onValChanged: client.coreCount = val }
                                InputRow { label: "任务数"; value: client.taskNum; onValChanged: client.taskNum = val }

                                RowLayout {
                                    Layout.fillWidth: true

                                    Label {
                                        text: "系统总利用率（≤ 0.7*核数）"
                                        Layout.preferredWidth: 160
                                        color: textColor
                                        font: mainFont
                                    }

                                    TextField {
                                        id: utilField

                                        Layout.fillWidth: true
                                        Layout.preferredHeight: inputHeight
                                        font: mainFont
                                        selectByMouse: true
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        color: titleColor
                                        background: Rectangle {
                                            color: inputBg
                                            radius: 4
                                            border.width: 1
                                            border.color: utilField.activeFocus ? primaryColor : borderColor
                                        }


                                        // 你定义的策略
                                        readonly property double upper: Math.max(1, client.coreCount * 0.7)
                                        readonly property double fallback: Math.max(0, client.coreCount * 0.5)

                                        validator: DoubleValidator {
                                            bottom: 0.0
                                            top: utilField.upper
                                            decimals: 3
                                            notation: DoubleValidator.StandardNotation
                                        }

                                        // 只在“没编辑”的时候同步显示，避免你打字时被后端值覆盖
                                        Binding {
                                            target: utilField
                                            property: "text"
                                            value: Number(client.utilization).toFixed(3)
                                            when: !utilField.activeFocus
                                        }

                                        onEditingFinished: {
                                            // 空字符串/非法就直接回退
                                            var v = Number(text)
                                            if (!isFinite(v) || v < 0) {
                                                client.utilization = fallback
                                                return
                                            }

                                            // 超过上限 => 回退到 coreCount*0.5
                                            if (v > upper) {
                                                client.utilization = fallback
                                            } else {
                                                client.utilization = v
                                            }
                                        }
                                    }
                                }


                                InputRow { label: "最小周期（ms）"; value: client.periodMin; onValChanged: client.periodMin = val; max: 100000 }
                                InputRow { label: "最大周期（ms）"; value: client.periodMax; onValChanged: client.periodMax = val; max: 100000 }
                                InputRow { label: "资源数量"; value: client.resourceNum; onValChanged: client.resourceNum = val }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Label { text: "资源访问任务比例"; Layout.preferredWidth: 160; wrapMode: Text.WordWrap; color: textColor; font: mainFont }
                                    TextField {
                                        id: rsfField
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: inputHeight
                                        font: mainFont
                                        selectByMouse: true
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        color: titleColor

                                        readonly property double fallback: 0.5

                                        validator: DoubleValidator {
                                            bottom: 0.0
                                            top: 1.0
                                            decimals: 3
                                            notation: DoubleValidator.StandardNotation
                                        }

                                        // ✅ 不编辑时才从后端刷新显示（并且固定 3 位）
                                        Binding {
                                            target: rsfField
                                            property: "text"
                                            value: Number(client.rsf).toFixed(3)
                                            when: !rsfField.activeFocus
                                        }

                                        background: Rectangle {
                                            color: inputBg
                                            radius: 4
                                            border.width: 1
                                            border.color: rsfField.activeFocus ? primaryColor : borderColor
                                        }

                                        onEditingFinished: {
                                            var v = Number(text)
                                            if (!isFinite(v) || v < 0 || v > 1) {
                                                client.rsf = fallback
                                            } else {
                                                client.rsf = v
                                            }
                                        }
                                    }


                                }

                                InputRow { label: "访问资源最大次数"; value: client.maxAccess; onValChanged: client.maxAccess = val }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Label { text: "临界区(us)"; Layout.preferredWidth: 160; color: textColor; font: mainFont }
                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: 5

                                        TextField {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: inputHeight
                                            font: mainFont
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: client.cslMin.toString()
                                            selectByMouse: true
                                            color: titleColor
                                            background: Rectangle {
                                                color: inputBg
                                                border.color: borderColor
                                                radius: 4
                                                border.width: 1
                                            }
                                            onEditingFinished: client.cslMin = parseInt(text)
                                        }
                                        Label { text: "-"; color: textColor }

                                        TextField {
                                            Layout.fillWidth: true
                                            Layout.preferredHeight: inputHeight
                                            font: mainFont
                                            horizontalAlignment: Text.AlignHCenter
                                            verticalAlignment: Text.AlignVCenter
                                            text: client.cslMax.toString()
                                            selectByMouse: true
                                            color: titleColor
                                            background: Rectangle {
                                                color: inputBg
                                                border.color: borderColor
                                                radius: 4
                                                border.width: 1
                                            }
                                            onEditingFinished: client.cslMax = parseInt(text)
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Label { text: "分配策略"; Layout.preferredWidth: 160; color: textColor; font: mainFont }
                                    ComboBox {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: inputHeight
                                        font: mainFont
                                        model: ["WF", "BF", "FF", "NF"]
                                        onCurrentTextChanged: client.allocation = currentText

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
                                            color: inputBg
                                            radius: 4
                                            border.color: borderColor
                                            border.width: 1
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    Label { text: "优先级排序"; Layout.preferredWidth: 160; color: textColor; font: mainFont }
                                    ComboBox {
                                        Layout.fillWidth: true
                                        Layout.preferredHeight: inputHeight
                                        font: mainFont
                                        model: ["DMPO", "RMPO"]
                                        onCurrentTextChanged: client.priority = currentText

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
                                            color: inputBg
                                            radius: 4
                                            border.color: borderColor
                                            border.width: 1
                                        }
                                    }
                                }
                            }
                        }

                        Button {
                            text: "生成系统"
                            Layout.fillWidth: true
                            Layout.preferredHeight: 48
                            enabled: !generating
                            background: Rectangle {
                                color: parent.down ? primaryDown : primaryColor
                                radius: 6
                            }
                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.bold: true
                                font.pixelSize: 16
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            onClicked: {
                                generating = true
                                client.generateSystem()
                            }
                        }

                        // Label { text: "JSON 上传"; font.bold: true; topPadding: 5; color: titleColor }

                        // Rectangle {
                        //     Layout.fillWidth: true
                        //     Layout.preferredHeight: 90
                        //     border.color: borderColor
                        //     border.width: 1
                        //     radius: 4
                        //     color: dark ? "#012B31" : "#FAFAFA"

                        //     TextArea {
                        //         id: jsonArea
                        //         anchors.fill: parent
                        //         anchors.margins: 8
                        //         font: mainFont
                        //         color: titleColor
                        //         placeholderText: "粘贴 JSON 内容（暂未实现）"
                        //         background: null
                        //     }
                        // }

                        // Button {
                        //     text: "上传"
                        //     Layout.fillWidth: true
                        //     Layout.preferredHeight: 40
                        //     enabled: false
                        //     background: Rectangle { color: primaryColor; radius: 6; opacity: 0.6 }
                        //     contentItem: Text {
                        //         text: parent.text
                        //         color: "white"
                        //         font.bold: true
                        //         horizontalAlignment: Text.AlignHCenter
                        //         verticalAlignment: Text.AlignVCenter
                        //     }
                        // }
                    }
                }

                // ==========================================
                // 2) Right Side: Results Display
                // ==========================================
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 15

                    // --- 2.1 Task Table ---
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: panelBg
                        radius: 8
                        border.color: borderColor
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 1
                            spacing: 0

                            Rectangle {
                                Layout.fillWidth: true
                                height: 40
                                color: headerBg
                                radius: 8
                                Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 10; color: headerBg }

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 0
                                    HeaderCell { text: "任务ID"; widthRatio: 0.8 }
                                    HeaderCell { text: "分区"; widthRatio: 0.8 }
                                    HeaderCell { text: "优先级"; widthRatio: 0.8 }
                                    HeaderCell { text: "关键级"; widthRatio: 0.8 }
                                    HeaderCell { text: "周期"; widthRatio: 1 }
                                    HeaderCell { text: "截止期"; widthRatio: 1 }
                                    HeaderCell { text: "C(LO)"; widthRatio: 1 }
                                    HeaderCell { text: "C(HI)"; widthRatio: 1 }
                                    HeaderCell { text: "资源"; widthRatio: 1.5 }
                                    HeaderCell { text: "利用率"; widthRatio: 1 }
                                }
                            }

                            Rectangle { height: 1; Layout.fillWidth: true; color: borderColor }

                            ListView {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                clip: true
                                model: client.tasks

                                delegate: Rectangle {
                                    width: parent.width
                                    height: 40
                                    property bool isSelected: toNum(modelData.id) === currentViewedTaskID
                                    color: isSelected ? highlightBg : (index % 2 === 0 ? panelBg : rowAltBg)

                                    RowLayout {
                                        anchors.fill: parent
                                        spacing: 0

                                        BodyCell { text: modelData.id;        widthRatio: 0.8 }
                                            BodyCell { text: modelData.partition; widthRatio: 0.8 }
                                            BodyCell { text: modelData.priority;  widthRatio: 0.8 }
                                            BodyCell { text: modelData.critical;  widthRatio: 0.8; color: text === "HI" ? "#F56C6C" : "#67C23A"; font.bold: true }

                                            BodyCell { text: modelData.period;    widthRatio: 1 }
                                            BodyCell { text: modelData.deadline;  widthRatio: 1 }
                                            BodyCell { text: modelData.cLow;      widthRatio: 1 }
                                            BodyCell { text: modelData.cHigh;     widthRatio: 1 }

                                        Item {
                                            Layout.fillHeight: true
                                            Layout.fillWidth: true
                                            Layout.preferredWidth: parent.width * (1.5 / 9.7)

                                            Rectangle {
                                                width: 64
                                                height: 26
                                                radius: 4
                                                color: isSelected ? "#2CDE85" : primaryColor
                                                anchors.centerIn: parent
                                                opacity: ma.containsMouse ? 0.85 : 1.0

                                                Text {
                                                    text: "查看"
                                                    color: "white"
                                                    anchors.centerIn: parent
                                                    font.pixelSize: 12
                                                    font.bold: true
                                                }

                                                MouseArea {
                                                    id: ma
                                                    anchors.fill: parent
                                                    hoverEnabled: true
                                                    cursorShape: Qt.PointingHandCursor
                                                    onClicked: handleTaskView(modelData)
                                                }
                                            }
                                        }

                                        BodyCell { text: modelData.util.toFixed(3) }
                                    }
                                }
                            }
                        }
                    }

                    // --- 2.2 Resource Overview ---
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                        color: panelBg
                        radius: 8
                        border.color: borderColor
                        border.width: 1

                        ColumnLayout {
                            anchors.fill: parent
                            anchors.margins: 20
                            spacing: 15

                            RowLayout {
                                Label { text: "资源"; font.bold: true; Layout.preferredWidth: 80; font.pixelSize: 14; color: titleColor }

                                Flow {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    Repeater {
                                        model: client.resources
                                        delegate: Rectangle {
                                            width: 50
                                            height: 46
                                            radius: 6

                                            property int rid: toNum(modelData.id)
                                            property bool isHi: highlightedResourceIDs.indexOf(rid) !== -1

                                            color: isHi ? primaryColor : (modelData.isGlobal ? "#FFE4BA" : "#F0F9EB")
                                            border.color: isHi ? "#0B8A6B" : (modelData.isGlobal ? "#E6A23C" : "#67C23A")
                                            border.width: isHi ? 2 : 1

                                            ColumnLayout {
                                                anchors.centerIn: parent
                                                spacing: 0
                                                Text {
                                                    text: "R" + modelData.id
                                                    font.pixelSize: 13
                                                    font.bold: true
                                                    color: parent.parent.isHi ? "white" : "#333"
                                                    Layout.alignment: Qt.AlignHCenter
                                                }
                                                Text {
                                                    text: modelData.cslLow + "/" + modelData.cslHigh
                                                    font.pixelSize: 9
                                                    color: parent.parent.isHi ? "#EEE" : "#666"
                                                    Layout.alignment: Qt.AlignHCenter
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle { height: 1; Layout.fillWidth: true; color: borderColor; opacity: 0.7 }

                            RowLayout {
                                Label { text: "请求次数"; font.bold: true; Layout.preferredWidth: 80; font.pixelSize: 14; color: titleColor }

                                Flow {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    Repeater {
                                        model: client.resources
                                        delegate: Item {
                                            width: 50
                                            height: 30

                                            property int rid: toNum(modelData.id)
                                            property int count: (resourceRequestMap[rid] !== undefined) ? resourceRequestMap[rid] : 0
                                            property bool show: highlightedResourceIDs.indexOf(rid) !== -1

                                            Text {
                                                text: show ? count : "-"
                                                anchors.centerIn: parent
                                                color: show ? titleColor : (dark ? "#3C5A60" : "#CCC")
                                                font.bold: true
                                                font.pixelSize: 14
                                            }
                                        }
                                    }
                                }
                            }

                            Rectangle { height: 1; Layout.fillWidth: true; color: borderColor; opacity: 0.7 }

                            RowLayout {
                                Label { text: "分区"; font.bold: true; Layout.preferredWidth: 80; font.pixelSize: 14; color: titleColor }

                                Flow {
                                    Layout.fillWidth: true
                                    spacing: 12

                                    Repeater {
                                        model: client.coreCount
                                        delegate: Rectangle {
                                            width: 50
                                            height: 36
                                            radius: 6

                                            property bool isHi: highlightedPartitions.indexOf(index) !== -1

                                            color: isHi ? primaryColor : (dark ? "#013038" : "#F2F6FC")
                                            border.color: isHi ? "#0B8A6B" : borderColor
                                            border.width: isHi ? 2 : 1

                                            Text {
                                                text: "P" + index
                                                anchors.centerIn: parent
                                                font.pixelSize: 13
                                                font.bold: true
                                                color: parent.isHi ? "white" : textColor
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // ===== Busy overlay =====
    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: generating ? 0.15 : 0
        visible: generating
    }
    BusyIndicator {
        anchors.centerIn: parent
        running: generating
        visible: generating
    }

    // ==========================================
    // Helper Components (保持原输入方式)
    // ==========================================
    component InputRow : RowLayout {
        property string label
        property int value
        property int max: 1000
        signal valChanged(int val)

        Layout.fillWidth: true

        Label {
            text: label
            Layout.preferredWidth: 160
            wrapMode: Text.WordWrap
            color: textColor
            font: mainFont
        }

        SpinBox {
            Layout.fillWidth: true
            Layout.preferredHeight: inputHeight
            editable: true
            font: mainFont
            from: 0
            to: max
            value: parent.value

            onValueModified: parent.valChanged(value)

            contentItem: TextInput {
                z: 2
                text: parent.textFromValue(parent.value, parent.locale)
                font: parent.font
                color: titleColor
                selectionColor: primaryColor
                selectedTextColor: "#ffffff"
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                readOnly: !parent.editable
                validator: parent.validator
                inputMethodHints: Qt.ImhFormattedNumbersOnly
            }

            background: Rectangle {
                color: inputBg
                border.color: parent.activeFocus ? primaryColor : borderColor
                border.width: 1
                radius: 4
            }
        }
    }

    component HeaderCell : Item {
        property string text
        property double widthRatio: 1

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: parent.width * (widthRatio / 9.7)

        Text {
            text: parent.text
            font.bold: true
            color: dark ? "#9FB2B6" : "#909399"
            anchors.centerIn: parent
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    component BodyCell : Item {
        property string text
        property double widthRatio: 1
        property color color: textColor
        property alias font: txt.font

        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: parent.width * (widthRatio / 9.7)

        Text {
            id: txt
            text: parent.text
            color: parent.color
            anchors.centerIn: parent
            font.pixelSize: 13
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
