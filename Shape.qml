import QtQuick 6.6

Item {
    id: shape
    property var gridData: []   // ماتریس 0 و 1
    property int cellSize: 40

    signal completed()

    Grid {
        id: grid
        rows: gridData.length
        columns: gridData[0].length
        Repeater {
            model: gridData.length * gridData[0].length
            Rectangle {
                width: shape.cellSize
                height: shape.cellSize
                color: gridData[Math.floor(index / gridData[0].length)][index % gridData[0].length] ? "blue" : "transparent"
                border.width: 1
                border.color: "white"
            }
        }
    }

    function checkCell(x, y) {
        // اگر سلول درست بود، رنگ عوض کن
        if (gridData[y] && gridData[y][x] === 1) {
            grid.itemAt(y * gridData[0].length + x).color = "green"
            // بررسی کامل شدن شکل
            if (allCellsFound()) {
                completed()
            }
        }
    }

    function allCellsFound() {
        for (var y=0; y<gridData.length; y++) {
            for (var x=0; x<gridData[0].length; x++) {
                if (gridData[y][x] === 1 &&
                    grid.itemAt(y * gridData[0].length + x).color !== "green") {
                    return false
                }
            }
        }
        return true
    }
}
