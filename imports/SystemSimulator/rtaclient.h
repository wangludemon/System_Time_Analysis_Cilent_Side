#ifndef RTACLIENT_H
#define RTACLIENT_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
#include <QNetworkReply>
#include <QQmlEngine>

class RtaClient : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    // === 输出数据 (用于右侧表格展示) ===
    Q_PROPERTY(QJsonArray tasks READ tasks NOTIFY dataChanged)
    Q_PROPERTY(QJsonArray resources READ resources NOTIFY dataChanged)

    // === 输入参数 (对应 Spring Boot 的 RtaGenerateRequest) ===
    Q_PROPERTY(int coreCount READ coreCount WRITE setCoreCount NOTIFY paramsChanged)
    Q_PROPERTY(int taskNum READ taskNum WRITE setTaskNum NOTIFY paramsChanged)
    Q_PROPERTY(double utilization READ utilization WRITE setUtilization NOTIFY paramsChanged)

    Q_PROPERTY(int periodMin READ periodMin WRITE setPeriodMin NOTIFY paramsChanged)
    Q_PROPERTY(int periodMax READ periodMax WRITE setPeriodMax NOTIFY paramsChanged)

    Q_PROPERTY(int resourceNum READ resourceNum WRITE setResourceNum NOTIFY paramsChanged)
    Q_PROPERTY(double rsf READ rsf WRITE setRsf NOTIFY paramsChanged)
    Q_PROPERTY(int maxAccess READ maxAccess WRITE setMaxAccess NOTIFY paramsChanged)

    Q_PROPERTY(int cslMin READ cslMin WRITE setCslMin NOTIFY paramsChanged)
    Q_PROPERTY(int cslMax READ cslMax WRITE setCslMax NOTIFY paramsChanged)

    Q_PROPERTY(QString allocation READ allocation WRITE setAllocation NOTIFY paramsChanged)
    Q_PROPERTY(QString priority READ priority WRITE setPriority NOTIFY paramsChanged)

    // rta 结果
    Q_PROPERTY(QVariantList analysisResults READ analysisResults NOTIFY analysisResultsChanged)
    Q_PROPERTY(bool analysisSchedulable READ analysisSchedulable NOTIFY analysisSchedulableChanged)
    Q_PROPERTY(QString analysisMethod READ analysisMethod NOTIFY analysisMetaChanged)
    Q_PROPERTY(QString analysisReason READ analysisReason NOTIFY analysisMetaChanged)
    Q_PROPERTY(QString analysisSystemMode READ analysisSystemMode NOTIFY analysisMetaChanged)

public:
    explicit RtaClient(QObject *parent = nullptr);

    // Getters
    QJsonArray tasks() const { return m_tasks; }
    QJsonArray resources() const { return m_resources; }

    int coreCount() const { return m_coreCount; }
    int taskNum() const { return m_taskNum; }
    double utilization() const { return m_utilization; }
    int periodMin() const { return m_periodMin; }
    int periodMax() const { return m_periodMax; }
    int resourceNum() const { return m_resourceNum; }
    double rsf() const { return m_rsf; }
    int maxAccess() const { return m_maxAccess; }
    int cslMin() const { return m_cslMin; }
    int cslMax() const { return m_cslMax; }
    QString allocation() const { return m_allocation; }
    QString priority() const { return m_priority; }

    QString analysisReason() const { return m_analysisReason; } // ✅ 新增 getter

    // Setters
    void setCoreCount(int v) { if(m_coreCount!=v) { m_coreCount=v; emit paramsChanged(); } }
    void setTaskNum(int v) { if(m_taskNum!=v) { m_taskNum=v; emit paramsChanged(); } }
    void setUtilization(double v) { if(!qFuzzyCompare(m_utilization,v)) { m_utilization=v; emit paramsChanged(); } }
    void setPeriodMin(int v) { if(m_periodMin!=v) { m_periodMin=v; emit paramsChanged(); } }
    void setPeriodMax(int v) { if(m_periodMax!=v) { m_periodMax=v; emit paramsChanged(); } }
    void setResourceNum(int v) { if(m_resourceNum!=v) { m_resourceNum=v; emit paramsChanged(); } }
    void setRsf(double v) { if(!qFuzzyCompare(m_rsf,v)) { m_rsf=v; emit paramsChanged(); } }
    void setMaxAccess(int v) { if(m_maxAccess!=v) { m_maxAccess=v; emit paramsChanged(); } }
    void setCslMin(int v) { if(m_cslMin!=v) { m_cslMin=v; emit paramsChanged(); } }
    void setCslMax(int v) { if(m_cslMax!=v) { m_cslMax=v; emit paramsChanged(); } }
    void setAllocation(QString v) { if(m_allocation!=v) { m_allocation=v; emit paramsChanged(); } }
    void setPriority(QString v) { if(m_priority!=v) { m_priority=v; emit paramsChanged(); } }

    // === 功能函数 ===
    Q_INVOKABLE void generateSystem();

    Q_INVOKABLE void analyze(const QString &method, const QString &systemMode);

    QVariantList analysisResults() const { return m_analysisResults; }
    bool analysisSchedulable() const { return m_analysisSchedulable; }
    QString analysisMethod() const { return m_analysisMethod; }
    QString analysisSystemMode() const { return m_analysisSystemMode; }

signals:
    void dataChanged();
    void paramsChanged();
    void requestFinished(bool success, QString message);

    void analysisFinished(bool success, const QString &msg);

    void analysisResultsChanged();
    void analysisSchedulableChanged();
    void analysisMetaChanged();

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    QNetworkAccessManager *m_manager;

    // Data
    QJsonArray m_tasks;
    QJsonArray m_resources;

    // Default Params (参考 JavaFX 截图中的默认值)
    int m_coreCount = 4;
    int m_taskNum = 16;
    double m_utilization = 2.0;
    int m_periodMin = 1;
    int m_periodMax = 1000;
    int m_resourceNum = 4;
    double m_rsf = 0.3;
    int m_maxAccess = 5;
    int m_cslMin = 1;
    int m_cslMax = 50;
    QString m_allocation = "WF";
    QString m_priority = "DMPO";

    QNetworkAccessManager m_mgr;

    QVariantList m_analysisResults;
    bool m_analysisSchedulable = false;
    QString m_analysisMethod;
    QString m_analysisSystemMode;
    QString m_analysisReason;   // ✅ 新增成员变量

    QString m_baseUrl = "http://127.0.0.1:8080/api"; // 配置后端运行地址
};

#endif // RTACLIENT_H
