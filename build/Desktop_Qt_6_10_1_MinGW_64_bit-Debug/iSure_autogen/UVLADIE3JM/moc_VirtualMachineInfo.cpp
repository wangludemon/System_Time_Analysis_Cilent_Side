/****************************************************************************
** Meta object code from reading C++ file 'VirtualMachineInfo.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/VirtualMachineInfo.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'VirtualMachineInfo.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN18VirtualMachineInfoE_t {};
} // unnamed namespace

template <> constexpr inline auto VirtualMachineInfo::qt_create_metaobjectdata<qt_meta_tag_ZN18VirtualMachineInfoE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "VirtualMachineInfo",
        "id",
        "name",
        "floor",
        "iconName",
        "active",
        "cpuNum",
        "cpuID",
        "memory",
        "supportDevice",
        "type",
        "vmState",
        "belongOS"
    };

    QtMocHelpers::UintData qt_methods {
    };
    QtMocHelpers::UintData qt_properties {
        // property 'id'
        QtMocHelpers::PropertyData<int>(1, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'name'
        QtMocHelpers::PropertyData<QString>(2, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'floor'
        QtMocHelpers::PropertyData<QString>(3, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'iconName'
        QtMocHelpers::PropertyData<QString>(4, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'active'
        QtMocHelpers::PropertyData<int>(5, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'cpuNum'
        QtMocHelpers::PropertyData<int>(6, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'cpuID'
        QtMocHelpers::PropertyData<QString>(7, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'memory'
        QtMocHelpers::PropertyData<QString>(8, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'supportDevice'
        QtMocHelpers::PropertyData<QString>(9, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'type'
        QtMocHelpers::PropertyData<QString>(10, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'vmState'
        QtMocHelpers::PropertyData<QString>(11, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'belongOS'
        QtMocHelpers::PropertyData<QString>(12, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<VirtualMachineInfo, qt_meta_tag_ZN18VirtualMachineInfoE_t>(QMC::PropertyAccessInStaticMetaCall, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject VirtualMachineInfo::staticMetaObject = { {
    nullptr,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN18VirtualMachineInfoE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN18VirtualMachineInfoE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN18VirtualMachineInfoE_t>.metaTypes,
    nullptr
} };

void VirtualMachineInfo::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = reinterpret_cast<VirtualMachineInfo *>(_o);
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<int*>(_v) = _t->getId(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->getName(); break;
        case 2: *reinterpret_cast<QString*>(_v) = _t->getFloor(); break;
        case 3: *reinterpret_cast<QString*>(_v) = _t->getIconName(); break;
        case 4: *reinterpret_cast<int*>(_v) = _t->getActive(); break;
        case 5: *reinterpret_cast<int*>(_v) = _t->getCpuNum(); break;
        case 6: *reinterpret_cast<QString*>(_v) = _t->getCpuID(); break;
        case 7: *reinterpret_cast<QString*>(_v) = _t->getMemory(); break;
        case 8: *reinterpret_cast<QString*>(_v) = _t->getSupportDevice(); break;
        case 9: *reinterpret_cast<QString*>(_v) = _t->getType(); break;
        case 10: *reinterpret_cast<QString*>(_v) = _t->getVmState(); break;
        case 11: *reinterpret_cast<QString*>(_v) = _t->getBelongOS(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setId(*reinterpret_cast<int*>(_v)); break;
        case 1: _t->setName(*reinterpret_cast<QString*>(_v)); break;
        case 2: _t->setFloor(*reinterpret_cast<QString*>(_v)); break;
        case 3: _t->setIconName(*reinterpret_cast<QString*>(_v)); break;
        case 4: _t->setActive(*reinterpret_cast<int*>(_v)); break;
        case 5: _t->setCpuNum(*reinterpret_cast<int*>(_v)); break;
        case 6: _t->setCpuID(*reinterpret_cast<QString*>(_v)); break;
        case 7: _t->setMemory(*reinterpret_cast<QString*>(_v)); break;
        case 8: _t->setSupportDevice(*reinterpret_cast<QString*>(_v)); break;
        case 9: _t->setType(*reinterpret_cast<QString*>(_v)); break;
        case 10: _t->setVmState(*reinterpret_cast<QString*>(_v)); break;
        case 11: _t->setBelongOS(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}
QT_WARNING_POP
