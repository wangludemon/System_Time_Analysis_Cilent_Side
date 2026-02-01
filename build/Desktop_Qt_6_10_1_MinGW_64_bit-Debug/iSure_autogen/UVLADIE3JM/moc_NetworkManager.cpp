/****************************************************************************
** Meta object code from reading C++ file 'NetworkManager.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/NetworkManager.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'NetworkManager.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN14NetworkManagerE_t {};
} // unnamed namespace

template <> constexpr inline auto NetworkManager::qt_create_metaobjectdata<qt_meta_tag_ZN14NetworkManagerE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "NetworkManager",
        "connectionSuccess",
        "",
        "connectionFailed",
        "errorMessage",
        "rustShyperInfoUpdate",
        "RustShyperInfo",
        "rustShyperInfo",
        "vmOperateSuccess",
        "origVmId",
        "newVmId",
        "operateType",
        "vmOperateFailed",
        "createVmSuccess",
        "VirtualMachineInfo",
        "vmInfo",
        "createVmFailed",
        "systemConfigUpdated",
        "availableOsTypes",
        "maxCpuCores",
        "totalMemory",
        "availableMemory",
        "connectToServer",
        "ipAddress",
        "vmOperate",
        "vmId",
        "createVm",
        "vmName",
        "osType",
        "cpuCores",
        "memorySize"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'connectionSuccess'
        QtMocHelpers::SignalData<void()>(1, 2, QMC::AccessPublic, QMetaType::Void),
        // Signal 'connectionFailed'
        QtMocHelpers::SignalData<void(const QString &)>(3, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 4 },
        }}),
        // Signal 'rustShyperInfoUpdate'
        QtMocHelpers::SignalData<void(const RustShyperInfo &)>(5, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 6, 7 },
        }}),
        // Signal 'vmOperateSuccess'
        QtMocHelpers::SignalData<void(const int, const int, const QString &)>(8, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 9 }, { QMetaType::Int, 10 }, { QMetaType::QString, 11 },
        }}),
        // Signal 'vmOperateFailed'
        QtMocHelpers::SignalData<void(const int, const int, const QString &)>(12, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 9 }, { QMetaType::Int, 10 }, { QMetaType::QString, 11 },
        }}),
        // Signal 'createVmSuccess'
        QtMocHelpers::SignalData<void(const VirtualMachineInfo &)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { 0x80000000 | 14, 15 },
        }}),
        // Signal 'createVmFailed'
        QtMocHelpers::SignalData<void(const QString &)>(16, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 4 },
        }}),
        // Signal 'systemConfigUpdated'
        QtMocHelpers::SignalData<void(const QStringList &, int, qint64, qint64)>(17, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QStringList, 18 }, { QMetaType::Int, 19 }, { QMetaType::LongLong, 20 }, { QMetaType::LongLong, 21 },
        }}),
        // Slot 'connectToServer'
        QtMocHelpers::SlotData<void(const QString &)>(22, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 23 },
        }}),
        // Slot 'vmOperate'
        QtMocHelpers::SlotData<void(const int, const QString &)>(24, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Int, 25 }, { QMetaType::QString, 11 },
        }}),
        // Slot 'createVm'
        QtMocHelpers::SlotData<void(const QString &, const QString &, int, qint64)>(26, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 27 }, { QMetaType::QString, 28 }, { QMetaType::Int, 29 }, { QMetaType::LongLong, 30 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'rustShyperInfo'
        QtMocHelpers::PropertyData<RustShyperInfo>(7, 0x80000000 | 6, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 2),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<NetworkManager, qt_meta_tag_ZN14NetworkManagerE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject NetworkManager::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14NetworkManagerE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14NetworkManagerE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN14NetworkManagerE_t>.metaTypes,
    nullptr
} };

void NetworkManager::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<NetworkManager *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->connectionSuccess(); break;
        case 1: _t->connectionFailed((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 2: _t->rustShyperInfoUpdate((*reinterpret_cast<std::add_pointer_t<RustShyperInfo>>(_a[1]))); break;
        case 3: _t->vmOperateSuccess((*reinterpret_cast<std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[3]))); break;
        case 4: _t->vmOperateFailed((*reinterpret_cast<std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[3]))); break;
        case 5: _t->createVmSuccess((*reinterpret_cast<std::add_pointer_t<VirtualMachineInfo>>(_a[1]))); break;
        case 6: _t->createVmFailed((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 7: _t->systemConfigUpdated((*reinterpret_cast<std::add_pointer_t<QStringList>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<int>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<qint64>>(_a[3])),(*reinterpret_cast<std::add_pointer_t<qint64>>(_a[4]))); break;
        case 8: _t->connectToServer((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 9: _t->vmOperate((*reinterpret_cast<std::add_pointer_t<int>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 10: _t->createVm((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2])),(*reinterpret_cast<std::add_pointer_t<int>>(_a[3])),(*reinterpret_cast<std::add_pointer_t<qint64>>(_a[4]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 2:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< RustShyperInfo >(); break;
            }
            break;
        case 5:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< VirtualMachineInfo >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (NetworkManager::*)()>(_a, &NetworkManager::connectionSuccess, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (NetworkManager::*)(const QString & )>(_a, &NetworkManager::connectionFailed, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (NetworkManager::*)(const RustShyperInfo & )>(_a, &NetworkManager::rustShyperInfoUpdate, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (NetworkManager::*)(const int , const int , const QString & )>(_a, &NetworkManager::vmOperateSuccess, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (NetworkManager::*)(const int , const int , const QString & )>(_a, &NetworkManager::vmOperateFailed, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (NetworkManager::*)(const VirtualMachineInfo & )>(_a, &NetworkManager::createVmSuccess, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (NetworkManager::*)(const QString & )>(_a, &NetworkManager::createVmFailed, 6))
            return;
        if (QtMocHelpers::indexOfMethod<void (NetworkManager::*)(const QStringList & , int , qint64 , qint64 )>(_a, &NetworkManager::systemConfigUpdated, 7))
            return;
    }
    if (_c == QMetaObject::RegisterPropertyMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< RustShyperInfo >(); break;
        }
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<RustShyperInfo*>(_v) = _t->getRustShyperInfo(); break;
        default: break;
        }
    }
}

const QMetaObject *NetworkManager::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *NetworkManager::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN14NetworkManagerE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int NetworkManager::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 11)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 11;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 1;
    }
    return _id;
}

// SIGNAL 0
void NetworkManager::connectionSuccess()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void NetworkManager::connectionFailed(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1);
}

// SIGNAL 2
void NetworkManager::rustShyperInfoUpdate(const RustShyperInfo & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void NetworkManager::vmOperateSuccess(const int _t1, const int _t2, const QString & _t3)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1, _t2, _t3);
}

// SIGNAL 4
void NetworkManager::vmOperateFailed(const int _t1, const int _t2, const QString & _t3)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1, _t2, _t3);
}

// SIGNAL 5
void NetworkManager::createVmSuccess(const VirtualMachineInfo & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1);
}

// SIGNAL 6
void NetworkManager::createVmFailed(const QString & _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 6, nullptr, _t1);
}

// SIGNAL 7
void NetworkManager::systemConfigUpdated(const QStringList & _t1, int _t2, qint64 _t3, qint64 _t4)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 7, nullptr, _t1, _t2, _t3, _t4);
}
QT_WARNING_POP
