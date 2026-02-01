/****************************************************************************
** Meta object code from reading C++ file 'simulationclient.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../imports/SystemSimulator/simulationclient.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'simulationclient.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN16SimulationClientE_t {};
} // unnamed namespace

template <> constexpr inline auto SimulationClient::qt_create_metaobjectdata<qt_meta_tag_ZN16SimulationClientE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "SimulationClient",
        "QML.Element",
        "auto",
        "dataChanged",
        "",
        "configChanged",
        "errorOccurred",
        "errorMsg",
        "onReplyFinished",
        "QNetworkReply*",
        "reply",
        "sendSimulationRequest",
        "getProtocolData",
        "protocolName",
        "startSimulation",
        "cpuGanttData",
        "QJsonArray",
        "taskGanttData",
        "taskTableData",
        "resourceTableData",
        "msrpResult",
        "mrspResult",
        "pwlpResult",
        "cpuCoreCount",
        "taskNumPerCore",
        "minPeriod",
        "maxPeriod",
        "maxAccess",
        "resourceRatio",
        "resourceType",
        "resourceCount",
        "isCriticalitySwitch",
        "isAutoSwitch",
        "algorithm"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'dataChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'configChanged'
        QtMocHelpers::SignalData<void()>(5, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'errorOccurred'
        QtMocHelpers::SignalData<void(QString)>(6, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 7 },
        }}),
        // Slot 'onReplyFinished'
        QtMocHelpers::SlotData<void(QNetworkReply *)>(8, 4, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 9, 10 },
        }}),
        // Method 'sendSimulationRequest'
        QtMocHelpers::MethodData<void()>(11, 4, QMC::AccessPublic, QMetaType::Void),
        // Method 'getProtocolData'
        QtMocHelpers::MethodData<void(QString)>(12, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 13 },
        }}),
        // Method 'startSimulation'
        QtMocHelpers::MethodData<void()>(14, 4, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'cpuGanttData'
        QtMocHelpers::PropertyData<QJsonArray>(15, 0x80000000 | 16, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'taskGanttData'
        QtMocHelpers::PropertyData<QJsonArray>(17, 0x80000000 | 16, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'taskTableData'
        QtMocHelpers::PropertyData<QJsonArray>(18, 0x80000000 | 16, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'resourceTableData'
        QtMocHelpers::PropertyData<QJsonArray>(19, 0x80000000 | 16, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'msrpResult'
        QtMocHelpers::PropertyData<bool>(20, QMetaType::Bool, QMC::DefaultPropertyFlags, 0),
        // property 'mrspResult'
        QtMocHelpers::PropertyData<bool>(21, QMetaType::Bool, QMC::DefaultPropertyFlags, 0),
        // property 'pwlpResult'
        QtMocHelpers::PropertyData<bool>(22, QMetaType::Bool, QMC::DefaultPropertyFlags, 0),
        // property 'cpuCoreCount'
        QtMocHelpers::PropertyData<int>(23, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'taskNumPerCore'
        QtMocHelpers::PropertyData<int>(24, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'minPeriod'
        QtMocHelpers::PropertyData<int>(25, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'maxPeriod'
        QtMocHelpers::PropertyData<int>(26, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'maxAccess'
        QtMocHelpers::PropertyData<int>(27, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'resourceRatio'
        QtMocHelpers::PropertyData<double>(28, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'resourceType'
        QtMocHelpers::PropertyData<QString>(29, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'resourceCount'
        QtMocHelpers::PropertyData<QString>(30, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'isCriticalitySwitch'
        QtMocHelpers::PropertyData<bool>(31, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'isAutoSwitch'
        QtMocHelpers::PropertyData<bool>(32, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'algorithm'
        QtMocHelpers::PropertyData<QString>(33, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<SimulationClient, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject SimulationClient::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16SimulationClientE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16SimulationClientE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN16SimulationClientE_t>.metaTypes,
    nullptr
} };

void SimulationClient::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<SimulationClient *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->dataChanged(); break;
        case 1: _t->configChanged(); break;
        case 2: _t->errorOccurred((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 3: _t->onReplyFinished((*reinterpret_cast<std::add_pointer_t<QNetworkReply*>>(_a[1]))); break;
        case 4: _t->sendSimulationRequest(); break;
        case 5: _t->getProtocolData((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1]))); break;
        case 6: _t->startSimulation(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 3:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QNetworkReply* >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (SimulationClient::*)()>(_a, &SimulationClient::dataChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (SimulationClient::*)()>(_a, &SimulationClient::configChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (SimulationClient::*)(QString )>(_a, &SimulationClient::errorOccurred, 2))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QJsonArray*>(_v) = _t->cpuGanttData(); break;
        case 1: *reinterpret_cast<QJsonArray*>(_v) = _t->taskGanttData(); break;
        case 2: *reinterpret_cast<QJsonArray*>(_v) = _t->taskTableData(); break;
        case 3: *reinterpret_cast<QJsonArray*>(_v) = _t->resourceTableData(); break;
        case 4: *reinterpret_cast<bool*>(_v) = _t->msrpResult(); break;
        case 5: *reinterpret_cast<bool*>(_v) = _t->mrspResult(); break;
        case 6: *reinterpret_cast<bool*>(_v) = _t->pwlpResult(); break;
        case 7: *reinterpret_cast<int*>(_v) = _t->cpuCoreCount(); break;
        case 8: *reinterpret_cast<int*>(_v) = _t->taskNumPerCore(); break;
        case 9: *reinterpret_cast<int*>(_v) = _t->minPeriod(); break;
        case 10: *reinterpret_cast<int*>(_v) = _t->maxPeriod(); break;
        case 11: *reinterpret_cast<int*>(_v) = _t->maxAccess(); break;
        case 12: *reinterpret_cast<double*>(_v) = _t->resourceRatio(); break;
        case 13: *reinterpret_cast<QString*>(_v) = _t->resourceType(); break;
        case 14: *reinterpret_cast<QString*>(_v) = _t->resourceCount(); break;
        case 15: *reinterpret_cast<bool*>(_v) = _t->isCriticalitySwitch(); break;
        case 16: *reinterpret_cast<bool*>(_v) = _t->isAutoSwitch(); break;
        case 17: *reinterpret_cast<QString*>(_v) = _t->algorithm(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 7: _t->setCpuCoreCount(*reinterpret_cast<int*>(_v)); break;
        case 8: _t->setTaskNumPerCore(*reinterpret_cast<int*>(_v)); break;
        case 9: _t->setMinPeriod(*reinterpret_cast<int*>(_v)); break;
        case 10: _t->setMaxPeriod(*reinterpret_cast<int*>(_v)); break;
        case 11: _t->setMaxAccess(*reinterpret_cast<int*>(_v)); break;
        case 12: _t->setResourceRatio(*reinterpret_cast<double*>(_v)); break;
        case 13: _t->setResourceType(*reinterpret_cast<QString*>(_v)); break;
        case 14: _t->setResourceCount(*reinterpret_cast<QString*>(_v)); break;
        case 15: _t->setIsCriticalitySwitch(*reinterpret_cast<bool*>(_v)); break;
        case 16: _t->setIsAutoSwitch(*reinterpret_cast<bool*>(_v)); break;
        case 17: _t->setAlgorithm(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *SimulationClient::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SimulationClient::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16SimulationClientE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int SimulationClient::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 7)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 7;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 18;
    }
    return _id;
}

// SIGNAL 0
void SimulationClient::dataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void SimulationClient::configChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void SimulationClient::errorOccurred(QString _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}
QT_WARNING_POP
