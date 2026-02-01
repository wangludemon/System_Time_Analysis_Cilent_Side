#include "ganttpainteritem.h"
#include <QPen>
#include <QBrush>
#include <QFontMetrics>

GanttPainterItem::GanttPainterItem(QQuickItem *parent)
    : QQuickPaintedItem(parent)
{
    setAntialiasing(true);
    setRenderTarget(QQuickPaintedItem::FramebufferObject);

    // === 关键修复：强制默认为 true，防止一开始不显示 ===
    m_showLabels = true;
}

void GanttPainterItem::paint(QPainter *painter)
{
    const int ROW_HEIGHT = 80;
    const int HEADER_HEIGHT = 40;
    const int UNIT_WIDTH = 80;
    const int BLOCK_HEIGHT = 40;
    const int BLOCK_OFFSET_Y = 40;

    int timeLen = 30;
    // 1. 获取时间轴长度
    if (!m_taskList.isEmpty()) {
        QJsonObject firstItem = m_taskList[0].toObject();
        if (firstItem.contains("taskGanttInformation")) {
            timeLen = firstItem["taskGanttInformation"].toObject()["timeAxisLength"].toInt();
        } else if (firstItem.contains("timeAxisLength")) {
            timeLen = firstItem["timeAxisLength"].toInt();
        }
    }

    // 2. 宽度自适应计算
    for (const auto &rowRef : m_taskList) {
        QJsonObject ganttInfo = rowRef.toObject();
        if (rowRef.toObject().contains("taskGanttInformation")) {
            ganttInfo = rowRef.toObject()["taskGanttInformation"].toObject();
        }
        QJsonArray events = ganttInfo["eventInformations"].toArray();
        for (const auto &e : events) {
            double end = e.toObject()["endTime"].toDouble();
            if (end > timeLen) timeLen = (int)end + 2;
        }
    }
    if (timeLen < 20) timeLen = 20;

    // --- 绘制背景网格和时间轴 ---
    painter->setFont(QFont("Arial", 14, QFont::Bold));
    for (int t = 0; t <= timeLen; ++t) {
        int x = t * UNIT_WIDTH;
        painter->setPen(QPen(QColor(208, 211, 212), 1));
        painter->drawLine(x, 0, x, height());

        if (t < timeLen) {
            QRect textRect(x, 0, UNIT_WIDTH, HEADER_HEIGHT);
            painter->setPen(QPen(QColor(208, 211, 212)));
            painter->drawText(textRect, Qt::AlignCenter, QString::number(t));
        }
    }

    painter->setPen(QPen(QColor(208, 211, 212), 2));
    painter->drawLine(0, HEADER_HEIGHT, width(), HEADER_HEIGHT);

    // --- 绘制任务行 ---
    // --- 绘制每一行任务 ---
    for (int i = 0; i < m_taskList.size(); ++i) {
        int rowTopY = HEADER_HEIGHT + i * ROW_HEIGHT;
        int rowBottomY = rowTopY + ROW_HEIGHT;

        // 1. 绘制行底部分割线
        painter->setPen(QPen(QColor(208, 211, 212), 2));
        painter->drawLine(0, rowBottomY, width(), rowBottomY);

        // 2. 获取当前行的数据对象
        QJsonObject taskRow = m_taskList[i].toObject();

        // === 关键修复：从行对象(Row)中提取 ID，而不是从事件中提取 ===
        int staticPid = -1;
        int dynamicPid = -1;

        if (taskRow.contains("staticPid")) {
            staticPid = taskRow["staticPid"].toInt();
        }
        if (taskRow.contains("dynamicPid")) {
            dynamicPid = taskRow["dynamicPid"].toInt();
        }

        // 3. 深入获取甘特图具体信息
        QJsonObject ganttInfo = taskRow;
        if (taskRow.contains("taskGanttInformation")) {
            ganttInfo = taskRow["taskGanttInformation"].toObject();
        }

        // 4. 绘制色块 (Event Blocks)
        QJsonArray events = ganttInfo["eventInformations"].toArray();
        for (const auto &eRef : events) {
            QJsonObject e = eRef.toObject();
            QString state = e["state"].toString();
            qDebug() << "State found:" << state;
            if (state == "spare" || state == "blocked") {
                continue; // 遇到等待状态，直接跳过不画 -> 变为空白
            }

            double start = e["startTime"].toDouble();
            double end = e["endTime"].toDouble();


            QRectF rect(start * UNIT_WIDTH, rowTopY + BLOCK_OFFSET_Y, (end - start) * UNIT_WIDTH, BLOCK_HEIGHT);

            painter->setPen(QPen(Qt::black, 2));
            painter->setBrush(getBrushForState(state));
            painter->drawRect(rect);

            if (state == "access-resource") {
                // 计算持续了几个单位时间 (例如 end=5, start=2 -> duration=3)
                // 这里假设时间都是整数。如果涉及小数，int转换会自动向下取整
                int duration = static_cast<int>(end - start);

                // 循环每一个单位时间
                for (int k = 0; k < duration; ++k) {
                    // 计算当前这一格的左边界 X 坐标
                    double unitX = rect.left() + k * UNIT_WIDTH;

                    // 画一条线：从当前格子的左上角 -> 当前格子的右下角
                    // 起点: (unitX, rect.top())
                    // 终点: (unitX + UNIT_WIDTH, rect.bottom())
                    painter->drawLine(
                        QPointF(unitX, rect.top()),
                        QPointF(unitX + UNIT_WIDTH, rect.bottom())
                        );
                }
            }


            // === 5. 绘制文字 (使用刚才从行对象提取的 staticPid) ===
            if (m_showLabels) {
                painter->setPen(Qt::black);

                QString label = "";

                // 1. 先拼 Task ID (T0, T1...)
                if (staticPid != -1) {
                    label += "Task" + QString::number(staticPid);
                } else if (e.contains("staticPid")) {
                    label += "Task" + QString::number(e["staticPid"].toInt());
                }

                // 2. 再拼 Job ID (J0, J1...) -> 这就是你强调的 sequence
                // if (dynamicPid != -1) {
                //     // 如果前面有 Task ID，加个短横线分隔
                //     if (!label.isEmpty()) label += "\n";
                //     label += "Job" + QString::number(dynamicPid);
                // } else if (e.contains("dynamicPid")) {
                //     if (!label.isEmpty()) label += "\n";
                //     label += "Job" + QString::number(e["dynamicPid"].toInt());
                // }

                // 3. 绘制文字 (居中)
                // 如果没有 ID，就不画
                if (!label.isEmpty()) {
                    painter->drawText(rect, Qt::AlignCenter, label);
                }
            }
        }

        // 5. 绘制符号 (Release, Deadline 等)
        QJsonArray points = ganttInfo["eventTimePoints"].toArray();
        for (const auto &pRef : points) {
            QJsonObject p = pRef.toObject();
            QString type = p["event"].toString();
            double time = p["eventTime"].toDouble();

            int resId = -1;
            if (p.contains("resourceId")) {
                resId = p["resourceId"].toInt();
            }

            drawSymbol(painter, time * UNIT_WIDTH, rowTopY, type, resId);
        }
    }

    // 绘制红线
    if (m_switchTime != -1) {
        double x = m_switchTime * UNIT_WIDTH;
        painter->setPen(QPen(Qt::red, 4));
        painter->drawLine(x, 0, x, height());
        painter->setBrush(Qt::red);
        painter->setPen(Qt::NoPen);
        painter->drawEllipse(QPointF(x, height() - 10), 8, 8);
    }
}

