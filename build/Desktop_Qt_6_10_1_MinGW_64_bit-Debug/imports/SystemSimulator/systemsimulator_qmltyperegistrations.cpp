/****************************************************************************
** Generated QML type registration code
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <QtQml/qqml.h>
#include <QtQml/qqmlmoduleregistration.h>

#if __has_include(<ganttpainteritem.h>)
#  include <ganttpainteritem.h>
#endif
#if __has_include(<rtaclient.h>)
#  include <rtaclient.h>
#endif
#if __has_include(<simulationclient.h>)
#  include <simulationclient.h>
#endif


#if !defined(QT_STATIC)
#define Q_QMLTYPE_EXPORT Q_DECL_EXPORT
#else
#define Q_QMLTYPE_EXPORT
#endif
Q_QMLTYPE_EXPORT void qml_register_types_SystemSimulator()
{
    QT_WARNING_PUSH QT_WARNING_DISABLE_DEPRECATED
    qmlRegisterTypesAndRevisions<GanttPainterItem>("SystemSimulator", 1);
    qmlRegisterAnonymousType<QQuickItem, 254>("SystemSimulator", 1);
    qmlRegisterTypesAndRevisions<RtaClient>("SystemSimulator", 1);
    qmlRegisterTypesAndRevisions<SimulationClient>("SystemSimulator", 1);
    QT_WARNING_POP
    qmlRegisterModule("SystemSimulator", 1, 0);
}

static const QQmlModuleRegistration systemSimulatorRegistration("SystemSimulator", qml_register_types_SystemSimulator);
