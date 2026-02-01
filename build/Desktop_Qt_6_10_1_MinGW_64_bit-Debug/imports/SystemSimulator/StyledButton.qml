import QtQuick
import QtQuick.Controls

Button {
    id: control

    // 固定绿色（不随主题）
    property color baseColor: "#67C23A"      // 常见“成功绿”
    property color pressedColor: "#5FBF3A"   // 按下稍深/稍暗一点
    property color borderColor: baseColor
    property color textColor: "white"

    background: Rectangle {
        radius: 15
        color: control.down ? control.pressedColor : control.baseColor
        border.color: control.borderColor
        border.width: 2
        opacity: control.enabled ? 1.0 : 0.6
    }

    contentItem: Text {
        text: control.text
        font.pixelSize: 19
        font.bold: true
        color: control.textColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
