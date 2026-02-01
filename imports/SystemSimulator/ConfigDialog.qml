import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import VirtualMachine

// simulation 参数配置界面
Dialog {
    id: configDialog
    title: "运行参数配置"

    width: 780
    height: 980
    x: (parent ? (parent.width - width) / 2 : 0)
    y: (parent ? (parent.height - height) / 2 : 0)

    modal: true
    closePolicy: Popup.NoAutoClose

    // 接收 C++ 对象
    property var simulationClient: null

    // ===============================
    // 主题适配（跟 iSure 虚拟机界面一致）
    // - 按钮保持绿色不变
    // - dark：背景变暗、字体变白/浅白
    // ===============================
    readonly property bool  dark: AppSettings.isDarkTheme

    // 固定绿色（不随主题变化）
    readonly property color primaryColor: "#2CDE85"
    readonly property color successColor: "#2CDE85"

    // 文本/背景/边框随主题
    readonly property color textColor:     dark ? "#FFFFFF" : "#606266"
    readonly property color titleColor:    dark ? "#FFFFFF" : "#303133"
    readonly property color borderColor:   dark ? Qt.rgba(1,1,1,0.18) : "#DCDFE6"
    readonly property color dividerColor:  dark ? Qt.rgba(1,1,1,0.12) : "#EBEEF5"
    readonly property color bgColor:       dark ? Constants.accentColor : "#FFFFFF"

    // 控件表面色（输入框/按钮底）
    readonly property color fieldBg:           dark ? Qt.rgba(1,1,1,0.06) : "white"
    readonly property color fieldBgPressed:    dark ? Qt.rgba(1,1,1,0.10) : "#f5f7fa"
    readonly property color stepBtnBg:         dark ? Qt.rgba(1,1,1,0.06) : "#f5f7fa"
    readonly property color stepBtnBgPressed:  dark ? Qt.rgba(1,1,1,0.12) : "#e6e6e6"
    readonly property color stepBtnText:       dark ? Qt.rgba(1,1,1,0.88) : "#606266"
    readonly property color iconMuted:         dark ? Qt.rgba(1,1,1,0.70) : "#909399"

    readonly property font  mainFont: Qt.font({ family: "Microsoft YaHei", pixelSize: 14 })
    font: mainFont

    // 保存/回填用的引用（Loader onLoaded 里赋值）
    property var cpuSpin
    property var taskNumSpin
    property var minPeriodSpin
    property var maxPeriodSpin
    property var maxAccessSpin
    property var ratioSpin

    // 资源配置默认值
    property string selectedResourceType: "SHORT LENGTH"
    property string selectedResourceCount: "PARTITIONS"

    background: Rectangle {
        color: bgColor
        radius: 8
        border.color: borderColor
        border.width: 1
        layer.enabled: true
    }

    header: Rectangle {
        width: parent.width
        height: 50
        color: "transparent"

        Text {
            text: configDialog.title
            anchors.centerIn: parent
            font.bold: true
            font.pixelSize: 18
            color: titleColor
        }
        Rectangle { width: parent.width; height: 1; color: dividerColor; anchors.bottom: parent.bottom }
    }

    footer: Rectangle {
        width: parent.width
        height: 70
        color: "transparent"

        Rectangle { width: parent.width; height: 1; color: dividerColor; anchors.top: parent.top }

        RowLayout {
            anchors.centerIn: parent
            spacing: 20

            Button {
                text: "取消"
                background: Rectangle {
                    implicitWidth: 100; implicitHeight: 36
                    color: parent.down ? fieldBgPressed : fieldBg
                    border.color: borderColor; border.width: 1; radius: 4
                }
                contentItem: Text {
                    text: parent.text
                    color: textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: configDialog.reject()
            }

            Button {
                text: "确定保存"
                background: Rectangle {
                    implicitWidth: 100; implicitHeight: 36
                    color: parent.down ? Qt.darker(primaryColor, 1.15) : primaryColor
                    radius: 4
                }
                contentItem: Text {
                    text: parent.text
                    color: "white"
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    saveData()
                    configDialog.accept()
                }
            }
        }
    }

    // === 逻辑：保存数据 ===
    function saveData() {
        if (!simulationClient) return

        simulationClient.cpuCoreCount = cpuSpin.value
        simulationClient.taskNumPerCore = taskNumSpin.value
        simulationClient.minPeriod = minPeriodSpin.value
        simulationClient.maxPeriod = maxPeriodSpin.value
        simulationClient.maxAccess = maxAccessSpin.value
        simulationClient.resourceRatio = ratioSpin.value

        simulationClient.isCriticalitySwitch = critSwitch.checked
        simulationClient.isAutoSwitch = critSwitch.checked ? autoSwitch.checked : false

        if (resourceTypeLoader.item) {
            simulationClient.resourceType = resourceTypeLoader.item.currentValue
        }
        if (resourceNumLoader.item) {
            simulationClient.resourceCount = resourceNumLoader.item.currentValue
        }

        simulationClient.generateData()
    }

    // === 逻辑：打开时同步数据 ===
    onOpened: {
        if (!simulationClient) return

        cpuSpin.value = simulationClient.cpuCoreCount
        taskNumSpin.value = simulationClient.taskNumPerCore
        minPeriodSpin.value = simulationClient.minPeriod
        maxPeriodSpin.value = simulationClient.maxPeriod
        maxAccessSpin.value = simulationClient.maxAccess
        ratioSpin.value = simulationClient.resourceRatio

        critSwitch.checked = simulationClient.isCriticalitySwitch
        autoSwitch.checked = simulationClient.isAutoSwitch

        // 回填资源配置：根据 value 设置 ComboBox 的 index
        setComboIndex(resourceTypeLoader.item, simulationClient.resourceType)
        setComboIndex(resourceNumLoader.item, simulationClient.resourceCount)
    }

    // 辅助函数：根据 value 设置 ComboBox 的 index
    function setComboIndex(comboBoxItem, valueToCheck) {
        if (!comboBoxItem || !valueToCheck) return
        var target = String(valueToCheck).toUpperCase()

        for (var i = 0; i < comboBoxItem.model.length; i++) {
            if (String(comboBoxItem.model[i].value).toUpperCase() === target) {
                comboBoxItem.currentIndex = i
                return
            }
        }
    }

    // ============================================================
    // 自定义：输入框 + 左右按钮
    // ============================================================
    Component {
        id: niceIntStepInput

        Item {
            id: root
            implicitWidth: 180
            implicitHeight: 40

            property int from: 0
            property int to: 100
            property int step: 1
            property int value: from

            property bool _syncing: false

            function clamp(v) {
                if (v < from) return from
                if (v > to) return to
                return v
            }

            function setValue(v) {
                v = clamp(v)
                root._syncing = true
                root.value = v
                field.text = String(v)
                root._syncing = false
            }

            function inc() { setValue(value + step) }
            function dec() { setValue(value - step) }

            Rectangle {
                anchors.fill: parent
                radius: 4
                border.width: 1
                border.color: field.activeFocus ? primaryColor : borderColor
                color: "transparent"
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.preferredWidth: 34
                    Layout.fillHeight: true
                    radius: 4
                    color: minusArea.pressed ? stepBtnBgPressed : stepBtnBg
                    border.color: borderColor
                    border.width: 1
                    Rectangle { width: 4; height: parent.height; color: parent.color; anchors.right: parent.right }
                    Text { text: "-"; anchors.centerIn: parent; font.pixelSize: 18; color: stepBtnText }

                    MouseArea {
                        id: minusArea
                        anchors.fill: parent
                        preventStealing: true
                        onClicked: root.dec()
                    }
                }

                TextField {
                    id: field
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    text: String(root.value)
                    font: mainFont
                    color: textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    background: Rectangle { color: fieldBg; radius: 0 }

                    validator: IntValidator { bottom: root.from; top: root.to }
                    inputMethodHints: Qt.ImhDigitsOnly

                    onActiveFocusChanged: if (activeFocus) selectAll()
                    TapHandler {
                        onTapped: {
                            field.forceActiveFocus()
                            field.selectAll()
                        }
                    }

                    function commit() {
                        var t = field.text.trim()
                        var v = parseInt(t)
                        if (isNaN(v)) {
                            field.text = String(root.value)
                            return
                        }
                        root.setValue(v)
                    }
                    onEditingFinished: commit()
                    onAccepted: commit()
                }

                Rectangle {
                    Layout.preferredWidth: 34
                    Layout.fillHeight: true
                    radius: 4
                    color: plusArea.pressed ? stepBtnBgPressed : stepBtnBg
                    border.color: borderColor
                    border.width: 1
                    Rectangle { width: 4; height: parent.height; color: parent.color; anchors.left: parent.left }
                    Text { text: "+"; anchors.centerIn: parent; font.pixelSize: 18; color: stepBtnText }

                    MouseArea {
                        id: plusArea
                        anchors.fill: parent
                        preventStealing: true
                        onClicked: root.inc()
                    }
                }
            }

            onValueChanged: {
                if (_syncing) return
                if (!field.activeFocus) field.text = String(value)
            }
        }
    }

    Component {
        id: niceDoubleStepInput

        Item {
            id: root
            implicitWidth: 180
            implicitHeight: 40

            property real from: 0.1
            property real to: 1.0
            property real step: 0.1
            property int decimals: 1
            property real value: from

            property bool _syncing: false

            function clamp(v) {
                if (v < from) return from
                if (v > to) return to
                return v
            }

            function roundToStep(v) {
                var k = Math.round(v / step)
                return k * step
            }

            function fmt(v) { return Number(v).toFixed(decimals) }

            function setValue(v) {
                v = clamp(v)
                v = roundToStep(v)
                v = Number(v.toFixed(decimals))
                root._syncing = true
                root.value = v
                field.text = fmt(v)
                root._syncing = false
            }

            function inc() { setValue(value + step) }
            function dec() { setValue(value - step) }

            Rectangle {
                anchors.fill: parent
                radius: 4
                border.width: 1
                border.color: field.activeFocus ? primaryColor : borderColor
                color: "transparent"
            }

            RowLayout {
                anchors.fill: parent
                spacing: 0

                Rectangle {
                    Layout.preferredWidth: 34
                    Layout.fillHeight: true
                    radius: 4
                    color: minusArea.pressed ? stepBtnBgPressed : stepBtnBg
                    border.color: borderColor
                    border.width: 1
                    Rectangle { width: 4; height: parent.height; color: parent.color; anchors.right: parent.right }
                    Text { text: "-"; anchors.centerIn: parent; font.pixelSize: 18; color: stepBtnText }

                    MouseArea {
                        id: minusArea
                        anchors.fill: parent
                        preventStealing: true
                        onClicked: root.dec()
                    }
                }

                TextField {
                    id: field
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    text: root.fmt(root.value)
                    font: mainFont
                    color: textColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    background: Rectangle { color: fieldBg; radius: 0 }

                    validator: DoubleValidator { bottom: root.from; top: root.to; decimals: root.decimals }
                    inputMethodHints: Qt.ImhFormattedNumbersOnly

                    onActiveFocusChanged: if (activeFocus) selectAll()
                    TapHandler {
                        onTapped: {
                            field.forceActiveFocus()
                            field.selectAll()
                        }
                    }

                    function commit() {
                        var t = field.text.trim()
                        var v = parseFloat(t)
                        if (isNaN(v)) {
                            field.text = root.fmt(root.value)
                            return
                        }
                        root.setValue(v)
                    }
                    onEditingFinished: commit()
                    onAccepted: commit()
                }

                Rectangle {
                    Layout.preferredWidth: 34
                    Layout.fillHeight: true
                    radius: 4
                    color: plusArea.pressed ? stepBtnBgPressed : stepBtnBg
                    border.color: borderColor
                    border.width: 1
                    Rectangle { width: 4; height: parent.height; color: parent.color; anchors.left: parent.left }
                    Text { text: "+"; anchors.centerIn: parent; font.pixelSize: 18; color: stepBtnText }

                    MouseArea {
                        id: plusArea
                        anchors.fill: parent
                        preventStealing: true
                        onClicked: root.inc()
                    }
                }
            }

            onValueChanged: {
                if (_syncing) return
                if (!field.activeFocus) field.text = fmt(value)
            }
        }
    }

    // ============================================================
    // 美化版 ComboBox（主题适配）
    // ============================================================
    Component {
        id: niceComboBox

        ComboBox {
            id: cb
            font: mainFont
            implicitHeight: 36

            background: Rectangle {
                radius: 4
                border.width: 1
                border.color: cb.activeFocus ? primaryColor : borderColor
                color: fieldBg
            }

            contentItem: Text {
                text: cb.displayText
                font: cb.font
                color: textColor
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                leftPadding: 10
                rightPadding: 28
            }

            indicator: Item {
                width: 24; height: 24
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 6

                Canvas {
                    anchors.fill: parent
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0,0,width,height)
                        ctx.strokeStyle = iconMuted
                        ctx.lineWidth = 2
                        ctx.beginPath()
                        ctx.moveTo(7, 9)
                        ctx.lineTo(12, 14)
                        ctx.lineTo(17, 9)
                        ctx.stroke()
                    }
                }
            }

            popup: Popup {
                y: cb.height + 6
                width: cb.width
                implicitHeight: Math.min(240, contentItem.implicitHeight)
                padding: 4

                background: Rectangle {
                    radius: 6
                    border.width: 1
                    border.color: borderColor
                    color: fieldBg
                }

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: cb.popup.visible ? cb.delegateModel : null
                    currentIndex: cb.highlightedIndex
                    ScrollBar.vertical: ScrollBar { }
                }
            }

            delegate: ItemDelegate {
                width: cb.width
                text: modelData.text
                font: cb.font
                highlighted: cb.highlightedIndex === index
                contentItem: Text {
                    text: parent.text
                    font: parent.font
                    color: textColor
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // === 内容区域 ===
    contentItem: ScrollView {
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        background: Rectangle { color: "transparent" }

        ColumnLayout {
            width: parent.width - 40
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 15

            // === 1. 系统资源 ===
            Label { text: "系统资源"; font.bold: true; color: titleColor; topPadding: 10 }

            GridLayout {
                columns: 2
                columnSpacing: 15
                rowSpacing: 15
                Layout.fillWidth: true

                Label { text: "CPU 核心数"; color: textColor }
                Loader {
                    sourceComponent: niceIntStepInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    onLoaded: {
                        item.from = 1
                        item.to = 16
                        item.step = 1
                        item.value = 2
                        configDialog.cpuSpin = item
                    }
                }

                Label { text: "单核任务数"; color: textColor }
                Loader {
                    sourceComponent: niceIntStepInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    onLoaded: {
                        item.from = 1
                        item.to = 20
                        item.step = 1
                        item.value = 2
                        configDialog.taskNumSpin = item
                    }
                }

                // 访问资源类型
                Label { text: "访问资源类型"; color: textColor }
                Loader {
                    id: resourceTypeLoader
                    sourceComponent: niceComboBox
                    Layout.fillWidth: true
                    onLoaded: {
                        item.textRole = "text"
                        item.valueRole = "value"
                        item.model = [
                            { text: "Very Long Length",  value: "VERY LONG LENGTH" },
                            { text: "Long Length",       value: "LONG LENGTH" },
                            { text: "Medium Length",     value: "MEDIUM LENGTH" },
                            { text: "Short Length",      value: "SHORT LENGTH" },
                            { text: "Very Short Length", value: "VERY SHORT LENGTH" },
                            { text: "Random",            value: "RANDOM" }
                        ]

                        // ✅ 修正：这里应该写 selectedResourceType
                        item.onActivated.connect(function() {
                            selectedResourceType = item.currentValue
                        })
                    }
                }

                // 资源个数
                Label { text: "资源个数"; color: textColor }
                Loader {
                    id: resourceNumLoader
                    sourceComponent: niceComboBox
                    Layout.fillWidth: true
                    onLoaded: {
                        item.textRole = "text"
                        item.valueRole = "value"
                        item.model = [
                            { text: "Half Partitions",   value: "HALF PARTITIONS" },
                            { text: "Partitions",        value: "PARTITIONS" },
                            { text: "Double Partitions", value: "DOUBLE PARTITIONS" }
                        ]

                        // ✅ 修正：这里应写 selectedResourceCount
                        item.onActivated.connect(function() {
                            selectedResourceCount = item.currentValue
                        })
                    }
                }
            }

            // === 2. 任务参数 ===
            Rectangle { height: 1; width: parent.width; color: dividerColor; Layout.margins: 10 }
            Label { text: "任务参数"; font.bold: true; color: titleColor }

            GridLayout {
                columns: 2
                columnSpacing: 15
                rowSpacing: 15
                Layout.fillWidth: true

                Label { text: "最小周期 (Min)"; color: textColor }
                Loader {
                    sourceComponent: niceIntStepInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    onLoaded: {
                        item.from = 1
                        item.to = 10000
                        item.step = 1
                        item.value = 10
                        configDialog.minPeriodSpin = item
                    }
                }

                Label { text: "最大周期 (Max)"; color: textColor }
                Loader {
                    sourceComponent: niceIntStepInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    onLoaded: {
                        item.from = 1
                        item.to = 10000
                        item.step = 1
                        item.value = 1000
                        configDialog.maxPeriodSpin = item
                    }
                }

                Label { text: "最大访问次数"; color: textColor }
                Loader {
                    sourceComponent: niceIntStepInput
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    onLoaded: {
                        item.from = 0
                        item.to = 10
                        item.step = 1
                        item.value = 2
                        configDialog.maxAccessSpin = item
                    }
                }

                // 资源访问比例
                Label { text: "资源访问比例"; color: textColor }
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Loader {
                        sourceComponent: niceDoubleStepInput
                        Layout.preferredWidth: 220
                        Layout.preferredHeight: 40
                        onLoaded: {
                            item.from = 0.1
                            item.to = 1.0
                            item.step = 0.1
                            item.decimals = 1
                            item.value = 0.5
                            configDialog.ratioSpin = item
                        }
                    }

                    Label {
                        text: ratioSpin ? (Math.round(ratioSpin.value * 100) + "%") : ""
                        color: primaryColor
                        font.bold: true
                        font.pixelSize: 12
                    }
                }
            }

            // === 3. 调度策略 ===
            Rectangle { height: 1; width: parent.width; color: dividerColor; Layout.margins: 10 }
            Label { text: "调度策略"; font.bold: true; color: titleColor }

            GridLayout {
                columns: 2
                columnSpacing: 15
                rowSpacing: 20
                Layout.fillWidth: true

                Label { text: "关键级切换 (Criticality Switch)"; color: textColor; font.bold: true }
                Switch {
                    id: critSwitch
                    text: checked ? "已开启" : "已关闭"
                    checked: false

                    onCheckedChanged: autoSwitch.checked = checked

                    indicator: Rectangle {
                        implicitWidth: 40; implicitHeight: 20; radius: 10
                        color: critSwitch.checked ? primaryColor : (dark ? Qt.rgba(1,1,1,0.25) : "#C0CCDA")
                        border.color: color
                        Rectangle {
                            x: critSwitch.checked ? parent.width - width - 2 : 2
                            y: 2
                            width: 16; height: 16; radius: 8
                            color: "white"
                            Behavior on x { NumberAnimation { duration: 200 } }
                        }
                    }
                    contentItem: Text {
                        text: critSwitch.text
                        font.pixelSize: 12
                        color: critSwitch.checked ? primaryColor : iconMuted
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: critSwitch.indicator.width + 10
                    }
                }

                Label {
                    text: "自动切换 (Auto Switch)"
                    color: critSwitch.checked ? textColor : (dark ? Qt.rgba(1,1,1,0.35) : "#C0C4CC")
                }
                Switch {
                    id: autoSwitch
                    text: checked ? "自动" : "手动"
                    enabled: critSwitch.checked

                    indicator: Rectangle {
                        implicitWidth: 40; implicitHeight: 20; radius: 10
                        color: autoSwitch.checked ? successColor : (dark ? Qt.rgba(1,1,1,0.25) : "#C0CCDA")
                        opacity: autoSwitch.enabled ? 1.0 : 0.5
                        Rectangle {
                            x: autoSwitch.checked ? parent.width - width - 2 : 2
                            y: 2
                            width: 16; height: 16; radius: 8
                            color: "white"
                            Behavior on x { NumberAnimation { duration: 200 } }
                        }
                    }
                    contentItem: Text {
                        text: autoSwitch.text
                        font.pixelSize: 12
                        color: autoSwitch.enabled ? (autoSwitch.checked ? successColor : iconMuted) : (dark ? Qt.rgba(1,1,1,0.35) : "#C0C4CC")
                        verticalAlignment: Text.AlignVCenter
                        leftPadding: autoSwitch.indicator.width + 10
                    }
                }
            }

            Item { height: 10 }
        }
    }
}
