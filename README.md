# 智能混合部署系统监控平台

## 项目概述

本项目是一个高安全、强实时、智能化混合部署系统的上位机监控平台，基于Qt6.9.3构建，提供现代化的设备管理和虚拟机监控解决方案。

## 项目结构

```
iSure/
├── content/                    # 主要QML界面文件
│   ├── DeviceManagementViewForm.ui.qml
│   ├── VirtualMachineItemForm.ui.qml
│   ├── SystemSimulatorView.qml         <-- [新] 系统模拟界面
│   ├── RtaPageView.qml      <-- [新] 时延分析界面
│   └── ...其他界面文件
├── imports/                   # QML模块
│   ├── SystemSimulator/               <-- [新] 实时性分析功能块
│   │   ├── simulationclient.h/.cpp    <-- simulator后端通信
│   │   ├── rtaclient.h/.cpp          <-- rta后端通信
│   │   └── ...其他界面文件
│   ├── VirtualMachine/          # 虚拟机管理模块
│   │   ├── AppSettings.qml
│   │   ├── Constants.qml
│   │   ├── RoomsModel.qml
│   │   └── VirtualMachineModel.qml
│   └── CustomControls/          # 自定义控件模块
│       ├── CustomSwitch.qml
│       ├── CustomRoundButton.qml
│       └── qmldir
├── src/                       # C++源代码
├── proto/                      # grpc协议定义
├── CMakeLists.txt              # 主构建文件 (修改：可关闭grpc模块)
├── qmlmodules                 # 模块配置
└── README.md                  # 项目文档
```

## 技术栈详情

### Qt/QML技术
- Qt Quick Controls 2
- Qt Quick Layouts
- QML状态管理和动画
- 自定义QML组件开发

### 构建系统
- CMake 3.x
- Qt CMake集成
- 模块化编译配置

### 开发工具支持
- Qt Creator 17.0.1（Community）

## 编译和运行

### 前置要求
- Qt 6.9.3 或更高版本
- CMake 3.20+
- C++兼容编译器

**注意**: 本项目目前处于开发阶段，部分功能仍在完善中。欢迎贡献代码和反馈建议！



#### 模块化开关

为了提高编译灵活性（尤其是在不需要完整后端的开发环境下），项目引入了编译宏开关：

- **`USE_GRPC`**: 控制是否编译 gRPC模块。
  - **OFF (默认)**: 仅编译前端 UI 及模拟逻辑占位符，不依赖 gRPC 环境。
  - **ON**: 启用通信，需配置本地 gRPC环境。

**配置示例：**

```
isure/CmakeList.txt中

option(USE_GRPC "Enable gRPC/protobuf module" ON) # 改为默认开启
```



```
# 使用命令行配置
cmake -DUSE_GRPC=ON ..
```

