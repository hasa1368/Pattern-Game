import QtQuick 6.6
import QtQuick.Controls 6.6
import QtQuick.Particles 6.0
import Qt5Compat.GraphicalEffects

Item {
    id: game
    width: 600
    height: 800
    focus: true

    property int cellSize: 50
    property int roundIndex: 0
    property int totalRounds: 10
    property var targetCells: []
    property var foundCells: []
    property int score: 0
    property real baseSpeed: 900
    property real speedMultiplier: 1.0
    property int currentStage: 1
    property bool stage2Unlocked: false
    property bool stage3Unlocked: false
    property real backgroundOpacity: 1.0

    readonly property int cols: Math.floor(width / cellSize)
    readonly property int rows: Math.floor(height / cellSize)

    // Background with stage-specific gradient and particle effects
    Rectangle {
        anchors.fill: parent
        opacity: backgroundOpacity
        gradient: {
            if (currentStage === 1) return stage1Gradient
            else if (currentStage === 2) return stage2Gradient
            else return stage3Gradient
        }
        Gradient {
            id: stage1Gradient
            GradientStop { position: 0.0; color: "#1e3a8a" } // Deep navy blue
            GradientStop { position: 1.0; color: "#93c5fd" } // Bright sky blue
        }
        Gradient {
            id: stage2Gradient
            GradientStop { position: 0.0; color: "#7f1d1d" } // Deep crimson
            GradientStop { position: 1.0; color: "#fca5a5" } // Light coral
        }
        Gradient {
            id: stage3Gradient
            GradientStop { position: 0.0; color: "#14532d" } // Dark forest green
            GradientStop { position: 1.0; color: "#a3e635" } // Vibrant lime
        }
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
        ParticleSystem {
            id: backgroundParticles
            running: true
            Emitter {
                anchors.fill: parent
                emitRate: currentStage === 1 ? 20 : (currentStage === 2 ? 35 : 50)
                lifeSpan: 4000
                size: currentStage === 1 ? 8 : (currentStage === 2 ? 10 : 12)
                sizeVariation: 4
                velocity: AngleDirection {
                    angle: 90
                    angleVariation: 45
                    magnitude: currentStage === 1 ? 50 : (currentStage === 2 ? 80 : 100)
                }
            }
            ImageParticle {
                source: "qrc:/particleresources/star.png"
                colorVariation: 0.5
                colorTable: {
                    if (currentStage === 1) return ["#60a5fa", "#3b82f6", "#1d4ed8"] // Blue stars
                    else if (currentStage === 2) return ["#f87171", "#ef4444", "#b91c1c"] // Red sparks
                    else return ["#86efac", "#22c55e", "#15803d"] // Green glows
                }
                alpha: currentStage === 1 ? 0.3 : (currentStage === 2 ? 0.5 : 0.7)
                rotation: 360
                rotationVariation: 180
            }
        }
        Rectangle {
            id: messageBox
            width: 240; height: 90
            color: "#cc4d4d88"
            radius: 12
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            visible: false
            z: 999
            Glow {
                anchors.fill: parent
                source: messageBox
                radius: 8
                samples: 16
                color: "#ffffff"
                opacity: 0.3
            }
            Text {
                anchors.centerIn: parent
                text: "Time's Up!"
                font.family: "Arial"
                font.pixelSize: 22
                color: "white"
                //style: Text.Outline
                //styleColor: "#000000"
            }
            Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
            Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }
        }
        Text {
            id: stageText
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 15
            text: "Stage: " + currentStage
            font.family: "Arial"
            font.pixelSize: 28
            color: "white"
            style: Text.Outline
            styleColor: "#000000"
            z: 999
        }
        Text {
            id: scoreText
            anchors.top: stageText.bottom
            anchors.left: parent.left
            anchors.margins: 15
            text: "Score: " + score
            font.family: "Arial"
            font.pixelSize: 28
            color: "white"
            style: Text.Outline
            styleColor: "#000000"
            z: 999
        }
    }

    Canvas {
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = "#555"
            //ctx.lineWidth: 1.5
            for (var i = 0; i <= cols; i++) {
                ctx.moveTo(i * cellSize, 0)
                ctx.lineTo(i * cellSize, height)
            }
            for (var j = 0; j <= rows; j++) {
                ctx.moveTo(0, j * cellSize)
                ctx.lineTo(width, j * cellSize)
            }
            ctx.stroke()
        }
    }

    Player {
        id: player
        cellSize: game.cellSize
        x: (game.width - width) / 2
        y: game.height - height - 8
        enabled: false
        Component.onCompleted: cellEntered.connect(onPlayerCellEntered)
    }

    MouseArea {
        anchors.fill: parent
        drag.target: player
        drag.axis: Drag.XandYAxis
        onPositionChanged: {
            player.notifyCell(Math.floor(player.x / cellSize), Math.floor(player.y / cellSize))
        }
    }

    Item { id: shapeLayer; anchors.fill: parent }

    Rectangle {
        id: checkMark
        visible: false
        width: 100; height: 100
        radius: 50
        anchors.centerIn: parent
        color: "transparent"
        border.color: "#22c55e"
        border.width: 6
        Text {
            anchors.centerIn: parent
            text: "✔"
            font.family: "Arial"
            font.pixelSize: 70
            color: "#22c55e"
            style: Text.Outline
            styleColor: "#ffffff"
        }
        Glow {
            anchors.fill: parent
            source: checkMark
            radius: 10
            samples: 20
            color: "#22c55e"
            opacity: 0.5
        }
        SequentialAnimation {
            running: checkMark.visible
            NumberAnimation { target: checkMark; property: "scale"; from: 0.5; to: 1.0; duration: 400; easing.type: Easing.OutBounce }
            NumberAnimation { target: checkMark; property: "rotation"; to: 360; duration: 400; easing.type: Easing.InOutQuad }
        }
        Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
    }

    Rectangle {
        id: endGameBox
        width: 420; height: 320
        radius: 20
        color: "#22c55eCC"
        anchors.centerIn: parent
        visible: false
        scale: 0
        z: 1000
        Glow {
            anchors.fill: parent
            source: endGameBox
            radius: 12
            samples: 24
            color: "#ffffff"
            opacity: 0.4
        }
        Text {
            anchors.centerIn: parent
            text: {
                if (currentStage === 1) {
                    return score > 50 ? "🎉Stage 1 Completed!\nTotal Score: " + score + "\nNext Stage Unlocked!" : "❌Stage 1 Not Completed!\nTotal Score: " + score + "\nNeed Score Above 50"
                } else if (currentStage === 2) {
                    return score > 50 ? "🎉Stage 2 Completed!\nTotal Score: " + score + "\nNext Stage Unlocked!" : "❌Stage 2 Not Completed!\nTotal Score: " + score + "\nNeed Score Above 50"
                } else {
                    return "🎉All Stages Completed!\nTotal Score: " + score
                }
            }
            font.family: "Arial"
            font.pixelSize: 34
            color: "white"
            style: Text.Outline
            styleColor: "#000000"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
        Button {
            id: stageTransitionButton
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20
            text: currentStage === 1 ? (score > 50 ? "Start Stage 2" : "Try Again") : (currentStage === 2 ? (score > 50 ? "Start Stage 3" : "Try Again") : "")
            visible: currentStage < 3
            background: Rectangle {
                color: "#22c55e"
                radius: 10
                border.color: "#ffffff"
                border.width: 2
            }
            contentItem: Text {
                text: parent.text
                font.family: "Arial"
                font.pixelSize: 24
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                backgroundOpacity = 0
                score = 0
                roundIndex = 0
                endGameBox.visible = false
                endGameBox.scale = 0
                if (currentStage === 1 && score > 50) {
                    currentStage = 2
                    stage2Unlocked = true
                    console.log("Manual advance from Stage 1 to Stage 2, score: " + score)
                } else if (currentStage === 2 && score > 50) {
                    currentStage = 3
                    stage3Unlocked = true
                    console.log("Manual advance from Stage 2 to Stage 3, score: " + score)
                } else {
                    console.log("Retrying Stage " + currentStage + ", score was: " + score)
                }
                stageTransitionTimer.start()
            }
        }
        Timer {
            id: stageTransitionTimer
            interval: 500
            repeat: false
            onTriggered: {
                backgroundOpacity = 1
                spawnShape()
                console.log("Transition completed to Stage " + currentStage + ", spawning shapes")
            }
        }
        Behavior on scale { NumberAnimation { duration: 800; easing.type: Easing.OutBounce } }
    }

    Window {
        id: victoryWindow
        width: 600
        height: 400
        visible: false
        color: "transparent"
        flags: Qt.Dialog
        title: "You Won!"
        Rectangle {
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#1e1b4b" } // Deep indigo
                GradientStop { position: 1.0; color: "#6b21a8" } // Vibrant purple
            }
        }
        ParticleSystem {
            id: particleSystem
            running: victoryWindow.visible
            Emitter {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                emitRate: 200
                lifeSpan: 3000
                size: 14
                sizeVariation: 7
                velocity: AngleDirection {
                    angle: 0
                    angleVariation: 360
                    magnitude: 300
                }
            }
            ImageParticle {
                source: "qrc:/particleresources/star.png"
                colorVariation: 0.6
                colorTable: [
                    "#ffd700", // Gold
                    "#ff4500", // OrangeRed
                    "#00ff7f", // SpringGreen
                    "#1e90ff", // DodgerBlue
                    "#ff69b4"  // HotPink
                ]
                rotation: 360
                rotationVariation: 180
                rotationVelocity: 80
                alpha: 0.8
            }
            Emitter {
                anchors.centerIn: parent
                width: parent.width / 2
                height: parent.height / 2
                emitRate: 50
                lifeSpan: 2000
                size: 10
                sizeVariation: 5
                velocity: AngleDirection {
                    angle: 90
                    angleVariation: 180
                    magnitude: 150
                }
            }
            ImageParticle {
                source: "qrc:/particleresources/glowdot.png"
                colorVariation: 0.5
                color: "#ffffff"
                alpha: 0.5
                rotation: 0
            }
        }
        Text {
            anchors.leftMargin:parent
            text: "🎉 You Won! 🎉"
            font.family: "Arial"
            font.pixelSize: 52
            color: "white"
            style: Text.Outline
            styleColor: "#ffd700"
            SequentialAnimation {
                running: victoryWindow.visible
                loops: Animation.Infinite
                NumberAnimation { target: parent; property: "scale"; to: 1.4; duration: 600; easing.type: Easing.InOutQuad }
                NumberAnimation { target: parent; property: "scale"; to: 1.0; duration: 600; easing.type: Easing.InOutQuad }
            }
            Glow {
                anchors.fill: parent
                source: parent
                radius: 10
                samples: 20
                color: "#ffd700"
                opacity: 0.6
            }
        }
        Button {
            id: resetButton
            anchors.centerIn: parent
            width: 200
            height: 60
            text: "Start Again?"
            background: Rectangle {
                color: "#22c55e"
                radius: 10
                border.color: "#ffffff"
                border.width: 2
            }
            contentItem: Text {
                text: parent.text
                font.family: "Arial"
                font.pixelSize: 24
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            onClicked: {
                victoryWindow.visible = false
                currentStage = 1
                stage2Unlocked = false
                stage3Unlocked = false
                score = 0
                roundIndex = 0
                backgroundOpacity = 0
                resetTimer.start()
                console.log("Game reset to Stage 1 from victory window")
            }
        }
        Timer {
            id: resetTimer
            interval: 500
            repeat: false
            onTriggered: {
                backgroundOpacity = 1
                spawnShape()
                console.log("Game reset to Stage 1, spawning shapes")
            }
        }
    }

    Timer {
        id: fadeOutTimer
        interval: 1000
        repeat: false
        onTriggered: {
            for (let i = 0; i < shapeLayer.children.length; i++) {
                shapeLayer.children[i].fadeOut = true
            }
            player.enabled = true
            responseTimer.restart()
            console.log("FadeOutTimer triggered, enabling player for Stage " + currentStage + ", score: " + score)
        }
    }

    Timer {
        id: responseTimer
        interval: 3000
        repeat: false
        onTriggered: {
            if (foundCells.length === targetCells.length) {
                checkMark.visible = true
                score += 10
                console.log("Round success, score incremented to: " + score)
            } else {
                messageBox.visible = true
                messageBox.scale = 1.1
                console.log("Round failed, showing Time's Up!, score: " + score)
            }
            player.enabled = false
            responseHideTimer.start()
        }
    }

    Timer {
        id: responseHideTimer
        interval: 1000
        repeat: false
        onTriggered: {
            messageBox.visible = false
            messageBox.scale = 1.0
            checkMark.visible = false
            roundIndex++
            console.log("ResponseHideTimer triggered, roundIndex: " + roundIndex + ", currentStage: " + currentStage + ", score: " + score)
            if (roundIndex < totalRounds) {
                spawnShape()
                console.log("Round " + roundIndex + " in Stage " + currentStage + ", spawning shapes")
            } else {
                if (currentStage < 3 && score > 50) {
                    // Auto-advance to next stage
                    if (currentStage === 1) {
                        currentStage = 2
                        stage2Unlocked = true
                        console.log("Auto-advancing from Stage 1 to Stage 2, score: " + score)
                    } else if (currentStage === 2) {
                        currentStage = 3
                        stage3Unlocked = true
                        console.log("Auto-advancing from Stage 2 to Stage 3, score: " + score)
                    }
                    backgroundOpacity = 0
                    score = 0
                    roundIndex = 0
                    stageTransitionTimer.start()
                } else if (currentStage === 3 && score > 50) {
                    endGameBox.visible = false
                    endGameBox.scale = 0
                    victoryWindow.visible = true
                    console.log("Stage 3 completed, showing victory window, score: " + score)
                } else {
                    endGameBox.visible = true
                    endGameBox.scale = 1
                    console.log("Stage " + currentStage + " ended, score: " + score + ", showing endGameBox")
                }
            }
        }
    }

    Connections {
        target: AI
        function onFlashCell(x, y, intensity) {
            for (let i = 0; i < shapeLayer.children.length; i++) {
                let c = shapeLayer.children[i]
                if (c.col === x && c.row === y) {
                    if (intensity === 1) c.color = "#FFFF66"
                    else if (intensity === 2) c.color = "#FF9900"
                    else c.color = "#FF3333"
                    c.scale = 1.3
                    break
                }
            }
        }
        function onHideHint(x, y) {
            for (let i = 0; i < shapeLayer.children.length; i++) {
                let c = shapeLayer.children[i]
                if (c.col === x && c.row === y) {
                    c.color = "#ef4444"
                    c.scale = 1
                    break
                }
            }
        }
    }

    function clearShape() {
        for (let i = shapeLayer.children.length - 1; i >= 0; i--) {
            shapeLayer.children[i].destroy()
        }
        targetCells = []
        foundCells = []
    }

    function patterns() {
        return [
            [{x:0,y:0},{x:1,y:0},{x:0,y:1},{x:0,y:2}],
            [{x:0,y:0},{x:1,y:0},{x:2,y:0},{x:1,y:1}],
            [{x:0,y:0},{x:1,y:0},{x:2,y:0},{x:3,y:0}],
            [{x:0,y:0},{x:0,y:1},{x:0,y:2},{x:0,y:3}],
            [{x:0,y:0},{x:1,y:0},{x:0,y:1},{x:1,y:1}],
            [{x:0,y:0},{x:1,y:0},{x:1,y:1},{x:2,y:1},{x:2,y:2}],
            [{x:1,y:0},{x:0,y:1},{x:1,y:1},{x:2,y:1},{x:1,y:2}],
            [{x:0,y:0},{x:2,y:0},{x:1,y:1},{x:0,y:2},{x:2,y:2}],
            [{x:0,y:0},{x:0,y:1},{x:0,y:2},{x:1,y:2},{x:2,y:2},{x:2,y:1},{x:2,y:0}],
            [{x:0,y:1},{x:1,y:1},{x:2,y:1},{x:3,y:0},{x:3,y:1},{x:3,y:2}]
        ]
    }

    function spawnShape() {
        player.enabled = false
        checkMark.visible = false
        messageBox.visible = false
        clearShape()
        var p = patterns()
        var shape = p[Math.floor(Math.random() * p.length)]
        var maxX = 0, maxY = 0
        for (let i = 0; i < shape.length; i++) {
            if (shape[i].x > maxX) maxX = shape[i].x
            if (shape[i].y > maxY) maxY = shape[i].y
        }
        var shapeW = maxX + 1, shapeH = maxY + 1
        var maxCol = Math.max(0, cols - shapeW)
        var maxRow = Math.max(0, rows - 3 - shapeH)
        var finalCol = Math.floor(Math.random() * (maxCol + 1))
        var finalRow = Math.floor(Math.random() * (maxRow + 1))
        var finalOriginX = finalCol * cellSize
        var finalOriginY = finalRow * cellSize

        for (let i = 0; i < shape.length; i++) {
            let dx = shape[i].x
            let dy = shape[i].y
            let cell = Qt.createQmlObject(
                'import QtQuick 6.6; import Qt5Compat.GraphicalEffects; Rectangle { width:' + cellSize + '; height:' + cellSize + '; radius:6; color:"#ef4444"; border.color:"#ffffff"; border.width:2; property int col:' + (finalCol + dx) + '; property int row:' + (finalRow + dy) + '; property bool fadeOut:false; scale:0; Behavior on y { NumberAnimation { duration:' + (baseSpeed * speedMultiplier) + '; easing.type:Easing.InOutQuad } } Behavior on opacity { NumberAnimation { duration:500 } } Behavior on color { ColorAnimation { duration:400 } } Behavior on scale { NumberAnimation { duration:400; easing.type:Easing.OutBack } } onFadeOutChanged: { if(fadeOut){opacity=0} } Component.onCompleted: { scale=1 } Glow { anchors.fill: parent; source: parent; radius:8; samples:16; color:"#ef4444"; opacity:0.4 } MouseArea { anchors.fill: parent; onClicked: { if(parent.color!="#22c55e"){ parent.color="#22c55e"; game.onPlayerCellEntered({x:col,y:row}) } } } }',
                shapeLayer, 'cell' + i
            )
            cell.x = finalOriginX + dx * cellSize
            cell.y = finalOriginY + dy * cellSize
            targetCells.push({x: finalCol + dx, y: finalRow + dy, found: false, weight: Math.ceil(Math.random() * 3)})
        }

        console.log("Spawned " + shape.length + " cells for Stage " + currentStage)
        if (shapeLayer.children.length === 0) {
            console.log("No shapes spawned, retrying...")
            spawnShape()
        }
        fadeOutTimer.start()
        AI.startAdvancedHint(targetCells, Math.min(3, Math.floor(score / 20) + 1))
    }

    function onPlayerCellEntered(cell) {
        for (var i = 0; i < targetCells.length; i++) {
            var c = targetCells[i]
            if (c.found) continue
            if (c.x == cell.x && c.y == cell.y) {
                c.found = true
                foundCells.push(c)
                console.log("Player hit cell at (" + c.x + ", " + c.y + "), foundCells: " + foundCells.length)
                break
            }
        }
    }

    Component.onCompleted: {
        spawnShape()
        console.log("Game started, initial shapes spawned for Stage 1")
    }
}
