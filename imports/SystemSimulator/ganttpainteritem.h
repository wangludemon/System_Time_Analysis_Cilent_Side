#ifndef GANTTPAINTERITEM_H
#define GANTTPAINTERITEM_H

#include <QQuickPaintedItem>
#include <QPainter>
#include <QJsonArray>
#include <QJsonObject>

class GanttPainterItem : public QQuickPaintedItem
{
    Q_OBJECT
    //QML_ELEMENT
    QML_NAMED_ELEMENT(GanttPainter)

    Q_PROPERTY(QJsonArray taskList READ taskList WRITE setTaskList NOTIFY taskListChanged)
    Q_PROPERTY(double switchTime READ switchTime WRITE setSwitchTime NOTIFY switchTimeChanged)
    Q_PROPERTY(int contentWidth READ contentWidth NOTIFY contentWidthChanged)

    // === 新增：控制是否显示文字标签 ===
    Q_PROPERTY(bool showLabels READ showLabels WRITE setShowLabels NOTIFY showLabelsChanged)


public:
    explicit GanttPainterItem(QQuickItem *parent = nullptr);
    void paint(QPainter *painter) override;

    QJsonArray taskList() const;
    void setTaskList(const QJsonArray &newTaskList);

    double switchTime() const;
    void setSwitchTime(double newSwitchTime);

    int contentWidth() const { return m_contentWidth; }

    // === 新增 Getter/Setter ===
    bool showLabels() const { return m_showLabels; }
    void setShowLabels(bool show);

signals:
    void taskListChanged();
    void switchTimeChanged();
    void contentWidthChanged();
    void showLabelsChanged(); // 新信号

private:
    QJsonArray m_taskList;
    double m_switchTime = -1;
    int m_contentWidth = 1000;

    bool m_showLabels = true; // 默认显示

    QBrush getBrushForState(const QString &state);
    void drawSymbol(QPainter *painter, int x, int y, const QString &type, int resourceId);
    void updateContentWidth();
};

#endif // GANTTPAINTERITEM_H
