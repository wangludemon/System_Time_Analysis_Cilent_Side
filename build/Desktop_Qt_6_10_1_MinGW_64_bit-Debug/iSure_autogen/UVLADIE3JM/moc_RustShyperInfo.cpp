/****************************************************************************
** Meta object code from reading C++ file 'RustShyperInfo.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/RustShyperInfo.h"
#include <QtCore/qmetatype.h>
#include <QtCore/QList>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'RustShyperInfo.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.10.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN14RustShyperInfoE_t {};
} // unnamed namespace

template <> constexpr inline auto RustShyperInfo::qt_create_metaobjectdata<qt_meta_tag_ZN14RustShyperInfoE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "RustShyperInfo",
        "cpuUtilizationRate",
        "memUtilizationRate",
        "deviceInfoList",
        "QList<DeviceInfo>",
        "virtualMachineInfoList",
        "QList<VirtualMachineInfo>",
        "board",
        "cpuInfo",
        "memoryInfo"
    };

    QtMocHelpers::UintData qt_methods {
    };
    QtMocHelpers::UintData qt_properties {
        // property 'cpuUtilizationRate'
        QtMocHelpers::PropertyData<int>(1, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'memUtilizationRate'
        QtMocHelpers::PropertyData<int>(2, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'deviceInfoList'
        QtMocHelpers::PropertyData<QList<DeviceInfo>>(3, 0x80000000 | 4, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet),
        // property 'virtualMachineInfoList'
        QtMocHelpers::PropertyData<QList<VirtualMachineInfo>>(5, 0x80000000 | 6, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet),
        // property 'board'
        QtMocHelpers::PropertyData<QString>(7, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'cpuInfo'
        QtMocHelpers::PropertyData<QString>(8, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'memoryInfo'
        QtMocHelpers::PropertyData<QString>(9, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<RustShyperInfo, qt_meta_tag_ZN14RustShyperInfoE_t>(QMC::PropertyAccessInStaticMetaCall, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject RustShyperInfo::staticMetaObject = { {
    nullptr,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14RustShyperInfoE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14RustShyperInfoE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14RustShyperInfoE_t>.metaTypes,
    nullptr
} };

void RustShyperInfo::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = reinterpret_cast<RustShyperInfo *>(_o);
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 2:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QList<DeviceInfo> >(); break;
        case 3:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QList<VirtualMachineInfo> >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<int*>(_v) = _t->getCpuUtilizationRate(); break;
        case 1: *reinterpret_cast<int*>(_v) = _t->getMemUtilizationRate(); break;
        case 2: *reinterpret_cast<QList<DeviceInfo>*>(_v) = _t->getDeviceInfoList(); break;
        case 3: *reinterpret_cast<QList<VirtualMachineInfo>*>(_v) = _t->getVirtualMachineInfoList(); break;
        case 4: *reinterpret_cast<QString*>(_v) = _t->getBoard(); break;
        case 5: *reinterpret_cast<QString*>(_v) = _t->getCpuInfo(); break;
        case 6: *reinterpret_cast<QString*>(_v) = _t->getMemoryInfo(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setCpuUtilizationRate(*reinterpret_cast<int*>(_v)); break;
        case 1: _t->setMemUtilizationRate(*reinterpret_cast<int*>(_v)); break;
        case 2: _t->setDeviceInfoList(*reinterpret_cast<QList<DeviceInfo>*>(_v)); break;
        case 3: _t->setVirtualMachineInfoList(*reinterpret_cast<QList<VirtualMachineInfo>*>(_v)); break;
        case 4: _t->setBoard(*reinterpret_cast<QString*>(_v)); break;
        case 5: _t->setCpuInfo(*reinterpret_cast<QString*>(_v)); break;
        case 6: _t->setMemoryInfo(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}
QT_WARNING_POP