// === Setter 实现 ===
void GanttPainterItem::setShowLabels(bool show) {
    if (m_showLabels == show) return;
    m_showLabels = show;
    emit showLabelsChanged();
    update(); // 触发重绘
}

// === 更新内容宽度 ===
void GanttPainterItem::updateContentWidth()
{
    int maxTime = 20;
    for (const auto &rowRef : m_taskList) {
        QJsonObject ganttInfo = rowRef.toObject();
        if (rowRef.toObject().contains("taskGanttInformation")) {
            ganttInfo = rowRef.toObject()["taskGanttInformation"].toObject();
        }
        if (ganttInfo.contains("timeAxisLength")) {
            int len = ganttInfo["timeAxisLength"].toInt();
            if (len > maxTime) maxTime = len;
        }
        QJsonArray events = ganttInfo["eventInformations"].toArray();
        for (const auto &e : events) {
            double end = e.toObject()["endTime"].toDouble();
            if (end > maxTime) maxTime = (int)end;
        }
    }
    int newWidth = maxTime * 80 + 200;
    if (m_contentWidth != newWidth) {
        m_contentWidth = newWidth;
        emit contentWidthChanged();
    }
}

// 其他函数保持不变
void GanttPainterItem::setTaskList(const QJsonArray &newTaskList) {
    if (m_taskList == newTaskList) return;
    m_taskList = newTaskList;
    updateContentWidth();
    emit taskListChanged();
    update();
}

