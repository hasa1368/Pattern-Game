import QtQuick 6.6

Rectangle {
    id: cursor
    property int xIndex: 0
    property int yIndex: 0
    property int cellSize: 30
    signal positionChanged(int xIndex, int yIndex)

    width: cellSize; height: cellSize
    color: "red"

    focus: true
    Keys.onPressed: {
        if (event.key === Qt.Key_Left) xIndex = Math.max(0, xIndex - 1)
        else if (event.key === Qt.Key_Right) xIndex++
        else if (event.key === Qt.Key_Up) yIndex = Math.max(0, yIndex - 1)
        else if (event.key === Qt.Key_Down) yIndex++

        x = xIndex * cellSize
        y = yIndex * cellSize
        positionChanged(xIndex, yIndex)
    }
}
