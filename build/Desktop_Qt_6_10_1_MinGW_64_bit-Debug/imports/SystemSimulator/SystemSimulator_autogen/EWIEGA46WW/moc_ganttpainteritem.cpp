/****************************************************************************
** Meta object code from reading C++ file 'ganttpainteritem.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.10.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../../../imports/SystemSimulator/ganttpainteritem.h"
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'ganttpainteritem.h' doesn't include <QObject>."
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
struct qt_meta_tag_ZN16GanttPainterItemE_t {};
} // unnamed namespace

template <> constexpr inline auto GanttPainterItem::qt_create_metaobjectdata<qt_meta_tag_ZN16GanttPainterItemE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "GanttPainterItem",
        "QML.Element",
        "GanttPainter",
        "taskListChanged",
        "",
        "switchTimeChanged",
        "contentWidthChanged",
        "showLabelsChanged",
        "taskList",
        "QJsonArray",
        "switchTime",
        "contentWidth",
        "showLabels"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'taskListChanged'
        QtMocHelpers::SignalData<void()>(3, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'switchTimeChanged'
        QtMocHelpers::SignalData<void()>(5, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'contentWidthChanged'
        QtMocHelpers::SignalData<void()>(6, 4, QMC::AccessPublic, QMetaType::Void),
        // Signal 'showLabelsChanged'
        QtMocHelpers::SignalData<void()>(7, 4, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
        // property 'taskList'
        QtMocHelpers::PropertyData<QJsonArray>(8, 0x80000000 | 9, QMC::DefaultPropertyFlags | QMC::Writable | QMC::EnumOrFlag | QMC::StdCppSet, 0),
        // property 'switchTime'
        QtMocHelpers::PropertyData<double>(10, QMetaType::Double, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 1),
        // property 'contentWidth'
        QtMocHelpers::PropertyData<int>(11, QMetaType::Int, QMC::DefaultPropertyFlags, 2),
        // property 'showLabels'
        QtMocHelpers::PropertyData<bool>(12, QMetaType::Bool, QMC::DefaultPropertyFlags | QMC::Writable | QMC::StdCppSet, 3),
    };
    QtMocHelpers::UintData qt_enums {
    };
    QtMocHelpers::UintData qt_constructors {};
    QtMocHelpers::ClassInfos qt_classinfo({
            {    1,    2 },
    });
    return QtMocHelpers::metaObjectData<GanttPainterItem, void>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums, qt_constructors, qt_classinfo);
}
Q_CONSTINIT const QMetaObject GanttPainterItem::staticMetaObject = { {
    QMetaObject::SuperData::link<QQuickPaintedItem::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16GanttPainterItemE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16GanttPainterItemE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN16GanttPainterItemE_t>.metaTypes,
    nullptr
} };

void GanttPainterItem::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<GanttPainterItem *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->taskListChanged(); break;
        case 1: _t->switchTimeChanged(); break;
        case 2: _t->contentWidthChanged(); break;
        case 3: _t->showLabelsChanged(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (GanttPainterItem::*)()>(_a, &GanttPainterItem::taskListChanged, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (GanttPainterItem::*)()>(_a, &GanttPainterItem::switchTimeChanged, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (GanttPainterItem::*)()>(_a, &GanttPainterItem::contentWidthChanged, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (GanttPainterItem::*)()>(_a, &GanttPainterItem::showLabelsChanged, 3))
            return;
    }
    if (_c == QMetaObject::ReadProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast<QJsonArray*>(_v) = _t->taskList(); break;
        case 1: *reinterpret_cast<double*>(_v) = _t->switchTime(); break;
        case 2: *reinterpret_cast<int*>(_v) = _t->contentWidth(); break;
        case 3: *reinterpret_cast<bool*>(_v) = _t->showLabels(); break;
        default: break;
        }
    }
    if (_c == QMetaObject::WriteProperty) {
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setTaskList(*reinterpret_cast<QJsonArray*>(_v)); break;
        case 1: _t->setSwitchTime(*reinterpret_cast<double*>(_v)); break;
        case 3: _t->setShowLabels(*reinterpret_cast<bool*>(_v)); break;
        default: break;
        }
    }
}

const QMetaObject *GanttPainterItem::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *GanttPainterItem::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN16GanttPainterItemE_t>.strings))
        return static_cast<void*>(this);
    return QQuickPaintedItem::qt_metacast(_clname);
}

int GanttPainterItem::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QQuickPaintedItem::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 4)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 4)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 4;
    }
    if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::BindableProperty
            || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 4;
    }
    return _id;
}

// SIGNAL 0
void GanttPainterItem::taskListChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void GanttPainterItem::switchTimeChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 1, nullptr);
}

// SIGNAL 2
void GanttPainterItem::contentWidthChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 2, nullptr);
}

// SIGNAL 3
void GanttPainterItem::showLabelsChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 3, nullptr);
}
QT_WARNING_POP
