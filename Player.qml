import QtQuick 6.6

Item {
    id: player
    property int cellSize: 30
    property bool enabled: false
    signal cellEntered(var cell)

    width: cellSize
    height: cellSize

    Rectangle {
        id: cursor
        anchors.fill: parent
        color: "#15d17b"
        radius: 0
        border.color: "#ffffff"
        border.width: 1
        opacity: 0.7
    }

    function notifyCell(col, row){
        if(enabled) cellEntered({x: col, y: row})
    }
}
