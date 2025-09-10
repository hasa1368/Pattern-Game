import QtQuick 6.6


Image {
id: car
source: "qrc:/icons/car.png"
width: 60
height: 100
property int speed: 20


Keys.onLeftPressed: x = Math.max(0, x - speed)
Keys.onRightPressed: x = Math.min(parent.width - width, x + speed)
focus: true
}
