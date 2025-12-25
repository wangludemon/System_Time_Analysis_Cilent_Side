
#include <iostream>
#include <string>
#include <set>
#include <grpcpp/grpcpp.h>
#include "NetworkManager.h"
#include "RustShyperInfo.h"
#include "shyper.grpc.pb.h"

using grpc::CreateChannel;
using grpc::InsecureChannelCredentials;
using namespace shyper;

NetworkManager::NetworkManager(QObject *parent)
    : QObject(parent)
{
    irqDeviceMap[23] = "ARM-PMU";
    irqDeviceMap[26] = "arch-timer";
    irqDeviceMap[105] = "dmc";
    irqDeviceMap[118] = "dma-controller";
    irqDeviceMap[124] = "gpu";
    irqDeviceMap[201] = "hdmi";
    irqDeviceMap[265] = "网口eth0";
    irqDeviceMap[349] = "i2c";
    irqDeviceMap[365] = "串口uart";
    irqDeviceMap[423] = "usb";

    vmIconNameMap["openEuler"] = "openEuler.svg";
    vmIconNameMap["Zephyr"] = "Zephyr.svg";
    vmIconNameMap["Ubuntu"] = "ubuntu.svg";
    vmIconNameMap["Sylix"] = "sylix.svg";
    vmIconNameMap["ArceOS"] = "ArceOS.svg";
    vmIconNameMap["Linux"] = "linux.svg";
}

void NetworkManager::connectToServer(const QString &ipAddress)
{
    // 这里添加实际的网络连接逻辑
    qDebug() << "Attempting to connect to IP:" << ipAddress;
    QString errorMsg = "Connection timed out"; // 替换为具体的错误信息
    bool connectResult;

    // 示例：简单的IP地址格式验证
    QRegularExpression ipRegex("^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$");
    QRegularExpressionMatch match = ipRegex.match(ipAddress);
    if (match.hasMatch()) {
        qDebug() << "IP address format is valid. Proceeding with connection...";

        connectResult = connectGrpc(ipAddress.toStdString());

        if (connectResult) {
            emit connectionSuccess(); // 发出成功信号
        } else {
            emit connectionFailed(errorMsg); // 发出失败信号，可携带错误信息
        }
    } else {
        qDebug() << "Invalid IP address format!";
        errorMsg = "Invalid IP address format!";
        emit connectionFailed(errorMsg);
    }
}

