#include "AIController.h"
#include <QVariantMap>
#include <QTimer>

AIController::AIController(QObject *parent) : QObject(parent)
{
}

void AIController::startAdvancedHint(const QVariantList &targetCells, int level)
{
    // level: 1-> آسان، 2-> متوسط، 3-> سخت
    QVariantList sortedCells = targetCells;

    // وزن‌دهی خانه‌ها (weight) برای اولویت Hint
    std::sort(sortedCells.begin(), sortedCells.end(), [](const QVariant &a, const QVariant &b){
        QVariantMap ma = a.toMap(); QVariantMap mb = b.toMap();
        int wa = ma["weight"].toInt(); int wb = mb["weight"].toInt();
        return wa > wb;
    });

    int delay = 0;
    for(const QVariant &v : sortedCells){
        QVariantMap map = v.toMap();
        int x = map["x"].toInt();
        int y = map["y"].toInt();
        int intensity = map["weight"].toInt(); // 1->کم, 3->زیاد
        scheduleCellHint(x, y, intensity, delay);
        delay += 200; // فاصله بین Flash خانه‌ها
    }
}

void AIController::scheduleCellHint(int x, int y, int intensity, int delay)
{
    QTimer::singleShot(delay, [=](){
        emit flashCell(x, y, intensity);
    });

    QTimer::singleShot(delay+300, [=](){
        emit hideHint(x, y);
    });
}
