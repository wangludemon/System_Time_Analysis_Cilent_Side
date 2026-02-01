#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <string>
#include <map>
#include <memory>          // MOD: for std::unique_ptr
#include <set>             // MOD: for std::set
#include <QObject>
#include <QString>
#include <QDebug>
#include <QRegularExpression>
#include <QQmlApplicationEngine>

#include "DeviceInfo.h"
#include "RustShyperInfo.h"
#include "VirtualMachineInfo.h"

// MOD: 只有启用 gRPC 时才包含 proto 生成头（否则会找不到 shyper.grpc.pb.h）
#if USE_GRPC
#include "shyper.grpc.pb.h"
using namespace shyper;  // MOD: 仅在 USE_GRPC 时引入命名空间，避免未定义
#endif

using namespace std;

class NetworkManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(RustShyperInfo rustShyperInfo READ getRustShyperInfo NOTIFY rustShyperInfoUpdate)

public:
    explicit NetworkManager(QObject *parent = nullptr);
    RustShyperInfo getRustShyperInfo() { return rustShyperInfo; }

public slots:
    void connectToServer(const QString &ipAddress);
    void vmOperate(const int vmId, const QString &operateType);
    void createVm(const QString &vmName, const QString &osType, int cpuCores, qint64 memorySize);

signals:
    void connectionSuccess();
    void connectionFailed(const QString &errorMessage);
    void rustShyperInfoUpdate(const RustShyperInfo &rustShyperInfo);
    void vmOperateSuccess(const int origVmId, const int newVmId, const QString &operateType);
    void vmOperateFailed(const int origVmId, const int newVmId, const QString &operateType);
    void createVmSuccess(const VirtualMachineInfo &vmInfo);
    void createVmFailed(const QString &errorMessage);
    void systemConfigUpdated(const QStringList &availableOsTypes, int maxCpuCores, qint64 totalMemory, qint64 availableMemory);

private:
    // MOD: gRPC 相关私有方法只在 USE_GRPC=1 时声明
#if USE_GRPC
    bool connectGrpc(string ip);
    void processGrpcReply(SnapshotReply& reply);
#endif

private:
    RustShyperInfo rustShyperInfo;
    map<int, string> irqDeviceMap;
    map<string, string> vmIconNameMap;
    QList<DeviceInfo> deviceInfoList;
    QList<VirtualMachineInfo> virtualMachineInfoList;

    // MOD: gRPC stub 只在 USE_GRPC=1 时存在
#if USE_GRPC
    std::unique_ptr<ShyperService::Stub> stub;
#endif

    std::set<std::string> vmNames;
    std::set<uint32_t> vmIds;
};

#endif // NETWORKMANAGER_H
