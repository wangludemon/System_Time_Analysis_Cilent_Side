#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _qt_qml_SystemSimulator_SimulatorPage_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_SystemSimulator_RtaPage_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_SystemSimulator_RtaParamPage_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_SystemSimulator_RtaAnalysisPage_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_SystemSimulator_ConfigDialog_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_SystemSimulator_GridCell_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_SystemSimulator_StyledButton_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/SystemSimulator/SimulatorPage.qml"), &QmlCacheGeneratedCode::_qt_qml_SystemSimulator_SimulatorPage_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/SystemSimulator/RtaPage.qml"), &QmlCacheGeneratedCode::_qt_qml_SystemSimulator_RtaPage_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/SystemSimulator/RtaParamPage.qml"), &QmlCacheGeneratedCode::_qt_qml_SystemSimulator_RtaParamPage_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/SystemSimulator/RtaAnalysisPage.qml"), &QmlCacheGeneratedCode::_qt_qml_SystemSimulator_RtaAnalysisPage_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/SystemSimulator/ConfigDialog.qml"), &QmlCacheGeneratedCode::_qt_qml_SystemSimulator_ConfigDialog_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/SystemSimulator/GridCell.qml"), &QmlCacheGeneratedCode::_qt_qml_SystemSimulator_GridCell_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/SystemSimulator/StyledButton.qml"), &QmlCacheGeneratedCode::_qt_qml_SystemSimulator_StyledButton_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_SystemSimulator)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_SystemSimulator))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_SystemSimulator)() {
    return 1;
}
