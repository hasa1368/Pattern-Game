<<<<<<< HEAD
#ifndef AICONTROLLER_H
#define AICONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QTimer>

class AIController : public QObject
{
    Q_OBJECT
public:
    explicit AIController(QObject *parent = nullptr);

    Q_INVOKABLE void startAdvancedHint(const QVariantList &targetCells, int level);

signals:
    void flashCell(int x, int y, int intensity);
    void hideHint(int x, int y);

private:
    void scheduleCellHint(int x, int y, int intensity, int delay);
};

#endif // AICONTROLLER_H
=======
#ifndef AICONTROLLER_H
#define AICONTROLLER_H

#include <QObject>
#include <QVariantList>
#include <QTimer>

class AIController : public QObject
{
    Q_OBJECT
public:
    explicit AIController(QObject *parent = nullptr);

    Q_INVOKABLE void startAdvancedHint(const QVariantList &targetCells, int level);

signals:
    void flashCell(int x, int y, int intensity);
    void hideHint(int x, int y);

private:
    void scheduleCellHint(int x, int y, int intensity, int delay);
};

#endif // AICONTROLLER_H
>>>>>>> 8af55d0ad8c1ee10a20a4de146cfee45cb00d582
