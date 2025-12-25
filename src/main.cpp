// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#include <QApplication>
#include <QQmlApplicationEngine>
#include <QGuiApplication>
#include <QQmlContext>

#include "app_environment.h"
#include "import_qml_plugins.h"
#include "NetworkManager.h"
#include "DeviceInfo.h"
#include "RustShyperInfo.h"
#include "VirtualMachineInfo.h"


int main(int argc, char *argv[])
{
    set_qt_environment();
    QApplication app(argc, argv);
    QApplication::setApplicationName("iSure");
    QApplication::setOrganizationName("QtProject");

    // 注册自定义类型，使其能用于信号槽传递和QML
    qRegisterMetaType<DeviceInfo>("DeviceInfo");
    qRegisterMetaType<RustShyperInfo>("RustShyperInfo");
    qRegisterMetaType<VirtualMachineInfo>("VirtualMachineInfo");

    QQmlApplicationEngine engine;
    NetworkManager networkManager;
    engine.rootContext()->setContextProperty("networkManager", &networkManager);

    QObject::connect(&engine, &QQmlApplicationEngine::quit, &app, &QGuiApplication::quit);
    engine.loadFromModule("Main", "Main");

    qDebug() << "hello in main!";

    return app.exec();
}
