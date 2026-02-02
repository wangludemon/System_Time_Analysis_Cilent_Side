import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Button {
    id: control

    // 默认尺寸（如果外面没写 width/height 或 Layout.preferred*）
    implicitWidth: 120
    implicitHeight: 40

    // 可选：暴露颜色，外面也能改（但默认就按你给的）
    property color normalColor: "#4CAF50"
    property color downColor:   "#2CDE85"
    property color textColor:   "white"
    property int   radius: 5

    // 你给的字体风格
    font.pixelSize: 16
    font.weight: 600

    background: Rectangle {
        radius: control.radius
        color: control.down ? control.downColor : control.normalColor
        opacity: control.enabled ? 1.0 : 0.6
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