void NetworkManager::processGrpcReply(SnapshotReply& reply)
{
    uint32_t snapshot_size = reply.snapshot_size();
    uint32_t vm_num = reply.vm_num();
    const auto& vms = reply.vms();
    HypervisorInfo hypervisorInfo= reply.hypervisor();
    qDebug() << "gRPC says:\n";
    qDebug() << "snapshot_size:" << QString::fromStdString(std::to_string(snapshot_size)) << "\n";
    qDebug() << "vm_num:" << QString::fromStdString(std::to_string(vm_num)) << "\n";
    qDebug() << "vms size:" << QString::fromStdString(std::to_string(vms.size())) << "\n";

    deviceInfoList.clear();
    
    string vmName;
    int deviceId = 0;
    int usedCpu = 0;
    uint32_t cpuBitMap;
    uint64_t usedMem = 0;
    for (int i = 0; i < vms.size(); ++i) {
        VirtualMachineInfo *virtualMachineInfo;
        if (vmIds.count(vms[i].id()) <= 0) {
            vmName = vms[i].name();
            int j = 0;
            while(vmNames.count(vmName)>0) {
                vmName = vms[i].name() + std::to_string(j++);
            }
            vmNames.insert(vmName);
            virtualMachineInfo = new VirtualMachineInfo;
            virtualMachineInfo->setId(vms[i].id());
            virtualMachineInfo->setName(QString::fromStdString(vmName));
        } else {
            qDebug() << "vms data"<< i <<"; count > 0; \n" ;
            for(int j = 0; j < virtualMachineInfoList.size(); j++) {
                if (virtualMachineInfoList[j].getId() == vms[i].id()) {
                    virtualMachineInfo = &virtualMachineInfoList[j];
                    break;
                }
            }
        }

        if(i == 0) {
            virtualMachineInfo->setFloor(QString::fromStdString("管理虚拟机"));
            virtualMachineInfo->setType(QString::fromStdString("管理虚拟机"));
        } else {
            virtualMachineInfo->setFloor(QString::fromStdString("通用虚拟机"));
            virtualMachineInfo->setType(QString::fromStdString("通用虚拟机"));
        }

        if(vmIconNameMap.find(vms[i].name()) != vmIconNameMap.end()) {
            virtualMachineInfo->setIconName(QString::fromStdString(vmIconNameMap[vms[i].name()]));
        } else {
            qDebug() << "failed to find the iconName of vm: " << vms[i].name();
        }
        virtualMachineInfo->setActive(1);

        int currVmCpuNum = 0;
        cpuBitMap = vms[i].allocate_bitmap();

        string cpuBitMapStr = cpuBitMap ? std::string(std::bitset<32>(cpuBitMap).to_string().substr(
            std::bitset<32>(cpuBitMap).to_string().find('1'))) : "0";
        virtualMachineInfo->setCpuID(QString::fromStdString(cpuBitMapStr));


        while(cpuBitMap != 0) {
            usedCpu += (cpuBitMap&1);
            currVmCpuNum += (cpuBitMap&1);
            cpuBitMap>>=1;
        }
        virtualMachineInfo->setCpuNum(currVmCpuNum);
        qDebug() << virtualMachineInfo->getName() << " currVmCpuNum = " << currVmCpuNum << " ;";

        uint64_t currVmMem = 0;
        const auto& phyMem = vms[i].phy_mem();
        for (int k = 0; k < phyMem.size(); ++k) {
            usedMem += phyMem[k].pa_length();
            currVmMem += phyMem[k].pa_length();
        }

        if ((currVmMem/1024/1024/1024) >= 1) {
            virtualMachineInfo->setMemory(QString::fromStdString(std::to_string(currVmMem/1024/1024/1024.0).append(" GB")));
        } else {
            virtualMachineInfo->setMemory(QString::fromStdString(std::to_string(currVmMem/1024/1024).append(" MB")));
        }

        string currVmSupportDevice = "";
        const auto& pt_irqs = vms[i].pt_irqs();
        for (int k = 0; k < pt_irqs.size(); ++k) {
            if (irqDeviceMap.find(pt_irqs[k]) != irqDeviceMap.end()) {
                DeviceInfo device;
                device.setId(deviceId++);
                device.setName(QString::fromStdString(irqDeviceMap[pt_irqs[k]]));
                device.setStatus(QString::fromStdString("就绪(READY)"));
                device.setBelongOS(virtualMachineInfo->getName());
                deviceInfoList.append(device);
                if (currVmSupportDevice != "") {
                    currVmSupportDevice.append(",");
                }
                currVmSupportDevice.append(irqDeviceMap[pt_irqs[k]]);
            }
        }

        virtualMachineInfo->setSupportDevice(QString::fromStdString(currVmSupportDevice));
        virtualMachineInfo->setVmState(QString::fromStdString("running"));
        virtualMachineInfo->setBelongOS(QString::fromStdString(vms[i].name()));

        if (vmIds.count(vms[i].id()) <= 0) {
            virtualMachineInfoList.append(*virtualMachineInfo);
            vmIds.insert(vms[i].id());
        }
    }

    qDebug() << "hypervisorInfo:" << QString::fromStdString(hypervisorInfo.DebugString()) << "\n";
    const auto&  mem_regions = hypervisorInfo.mem_regions();
    uint64_t memTotalSize = 0;
    for (int i = 0; i < mem_regions.size(); ++i) {
        memTotalSize+=mem_regions[i].size();
    }
    qDebug() << "memTotalSize:" << QString::fromStdString(std::to_string(memTotalSize)) <<"; " << QString::fromStdString(std::to_string(memTotalSize/1024/1024/1024.0)) << "GB\n";


    string cpuInfo = "CPU核心数：";
    string memInfo = "内存大小：";
    rustShyperInfo.setCpuUtilizationRate((usedCpu*100)/hypervisorInfo.phys_cpu_num());
    rustShyperInfo.setMemUtilizationRate((usedMem*100)/memTotalSize);
    rustShyperInfo.setDeviceInfoList(deviceInfoList);
    rustShyperInfo.setVirtualMachineInfoList(virtualMachineInfoList);
    rustShyperInfo.setBoard(QString::fromStdString("开发板：ROC_RK3588s_PC"));
    rustShyperInfo.setCpuInfo(QString::fromStdString(cpuInfo.append(std::to_string(hypervisorInfo.phys_cpu_num())).append("(CORTEX_A55, CORTEX_A76)")));
    rustShyperInfo.setMemoryInfo(QString::fromStdString(memInfo.append(std::to_string(memTotalSize/1024/1024/1024.0)).append(" GB")));
    qDebug() << "about to emit rustShyperInfoUpdate, DeviceInfoList length:" << deviceInfoList.length() << "; usedCpu:" << usedCpu << "; CpuUtilizationRate:" << rustShyperInfo.getCpuUtilizationRate() << "; usedMem:" << usedMem << "; MemUtilizationRate:" << rustShyperInfo.getMemUtilizationRate();
    emit rustShyperInfoUpdate(rustShyperInfo);
}

