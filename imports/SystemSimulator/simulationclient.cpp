#include "simulationclient.h"
#include <QDebug>
#include <QUrlQuery>
#include <algorithm> // ✅ 必须引入，用于 std::sort

SimulationClient::SimulationClient(QObject *parent)
    : QObject{parent}
{
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, &QNetworkAccessManager::finished, this, &SimulationClient::onReplyFinished);
}

// 兼容旧接口
void SimulationClient::startSimulation()
{
    sendSimulationRequest();
}

// === ✅ 核心修改：发送完整配置参数 ===
void SimulationClient::sendSimulationRequest()
{
    // 1. 构造 JSON 对象
    QJsonObject json;

    // --- 使用配置参数 ---
    json["totalCPUNum"] = m_cpuCoreCount;
    json["numberOfTaskInAPartition"] = m_taskNumPerCore;

    // ✅ 使用新增的配置参数
    json["minPeriod"] = m_minPeriod;
    json["maxPeriod"] = m_maxPeriod;
    json["numberOfMaxAccessToOneResource"] = m_maxAccess;
    json["resourceSharingFactor"] = m_resourceRatio;

    // ✅ 新增参数处理 (转大写以匹配后端 value)
    // Vue 中 value="SHORT LENGTH"，QML 中 text="Short Length"
    json["resourceType"] = m_resourceType.toUpper();
    json["resourceNum"] = m_resourceCount.toUpper();

    // ✅ 关键级切换开关
    json["isStartUpSwitch"] = m_isCriticalitySwitch;

    // 其他固定参数
    json["criticalitySwitchTime"] = -1;
    json["algorithm"] = m_algorithm;

    // 2. 发送请求
    QNetworkRequest request;
    request.setUrl(QUrl( m_baseUrl +"/isSchedulable"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    qDebug() << "Sending Simulation Request with Config:"
             << "Cores:" << m_cpuCoreCount
             << "ResType:" << m_resourceType
             << "ResCount:" << m_resourceCount
             << "Switch:" << m_isCriticalitySwitch;

    m_manager->post(request, QJsonDocument(json).toJson());
}

// === 点击“查看调度信息”或切换Tab时调用 ===
void SimulationClient::getProtocolData(QString protocolName)
{
    QUrl url( m_baseUrl + "/" + protocolName.toLower());

    QUrlQuery query;
    // ✅ 将配置中的开关状态传给后端
    query.addQueryItem("isStartUpSwitch", m_isCriticalitySwitch ? "true" : "false");
    query.addQueryItem("criticalitySwitchTime", "-1");

    url.setQuery(query);

    QNetworkRequest request;
    request.setUrl(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    qDebug() << "Requesting details for protocol:" << protocolName << "Switch:" << m_isCriticalitySwitch;
    m_manager->post(request, QByteArray()); // 发送空 body 的 POST
}

// === 接收回复 (保持原样) ===
void SimulationClient::onReplyFinished(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError) {
        qDebug() << "Network Error:" << reply->errorString();
        emit errorOccurred("Network Error: " + reply->errorString());
        reply->deleteLater();
        return;
    }

    QByteArray responseData = reply->readAll();
    QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
    QJsonObject rootObj = jsonDoc.object();

    // 1. 更新调度结果状态
    if (rootObj.contains("msrpSchedulable")) m_msrpResult = rootObj["msrpSchedulable"].toBool();
    if (rootObj.contains("mrspSchedulable")) m_mrspResult = rootObj["mrspSchedulable"].toBool();
    if (rootObj.contains("pwlpSchedulable")) m_pwlpResult = rootObj["pwlpSchedulable"].toBool();

    // === 获取全局切换时间 ===
    int switchTime = -1;
    if (rootObj.contains("criticalitySwitchTime")) {
        switchTime = rootObj["criticalitySwitchTime"].toInt();
    }

    // 2. 更新 CPU 甘特图 (✅ 新增：注入切换事件)
    if (rootObj.contains("cpuGanttInformations")) {
        QJsonArray rawCpuArray = rootObj["cpuGanttInformations"].toArray();
        QJsonArray finalCpuArray;

        for (const auto &val : rawCpuArray) {
            QJsonObject cpuObj = val.toObject();

            // === ✅ 给 CPU 甘特图注入 Switch 事件 ===
            if (switchTime > 0) {
                if (cpuObj.contains("eventTimePoints")) {
                    QJsonArray eventPoints = cpuObj["eventTimePoints"].toArray();

                    QJsonObject switchEvent;
                    switchEvent["event"] = "criticality-switch"; // 对应 Main.qml 图例
                    switchEvent["eventTime"] = switchTime;
                    switchEvent["staticPid"] = -1;
                    switchEvent["dynamicPid"] = -1;

                    eventPoints.append(switchEvent);
                    cpuObj["eventTimePoints"] = eventPoints;
                }
            }
            finalCpuArray.append(cpuObj);
        }
        m_cpuGanttData = finalCpuArray;
    }

    // 3. 更新 Task 甘特图
    if (rootObj.contains("taskGanttInformations")) {
        QJsonArray rawArray = rootObj["taskGanttInformations"].toArray();
        QList<QJsonObject> sortedList;
        for (const auto &val : rawArray) sortedList.append(val.toObject());

        // 排序 Job ID
        std::sort(sortedList.begin(), sortedList.end(), [](const QJsonObject &a, const QJsonObject &b) {
            return a["dynamicPid"].toInt() < b["dynamicPid"].toInt();
        });

        QJsonArray finalArray;
        for (const auto &obj : sortedList) {
            QJsonObject taskObj = obj;

            // === ✅ 给 Task 甘特图注入 Switch 事件 ===
            if (switchTime > 0) {
                QJsonObject ganttInfo = taskObj["taskGanttInformation"].toObject();
                QJsonArray eventPoints = ganttInfo["eventTimePoints"].toArray();

                QJsonObject switchEvent;
                switchEvent["event"] = "criticality-switch";
                switchEvent["eventTime"] = switchTime;
                switchEvent["staticPid"] = taskObj["staticPid"];
                switchEvent["dynamicPid"] = taskObj["dynamicPid"];

                eventPoints.append(switchEvent);
                ganttInfo["eventTimePoints"] = eventPoints;
                taskObj["taskGanttInformation"] = ganttInfo;
            }
            finalArray.append(taskObj);
        }
        m_taskGanttData = finalArray;
    }

    // 4. 更新表格数据
    if (rootObj.contains("taskInformations")) {
        m_taskTableData = rootObj["taskInformations"].toArray();
    }
    if (rootObj.contains("resourceInformations")) {
        m_resourceTableData = rootObj["resourceInformations"].toArray();
    }

    emit dataChanged();
    reply->deleteLater();
}
