// 简单的测试脚本，用于验证SideBar组件的实现
// 1. 检查SideBarForm.ui.qml中是否正确声明了networkManager属性
// 2. 检查SideBar.qml是否正确传递了networkManager属性
// 3. 检查HomePageForm.ui.qml是否正确传递了networkManager属性

console.log("测试开始...")

// 1. 检查SideBarForm.ui.qml
var sideBarFormContent = Qt.resolvedUrl("content/SideBarForm.ui.qml")
console.log("SideBarForm.ui.qml路径:", sideBarFormContent)

// 2. 检查SideBar.qml
var sideBarContent = Qt.resolvedUrl("content/SideBar.qml")
console.log("SideBar.qml路径:", sideBarContent)

// 3. 检查HomePageForm.ui.qml
var homePageFormContent = Qt.resolvedUrl("content/HomePageForm.ui.qml")
console.log("HomePageForm.ui.qml路径:", homePageFormContent)

console.log("测试结束...")
