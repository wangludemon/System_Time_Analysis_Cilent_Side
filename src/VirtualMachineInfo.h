#ifndef VIRTUALMACHINEINFO_H
#define VIRTUALMACHINEINFO_H

#include <QString>
#include <QVariantList>

struct VirtualMachineInfo {
    Q_GADGET
    Q_PROPERTY(int id READ getId WRITE setId)
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(QString floor READ getFloor WRITE setFloor)
    Q_PROPERTY(QString iconName READ getIconName WRITE setIconName)
    Q_PROPERTY(int active READ getActive WRITE setActive)
    Q_PROPERTY(int cpuNum READ getCpuNum WRITE setCpuNum)
    Q_PROPERTY(QString cpuID READ getCpuID WRITE setCpuID)
    Q_PROPERTY(QString memory READ getMemory WRITE setMemory)
    Q_PROPERTY(QString supportDevice READ getSupportDevice WRITE setSupportDevice)
    Q_PROPERTY(QString type READ getType WRITE setType)
    Q_PROPERTY(QString vmState READ getVmState WRITE setVmState)
    Q_PROPERTY(QString belongOS READ getBelongOS WRITE setBelongOS)

public:
    VirtualMachineInfo(): id(0), name(""), floor(""), iconName(""), active(1),cpuNum(0), cpuID(""), memory(""), supportDevice(""), type(""),vmState(""),belongOS("") {}
    VirtualMachineInfo(const int id, const QString name, const QString floor, const QString iconName, const int active, const int cpuNum,
                       const QString cpuID, const QString memory,const QString supportDevice,const QString type,const QString vmState,const QString belongOS):
        name(name), floor(floor), iconName(iconName), active(active), cpuNum(cpuNum), cpuID(cpuID), memory(memory), supportDevice(supportDevice), vmState(vmState), belongOS(belongOS){}
    int getId() const {return id;}
    void setId(const int id) {this->id = id;}

    QString getName() const { return name; }
    void setName(const QString &name) { this->name = name; }

    QString getFloor() const { return floor; }
    void setFloor(const QString &floor) { this->floor = floor; }

    QString getIconName() const { return iconName; }
    void setIconName(const QString &iconName) { this->iconName = iconName; }

    int getActive() const {return active;}
    void setActive(const int active) {this->active = active;}

    int getCpuNum() const {return cpuNum;}
    void setCpuNum(const int cpuNum) {this->cpuNum = cpuNum;}

    QString getCpuID() const { return cpuID; }
    void setCpuID(const QString &cpuID) { this->cpuID = cpuID; }

    QString getMemory() const { return memory; }
    void setMemory(const QString &memory) { this->memory = memory; }

    QString getSupportDevice() const { return supportDevice; }
    void setSupportDevice(const QString &supportDevice) { this->supportDevice = supportDevice; }

    QString getType() const { return type; }
    void setType(const QString &type) { this->type = type; }

    QString getVmState() const { return vmState; }
    void setVmState(const QString &vmState) { this->vmState = vmState; }

    QString getBelongOS() const { return belongOS; }
    void setBelongOS(const QString &belongOS) { this->belongOS = belongOS; }

private:
    int id;
    QString name;
    QString floor;
    QString iconName;
    int active;
    int cpuNum;
    QString cpuID;
    QString memory;
    QString supportDevice;
    QString type;
    QString vmState;
    QString belongOS;
};

Q_DECLARE_METATYPE(VirtualMachineInfo)

#endif // VIRTUALMACHINEINFO_H