void NetworkManager::vmOperate(const int vmId, const QString &operateType)
{
    qDebug() << "in NetworkManager::vmOperate; vmId:"<< vmId << "; operateType = " << operateType;
    VirtualMachineInfo *virtualMachineInfo = NULL;
    for(int j = 0; j < virtualMachineInfoList.size(); j++) {
        if (virtualMachineInfoList[j].getId() == vmId) {
            virtualMachineInfo = &virtualMachineInfoList[j];
            break;
        }
    }

    if (virtualMachineInfo == NULL) {
        qDebug() << "in NetworkManager::vmOperate; virtualMachineInfo == NULL";
        return;
    }

    if((virtualMachineInfo->getVmState() == "running") && (operateType == "start")) {
        qDebug() << "in NetworkManager::vmOperate; vm is open operating, no need start";
        return;
    } else if((virtualMachineInfo->getVmState() == "removed") && (operateType == "remove")) {
        qDebug() << "in NetworkManager::vmOperate; vm has being removed, no need remove";
        return;
    }

    VmActionRequest req;
    req.set_vm_id(vmId);
    if(operateType == "start") {
        req.set_action(ACTION_BOOT);
    } else if(operateType == "remove") {
        req.set_action(ACTION_REMOVE);
    } else {
        qDebug() << "in NetworkManager::vmOperate; unknow operate:" << operateType;
    }

    grpc::ClientContext ctx;
    VmActionReply reply;
    stub->VmAction(&ctx, req, &reply);

    if (reply.success()) {
        qDebug() << "in NetworkManager::vmOperate; reply.success; vm_id:" << reply.vm_id();
        virtualMachineInfo->setId(reply.vm_id());
        if (operateType == "start") {
            virtualMachineInfo->setVmState(QString::fromStdString("running"));
        } else if(operateType == "remove") {
            virtualMachineInfo->setVmState(QString::fromStdString("removed"));
        }

        vmIds.erase(vmId);
        vmIds.insert(reply.vm_id());
        emit vmOperateSuccess(vmId, reply.vm_id(), operateType);
    } else {
        qDebug() << "in NetworkManager::vmOperate; reply failed!" ;
        emit vmOperateFailed(vmId, reply.vm_id(), operateType);
    }
}

void NetworkManager::createVm(const QString &vmName, const QString &osType, int cpuCores, qint64 memorySize)
{
    qDebug() << "in NetworkManager::createVm; vmName:" << vmName << "; osType:" << osType 
             << "; cpuCpus:" << cpuCores << "; memorySize:" << memorySize;

    // 检查stub是否已初始化
    if (!stub) {
        qDebug() << "Error: stub is not initialized. Please connect to server first.";
        emit createVmFailed("网络连接未建立，请先连接服务器");
        return;
    }

    CreateVmRequest req;
    
    try {
        std::string vmNameStr = vmName.toUtf8().constData();
        req.set_vm_name(vmNameStr);
    } catch (const std::exception& e) {
        qDebug() << "Error converting vmName to std::string:" << e.what();
        emit createVmFailed(QString("虚拟机名称转换失败: %1").arg(e.what()));
        return;
    }
    
    try {
        std::string osTypeStr = osType.toUtf8().constData();
        req.set_os_type(osTypeStr);
    } catch (const std::exception& e) {
        qDebug() << "Error converting osType to std::string:" << e.what();
        emit createVmFailed(QString("操作系统类型转换失败: %1").arg(e.what()));
        return;
    }
    
    req.set_cpu_cores(cpuCores);
    req.set_memory_size(memorySize);

    grpc::ClientContext ctx;
    CreateVmReply reply;
    grpc::Status status = stub->CreateVm(&ctx, req, &reply);

    if (status.ok() && reply.success()) {
        qDebug() << "in NetworkManager::createVm; reply.success; vm_id:" << reply.vm_info().id();
        // 将VmInfo转换为VirtualMachineInfo
        VirtualMachineInfo newVmInfo;
        newVmInfo.setId(reply.vm_info().id());
        newVmInfo.setName(QString::fromStdString(reply.vm_info().name()));
        newVmInfo.setType(QString::fromStdString(reply.vm_info().vm_type()));
        newVmInfo.setVmState(QString::fromStdString(reply.vm_info().vm_state()));
        newVmInfo.setBelongOS(QString::fromStdString(reply.vm_info().vm_type()));
        // 可以根据需要设置更多属性
        
        emit createVmSuccess(newVmInfo);
    } else {
        QString errorMsg;
        if (!status.ok()) {
            errorMsg = QString("gRPC调用失败: %1").arg(QString::fromStdString(status.error_message()));
        } else {
            errorMsg = QString::fromStdString(reply.error_message());
        }
        qDebug() << "in NetworkManager::createVm; call failed! Error:" << errorMsg;
        emit createVmFailed(errorMsg);
    }
}



bool NetworkManager::connectGrpc(string ip)
{
    ip.append(":50051");
    // 创建 gRPC 通道
    auto channel = CreateChannel(ip, InsecureChannelCredentials());
    stub = ShyperService::NewStub(channel);

    // 构造请求
    SnapshotRequest req;

    SnapshotReply reply;
    grpc::ClientContext ctx;
    grpc::Status status = stub->GetSnapshot(&ctx, req, &reply);

    if (status.ok()) {
        processGrpcReply(reply);
        return true;
    } else {
        qDebug() << "RPC failed:" << status.error_message();
        return false;
    }
    return true;
}
