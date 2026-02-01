import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    // 默认透明背景
    color: "transparent"

    property alias text: label.text
    property alias font: label.font
    property alias textColor: label.color
    property bool contentCenter: true // 默认居中，可选靠左

    // 1. 模拟 CSS 的 border-width: 0px 2px 2px 0px
    // 下边框
    Rectangle {
        width: parent.width; height: 2
        color: "#D0D3D4" // rgb(208, 211, 212)
        anchors.bottom: parent.bottom
    }
    // 右边框
    Rectangle {
        width: 2; height: parent.height
        color: "#D0D3D4"
        anchors.right: parent.right
    }

    // 2. 文本样式
    Text {
        id: label
        anchors.fill: parent
        anchors.margins: 5 // padding
        horizontalAlignment: root.contentCenter ? Text.AlignHCenter : Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        color: "#D0D3D4" // 默认字体颜色
        font.pixelSize: 18 // 对应 Vue 的 18px-20px
        font.bold: true
        elide: Text.ElideRight
    }
}