void GanttPainterItem::setSwitchTime(double newSwitchTime) {
    if (qFuzzyCompare(m_switchTime, newSwitchTime)) return;
    m_switchTime = newSwitchTime;
    emit switchTimeChanged();
    update();
}

QJsonArray GanttPainterItem::taskList() const { return m_taskList; }
double GanttPainterItem::switchTime() const { return m_switchTime; }

QBrush GanttPainterItem::getBrushForState(const QString &state) {
    if (state == "normal-execution") return Qt::white;
    if (state == "help-access-resource" || state == "help-direct-spinning") return QColor(202, 249, 160);
    if (state == "withdraw") return QColor(0, 163, 255);
    if (state == "access-resource") return Qt::white;  //Qt::FDiagPattern;
    if (state == "direct-spinning" || state == "spinning") return Qt::BDiagPattern;  // return Qt::Dense6Pattern;
    if (state == "indirect-spinning") return Qt::VerPattern;
    if (state == "arrival-blocking") return Qt::HorPattern;
    return Qt::white;
}

void GanttPainterItem::drawSymbol(QPainter *painter, int x, int y, const QString &type, int resourceId) {
    painter->save();
    painter->translate(x - 20, y);
    QPen blackPen(Qt::black, 3);
    painter->setPen(blackPen);

    if (type == "locked") {
        painter->drawLine(20, 30, 20, 80); painter->setBrush(Qt::black); painter->drawEllipse(QPoint(20, 20), 10, 10);
        if (resourceId != -1) {
            // 字体稍微小一点，画在圆圈的右上方
            QFont f = painter->font();
            f.setPixelSize(17);
            f.setBold(true);
            painter->setFont(f);
            painter->setPen(Qt::black); // 黑色文字

            // 坐标 (35, 25) 大概在圆圈的右侧
            painter->drawText(35, 25, "r" + QString::number(resourceId));
        }
    } else if (type == "unlocked") {
        painter->drawLine(20, 30, 20, 80); painter->setBrush(Qt::NoBrush); painter->drawEllipse(QPoint(20, 20), 10, 10);
    } else if (type == "locked-attempt") {
        painter->drawLine(20, 30, 20, 80); painter->setBrush(Qt::black); painter->drawPie(10, 10, 20, 20, 90 * 16, 180 * 16); painter->setBrush(Qt::NoBrush); painter->drawArc(10, 10, 20, 20, 0, 360 * 16);
    } else if (type == "release") {
        QPolygon triangle; triangle << QPoint(20, 10) << QPoint(10, 30) << QPoint(30, 30); painter->setBrush(Qt::black); painter->drawPolygon(triangle); painter->drawLine(20, 30, 20, 80);
    } else if (type == "completion") {
        painter->drawLine(20, 20, 20, 80); painter->drawLine(10, 20, 30, 20);
    } else if (type == "switch-task") {
        painter->setPen(QPen(QColor(0, 185, 255), 3)); painter->drawLine(20, 0, 20, 80);
    } else if (type == "killed") {
        painter->setPen(QPen(QColor(255, 208, 0), 4)); painter->drawLine(20, 20, 20, 80); painter->drawLine(10, 10, 30, 30); painter->drawLine(10, 30, 30, 10);
    } else if (type == "criticality-switch") {
        painter->setBrush(Qt::red); painter->setPen(Qt::NoPen); painter->drawEllipse(QPoint(20, 40), 10, 10);
    }
    painter->restore();
}
