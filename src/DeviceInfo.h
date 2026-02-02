#ifndef DEVICEINFO_H
#define DEVICEINFO_H

#include <QString>
#include <QVariantList>

struct DeviceInfo {
    Q_GADGET
    Q_PROPERTY(int id READ getId WRITE setId)
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(QString status READ getStatus WRITE setStatus)
    Q_PROPERTY(QString belongOS READ getBelongOS WRITE setBelongOS)

public:
    DeviceInfo(): id(0), name(""), status(""),belongOS("") {}
    DeviceInfo(const int id, const QString name, const QString status,const QString belongOS): name(name), status(status), belongOS(belongOS){}
    int getId() const {return id;}
    void setId(const int id) {this->id = id;}

    QString getName() const { return name; }
    void setName(const QString &name) { this->name = name; }

    QString getStatus() const { return status; }
    void setStatus(const QString &status) { this->status = status; }

    QString getBelongOS() const { return belongOS; }
    void setBelongOS(const QString &belongOS) { this->belongOS = belongOS; }

private:
    int id;
    QString name;
    QString status;
    QString belongOS;
};

Q_DECLARE_METATYPE(DeviceInfo)

#endif // DEVICEINFO_H
