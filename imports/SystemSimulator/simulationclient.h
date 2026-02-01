#ifndef SIMULATIONCLIENT_H
#define SIMULATIONCLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QQmlEngine>

class SimulationClient : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    // === 数据展示属性 ===
    Q_PROPERTY(QJsonArray cpuGanttData READ cpuGanttData NOTIFY dataChanged)
    Q_PROPERTY(QJsonArray taskGanttData READ taskGanttData NOTIFY dataChanged)
    Q_PROPERTY(QJsonArray taskTableData READ taskTableData NOTIFY dataChanged)
    Q_PROPERTY(QJsonArray resourceTableData READ resourceTableData NOTIFY dataChanged)

    // === 结果状态属性 ===
    Q_PROPERTY(bool msrpResult READ msrpResult NOTIFY dataChanged)
    Q_PROPERTY(bool mrspResult READ mrspResult NOTIFY dataChanged)
    Q_PROPERTY(bool pwlpResult READ pwlpResult NOTIFY dataChanged)

    // === ✅ 配置参数 ===
    Q_PROPERTY(int cpuCoreCount READ cpuCoreCount WRITE setCpuCoreCount NOTIFY configChanged)
    Q_PROPERTY(int taskNumPerCore READ taskNumPerCore WRITE setTaskNumPerCore NOTIFY configChanged)
    Q_PROPERTY(int minPeriod READ minPeriod WRITE setMinPeriod NOTIFY configChanged)
    Q_PROPERTY(int maxPeriod READ maxPeriod WRITE setMaxPeriod NOTIFY configChanged)
    Q_PROPERTY(int maxAccess READ maxAccess WRITE setMaxAccess NOTIFY configChanged)
    Q_PROPERTY(double resourceRatio READ resourceRatio WRITE setResourceRatio NOTIFY configChanged)

    // --- ✅ 新增：资源类型和资源个数 ---
    Q_PROPERTY(QString resourceType READ resourceType WRITE setResourceType NOTIFY configChanged)
    Q_PROPERTY(QString resourceCount READ resourceCount WRITE setResourceCount NOTIFY configChanged)

    // --- 关键级切换开关 ---
    Q_PROPERTY(bool isCriticalitySwitch READ isCriticalitySwitch WRITE setIsCriticalitySwitch NOTIFY configChanged)
    Q_PROPERTY(bool isAutoSwitch READ isAutoSwitch WRITE setIsAutoSwitch NOTIFY configChanged)

    Q_PROPERTY(QString algorithm READ algorithm WRITE setAlgorithm NOTIFY configChanged)

public:
    explicit SimulationClient(QObject *parent = nullptr);

    // Getters for Data
    QJsonArray cpuGanttData() const { return m_cpuGanttData; }
    QJsonArray taskGanttData() const { return m_taskGanttData; }
    QJsonArray taskTableData() const { return m_taskTableData; }
    QJsonArray resourceTableData() const { return m_resourceTableData; }

    bool msrpResult() const { return m_msrpResult; }
    bool mrspResult() const { return m_mrspResult; }
    bool pwlpResult() const { return m_pwlpResult; }

    // === 配置参数 Setters/Getters ===
    int cpuCoreCount() const { return m_cpuCoreCount; }
    void setCpuCoreCount(int c) { if(m_cpuCoreCount!=c){m_cpuCoreCount=c; emit configChanged();} }

    int taskNumPerCore() const { return m_taskNumPerCore; }
    void setTaskNumPerCore(int n) { if(m_taskNumPerCore!=n){m_taskNumPerCore=n; emit configChanged();} }

    int minPeriod() const { return m_minPeriod; }
    void setMinPeriod(int n) { if(m_minPeriod!=n){m_minPeriod=n; emit configChanged();} }

    int maxPeriod() const { return m_maxPeriod; }
    void setMaxPeriod(int n) { if(m_maxPeriod!=n){m_maxPeriod=n; emit configChanged();} }

    int maxAccess() const { return m_maxAccess; }
    void setMaxAccess(int n) { if(m_maxAccess!=n){m_maxAccess=n; emit configChanged();} }

    double resourceRatio() const { return m_resourceRatio; }
    void setResourceRatio(double d) { if(!qFuzzyCompare(m_resourceRatio, d)){m_resourceRatio=d; emit configChanged();} }

    // --- ✅ 新增 Getter/Setter ---
    QString resourceType() const { return m_resourceType; }
    void setResourceType(const QString &val) { if(m_resourceType!=val){m_resourceType=val; emit configChanged();} }

    QString resourceCount() const { return m_resourceCount; }
    void setResourceCount(const QString &val) { if(m_resourceCount!=val){m_resourceCount=val; emit configChanged();} }

    bool isCriticalitySwitch() const { return m_isCriticalitySwitch; }
    void setIsCriticalitySwitch(bool b) { if(m_isCriticalitySwitch!=b){m_isCriticalitySwitch=b; emit configChanged();} }

    bool isAutoSwitch() const { return m_isAutoSwitch; }
    void setIsAutoSwitch(bool b) { if(m_isAutoSwitch!=b){m_isAutoSwitch=b; emit configChanged();} }

    QString algorithm() const { return m_algorithm; }
    void setAlgorithm(const QString &a) { if(m_algorithm!=a){m_algorithm=a; emit configChanged();} }

    // === 功能函数 ===
    Q_INVOKABLE void sendSimulationRequest();
    Q_INVOKABLE void getProtocolData(QString protocolName);
    Q_INVOKABLE void startSimulation(); // 兼容旧接口

signals:
    void dataChanged();
    void configChanged();
    void errorOccurred(QString errorMsg);

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_manager;

    QJsonArray m_cpuGanttData;
    QJsonArray m_taskGanttData;
    QJsonArray m_taskTableData;
    QJsonArray m_resourceTableData;

    bool m_msrpResult = true;
    bool m_mrspResult = false;
    bool m_pwlpResult = true;

    // === 内部配置变量 (带默认值) ===
    int m_cpuCoreCount = 2;
    int m_taskNumPerCore = 2;
    int m_minPeriod = 10;
    int m_maxPeriod = 1000;
    int m_maxAccess = 2;
    double m_resourceRatio = 0.5;

    // ✅ 新增配置默认值
    QString m_resourceType = "Short Length";
    QString m_resourceCount = "Partitions";

    bool m_isCriticalitySwitch = false;
    bool m_isAutoSwitch = false;
    QString m_algorithm = "MSRP";

    QString m_baseUrl = "http://127.0.0.1:8080/api";  // 配置后端运行地址
};

#endif // SIMULATIONCLIENT_H
