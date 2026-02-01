include("E:/iSurePro/iSure/build/Desktop_Qt_6_10_1_MinGW_64_bit-Debug/.qt/QtDeploySupport.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/iSure-plugins.cmake" OPTIONAL)
set(__QT_DEPLOY_I18N_CATALOGS "qtbase;qtdeclarative;qtdeclarative;qtdeclarative;qtdeclarative;qtdeclarative;qtdeclarative;qtdeclarative;qtdeclarative;qtdeclarative")

qt6_deploy_qml_imports(TARGET iSure PLUGINS_FOUND plugins_found)
qt6_deploy_runtime_dependencies(
    EXECUTABLE "E:/iSurePro/iSure/build/Desktop_Qt_6_10_1_MinGW_64_bit-Debug/iSure.exe"
    ADDITIONAL_MODULES ${plugins_found}
    GENERATE_QT_CONF
)