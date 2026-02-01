# Embedded SystemSimulator QML module for iSure

qt_add_library(SystemSimulator STATIC)

qt_add_qml_module(SystemSimulator
    URI "SystemSimulator"
    VERSION 1.0

    QML_FILES
        SimulatorPage.qml
        RtaPage.qml
        RtaParamPage.qml
        RtaAnalysisPage.qml
        ConfigDialog.qml
        GridCell.qml
        StyledButton.qml

    SOURCES
        ganttpainteritem.h ganttpainteritem.cpp
        simulationclient.h simulationclient.cpp
        rtaclient.h rtaclient.cpp
)

target_link_libraries(SystemSimulator PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::Network
)
