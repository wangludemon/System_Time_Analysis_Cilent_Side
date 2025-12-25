#ifndef RUSTSHYPERINFO_H
#define RUSTSHYPERINFO_H

#include <QString>
#include <QList>
#include "DeviceInfo.h"
#include "VirtualMachineInfo.h"

struct RustShyperInfo {
    Q_GADGET
    Q_PROPERTY(int cpuUtilizationRate READ getCpuUtilizationRate WRITE setCpuUtilizationRate)
    Q_PROPERTY(int memUtilizationRate READ getMemUtilizationRate WRITE setMemUtilizationRate)
    // 关键修改：将playerList的类型改为QList<PlayerInfo>
    Q_PROPERTY(QList<DeviceInfo> deviceInfoList READ getDeviceInfoList WRITE setDeviceInfoList)
    Q_PROPERTY(QList<VirtualMachineInfo> virtualMachineInfoList READ getVirtualMachineInfoList WRITE setVirtualMachineInfoList)
    Q_PROPERTY(QString board READ getBoard WRITE setBoard)
    Q_PROPERTY(QString cpuInfo READ getCpuInfo WRITE setCpuInfo)
    Q_PROPERTY(QString memoryInfo READ getMemoryInfo WRITE setMemoryInfo)

public:
    int getCpuUtilizationRate() const {return cpuUtilizationRate;}
    void setCpuUtilizationRate(const int cpuUtilizationRate) {this->cpuUtilizationRate = cpuUtilizationRate;}

    int getMemUtilizationRate() const {return memUtilizationRate;}
    void setMemUtilizationRate(const int memUtilizationRate) {this->memUtilizationRate = memUtilizationRate;}

    QList<DeviceInfo> getDeviceInfoList() const { return deviceInfoList; }
    void setDeviceInfoList(const QList<DeviceInfo> &deviceInfoList) { this->deviceInfoList = deviceInfoList; }

    QList<VirtualMachineInfo> getVirtualMachineInfoList() const { return virtualMachineInfoList; }
    void setVirtualMachineInfoList(const QList<VirtualMachineInfo> &virtualMachineInfoList) { this->virtualMachineInfoList = virtualMachineInfoList; }

    QString getBoard() const { return board; }
    void setBoard(const QString &board) { this->board = board; }

    QString getCpuInfo() const { return cpuInfo; }
    void setCpuInfo(const QString &cpuInfo) { this->cpuInfo = cpuInfo; }

    QString getMemoryInfo() const { return memoryInfo; }
    void setMemoryInfo(const QString &memoryInfo) { this->memoryInfo = memoryInfo; }

private:
    int cpuUtilizationRate;
    int memUtilizationRate;
    QList<DeviceInfo> deviceInfoList;
    QList<VirtualMachineInfo> virtualMachineInfoList;
    QString board;
    QString cpuInfo;
    QString memoryInfo;
};

Q_DECLARE_METATYPE(RustShyperInfo)
#endif // RUSTSHYPERINFO_H
