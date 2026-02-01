/****************************************************************************
** Meta object code from reading C++ file 'rtaclient.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../imports/SystemSimulator/rtaclient.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'rtaclient.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN9RtaClientE_t {};
} // unnamed namespace

template <> constexpr inline auto RtaClient::qt_create_metaobjectdata<qt_meta_tag_ZN9RtaClientE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "RtaClient",
        "QML.Element",
        "auto",
        "dataChanged",
        "",
        "paramsChanged",
        "requestFinished",
        "success",
        "message",
        "analysisFinished",
        "msg",
        "analysisResultsChanged",
        "analysisSchedulableChanged",
        "analysisMetaChanged",
        "onReplyFinished",
        "QNetworkReply*",
        "reply",
        "generateSystem",
        "analyze",
        "method",
        "systemMode",
        "tasks",
        "QJsonArray",
        "resources",
        "coreCount",
        "taskNum",
        "utilization",
        "periodMin",
        "periodMax",
        "resourceNum",
        "rsf",
        "maxAccess",
        "cslMin",
        "cslMax",
        "allocation",
        "priority",
        "analysisResults",
        "QVariantList",
        "analysisSchedulable",
        "analysisMethod",
        "analysisReason",
        "analysisSystemMode"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'dataChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'paramsChanged'
        QtMocHelpers::SignalData<void()>(5, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'requestFinished'
        QtMocHelpers::SignalData<void(bool, QString)>(6, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 7 }, { QMetaType::QString, 8 },
        }}),
        // Signal 'analysisFinished'
        QtMocHelpers::SignalData<void(bool, const QString &)>(9, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::Bool, 7 }, { QMetaType::QString, 10 },
        }}),
        // Signal 'analysisResultsChanged'
        QtMocHelpers::SignalData<void()>(11, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'analysisSchedulableChanged'
        QtMocHelpers::SignalData<void()>(12, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'analysisMetaChanged'
        QtMocHelpers::SignalData<void()>(13, 4, QMC::AccessPublic, QMetaType::Void),
        // Slot 'onReplyFinished'
        QtMocHelpers::SlotData<void(QNetworkReply *)>(14, 4, QMC::AccessPrivate, QMetaType::Void, {{
            { 0x80000000 | 15, 16 },
        }}),
        // Method 'generateSystem'
        QtMocHelpers::MethodData<void()>(17, 4, QMC::AccessPublic, QMetaType::Void),
        // Method 'analyze'
        QtMocHelpers::MethodData<void(const QString &, const QString &)>(18, 4, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 19 }, { QMetaType::QString, 20 },
        }}),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'tasks'
        QtMocHelpers::PropertyData<QJsonArray>(21, 0x80000000 | 22, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'resources'
        QtMocHelpers::PropertyData<QJsonArray>(23, 0x80000000 | 22, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 0),
        // property 'coreCount'
        QtMocHelpers::PropertyData<int>(24, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'taskNum'
        QtMocHelpers::PropertyData<int>(25, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'utilization'
        QtMocHelpers::PropertyData<double>(26, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'periodMin'
        QtMocHelpers::PropertyData<int>(27, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'periodMax'
        QtMocHelpers::PropertyData<int>(28, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'resourceNum'
        QtMocHelpers::PropertyData<int>(29, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'rsf'
        QtMocHelpers::PropertyData<double>(30, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'maxAccess'
        QtMocHelpers::PropertyData<int>(31, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'cslMin'
        QtMocHelpers::PropertyData<int>(32, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'cslMax'
        QtMocHelpers::PropertyData<int>(33, QMetaType::Int, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'allocation'
        QtMocHelpers::PropertyData<QString>(34, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'priority'
        QtMocHelpers::PropertyData<QString>(35, QMetaType::QString, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'analysisResults'
        QtMocHelpers::PropertyData<QVariantList>(36, 0x80000000 | 37, QMC::DefaultPropertyFlags | QMC::EnumOrFlag, 4),
        // property 'analysisSchedulable'
        QtMocHelpers::PropertyData<bool>(38, QMetaType::Bool, QMC::DefaultPropertyFlags, 5),
        // property 'analysisMethod'
        QtMocHelpers::PropertyData<QString>(39, QMetaType::QString, QMC::DefaultPropertyFlags, 6),
        // property 'analysisReason'
        QtMocHelpers::PropertyData<QString>(40, QMetaType::QString, QMC::DefaultPropertyFlags, 6),
        // property 'analysisSystemMode'
        QtMocHelpers::PropertyData<QString>(41, QMetaType::QString, QMC::DefaultPropertyFlags, 6),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<RtaClient, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject RtaClient::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9RtaClientE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9RtaClientE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN9RtaClientE_t>.metaTypes,
    nullptr
} };

void RtaClient::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<RtaClient *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->dataChanged(); break;
        case 1: _t->paramsChanged(); break;
        case 2: _t->requestFinished((*reinterpret_cast<std::add_pointer_t<bool>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 3: _t->analysisFinished((*reinterpret_cast<std::add_pointer_t<bool>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        case 4: _t->analysisResultsChanged(); break;
        case 5: _t->analysisSchedulableChanged(); break;
        case 6: _t->analysisMetaChanged(); break;
        case 7: _t->onReplyFinished((*reinterpret_cast<std::add_pointer_t<QNetworkReply*>>(_a[1]))); break;
        case 8: _t->generateSystem(); break;
        case 9: _t->analyze((*reinterpret_cast<std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast<std::add_pointer_t<QString>>(_a[2]))); break;
        default: ;
        }
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
        case 7:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType(); break;
            case 0:
                *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType::fromType< QNetworkReply* >(); break;
            }
            break;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (RtaClient::*)()>(_a, &RtaClient::dataChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (RtaClient::*)()>(_a, &RtaClient::paramsChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (RtaClient::*)(bool , QString )>(_a, &RtaClient::requestFinished, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (RtaClient::*)(bool , const QString & )>(_a, &RtaClient::analysisFinished, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (RtaClient::*)()>(_a, &RtaClient::analysisResultsChanged, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (RtaClient::*)()>(_a, &RtaClient::analysisSchedulableChanged, 5))
            return;
        if (QtMocHelpers::indexOfMethod<void (RtaClient::*)()>(_a, &RtaClient::analysisMetaChanged, 6))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QJsonArray*>(_v) = _t->tasks(); break;
        case 1: *reinterpret_cast<QJsonArray*>(_v) = _t->resources(); break;
        case 2: *reinterpret_cast<int*>(_v) = _t->coreCount(); break;
        case 3: *reinterpret_cast<int*>(_v) = _t->taskNum(); break;
        case 4: *reinterpret_cast<double*>(_v) = _t->utilization(); break;
        case 5: *reinterpret_cast<int*>(_v) = _t->periodMin(); break;
        case 6: *reinterpret_cast<int*>(_v) = _t->periodMax(); break;
        case 7: *reinterpret_cast<int*>(_v) = _t->resourceNum(); break;
        case 8: *reinterpret_cast<double*>(_v) = _t->rsf(); break;
        case 9: *reinterpret_cast<int*>(_v) = _t->maxAccess(); break;
        case 10: *reinterpret_cast<int*>(_v) = _t->cslMin(); break;
        case 11: *reinterpret_cast<int*>(_v) = _t->cslMax(); break;
        case 12: *reinterpret_cast<QString*>(_v) = _t->allocation(); break;
        case 13: *reinterpret_cast<QString*>(_v) = _t->priority(); break;
        case 14: *reinterpret_cast<QVariantList*>(_v) = _t->analysisResults(); break;
        case 15: *reinterpret_cast<bool*>(_v) = _t->analysisSchedulable(); break;
        case 16: *reinterpret_cast<QString*>(_v) = _t->analysisMethod(); break;
        case 17: *reinterpret_cast<QString*>(_v) = _t->analysisReason(); break;
        case 18: *reinterpret_cast<QString*>(_v) = _t->analysisSystemMode(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 2: _t->setCoreCount(*reinterpret_cast<int*>(_v)); break;
        case 3: _t->setTaskNum(*reinterpret_cast<int*>(_v)); break;
        case 4: _t->setUtilization(*reinterpret_cast<double*>(_v)); break;
        case 5: _t->setPeriodMin(*reinterpret_cast<int*>(_v)); break;
        case 6: _t->setPeriodMax(*reinterpret_cast<int*>(_v)); break;
        case 7: _t->setResourceNum(*reinterpret_cast<int*>(_v)); break;
        case 8: _t->setRsf(*reinterpret_cast<double*>(_v)); break;
        case 9: _t->setMaxAccess(*reinterpret_cast<int*>(_v)); break;
        case 10: _t->setCslMin(*reinterpret_cast<int*>(_v)); break;
        case 11: _t->setCslMax(*reinterpret_cast<int*>(_v)); break;
        case 12: _t->setAllocation(*reinterpret_cast<QString*>(_v)); break;
        case 13: _t->setPriority(*reinterpret_cast<QString*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *RtaClient::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *RtaClient::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN9RtaClientE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int RtaClient::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 10)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 10)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 19;
    }
    return _id;
}

// SIGNAL 0
void RtaClient::dataChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void RtaClient::paramsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void RtaClient::requestFinished(bool _t1, QString _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1, _t2);
}

// SIGNAL 3
void RtaClient::analysisFinished(bool _t1, const QString & _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1, _t2);
}

// SIGNAL 4
void RtaClient::analysisResultsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void RtaClient::analysisSchedulableChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 5, nullptr);
}

// SIGNAL 6
void RtaClient::analysisMetaChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 6, nullptr);
}
QT_WARNING_POP
