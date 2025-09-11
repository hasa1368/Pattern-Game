#include "AIController.h"
#include <QVariantMap>
#include <QTimer>
#include <QDebug>

AIController::AIController(QObject *parent) : QObject(parent)
{
}

void AIController::startAdvancedHint(const QVariantList &targetCells, int level)
{
    // level: 1-> easy (all cells), 2-> medium (weight >= 2), 3-> hard (weight == 3)
    QVariantList sortedCells = targetCells;

    // Sort cells by weight in descending order for hint priority
    std::sort(sortedCells.begin(), sortedCells.end(), [](const QVariant &a, const QVariant &b){
        QVariantMap ma = a.toMap(); QVariantMap mb = b.toMap();
        int wa = ma["weight"].toInt(); int wb = mb["weight"].toInt();
        return wa > wb;
    });

    // Determine number of cells to hint and timing based on level
    int maxHints = 0;
    int flashDuration = 0;
    int delayIncrement = 0;
    switch (level) {
    case 1: // Easy: Hint all cells, longer duration
        maxHints = sortedCells.size();
        flashDuration = 400;
        delayIncrement = 300;
        break;
    case 2: // Medium: Hint cells with weight >= 2
        maxHints = 0;
        for (const QVariant &v : sortedCells) {
            if (v.toMap()["weight"].toInt() >= 2) maxHints++;
        }
        flashDuration = 300;
        delayIncrement = 200;
        break;
    case 3: // Hard: Hint only cells with weight == 3
        maxHints = 0;
        for (const QVariant &v : sortedCells) {
            if (v.toMap()["weight"].toInt() == 3) maxHints++;
        }
        flashDuration = 200;
        delayIncrement = 100;
        break;
    default:
        qWarning() << "Invalid level" << level << ", defaulting to easy";
        maxHints = sortedCells.size();
        flashDuration = 400;
        delayIncrement = 300;
        break;
    }

    // Ensure at least one hint if cells exist
    if (maxHints == 0 && !sortedCells.isEmpty()) {
        maxHints = 1; // Hint at least the highest-weighted cell
    }

    int delay = 0;
    int hintedCells = 0;
    for (const QVariant &v : sortedCells) {
        QVariantMap map = v.toMap();
        int weight = map["weight"].toInt();
        // Skip cells based on level
        if (level == 2 && weight < 2) continue;
        if (level == 3 && weight < 3) continue;

        int x = map["x"].toInt();
        int y = map["y"].toInt();
        int intensity = weight; // 1->low (yellow), 2->medium (orange), 3->high (red)
        scheduleCellHint(x, y, intensity, delay, flashDuration);
        delay += delayIncrement;
        hintedCells++;
        if (hintedCells >= maxHints) break;
    }

    qDebug() << "AI hinting" << hintedCells << "cells for level" << level;
}

void AIController::scheduleCellHint(int x, int y, int intensity, int delay, int flashDuration)
{
    QTimer::singleShot(delay, [=](){
        emit flashCell(x, y, intensity);
    });

    QTimer::singleShot(delay + flashDuration, [=](){
        emit hideHint(x, y);
    });
}
