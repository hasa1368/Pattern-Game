import QtQuick 6.6
import QtQuick.Controls 6.6

ApplicationWindow {
    visible: true
    width: 600
    height: 800
    title: qsTr("Pattern Game")

    Game {
        anchors.fill: parent
    }
}
