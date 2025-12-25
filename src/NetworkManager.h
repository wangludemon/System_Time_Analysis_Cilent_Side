#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <string>
#include <map>
#include <QObject>
#include <QString>
#include <QDebug>
#include <QRegularExpression>
#include <QQmlApplicationEngine>
#include "DeviceInfo.h"
#include "RustShyperInfo.h"
#include "VirtualMachineInfo.h"
#include "shyper.grpc.pb.h"
using namespace std;
using namespace shyper;

class NetworkManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(RustShyperInfo rustShyperInfo READ getRustShyperInfo NOTIFY rustShyperInfoUpdate)
public:
    explicit NetworkManager(QObject *parent = nullptr);
    RustShyperInfo getRustShyperInfo() {return rustShyperInfo;}

public slots: // 声明为槽函数，以便QML调用[2](@ref)[8](@ref)
    void connectToServer(const QString &ipAddress); // 接收IP地址参数
    void vmOperate(const int vmId, const QString &operateType);
    void createVm(const QString &vmName, const QString &osType, int cpuCores, qint64 memorySize);

signals: // 新增两个信号
    void connectionSuccess();
    void connectionFailed(const QString &errorMessage);
    void rustShyperInfoUpdate(const RustShyperInfo &rustShyperInfo);
    void vmOperateSuccess(const int origVmId, const int newVmId,const QString &operateType);
    void vmOperateFailed(const int origVmId, const int newVmId,const QString &operateType);
    void createVmSuccess(const VirtualMachineInfo &vmInfo);
    void createVmFailed(const QString &errorMessage);
    void systemConfigUpdated(const QStringList &availableOsTypes, int maxCpuCores, qint64 totalMemory, qint64 availableMemory);

private:
    bool connectGrpc(string ip);
    void processGrpcReply(SnapshotReply& reply);
    RustShyperInfo rustShyperInfo;
    map<int, string> irqDeviceMap;
    map<string,string> vmIconNameMap;
    QList<DeviceInfo> deviceInfoList;
    QList<VirtualMachineInfo> virtualMachineInfoList;
    std::unique_ptr<ShyperService::Stub> stub;
    std::set<std::string> vmNames;
    std::set<uint32_t> vmIds;
};

#endif // NETWORKMANAGER_H
