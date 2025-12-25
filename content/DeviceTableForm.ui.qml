import QtQuick
import QtQuick.Controls
import QtQuick.Layouts  // 这是 Qt 6.5+ 推荐的高性能 TableView
import Qt.labs.qmlmodels  // 用于 TableModel
import VirtualMachine

Pane {
    id : root
    width: 900
    height: 550
    visible: true
    property var deviceInfoList: []

    // 定义表格数据模型
    TableModel {
        id: myTableModel
        TableModelColumn { display: "id" }
        TableModelColumn { display: "name" }
        TableModelColumn { display: "status" }
        TableModelColumn { display: "whoUsed" }

        rows: []
    }

    function updateTableModelData() {
        if (root.deviceInfoList && root.deviceInfoList.length>0) {
            var tableRows = root.deviceInfoList.map(function(device, index){
                return {
                    id: device.id,
                    name:device.name,
                    status:device.status,
                    whoUsed:device.belongOS
                };
            });
            // 将转换后的数据赋值给TableModel的rows属性
            myTableModel.rows = tableRows;
            console.log("成功加载", tableRows.length, "条玩家数据到表格。");
        } else {
            console.log("deviceInfoList为空或未定义。");
            myTableModel.rows = []; // 清空表格
        }
    }

    Connections {
        target: networkManager

        function onRustShyperInfoUpdate(rustShyperInfo) {
            if (rustShyperInfo) {
                root.deviceInfoList = networkManager.rustShyperInfo.deviceInfoList;
                updateTableModelData();
            } else {
                console.log("DeviceTableForm onRustShyperInfoUpdate, Received rustShyperInfo is undefined!");
            }
        }
    }

    // 当页面加载完成时执行初始化操作
    Component.onCompleted: {
        

        console.log("on Component.onCompleted:\r\n rustShyperInfo.cpuUtilizationRate:", networkManager.rustShyperInfo.cpuUtilizationRate);
        root.deviceInfoList = networkManager.rustShyperInfo.deviceInfoList;
        updateTableModelData();
        console.log("初始化数据读取完毕。root.deviceInfoList:", root.deviceInfoList);
        
    }

    // 主背景
    Rectangle {
        anchors.fill: parent
        
        color: AppSettings.isDarkTheme ?  "#2CDE85" : "#B8F6D5"
        radius: 12


        // 提示文本
        Text {
            anchors.bottom: tableContainer.top
            anchors.bottomMargin: 7
            anchors.horizontalCenter: parent.horizontalCenter
            text: "设备使用情况列表"
            color: AppSettings.isDarkTheme ? "#FFFFFF" : "#000000"
            font.pointSize: 15
            font.bold: true
        }

        // 表格容器：通过固定高度实现最多显示5行
        Rectangle {
            id: tableContainer
            anchors.centerIn: parent
            width: 850
            height: 450  // 关键：固定容器高度 (40 * 10 = 400) + 边距
            color: "white"
            border.color: AppSettings.isDarkTheme ? "#2CDE85" : "#00414A"
            radius: 5
            clip: true

            // 表头定义[2](@ref)[6](@ref)
            Rectangle {
                id: headerView
                width: parent.width
                height: 40
                color: AppSettings.isDarkTheme ? "#D9D9D9" : "#2CDE85"
                border.color: AppSettings.isDarkTheme ? "#000000" : "#dee2e6"
                z: 2  // 确保表头位于表格内容之上

                Row {
                    anchors.fill: parent
                    spacing: 0

                    // 使用Repeater动态生成表头列[2](@ref)[4](@ref)
                    Repeater {
                        model: ["ID", "设备名称", "设备状态", "所属OS"]
                        Rectangle {
                            width: tableView.columnWidthProvider(index)
                            height: parent.height
                            color: "transparent"
                            border.color: AppSettings.isDarkTheme ? "#000000" : "#dee2e6"
                            border.width: 0
                            

                            Text {
                                anchors.centerIn: parent
                                text: modelData
                                font.bold: true
                                font.pointSize: 10
                                color: AppSettings.isDarkTheme ? "#FFFFFF" : "#000000"
                            }
                        }
                    }
                }
            }

            // 使用新版高性能 TableView
            TableView {
                id: tableView
                anchors.top: headerView.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.margins: 1
                clip: true  // 必需：裁剪超出视口的内容[1](@ref)
                boundsBehavior: Flickable.StopAtBounds // 滚动到边界时停止

                model: myTableModel
                //model: root.deviceInfoList

                // 关键设置：固定行高，确保6行正好在容器高度内
                rowHeightProvider: function(row) { return 40; } // 40像素 * 6行 = 240像素
                columnWidthProvider: function(column) {
                    // 分配列宽
                    return [100, 350, 200, 200][column];
                }

                // 自定义委托：渲染每个单元格
                delegate: Rectangle {
                    id: cellDelegate
                    required property int row
                    required property int column
                    required property var model
                    required property string display

                    implicitWidth: 100
                    implicitHeight: 40
                    color: {
                        // 交替行颜色
                        if (row % 2 === 0) {
                            return "#fafafa";
                        } else {
                            return "#ffffff";
                        }
                    }
                    border.color: "#eeeeee"
                    border.width: 0

                    Text {
                        anchors.fill: parent
                        anchors.margins: 8
                        text: cellDelegate.display

                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: 9
                        color: "#333333"
                        elide: Text.ElideRight
                    }
                }

                // 自定义垂直滚动条
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    width: 10
                    active: true

                    contentItem: Rectangle {
                        implicitWidth: 10
                        radius: 5
                        color: parent.pressed ? "#888888" : "#cccccc"
                        opacity: parent.active ? 0.8 : 0.4
                    }

                    background: Rectangle {
                        color: "#f0f0f0"
                        opacity: 0.3
                    }
                }

            }
        }

        // 提示文本
        Text {
            anchors.top: tableContainer.bottom
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            text: "表格最多显示10行，当前数据共" + myTableModel.rows.length + "行"
            color: "#666666"
            font.pointSize: 9
        }
    }
}
