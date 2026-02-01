#include "rtaclient.h"
#include <QDebug>

RtaClient::RtaClient(QObject *parent) : QObject{parent}
{
    m_manager = new QNetworkAccessManager(this);
    connect(m_manager, &QNetworkAccessManager::finished, this, &RtaClient::onReplyFinished);
}

void RtaClient::generateSystem()
{
    QJsonObject json;
    json["coreCount"] = m_coreCount;
    json["taskNum"] = m_taskNum;
    json["utilization"] = m_utilization;
    json["periodMin"] = m_periodMin;
    json["periodMax"] = m_periodMax;
    json["resourceNum"] = m_resourceNum;
    json["rsf"] = m_rsf;
    json["maxAccess"] = m_maxAccess;
    json["cslMin"] = m_cslMin;
    json["cslMax"] = m_cslMax;
    json["allocation"] = m_allocation;
    json["priority"] = m_priority;

    // 根据你的 Controller 路径
    QNetworkRequest request(QUrl(m_baseUrl + "/rta/generateSystem"));
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    qDebug() << "Generating System params:" << json;
    m_manager->post(request, QJsonDocument(json).toJson());
}

void RtaClient::onReplyFinished(QNetworkReply *reply)
{
    if (reply->error() != QNetworkReply::NoError) {
        emit requestFinished(false, "Network Error: " + reply->errorString());
        reply->deleteLater();
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
    QJsonObject root = doc.object();

    // 更新任务列表
    if (root.contains("tasks")) {
        m_tasks = root["tasks"].toArray();
    } else {
        m_tasks = QJsonArray();
    }

    // 更新资源列表
    if (root.contains("resources")) {
        m_resources = root["resources"].toArray();
    } else {
        m_resources = QJsonArray();
    }

    qDebug() << "System Generated. Tasks:" << m_tasks.size() << "Resources:" << m_resources.size();

    emit dataChanged();
    emit requestFinished(true, "Success");
    reply->deleteLater();
}

void RtaClient::analyze(const QString &method, const QString &systemMode) {
    // POST http://127.0.0.1:8080/api/rta/analyze
    QUrl url(m_baseUrl + "/rta/analyze");

    QNetworkRequest req(url);
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject body;
    body["method"] = method;
    body["systemMode"] = systemMode;

    QNetworkReply *reply = m_mgr.post(req, QJsonDocument(body).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        const int httpCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
        const QByteArray bytes = reply->readAll();

        if (reply->error() != QNetworkReply::NoError) {
            emit analysisFinished(false, QString("HTTP %1: %2").arg(httpCode).arg(reply->errorString()));
            reply->deleteLater();
            return;
        }

        QJsonParseError err;
        QJsonDocument doc = QJsonDocument::fromJson(bytes, &err);
        if (err.error != QJsonParseError::NoError || !doc.isObject()) {
            emit analysisFinished(false, "Invalid JSON response");
            reply->deleteLater();
            return;
        }

        QJsonObject root = doc.object();

        // meta
        m_analysisMethod = root.value("method").toString();
        m_analysisSystemMode = root.value("systemMode").toString();
        m_analysisReason = root.value("reason").toString();
        emit analysisMetaChanged();

        // schedulable
        m_analysisSchedulable = root.value("schedulable").toBool(false);
        emit analysisSchedulableChanged();

        // results
        m_analysisResults.clear();
        QJsonArray arr = root.value("results").toArray();
        for (const QJsonValue &v : arr) {
            if (v.isObject()) m_analysisResults.append(v.toObject().toVariantMap());
        }
        emit analysisResultsChanged();

        emit analysisFinished(true, "OK");
        reply->deleteLater();
    });
}
