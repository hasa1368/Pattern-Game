import QtQuick 6.6


Image {
id: obstacle
source: "qrc:/icons/obstacle.png"
width: 50
height: 50


property int fallDuration: 2000


SequentialAnimation on y {
loops: 1
NumberAnimation { from: -50; to: parent.height; duration: fallDuration }
ScriptAction { script: obstacle.destroy() }
}


Timer {
interval: 50; repeat: true; running: true
onTriggered: {
if (obstacle.y + obstacle.height >= car.y &&
obstacle.x < car.x + car.width &&
obstacle.x + obstacle.width > car.x) {
console.log("Collision at:", Math.floor(obstacle.x/50), Math.floor(obstacle.y/50))
obstacle.destroy()
}
if (obstacle.y > car.y + car.height) {
game.score += 10
console.log("Score:", game.score)
obstacle.destroy()
}
}
}
}
