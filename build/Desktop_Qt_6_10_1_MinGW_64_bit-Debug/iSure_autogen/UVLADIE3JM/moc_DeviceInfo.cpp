/****************************************************************************
** Meta object code from reading C++ file 'DeviceInfo.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../src/DeviceInfo.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'DeviceInfo.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN10DeviceInfoE_t {};
} // unnamed namespace

template <> constexpr inline auto DeviceInfo::qt_create_metaobjectdata<qt_meta_tag_ZN10DeviceInfoE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "DeviceInfo",
        "id",
        "name",
        "status",
        "belongOS"
    };

    QtMocHelpers::UintData qt_methods {
    };
    QtMocHelpers::UintData qt_properties {
        // property 'id'
        QtMocHelpers::PropertyData<int>(1, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'name'
        QtMocHelpers::PropertyData<QString>(2, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'status'
        QtMocHelpers::PropertyData<QString>(3, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
        // property 'belongOS'
        QtMocHelpers::PropertyData<QString>(4, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet),
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<DeviceInfo, qt_meta_tag_ZN10DeviceInfoE_t>(QMC::PropertyAccessInStaticMetaCall, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject DeviceInfo::staticMetaObject = { {
    nullptr,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN10DeviceInfoE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN10DeviceInfoE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN10DeviceInfoE_t>.metaTypes,
    nullptr
} };

void DeviceInfo::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = reinterpret_cast<DeviceInfo *>(_o);
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<int*>(_v) = _t->getId(); break;
        case 1: *reinterpret_cast<QString*>(_v) = _t->getName(); break;
        case 2: *reinterpret_cast<QString*>(_v) = _t->getStatus(); break;
        case 3: *reinterpret_cast<QString*>(_v) = _t->getBelongOS(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setId(*reinterpret_cast<int*>(_v)); break;
        case 1: _t->setName(*reinterpret_cast<QString*>(_v)); break;
        case 2: _t->setStatus(*reinterpret_cast<QString*>(_v)); break;
        case 3: _t->setBelongOS(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}
QT_WARNING_POP
